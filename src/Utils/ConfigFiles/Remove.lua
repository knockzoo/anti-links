local Read, Write = require("src.Utils.ConfigFiles.Read"), require("src.Utils.ConfigFiles.Write")

return function(Path, Index)
    local Database = Read(Path, true)
    Database[Index] = nil

    return Write(Path, Database)
end