local Serializer = require("src.Serializer.Main")

return function(Path, Data)
    local Serialized = Serializer(Data)
    if Serialized then
        local HasExtension = Path:match("%.lua$")
        local File = io.open(HasExtension and Path or Path .. ".lua", "w+")
        File:write(Serialized)
        File:close()

        return true
    end

    return false, "Failed to serialize data"
end