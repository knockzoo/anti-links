return function(Name, Commands)
    for i, v in pairs(Commands) do
        if v['Name'] == Name then
            return true
        end
    end

    return false
end