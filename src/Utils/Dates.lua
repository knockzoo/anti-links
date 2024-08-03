local Dates = {}

Dates.GetCurrentDate = function()
    return os.date("%Y-%m-%d")
end

Dates.GetCurrentTime = function()
    return os.date("%H:%M:%S")
end

Dates.GetCurrentEpoch = function()
    return os.time()
end

Dates.Convert = {
    EpochToDate = function(Epoch)
        return os.date("%Y-%m-%d", Epoch)
    end,
    EpochToTime = function(Epoch)
        return os.date("%H:%M:%S", Epoch)
    end,
    SecondsToMinutes = function(Seconds)
        return math.floor(Seconds / 60)
    end,
    SecondsToHours = function(Seconds)
        return math.floor(Dates.Convert.SecondsToMinutes(Seconds) / 60)
    end,
    SecondsToDays = function(Seconds)
        return math.floor(Dates.Convert.SecondsToHours(Seconds) / 24)
    end
}

Dates.DiscordFormat = {
    Relative = function(Epoch)
        return string.format("<t:%d:R>", Epoch)
    end,
    Short = function(Epoch)
        return string.format("<t:%d:t>", Epoch)
    end,
    Long = function(Epoch)
        return string.format("<t:%d:T>", Epoch)
    end
}

return Dates