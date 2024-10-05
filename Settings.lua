return {
	["Version"] = "0.0.3",
	["Prefix"] = ".",
	["BotToken"] = "", -- Put your bot token in here
	["Status"] = "Preventing unauthorized URLs",
	["Blacklisted"] = {
		["*all"] = true, -- Blocks ALL domains/URLs
		["*.com"] = true, -- Blocks all .com domains/URLs
		["discord.com"] = true, -- Blocks all discord.com
		["*.test.com"] = true -- Blocks all subdomains of test.com
    },
    ["AllowGifs"] = true, -- Automatically allows tenor.com, giphy.com, and Discord GIF files
    ["WhitelistedPermissions"] = { -- List of permissions that, when the user has them, they are allowed to send ANY URL
        ["manageMessages"] = true,
        ["manageGuild"] = true
    },
    ["WhitelistedChannels"] = { -- List of channels that are allowed to send ANY URL
        ["1155201422506336369"] = {
            ["Enabled"] = true,
            ["OptionalMetadata"] = { -- You can add whatever entries you want here with whatever data you want, they're never used and just act as a way to stay organized
                ["ChannelName"] = "media"
            }
        }
    },
    ["WhitelistedRoles"] = { -- List of roles that are allowed to send ANY URL
        ["1147601297562931290"] = true,
        ["1147580026854846514"] = true
    },
    ["DisabledCommands"] = {
        ["commandnamehere"] = true,
        ["neofetch"] = true
    }
}