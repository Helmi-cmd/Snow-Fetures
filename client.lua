local cooldown = false

local SnowmanEntity

local snowing = {
    'BLIZZARD',
    'SNOW',
    'SNOWLIGHT',
    'XMAS'
}

local snowmen = {
    'xm3_prop_xm3_snowman_01a',
    'xm3_prop_xm3_snowman_01b',
    'xm3_prop_xm3_snowman_01c',
}
local inSnowman = false


-------------------------------------------------------------------------------------------------------------------------------------------
-- Snowball Making and weather checking

local keybind = lib.addKeybind({
    name = 'snowball',
    description = 'press G to make a snowball',
    defaultKey = 'G',
    onPressed = function(self)
        TriggerEvent('snowball')
    end,
})
RegisterNetEvent('snowball', function()
    local weather = GlobalState.weather.weather

    if not table.contains(snowing, weather) then
        exports.qbx_core:Notify('There is no snow on the ground', 'error', 5000) -- Notify Client, There is no snow on the ground
        return
    end
    if cooldown then
        return
    else
        cooldown = true
    end
    local maxamount = lib.callback.await('checkSnowballCount')                    -- Check if the player has more than 10 snowballs
    if not maxamount then
        exports.qbx_core:Notify('You can\'t carry more snowballs', 'error', 5000) -- Notify Client, You have too many snowballs
        cooldown = false
        return
    end
    if lib.progressCircle({            -- Start the Progress Circle
            label = 'Making snowball', -- Label
            duration = 1500,
            position = 'bottom',
            useWhileDead = false,
            allowCuffed = false,
            allowSwimming = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true,
            },
            anim = { -- anim@mp_snowball : pickup_snowball
                dict = 'anim@mp_snowball',
                clip = 'pickup_snowball',
                flag = 0
            },
        }) then
        print('we completed the progress, Return True')
        TriggerServerEvent('qbx_smallresources:server:addSnowballToInv') -- Trigger Server Event
        Wait(1500)
        cooldown = false
    else
        print('we failed, Returning False')
        exports.qbx_core:Notify('You have cancelled the action', 'error', 5000) -- Notify Client, You cancelled the action
    end
end)

------------------------------------------------------------------------------------------------------------------------------
-- Making of the snowman

RegisterNetEvent('qbx_smallresources:client:snowmanProgress', function()
    if lib.callback.await('checkSnowballAndCarrotCount') then
        exports.qbx_core:Notify('You do not have enough snowballs or carrots', 'error', 5000) -- Notify Client, You do not have enough snowballs or carrots
        return
    end

    if lib.progressCircle({           -- Start the Progress Circle
            label = 'Making Snowman', -- Label
            duration = 15000,
            position = 'bottom',
            useWhileDead = false,
            allowCuffed = false,
            allowSwimming = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true,
            },
            anim = { -- anim@amb@clubhouse@tutorial@bkr_tut_ig3@ : machinic_loop_mechandplayer
                dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
                clip = 'machinic_loop_mechandplayer',
                flag = 0
            },
        }) then
        print('we completed the progress, Return True')

        local playerHeading = GetEntityHeading(cache.ped)
        local playerCoords = GetEntityCoords(cache.ped)

        -- Calculate new coordinates 1 unit in front of the player
        local offsetX = math.sin(math.rad(playerHeading)) * 1.0
        local offsetY = math.cos(math.rad(playerHeading)) * 1.0
        local newCoords = vector4(playerCoords.x - offsetX, playerCoords.y + offsetY, playerCoords.z - 1.0, playerHeading)

        TriggerServerEvent('qbx_smallresources:server:removeSnowballAndCarrotFromInv') -- Trigger Server Event


        local randomIndex = math.random(1, #snowmen)
        local snowmanModel = snowmen[randomIndex]
       SnowmanEntity = CreateObject(snowmanModel, newCoords.x, newCoords.y, newCoords.z, true, true, true) -- Create the snowman
        print('WOOHOO, you made a snowman')
    else
        exports.qbx_core:Notify('You have cancelled the action', 'error', 5000) -- Notify Client, You cancelled the action
    end
end)
------------------------------------------------------------------------------------------------------------------------------
-- Hiding in the snowman and exiting the snowman

local function snowmanCheck()
    inSnowman = true
    print("Entered snowmanCheck, inSnowman set to true")
    CreateThread(function()
        while inSnowman do
            Wait(0)
            if IsControlPressed(0, 32) or not DoesEntityExist(SnowmanEntity) then
                lib.hideTextUI()

                local coords = GetEntityCoords(cache.ped)

                lib.requestAnimDict('anim@sports@ballgame@handball@')
                lib.requestNamedPtfxAsset('core')
                UseParticleFxAssetNextCall('core')
                StartNetworkedParticleFxNonLoopedAtCoord('ent_dst_xt_snowman', coords.x, coords.y, coords.z, 0.0, 0.0, 0.0,
                    1,
                    false, false, false)

                TaskPlayAnim(cache.ped, "anim@sports@ballgame@handball@", "ball_rstop_r", 8.0, -8.0, -1, 0, 0, false,
                    false, false)
                inSnowman = false
                SetEntityVisible(cache.ped, true, false)
                FreezeEntityPosition(cache.ped, false)

                local animDuration = GetAnimDuration('anim@sports@ballgame@handball@', 'ball_rstop_r')

                DeleteEntity(SnowmanEntity)
                Wait(animDuration * 1000)
                RemoveNamedPtfxAsset('core')
                RemoveAnimDict('anim@sports@ballgame@handball@')
            end
        end
    end)
end



local function hideInSnowman(snowmanCoords, snowmanEntity)
    print("Event 'qbx_smallresources:client:hideInSnowman' triggered")
    local playerPed = cache.ped
    local distance = #(GetEntityCoords(playerPed) - vector3(snowmanCoords.x, snowmanCoords.y, snowmanCoords.z))
    print("Distance to snowman:", distance)
    if inSnowman then
        print("Already in snowman, returning")
        return
    end
    if distance > 2.0 then
        print("Too far from snowman, notifying client")
        exports.qbx_core:Notify('You are too far away from the snowman', 'error', 5000) -- Notify Client, You are too far away from the snowman
        return
    end
    print("Hiding in snowman")
    SetEntityVisible(playerPed, false, false)                                                               -- Set the player invisible
    SetEntityCoords(playerPed, snowmanCoords.x, snowmanCoords.y, snowmanCoords.z - 1, 0.0, 0.0, 0.0, false) -- Set the player inside the snowman
    FreezeEntityPosition(playerPed, true)                                                                   -- Freeze the player

    lib.showTextUI('[w] - Exit', {
        position = "top-center",
        style = {
            borderRadius = 0,
            backgroundColor = '#48BB78',
            color = 'white'
        }
    })

    snowmanCheck()
end

for k, v in pairs(snowmen) do
    exports.ox_target:addModel(v, {
        {
            label = 'Hide in Snowman',
            onSelect = function(data)
                print("Snowman selected, triggering event")
                for k, v in pairs(data) do
                    print(k, v)
                end
                hideInSnowman(data.coords, data.entity)
            end
        }
    })
end