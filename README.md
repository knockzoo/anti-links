> [!CAUTION]
> Please take extra care while handling your bot's token, as anyone with access to it can make the bot do whatever they want.

# Anti Links Bot
This is a free & open source take on the concept of moderation utilities designed to limit what links are shared in a server. This has the benefit of preventing scams, malicious attempts at gathering personal information, or manipulating users into unknowingly providing a service (such as online video views).

## How it does this
Instead of relying on static auto-mod filters which don't have full context of what the URL is, what channel it's sent in, or who sent it, this bot uses all of the above as well as more in accordance with your own configuration to determine which links are or are not allowed.

For example, you could have a sample configuration which *does* block all domains and URLs, except for those which are GIFs, or except for those which are sent by a staff member or sent in a media channel.

This long list of customization options leads to a more expected experience for your users, as well as a more accurate experience for your staff.

## How to setup
### Requirements
#### Package Depencies
This bot and project relies on third party libraries provided in most GNU+Linux distributions/operating systems; such as `curl`, `md5sum`, `tar`, `vmstat`, `tail`, `awk`, `free`, `grep`, and others.

Check your own distribution's manual for instructions on how to safely and effectively download and install packages and dependencies for your operating system. You will need these installed for the `ping` command as well as the `info` command.

Unfortunately, this also means that **this bot will not work on Windows**, as the above mentioned libraries are not easily available. You may find look through Windows' various tools for running virtualized GNU+Linux CLI instances, such as WSL, but this is not tested and by extension not officially supported or endorsed. Proper Windows support would likely also require slight modifications to any files that call said packages or libraries.

#### System Requirements
1. Up to date operating system and packages for the best experience
2. ~200mb of extra RAM to ensure ample memory for the bot to run
3. ~100mb of extra disk space to ensure the bot can store its data
4. As mentioned above, a GNU+Linux operating system

### Installation
I recommend looking at the [official Discordia documentation](https://github.com/SinisterRectus/Discordia/wiki/Installing-Discordia) as a starting point on how Discordia interacts with Luvit and vise-versa.

However, you can use the following commands to quickly get started:
```bash
cd ~/Documents # Navigate to the home directory's Documents directory
git clone https://github.com/knockzoo/anti-links/ # Clone the repository
cd anti-links # Navigate into the repository
curl -L https://github.com/luvit/lit/raw/master/get-lit.sh | sh # Download and install lit
./lit install SinisterRectus/discordia # Install the discordia library
```

Or all in one line:
```bash
cd ~/Documents && git clone https://github.com/knockzoo/anti-links/ && cd anti-links && curl -L https://github.com/luvit/lit/raw/master/get-lit.sh | sh && ./lit install SinisterRectus/discordia
```

Now, you can create your bot application through the Discord Developer Portal if you haven't already.

1. Go to [this link](https://discord.com/developers/applications).
2. Click "New Application" in the top right.
3. Name your application, agree to the TOS and click "Create".
4. Click "Bot" in the left sidebar.
5. Click "Reset Token" (just below the username and profile picture).
6. Confirm via "Yes do it!" and the following dialogs if applicable.
7. Copy the token and paste it into `Settings.lua` in the BotToken entry.
8. Now, back in the developer portal, scroll down to "Privileged Gateway Intents" and enable "Message Content Intents", "Server Members Intents" and "Presence Intents".
9. Back in the sidebar, click "Installation".
10. Under "Guild Install", select "bot" and provide it with at least view messages, view messages in threads, manage messages, and read message history. A simpler solution would to be just providing administrative permissions and not worrying about the rest - however this is significantly more risky in the even of a token leak.
11. Copy the Discord provided install link and open it either in your browser or in Discord, and then follow the steps to add it to whichever server you choose.

Now that you have a working and legitimate bot token in your `Settings.lua` configuration, you can start to adjust the bot's behavior to your liking through other configuration options in `Settings.lua`.

Under `Blacklisted`, you can create new entries and use the wildcard `*` to match any string, or `*all` to match all domains/URLs.

An example of this would be that `*.com` would match `example.com`, `123abc.com`, `example.com/path/to/something`, etc.

Enable `AllowGifs` to allow any GIFs sent through Discord's file host, tenor.com, or giphy.com - regardless of the channel, etc.

Continue adding channel IDs to the `WhitelistedChannels` table to allow links in specific channels. Add whichever data you want to OptionalMetadata, as it will not be interpreted by the program and simply acts as a way of documenting which IDs mean which channels.

Same as above for `WhitelistedRoles` except for Role IDs, and without the documentation and optional metadata.

If you feel that doing a per-role configuration is too much work, you can instead enable various permissions in the `WhitelistedPermissions` table. This will allow any users with those permissions to send any links they want.

#### Starting up the bot
After you have finished all the above steps, your project layout should be similar to the following:
```
anti-links/
├── src/
│   ├── init.lua
│   └── ...
├── deps/
│   └── discordia/
│       └── ...
├── Settings.lua
└── luvit
```

Run the command:
```bash
./luvit src/init.lua
```

To start the bot.
