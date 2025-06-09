task.spawn(function()
    local HttpService = game:GetService("HttpService")

    local config = getgenv().Wedbook and getgenv().Wedbook.Wedbook
    if not config or not config.Url then return end

    local url = config.Url
    local delayTime = tonumber(config.Delay) or 0
    local contentConfig = config.Content or {}

    task.wait(delayTime)

    local messageParts = {}

    if contentConfig["Ping Everyone"] then
        table.insert(messageParts, "@everyone")
    end

    if contentConfig["Ping Here"] then
        table.insert(messageParts, "@here")
    end

    if contentConfig["Ping Id Role"] and contentConfig["RoleId"] then
        table.insert(messageParts, "<@&" .. tostring(contentConfig["RoleId"]) .. ">")
    end

    if contentConfig["Ping Id User"] and contentConfig["UserId"] then
        table.insert(messageParts, "<@" .. tostring(contentConfig["UserId"]) .. ">")
    end

    if contentConfig.Content then
        table.insert(messageParts, tostring(contentConfig.Content))
    end

    local finalMessage = table.concat(messageParts, " ")

    local payload = {
        content = finalMessage
    }

    local request =
        (typeof(http_request) == "function" and http_request)
        or (typeof(request) == "function" and request)
        or (syn and syn.request)
        or (fluxus and fluxus.request)

    if request then
        pcall(function()
            request{
                Url = url,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(payload)
            }
        end)
    end
end)
