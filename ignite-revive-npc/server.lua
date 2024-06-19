QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('qb-revive:server:revivePlayer')
AddEventHandler('qb-revive:server:revivePlayer', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        TriggerClientEvent('hospital:client:Revive', src)
    end
end)