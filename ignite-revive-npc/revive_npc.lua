local npcModel = "s_m_m_scientist_01"  -- NPC model
local npcCoords1 = vector4(-924.74, -798.71, 15.92, 52.57)  -- Change these if required
local danceDict = "anim@amb@nightclub@dancers@podium_dancers@"
local danceAnim = "hi_dance_facedj_17_v2_male^6"

local function createNPC(coords)
    RequestModel(GetHashKey(npcModel))
    while not HasModelLoaded(GetHashKey(npcModel)) do
        Citizen.Wait(1)
    end

    local npc = CreatePed(4, GetHashKey(npcModel), coords.x, coords.y, coords.z - 1.0, coords.w, false, true)
    SetEntityHeading(npc, coords.w)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)

    RequestAnimDict(danceDict)
    while not HasAnimDictLoaded(danceDict) do
        Citizen.Wait(1)
    end

    TaskPlayAnim(npc, danceDict, danceAnim, 8.0, -8.0, -1, 1, 0, false, false, false)

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 280)  -- Blip icon
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 2)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Scientist")
    EndTextCommandSetBlipName(blip)
end

Citizen.CreateThread(function()
    createNPC(npcCoords1)
    createNPC(npcCoords2)
    createNPC(npcCoords3)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        local function handleReviveInteraction(coords)
            local distance = #(playerCoords - vector3(coords.x, coords.y, coords.z))
            if distance < 2.0 then
                DrawText3D(coords.x, coords.y, coords.z + 1.0, "[E] Revive Yourself")
                if IsControlJustReleased(0, 38) then  -- 'E' key
                    TriggerServerEvent('qb-revive:server:revivePlayer')
                end
            end
        end

        handleReviveInteraction(npcCoords1)
        handleReviveInteraction(npcCoords2)
        handleReviveInteraction(npcCoords3)
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end
