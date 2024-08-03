local function ArchiveDirectory()
    local Process = io.popen("tar -czf src.tar.gz src")
    Process:close()
end

local function MD5(Source)
    local Process = io.popen("md5sum " .. Source)
    local Result = Process:read("*a")
    Process:close()
    return Result:match("%S+")
end

return function()
    ArchiveDirectory()

    local Result = MD5("src.tar.gz")
    os.remove("src.tar.gz")
    return Result
end