local Append, Index, Read, Remove, Write = require("src.Utils.ConfigFiles.Append"), require("src.Utils.ConfigFiles.Index"), require("src.Utils.ConfigFiles.Read"), require("src.Utils.ConfigFiles.Remove"), require("src.Utils.ConfigFiles.Write")

return function(Path, NoCache)
    NoCache = NoCache or true -- Useful for sensitive data
    local Metatable = {
        __index = function(self, Key)
            local Custom = {
                __write = function(Data)
                    Write(Path, Data)
                end,
                __remove = function(__Key)
                    Remove(Path, __Key)
                end,
                __overwrite = function(Data)
                    Write(Path, Data)
                end,
                __valuereplace = function(__Key, Value)
                    Remove(Path, __Key)
                    Append(Path, Value, __Key)
                end
            }

            if Custom[Key] then
                return Custom[Key]
            end

            return Index(Path, Key, NoCache)
        end,
        __newindex = function(self, Key, Value)
            Append(Path, Value, Key)
        end,
        __pairs = function(self)
            return pairs(Read(Path, NoCache))
        end,
        __len = function(self)
            local Counter = 0
            for _ in pairs(Read(Path, NoCache)) do
                Counter = Counter + 1
            end
            
            return Counter
        end,
        __tostring = function(self)
            return tostring(Read(Path, NoCache))
        end,
        __eq = function(self, Value)
            return Read(Path, NoCache) == Value
        end
    }

    if NoCache then
        Metatable.__mode = "kv"
    end

    return setmetatable({}, Metatable)
end