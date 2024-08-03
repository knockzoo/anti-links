local Settings, GetVersion, Dates, CreateObject, Colors =
	require("Settings"),
	require("src.Utils.GetVersion"),
	require("src.Utils.Dates"),
	require("src.Utils.Commands.CreateObject"),
	require("src.Utils.Colors")

return CreateObject()
	:SetName("info")
	:SetDescription("Get information about the bot.")
	:SetUsage("info")
	:SetCategory("Information")
	:SetCoroutine(true)
	:SetServerOnly(false)
	:SetCallback(function(Received)
		local Prefix, Version, Init = Settings.Prefix, GetVersion(), Received.Init
		local Response = {
			embed = {
				title = "Information",
				description = "Use the `help` command to get more information about the bot's commands.",
				color = Colors.Green.Light,
				fields = {
					{
						name = "Version",
						value = string.format("`%s | %s`", Settings.Version, Version),
						inline = false,
					},
					{
						name = "Startup",
						value = Dates.DiscordFormat.Relative(Init),
						inline = true,
					},
					{
						name = "Prefix",
						value = string.format("`%s`", Prefix),
						inline = true,
					},
				},
			},
		}
		Received.Message:reply(Response)
	end)
