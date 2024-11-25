--check for snow on the ground
lib.callback.register('checkSnowballCount', function(source)
    local snowballs = exports.ox_inventory:GetItemCount(source, 'weapon_snowball')
    if snowballs >= 10 then
        return false
    end
    return true
end)
RegisterNetEvent('qbx_smallresources:server:addSnowballToInv', function()
    exports.ox_inventory:AddItem(source, 'weapon_snowball', 1) -- Add the item back to the inventory
end)

--------snowman making-------


RegisterNetEvent('qbx_smallresources:server:removeSnowballToInv', function()
    exports.ox_inventory:RemoveItem(source, 'weapon_snowball', 1) -- Add the item back to the inventory
end)

exports.qbx_core:CreateUseableItem('weapon_snowball', function(source, item)
    print('Using item')
    TriggerClientEvent('qbx_smallresources:client:snowmanProgress', source)
end)

RegisterNetEvent('qbx_smallresources:server:removeSnowballAndCarrotFromInv', function()
    local source = source   
    exports.ox_inventory:RemoveItem(source, 'weapon_snowball', 10) -- Remove the item from the inventory
    exports.ox_inventory:RemoveItem(source, 'carrot', 1) -- Remove the item from the inventory
end)

lib.callback.register('checkSnowballAndCarrotCount', function(source)
    local snowballs = exports.ox_inventory:GetItemCount(source, 'weapon_snowball')
    local carrot = exports.ox_inventory:GetItemCount(source, 'carrot')
    if snowballs >= 10 and carrot >= 1 then
        return false
    end
    return true
end)