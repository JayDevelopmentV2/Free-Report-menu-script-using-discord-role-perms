local function GetDiscordRoles(source)
    local identifiers = GetPlayerIdentifiers(source)
    local discordId = nil
    
    for _, id in pairs(identifiers) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end
    
    if not discordId then
        return {}
    end
    
    local endpoint = ("guilds/%s/members/%s"):format(Config.Discord.guildId, discordId)
    local headers = {
        ["Content-Type"] = "application/json",
        ["Authorization"] = "Bot " .. Config.Discord.botToken
    }
    
    PerformHttpRequest("https://discord.com/api/v10/" .. endpoint, function(statusCode, response, headers)
        if statusCode == 200 then
            local data = json.decode(response)
            if data and data.roles then
                return data.roles
            end
        end
    end, "GET", "", headers)
    
    return {}
end

local function HasDiscordRole(source, roleId)
    local identifiers = GetPlayerIdentifiers(source)
    local discordId = nil
    
    for _, id in pairs(identifiers) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end
    
    if not discordId then
        return false
    end
    
    local endpoint = ("guilds/%s/members/%s"):format(Config.Discord.guildId, discordId)
    local headers = {
        ["Content-Type"] = "application/json",
        ["Authorization"] = "Bot " .. Config.Discord.botToken
    }
    
    local hasRole = false
    
    PerformHttpRequest("https://discord.com/api/v10/" .. endpoint, function(statusCode, response, headers)
        if statusCode == 200 then
            local data = json.decode(response)
            if data and data.roles then
                for _, role in pairs(data.roles) do
                    if role == roleId then
                        hasRole = true
                        break
                    end
                end
            end
        end
    end, "GET", "", headers)
    
    Wait(500)
    return hasRole
end

function HasAdminPermission(source)
    if not Config.Discord.enabled then
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer and xPlayer.getGroup() == 'admin'
    end
    
    return HasDiscordRole(source, Config.Discord.adminRoleId)
end
