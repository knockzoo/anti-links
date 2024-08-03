local Colors = require("src.Utils.Colors")

return function()
    local Obj = {}

    function Obj:SetName(Name)
        self.Name = Name
        return self
    end

    function Obj:SetDescription(Description)
        assert(type(Description) == "string", "Description must be a string")
        self.Description = Description
        return self
    end

    function Obj:SetUsage(Usage)
        assert(type(Usage) == "string", "Usage must be a string")
        self.Usage = Usage
        return self
    end

    function Obj:SetPermissions(Permissions)
        assert(type(Permissions) == "table", "Permissions must be a table")
        self.Permissions = Permissions
        return self
    end

    function Obj:SetCategory(Category)
        assert(type(Category) == "string", "Category must be a string")
        self.Category = Category
        return self
    end

    function Obj:SetCoroutine(Coroutine)
        assert(type(Coroutine) == "boolean", "Coroutine must be a boolean")
        self.Coroutine = Coroutine
        return self
    end

    function Obj:SetServerOnly(ServerOnly)
        assert(type(ServerOnly) == "boolean", "ServerOnly must be a boolean")
        self.ServerOnly = ServerOnly
        return self
    end

    function Obj:SetCallback(Callback)
        assert(type(Callback) == "function", "Callback must be a function")
        self.Callback = Callback
        return self
    end

    function Obj:SetCustomCheck(CustomCheck)
        print("CustomCheck called with function name: " .. debug.getinfo(2, CustomCheck).name)
        print("CustomCheck called from: " .. debug.getinfo(3, "S").short_src .. " at line " .. debug.getinfo(3, "l").currentline)
        assert(type(CustomCheck) == "function", "CustomCheck must be a function")
        self.CustomCheck = CustomCheck
        return self
    end

    Obj.__call = function(self, Provided)
        local Message = Provided.Message
        if self.ServerOnly and not Message.guild then
            return Message:reply({
                embed = {
                    title = "Error :x:",
                    description = "This command can only be used in a server",
                    color = Colors.Red.Light,
                },
            })
        end

        if self.CustomCheck then
            local Result = self.CustomCheck(Provided)
            if Result ~= true then
                return Result
            end
        end

        if self.Permissions then
            for Index, Permission in pairs(self.Permissions) do
                if not Message.member:hasPermission(Message.channel, Permission) then
                    return Message:reply({
                        embed = {
                            title = "Error :x:",
                            description = string.format("Missing permissions **%s**.", Permission),
                            color = Colors.Red.Light,
                        },
                    })
                end
            end
        end

        return self.Callback(Provided)
    end

    function Obj:New()
        return setmetatable(Obj, Obj)
    end

    return Obj:New()
end