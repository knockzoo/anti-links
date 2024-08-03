return function()
	local Commands = {}
	local p = io.popen("ls src/Commands/*.lua")

	for File in p:lines() do
		File = File:match("([^/]+)%.lua$")
		local Path = "src.Commands." .. File
		local Command = require(Path)
		Commands[Command.Name] = Command
	end

	p:close()
	return Commands
end
