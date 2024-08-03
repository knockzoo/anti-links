return function(Path, NoCache)
    local Database = require(Path)
    
    if NoCache then
        Database = setmetatable({Database}, { __mode = "kv" })[1]
    end

    return Database
end