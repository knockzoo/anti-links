local Split = require("src.Utils.Split")
local Settings = require("Settings")
local Prefix = Settings.Prefix

local Sub = string.sub
local Find = string.find
local Match = string.match
local ToNumber = tonumber

local function ParseCommands(Content)
	local IsCommand = Sub(Content, 1, #Prefix) == Prefix

	if not IsCommand then
		return false
	end

	local Command, Arguments = Content:sub(2, #Content), {}

	if Find(Command, " ") then
		local AsSplit = Split(Command, " ")
		Command = table.remove(AsSplit, 1)
		Arguments = AsSplit
	end

	return {
		Command = Command,
		Arguments = Arguments
	}
end

return ParseCommands