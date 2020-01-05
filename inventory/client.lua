local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local personalMenu

AddRemoteEvent("OpenPersonalMenu", function(key, items, inventory, playerName, playerId, playerList)
    OpenUIInventory(key, items, inventory, playerName, playerId, playerList)
end)

function itemUsedInInventory(event)
    local data = json_decode(event)
    CallRemoteEvent("UseInventory", data.idItem, 1)
end
AddEvent('BURDIGALAX_inventory_onUse', itemUsedInInventory)

function itemDeletedInInventory(event)
    local data = json_decode(event)
    print(event)
end
AddEvent('BURDIGALAX_inventory_onDelete', itemDeletedInInventory)

function itemTransferedInInventory(event)
    local data = json_decode(event)
    CallRemoteEvent("TransferInventory", data.idItem, data.quantity, data.destinationInventoryId)
end
AddEvent('BURDIGALAX_inventory_onTransfer', itemTransferedInInventory)


AddEvent("OnKeyPress", function( key )
    if key == "F4" and not alreadyInteracting then
        CallRemoteEvent("ServerPersonalMenu")
    end
end)

AddRemoteEvent("LockControlMove", function(move)
    SetIgnoreMoveInput(move)
end)

