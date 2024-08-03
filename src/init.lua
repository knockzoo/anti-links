local Discordia = require("discordia")
local ParseCommands = require("src.Utils.Commands.ParseCommands")
local ImportCommands = require("src.Utils.Commands.ImportCommands")
local DoesExist = require("src.Utils.Commands.DoesExist")
local Settings = require("Settings")
local URLCheck = require("src.URLCheck")
local Colors = require("src.Utils.Colors")
local ConfigDB = require("src.Utils.ConfigFiles.BuildObject")

local RebootData = ConfigDB("src/Reboot", false)

local Client = Discordia.Client()
local Commands = ImportCommands()
local Token = Settings.BotToken
local Status = Settings.Status

local Init = os.time()

Discordia.extensions()

Client:on("ready", function()
	print("Bot is ready! Logged in as " .. Client.user.username)
	Client:setActivity(Status)

	if #RebootData > 1 then
		local ChannelID = RebootData.ChannelID
		local MessageID = RebootData.MessageID
		local Channel = Client:getChannel(ChannelID)
		local Message = Channel:getMessage(MessageID)

		Message:setEmbed({
			title = "Rebooted!",
			description = "The bot has been rebooted successfully.",
			color = Colors.Green.Light,
			fields = {
				{
					name = "Current prefix",
					value = string.format("`%s`", Settings.Prefix),
					inline = true,
				},
				{
					name = "Current version",
					value = string.format("`%s`", Settings.Version),
					inline = true,
				},
			},
			footer = {
				text = "Rebooted at " .. os.date("%Y-%m-%d %H:%M:%S"),
			},
		})

		RebootData.__overwrite({}) -- Replace with a empty table as to avoid infinite rebooted message edits
	end
end)

Client:on("messageCreate", function(Message)
	local Content, Author = Message.content, Message.author
	if Author.bot or Author == Client.user then
		return
	end

	URLCheck({ Message = Message })

	local Parsed = ParseCommands(Content)

	if not Parsed or not DoesExist(Parsed.Command, Commands) then
		return
	end

	local CommandObject = Commands[Parsed.Command]
	local Callable, Args =
		CommandObject,
		{ Message = Message, Arguments = Parsed.Arguments, Client = Client, Init = Init, Commands = Commands }
	if not CommandObject.Coroutine then
		Callable(Args)
	else
		coroutine.wrap(Callable.__call)(Callable, Args)
	end
end)

Client:run("Bot " .. Token)
