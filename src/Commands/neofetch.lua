local uv = require("uv")
local CreateObject, Colors, Dates = require("src.Utils.Commands.CreateObject"), require("src.Utils.Colors"), require("src.Utils.Dates")

local InvisCharacter = "​"

local function SanitizeLogo(Logo)
    return Logo:gsub("`", InvisCharacter .. "`"):gsub("\n%s*\n", "\n")
end

local function GetLogo()
    local Process = io.popen("neofetch -L | sed 's/\x1B\\[[0-9;]*m//g'")
    local Result = Process:read("*a")
    Process:close()

    return SanitizeLogo(Result)
end

local function GetNeofetch()
	local Process = io.popen("neofetch --color_blocks off --stdout")
	local Result = Process:read("*a")
	Process:close()

	return Result
end

return CreateObject()
	:SetName("neofetch")
	:SetDescription("Returns the system information of the bot.")
	:SetUsage("neofetch")
	:SetCategory("Utility")
	:SetCoroutine(true)
	:SetServerOnly(false)
	:SetCallback(function(Received)
		local Message = Received.Message
		local Client = Received.Client

		local Neofetch = GetNeofetch()
        local Logo = GetLogo()

		local Response = {
			embed = {
                description = "```\n" .. Logo.. "\n```",
				color = Colors.ArchLinux,
				fields = {
					{
                        name = "**Neofetch**",
                        value = string.format("```\n%s\n```", Neofetch),
						inline = false,
					}
				},
			},
		}

		Message:reply(Response)
	end)
