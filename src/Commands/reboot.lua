local CreateObject, ConfigDB, Colors = require("src.Utils.Commands.CreateObject"), require("src.Utils.ConfigFiles.BuildObject"), require("src.Utils.Colors")
local RebootData = ConfigDB("src/Reboot", false)

return CreateObject()
	:SetName("reboot")
	:SetDescription("Reboots the bot's program.")
	:SetUsage("reboot")
	:SetCategory("Management")
	:SetCoroutine(true)
	:SetServerOnly(true)
	:SetPermissions({
        "manageGuild"
    })
	:SetCallback(function(Received)
        Received.Client:setActivity("Rebooting...")
        local StatusMessage = Received.Message:reply({
            embed = {
                title = "Rebooting...",
                description = "The bot's program is rebooting. Please wait for the bot to restart itself.",
                color = Colors.Yellow.Light,
            }
        })

        local ChannelID = Received.Message.channel.id
        local MessageID = StatusMessage.id

        RebootData.__valuereplace("ChannelID", ChannelID)
        RebootData.__valuereplace("MessageID", MessageID)

        -- i love writing shit code

		coroutine.wrap(function()
			local Process = io.popen("./luvit src/init.lua")
            local Result = Process:read("*a")
			Process:close()
		end)()

        local Process = io.popen("exit")
        local Result = Process:read("*a")
        Process:close()
	end)
