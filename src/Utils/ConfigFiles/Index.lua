local Read = require("src.Utils.ConfigFiles.Read")

return function(Path, Index, NoCache)
    NoCache = NoCache or true
    local Database = Read(Path, NoCache)
    return Database[Index]
end