local function Split(String, Delimiter)
	local Result = {}
	for Part in String:gmatch("[^" .. Delimiter .. "]+") do
		table.insert(Result, Part)
	end
	
	return Result
end

return Split