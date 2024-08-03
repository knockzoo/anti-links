local ConfigDB, CreateObject, Split, Colors = require("src.Utils.ConfigFiles.BuildObject"), require("src.Utils.Commands.CreateObject"), require("src.Utils.Split"), require("src.Utils.Colors")
local SettingsDB = ConfigDB("Settings", false)

return CreateObject()
	:SetName("prefix")
	:SetDescription("Sets the prefix of the bot.")
	:SetUsage("prefix <prefix>")
	:SetCategory("Management")
	:SetCoroutine(true)
	:SetServerOnly(true)
	:SetPermissions({
        "manageGuild"
    })
	:SetCallback(function(Received)
		local Message = Received.Message
        local Split = Split(Message.content, " ")

		SettingsDB.Prefix = table.concat(Split, " ", 2)

        return Message:reply({
            embed = {
                title = "Prefix",
                description = string.format("The prefix has been set to `%s`.\nPlease run the **reboot** command to apply the changes.", SettingsDB.Prefix),
                color = Colors.Green.Light,
            }
        })
	end)

	--[[
		the issue with requiring you to reboot in order to update the prefix
		is actually incredibly avoidable; instead of requiring() the settings file,
		you could instead use the DBConfig library in order to receive a constant up to date
		representation of the file instead of a loaded into memory version.

		i just simply cba.
	]]