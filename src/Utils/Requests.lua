-- also not used, but this is useful for any bots that contact a third party api
-- i am deeply retarded, luvit has this built in

local Requests = {Format = {}}

local function RunCommand(Command)
    local Process = io.popen(Command)
    local Result = Process:read("*a")
    Process:close()
    return Result
end

function Requests.Format.Get(URL, Args)
    return string.format("curl -s %s %s", Args, URL)
end

function Requests.Get(URL, Args)
    local Result = RunCommand(Requests.Format.Get(URL, Args))
    return Result
end

function Requests.Format.Post(URL, Args)
    return string.format("curl -s -X POST -d '%s' %s", Args, URL)
end

function Requests.Post(URL, Args)
    local Result = RunCommand(Requests.Format.Post(URL, Args))
    return Result
end

function Requests.Format.Any(Method, URL, Args)
    return string.format("curl -s -X %s -d '%s' %s", Method, Args, URL)
end

function Requests.Any(Method, URL, Args)
    local Result = RunCommand(Requests.Format.Any(Method, URL, Args))
    return Result
end

return Requests