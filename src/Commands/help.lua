local ObjectBuilder, Colors, Settings = require("src.Utils.Commands.CreateObject"), require("src.Utils.Colors"), require("Settings")

return ObjectBuilder()
	:SetName("help")
	:SetDescription("Shows this message.")
	:SetCoroutine(true)
	:SetServerOnly(false)
    :SetUsage("help")
    :SetCategory("Information")
	:SetCallback(function(Received)
		local Commands = Received.Commands

        local Categories = {}
        for _, Command in pairs(Commands) do
            if not Categories[Command.Category] then
                Categories[Command.Category] = {}
            end

            table.insert(Categories[Command.Category], Command)
        end

        local Result = ""
        for CatName, Category in pairs(Categories) do
            Result = Result .. "## " .. CatName .. ":\n"
            for _, Command in pairs(Category) do
                local Disabled = Settings["DisabledCommands"][Command.Name]
                
                Result = Result .. string.format("### %s\n> **Description:** %s\n> **Usage:** ```%s```\n%s\n", Command.Name, Command.Description, Command.Usage, Disabled and "> **Warning:** This command has been disabled\n" or "")
            end
        end

		local Embed = {
			title = "Help",
			description = Result,
			color = Colors.Blue.Light,
		}

		Received.Message:reply({ embed = Embed })
	end)
