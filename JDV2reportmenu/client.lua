ESX = exports['es_extended']:getSharedObject()

local isUIOpen = false

local function Notify(title, message, duration, notifType)
    local success = pcall(function()
        TriggerEvent('wasabi_notify:notify', title, message, duration, notifType)
    end)
    
    if not success then
        ESX.ShowNotification(message)
    end
end

local function CloseUI()
    if isUIOpen then
        isUIOpen = false
        SetNuiFocus(false, false)
        SendNUIMessage({ action = 'closeUI' })
    end
end

RegisterCommand('report', function()
    if not isUIOpen then
        isUIOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({ action = 'openReportUI' })
    end
end)

RegisterCommand('reports', function(source)
    ESX.TriggerServerCallback('reportmenu:isAdmin', function(isAdmin)
        if isAdmin then
            ESX.TriggerServerCallback('reportmenu:getReports', function(reports)
                if not isUIOpen then
                    isUIOpen = true
                    SetNuiFocus(true, true)
                    SendNUIMessage({
                        action = 'openAdminUI',
                        reports = reports
                    })
                end
            end)
        else
            Notify('Permission Denied', 'You do not have permission to use this command', 5000, 'error')
        end
    end)
end)

RegisterNUICallback('closeUI', function(data, cb)
    cb('ok')
    CloseUI()
end)

RegisterNUICallback('submitReport', function(data, cb)
    cb('ok')
    if data.title and data.description then
        TriggerServerEvent('reportmenu:submitReport', data.title, data.description)
    end
end)

RegisterNUICallback('closeReport', function(data, cb)
    cb('ok')
    TriggerServerEvent('reportmenu:closeReport', data.reportId)
end)

RegisterNUICallback('bringPlayer', function(data, cb)
    cb('ok')
    TriggerServerEvent('reportmenu:bringPlayer', data.reportId)
end)

RegisterNUICallback('teleportToPlayer', function(data, cb)
    cb('ok')
    TriggerServerEvent('reportmenu:teleportToPlayer', data.reportId)
end)

RegisterNUICallback('freezePlayer', function(data, cb)
    cb('ok')
    TriggerServerEvent('reportmenu:freezePlayer', data.reportId)
end)

RegisterNUICallback('unfreezePlayer', function(data, cb)
    cb('ok')
    TriggerServerEvent('reportmenu:unfreezePlayer', data.reportId)
end)

RegisterNetEvent('reportmenu:reportSubmitted')
AddEventHandler('reportmenu:reportSubmitted', function()
    CloseUI()
    Wait(100)
    Notify('Report Submitted', 'Your report has been submitted successfully', 5000, 'success')
end)

RegisterNetEvent('reportmenu:notification')
AddEventHandler('reportmenu:notification', function(message, notifType)
    Notify('Report System', message, 5000, notifType or 'info')
end)

RegisterNetEvent('reportmenu:refreshReports')
AddEventHandler('reportmenu:refreshReports', function()
    if isUIOpen then
        ESX.TriggerServerCallback('reportmenu:getReports', function(reports)
            SendNUIMessage({
                action = 'updateReports',
                reports = reports
            })
        end)
    end
end)

RegisterNetEvent('reportmenu:bringToAdmin')
AddEventHandler('reportmenu:bringToAdmin', function(adminCoords)
    SetEntityCoords(PlayerPedId(), adminCoords.x, adminCoords.y, adminCoords.z, false, false, false, true)
    Notify('Teleported', 'An admin has brought you to them', 5000, 'info')
end)

RegisterNetEvent('reportmenu:teleportAdminToPlayer')
AddEventHandler('reportmenu:teleportAdminToPlayer', function(targetCoords)
    SetEntityCoords(PlayerPedId(), targetCoords.x, targetCoords.y, targetCoords.z, false, false, false, true)
    Notify('Teleported', 'Teleported to player', 5000, 'success')
end)

RegisterNetEvent('reportmenu:freezePlayer')
AddEventHandler('reportmenu:freezePlayer', function(freeze)
    FreezeEntityPosition(PlayerPedId(), freeze)
    if freeze then
        Notify('Frozen', 'You have been frozen by an admin', 5000, 'warning')
    else
        Notify('Unfrozen', 'You have been unfrozen by an admin', 5000, 'success')
    end
end)

RegisterCommand('fixfocus', function()
    isUIOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'closeUI' })
end)
