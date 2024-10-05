local uv = require("uv")
local Requests, CreateObject, Colors, Dates = require("src.Utils.Requests"), require("src.Utils.Commands.CreateObject"), require("src.Utils.Colors"), require("src.Utils.Dates")

local function BytesToGigabytes(Bytes)
	return Bytes / 1024 / 1024 / 1024
end

local function GetSystemStats()
	local function GetCPU()
		local CPUInfo = uv.cpu_info()
		local TotalUser, TotalNice, TotalSys, TotalIdle, TotalIrq = 0, 0, 0, 0, 0

		for _, CPU in ipairs(CPUInfo) do
			TotalUser = TotalUser + CPU.times.user
			TotalNice = TotalNice + CPU.times.nice
			TotalSys = TotalSys + CPU.times.sys
			TotalIdle = TotalIdle + CPU.times.idle
			TotalIrq = TotalIrq + CPU.times.irq
		end

		local TotalUsage = TotalUser + TotalNice + TotalSys + TotalIrq
		local TotalTime = TotalUsage + TotalIdle

		return (TotalUsage / TotalTime) * 100
	end

	local function GetMemoryUsage()
		local TotalMem = BytesToGigabytes(uv.get_total_memory())
		local FreeMem = BytesToGigabytes(uv.get_free_memory())
		local UsedMem = TotalMem - FreeMem
		local UsedMemPercent = (UsedMem / TotalMem) * 100

		return UsedMemPercent, TotalMem, FreeMem, UsedMem
	end

	local CPU, RAM, TotalMem, FreeMem, UsedMem = GetCPU(), GetMemoryUsage()

	return {
		["CPU"] = string.format("%.2f%%", CPU),
		["RAM"] = string.format("%.2f%% (%.2fGB / %.2fGB)", RAM, UsedMem, TotalMem),
	}
end

return CreateObject()
	:SetName("ping")
	:SetDescription("Returns the latency between the bot and Discord's servers.")
	:SetUsage("ping")
	:SetCategory("Utility")
	:SetCoroutine(true)
	:SetServerOnly(false)
	:SetCallback(function(Received)
		local Message = Received.Message
		local Client = Received.Client

		local SystemStats = GetSystemStats()

		local Latency = Client._latency
		if not Latency then
			Message:reply("Waiting for heartbeat connection...")
			local Timedout, Shard, Delay = Client:waitFor("heartbeat")
			Latency = Delay
		end

		-- ":information_source: Info:"
		-- ":inbox_tray: **Latency:** `%dms`\n:hourglass: **Uptime:** `%s`\n:computer: **Resources**:\n**  **CPU: `%s%%`\n**  **RAM: `%s%%`"

		local Response = {
			embed = {
				title = "Pong!",
				color = Colors.Green.Light,
				fields = {
					{
						name = ":information_source: Info",
						value = string.format(":inbox_tray: **Latency:** `%dms`\n:hourglass: **Uptime:** `%s`\n:computer: **Resources**:\n**  **CPU: `%s`\n**  **RAM: `%s`", Latency,  Dates.Convert.SecondsToRelative(os.time() - Client._init), SystemStats["CPU"], SystemStats["RAM"]),
						inline = false,
					}
				},
			},
		}

		Message:reply(Response)
	end)
