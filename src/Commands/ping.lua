local Requests, CreateObject, Colors =
	require("src.Utils.Requests"), require("src.Utils.Commands.CreateObject"), require("src.Utils.Colors")

local function GetSystemStats()
	local function Run(Cmd)
		return io.popen(Cmd)
	end

	local Command = [[
			vmstat 1 2 | tail -1 | awk '{print 100 - $15}' && 
			free | grep Mem | awk '{print $3/$2 * 100.0}'
		]]

	local Handle = Run(Command)
	local Output = Handle:read("a")
	Handle:close()

	local CPU, RAM = Output:match("(%d+%.?%d*)%s+(%d+%.?%d*)")

	return {
		["CPU"] = CPU,
		["RAM"] = RAM,
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

		local Start = os.clock()
		local Response = Requests.Get("https://discord.com/api/v9/gateway/bot")
		local End = os.clock()
		local Latency = math.floor((End - Start) * 1000000)

		local SystemStats = GetSystemStats()

		local Response = {
			embed = {
				title = "Pong!",
				color = Colors.Green.Light,
				fields = {
					{
						name = "Latency",
						value = string.format("%dms", Latency),
						inline = true,
					},
					{
						name = "CPU",
						value = string.format("%s%%", SystemStats["CPU"]),
						inline = true,
					},
					{
						name = "RAM",
						value = string.format("%s%%", SystemStats["RAM"]:sub(1, 4)),
						inline = true,
					},
				},
			},
		}

		Message:reply(Response)
	end)
