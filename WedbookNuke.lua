getgenv().Wedbook = {
    ["Wedbook"] = {
        ["Url"] = "",
        ["Delay"] = 1,     
        ["Repeat"] = "",   
        ["Content"] = {
            ["Content"] = "",
            ["Ping Everyone"] = false,
            ["Ping Here"] = false,
            ["Ping Id Role"] = "",
            ["Ping Id User"] = "",
        }
    }
}

task.spawn(function()
    local HttpService = game:GetService("HttpService")
    local config = getgenv().Wedbook and getgenv().Wedbook.Wedbook
    if not config or not config.Url then return end

    local url = config.Url
    local delayTime = tonumber(config.Delay) or 1
    local repeatCount = tonumber(config.Repeat)
    if not repeatCount or repeatCount <= 0 then
        repeatCount = math.huge -- vô hạn
    end

    local contentConfig = config.Content or {}

    local messageParts = {}

    if contentConfig["Ping Everyone"] then
        table.insert(messageParts, "@everyone")
    end

    if contentConfig["Ping Here"] then
        table.insert(messageParts, "@here")
    end

    if contentConfig["Ping Id Role"] and contentConfig["Ping Id Role"] ~= "" then
        table.insert(messageParts, "<@&" .. tostring(contentConfig["Ping Id Role"]) .. ">")
    end

    if contentConfig["Ping Id User"] and contentConfig["Ping Id User"] ~= "" then
        table.insert(messageParts, "<@" .. tostring(contentConfig["Ping Id User"]) .. ">")
    end

    if contentConfig.Content and contentConfig.Content ~= "" then
        table.insert(messageParts, tostring(contentConfig.Content))
    end

    local finalMessage = table.concat(messageParts, " ")

    local request =
        (typeof(http_request) == "function" and http_request)
        or (typeof(request) == "function" and request)
        or (syn and syn.request)
        or (fluxus and fluxus.request)

    for i = 1, repeatCount do
        if request then
            pcall(function()
                request{
                    Url = url,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = HttpService:JSONEncode({ content = finalMessage })
                }
            end)
        end
        task.wait(delayTime)
    end
end)
