local _ = function(k,...) return ImportPackage("i18n").t(GetPackageName(),k,...) end

local gatherIds = {}
local processIds = {}

AddRemoteEvent("gatheringSetup", function(gatherObject, processObject)
    gatherIds = gatherObject
    processIds = processObject
end)


function OnKeyPress(key)
    if key == "E" and not alreadyInteracting then
        local NearestGatherZone = GetNearestGatherZone()
        local NearestProcessZone = GetNearestProcessZone()

        if NearestGatherZone ~= 0 then
            CallRemoteEvent( "StartGathering", NearestGatherZone)   
        end
        if NearestProcessZone ~= 0 then
            CallRemoteEvent( "StartProcessing", NearestProcessZone)  
        end
	end
end
AddEvent("OnKeyPress", OnKeyPress)

function GetNearestGatherZone()
	local x, y, z = GetPlayerLocation()
	
	for k,v in pairs(GetStreamedPickups()) do
        local x2, y2, z2 = GetPickupLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 4000.0 then
			for k,i in pairs(gatherIds) do
				if v == i then
					return v
				end
			end
		end
	end

	return 0
end

function GetNearestProcessZone()
	local x, y, z = GetPlayerLocation()
	
	for k,v in pairs(GetStreamedPickups()) do
        local x2, y2, z2 = GetPickupLocation(v)
		local dist = GetDistance3D(x, y, z, x2, y2, z2)

		if dist < 150.0 then
			for k,i in pairs(processIds) do
				if v == i then
					return v
				end
			end
		end
	end

	return 0
end