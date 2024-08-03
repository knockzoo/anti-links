local Settings, Colors = require("Settings"), require("src.Utils.Colors")

local function HasUrl(Content)
    return Content:match("https?://[%w%.%/]+")
end

local function ExtractDomain(Url)
    return Url:match("https?://([^/]+)")
end

local function IsGif(Url, Domain)
    if Domain == "tenor.com" or Domain == "giphy.com" then
        return true
    end

    return Url:match("https?://[%w%.%/]+%.gif$")
end

local function MatchWildcard(Domain, Pattern)
    if Pattern:sub(1, 2) == "*." then
        local Suffix = Pattern:sub(3)
        return Domain:sub(-#Suffix) == Suffix
    end
    return Domain == Pattern
end

local function PermsCheck(Message)
    for Permission, Enabled in pairs(Settings.WhitelistedPermissions or {}) do
        if Enabled then
            if not Message.member:hasPermission(Message.channel, Permission) then
                return true
            end
        end
    end

    return false
end

local function ChannelCheck(Message)
    for Channel, Enabled in pairs(Settings.WhitelistedChannels or {}) do
        if Enabled then
            if Message.channel.id == Channel then
                return true
            end
        end
    end

    return false
end

local function RoleCheck(Message)
    for Role, Enabled in pairs(Settings.WhitelistedRoles or {}) do
        if Enabled then
            if Message.member:hasRole(Role) then
                return true
            end
        end
    end

    return false
end

return function(Received)
    local Content = Received.Message.content
    local Author = Received.Message.author

    if PermsCheck(Received.Message) then
        return
    end

    if ChannelCheck(Received.Message) then
        return
    end

    if RoleCheck(Received.Message) then
        return
    end

    local URL = HasUrl(Content)
    if not URL then
        return
    end

    local Domain = ExtractDomain(URL)

    local IsBlacklisted = false
    for BlacklistedDomain, _ in pairs(Settings.Blacklisted) do
        if MatchWildcard(Domain, BlacklistedDomain) or BlacklistedDomain == "*all" then
            IsBlacklisted = true
            break
        end
    end

    if IsGif(URL, Domain) then
        IsBlacklisted = not Settings.AllowGifs
    end

    if IsBlacklisted then
        Received.Message:reply({
            embed = {
                title = "Message deleted",
                description = Author.name .. ", your message has been deleted for containing a blacklisted URL.",
                color = Colors.Red.Light,
            },
        })

        Received.Message:delete()
    end
end