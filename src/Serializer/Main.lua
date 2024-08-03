local Format = string.format
local Tonumber, Tostring = tonumber, tostring
local Insert = table.insert
local Rep = string.rep

local function EscapeString(Str)
    return (Format("%q", Str))
end

local Serialize = {}
Serialize.String = EscapeString
Serialize.Number = function(Int) return Format("%d", Int) end
Serialize.Boolean = function(Bool) return (Bool and "true") or "false" end
Serialize.Value = function(Val, Level) -- in case of table
 	local Level = Level or 0 -- same logic needs to be applied to ensure its backwards compatible
	local Conversion = {string='String', number='Number', boolean='Boolean', table='Table'}
	local TypeOf = type(Val)
	
	local Result = Conversion[TypeOf]
	if Result ~= 'Table' then
		return Serialize[Result](Val)
	else
		return Serialize[Result](Val, Level + 1)
	end
end
Serialize.Table = function(Tab, Level)
	local Level = Level or 1
	
	assert(Level < 15, "this table's depth is too large to serialize")
	
	local Result = {}
	for Index, Value in pairs(Tab) do
		local SerializedIndex, SerializedValue = Serialize.Value(Index, Level), Serialize.Value(Value, Level)
		
		Insert(Result, string.format("%s[%s] = %s", Rep("\t", Level), SerializedIndex, SerializedValue))
	end
	
	Result = ((Level == 1 and "return ") or "") .. '{\n' .. table.concat(Result, ",\n") .. "\n" .. Rep("\t", Level - 1) .. "}"
	return Result
end

setmetatable(Serialize, {
	__call = function(self, ...)
		return self.Value(...)
	end
})

return Serialize