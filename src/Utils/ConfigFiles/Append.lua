local Read, Write = require("src.Utils.ConfigFiles.Read"), require("src.Utils.ConfigFiles.Write")

return function(Path, Data, Index)
    local Success, Error = pcall(function()
        local Database = Read(Path, true)
        Index = Index or #Database + 1

        Database[Index] = Data
        Write(Path, Database)
    end)

    if not Success then
        return false, Error
    end

    return true
end