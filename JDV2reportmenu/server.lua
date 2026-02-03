ESX = exports['es_extended']:getSharedObject()

local reports = {}
local reportIdCounter = 1

CreateThread(function()
    MySQL.query.await([[
        CREATE TABLE IF NOT EXISTS player_reports (
            id INT AUTO_INCREMENT PRIMARY KEY,
            reporter_identifier VARCHAR(50),
            reporter_name VARCHAR(100),
            title VARCHAR(255),
            description TEXT,
            status VARCHAR(20) DEFAULT 'open',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ]])
    
    local result = MySQL.query.await('SELECT * FROM player_reports WHERE status = ?', {'open'})
    
    if result then
        for _, report in ipairs(result) do
            reports[report.id] = {
                id = report.id,
                reporterIdentifier = report.reporter_identifier,
                reporterName = report.reporter_name,
                title = report.title,
                description = report.description,
                timestamp = report.created_at
            }
            if report.id >= reportIdCounter then
                reportIdCounter = report.id + 1
            end
        end
    end
end)

RegisterServerEvent('reportmenu:submitReport')
AddEventHandler('reportmenu:submitReport', function(title, description)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    
    if not xPlayer then return end
    
    local reportId = reportIdCounter
    reportIdCounter = reportIdCounter + 1
    
    reports[reportId] = {
        id = reportId,
        reporterIdentifier = xPlayer.identifier,
        reporterName = xPlayer.getName(),
        title = title,
        description = description,
        timestamp = os.date('%Y-%m-%d %H:%M:%S')
    }
    
    MySQL.insert('INSERT INTO player_reports (id, reporter_identifier, reporter_name, title, description) VALUES (?, ?, ?, ?, ?)', {
        reportId,
        xPlayer.identifier,
        xPlayer.getName(),
        title,
        description
    })
    
    TriggerClientEvent('reportmenu:reportSubmitted', _source)
    
    for _, playerId in ipairs(GetPlayers()) do
        if HasAdminPermission(playerId) then
            TriggerClientEvent('reportmenu:notification', playerId, 'New report from ' .. xPlayer.getName(), 'info')
        end
    end
end)

ESX.RegisterServerCallback('reportmenu:getReports', function(source, cb)
    local reportList = {}
    for id, report in pairs(reports) do
        table.insert(reportList, report)
    end
    
    table.sort(reportList, function(a, b)
        return a.id > b.id
    end)
    
    cb(reportList)
end)

ESX.RegisterServerCallback('reportmenu:isAdmin', function(source, cb)
    cb(HasAdminPermission(source))
end)

RegisterServerEvent('reportmenu:closeReport')
AddEventHandler('reportmenu:closeReport', function(reportId)
    local _source = source
    
    if not HasAdminPermission(_source) then return end
    
    if reports[reportId] then
        reports[reportId] = nil
        
        MySQL.query('DELETE FROM player_reports WHERE id = ?', {reportId})
        
        for _, playerId in ipairs(GetPlayers()) do
            if HasAdminPermission(playerId) then
                TriggerClientEvent('reportmenu:refreshReports', playerId)
            end
        end
    end
end)

RegisterServerEvent('reportmenu:bringPlayer')
AddEventHandler('reportmenu:bringPlayer', function(reportId)
    local _source = source
    
    if not HasAdminPermission(_source) then return end
    
    local report = reports[reportId]
    if not report then 
        TriggerClientEvent('reportmenu:notification', _source, Config.Notifications.reportNotFound.message, Config.Notifications.reportNotFound.type)
        return 
    end
    
    local targetPlayer = ESX.GetPlayerFromIdentifier(report.reporterIdentifier)
    
    if targetPlayer then
        local adminPed = GetPlayerPed(_source)
        local adminCoords = GetEntityCoords(adminPed)
        
        TriggerClientEvent('reportmenu:bringToAdmin', targetPlayer.playerId, adminCoords)
        TriggerClientEvent('reportmenu:notification', _source, Config.Notifications.playerBrought.message, Config.Notifications.playerBrought.type)
    else
        TriggerClientEvent('reportmenu:notification', _source, Config.Notifications.playerNotOnline.message, Config.Notifications.playerNotOnline.type)
    end
end)

RegisterServerEvent('reportmenu:teleportToPlayer')
AddEventHandler('reportmenu:teleportToPlayer', function(reportId)
    local _source = source
    
    if not HasAdminPermission(_source) then return end
    
    local report = reports[reportId]
    if not report then 
        TriggerClientEvent('reportmenu:notification', _source, Config.Notifications.reportNotFound.message, Config.Notifications.reportNotFound.type)
        return 
    end
    
    local targetPlayer = ESX.GetPlayerFromIdentifier(report.reporterIdentifier)
    
    if targetPlayer then
        local targetPed = GetPlayerPed(targetPlayer.playerId)
        local targetCoords = GetEntityCoords(targetPed)
        
        TriggerClientEvent('reportmenu:teleportAdminToPlayer', _source, targetCoords)
        TriggerClientEvent('reportmenu:notification', _source, Config.Notifications.playerTeleported.message, Config.Notifications.playerTeleported.type)
    else
        TriggerClientEvent('reportmenu:notification', _source, Config.Notifications.playerNotOnline.message, Config.Notifications.playerNotOnline.type)
    end
end)

RegisterServerEvent('reportmenu:freezePlayer')
AddEventHandler('reportmenu:freezePlayer', function(reportId)
    local _source = source
    
    if not HasAdminPermission(_source) then return end
    
    local report = reports[reportId]
    if not report then 
        TriggerClientEvent('reportmenu:notification', _source, Config.Notifications.reportNotFound.message, Config.Notifications.reportNotFound.type)
        return 
    end
    
    local targetPlayer = ESX.GetPlayerFromIdentifier(report.reporterIdentifier)
    
    if targetPlayer then
        TriggerClientEvent('reportmenu:freezePlayer', targetPlayer.playerId, true)
        TriggerClientEvent('reportmenu:notification', _source, Config.Notifications.playerFrozen.message, Config.Notifications.playerFrozen.type)
    else
        TriggerClientEvent('reportmenu:notification', _source, Config.Notifications.playerNotOnline.message, Config.Notifications.playerNotOnline.type)
    end
end)

RegisterServerEvent('reportmenu:unfreezePlayer')
AddEventHandler('reportmenu:unfreezePlayer', function(reportId)
    local _source = source
    
    if not HasAdminPermission(_source) then return end
    
    local report = reports[reportId]
    if not report then 
        TriggerClientEvent('reportmenu:notification', _source, Config.Notifications.reportNotFound.message, Config.Notifications.reportNotFound.type)
        return 
    end
    
    local targetPlayer = ESX.GetPlayerFromIdentifier(report.reporterIdentifier)
    
    if targetPlayer then
        TriggerClientEvent('reportmenu:freezePlayer', targetPlayer.playerId, false)
        TriggerClientEvent('reportmenu:notification', _source, Config.Notifications.playerUnfrozen.message, Config.Notifications.playerUnfrozen.type)
    else
        TriggerClientEvent('reportmenu:notification', _source, Config.Notifications.playerNotOnline.message, Config.Notifications.playerNotOnline.type)
    end
end)
