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
    end,
    SecondsToRelative = function(Seconds)
        local Minute, Hour, Day = 60, 60 * 60, (60 * 60) * 24
        local IsPlural
        if Seconds < Minute then
            IsPlural = (Seconds == 1 and "") or "s"
            return string.format("%d second%s", Seconds, IsPlural)
        elseif Seconds < Hour then
            IsPlural = (Minute == 1 and "") or "s"
            return string.format("%d minute%s", Dates.Convert.SecondsToMinutes(Seconds), IsPlural)
        elseif Seconds < Day then
            IsPlural = (Hour == 1 and "") or "s"
            return string.format("%d hour%s", Dates.Convert.SecondsToHours(Seconds), IsPlural)
        else
            IsPlural = (Day == 1 and "") or "s"
            return string.format("%d day%s", Dates.Convert.SecondsToDays(Seconds), IsPlural)
        end
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