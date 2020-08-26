local _, core = ... 											--Global Addon Namespace
local L = core.L												--Translation Table

local events = CreateFrame("Frame")								--All events are registered to this frame
local EATUIConfig													--UIConfig is used to make a display asking the user if they would like
local UICreated = false											--To enable achievement tracking when they enter an instances
local debugMode = false
local debugModeChat = false
local sendDebugMessages = false

EATachievementTrackerOptions = {}
EATAchievementTrackerTracking = {}

events:RegisterEvent("ADDON_LOADED")
events:RegisterEvent("ZONE_CHANGED_NEW_AREA")
events:RegisterEvent("SUPER_TRACKING_CHANGED")
events:RegisterEvent("USER_WAYPOINT_UPDATED")
events:RegisterEvent("CRITERIA_EARNED")
events:RegisterEvent("CRITERIA_UPDATE")

--Waypoint Scheduler
local waypoints = {}
local schedulerStarted = false
local waypointQueue = {}
local schedulerLock = false
local scheulderReschedule = false

events:SetScript("OnEvent", function(self, event, ...)
    return self[event] and self[event](self, event, ...)
end)

function events:ADDON_LOADED(event, name)
    if name ~= "ExplorationAchievementTracker" then return end

    core:checkForTracking()
end

function events:ZONE_CHANGED_NEW_AREA()
    waypoints = {}
    core:checkForTracking()
end

function events:SUPER_TRACKING_CHANGED()
end

function events:USER_WAYPOINT_UPDATED()
end

function events:CRITERIA_EARNED(self, achievementID, description)
    print("CriteriaEarned")
    core:getNextWaypoint()
end

function events:CRITERIA_UPDATE()
    print("CriteriaUpdate")
    core:getNextWaypoint()
end

function core:checkForTracking()
    local mapID = C_Map.GetBestMapForUnit("Player")
    local achievementFoundForTracking = false

    --Set Information to current zone
    for island, _ in pairs(core.Database) do
        for zone, _ in pairs(core.Database[island]) do
            if zone == mapID then
                core.island = island
                core.zone = zone

                --Track achievements for zone
                for achievement, _ in pairs(core.Database[island][zone]) do
                    if achievement ~= "name" then
                        print(island,zone,achievement)
                        if core.Database[island][zone][achievement].enabled == true and EATAchievementTrackerTracking[core.Database[island][zone][achievement].achievement] == true then
                            core.Database[island][zone][achievement].track()
                            core.Config:EATMap_OnClickAutomatic()
                            core.Config:InfoFrameToggleOn()
                            achievementFoundForTracking = true
                        end
                    end
                end
            end
        end
    end

    if achievementFoundForTracking == false then
        core.Config:InfoFrameToggleOff()
    else
        core:calculateRoute()
        core:getNextWaypoint()
    end
end

function core:calculateRoute()
    --Re-evluates all waypoints
    local waypointsTmp = {}
    local bestDistance = nil
    local route = {}

    for index3, value3 in ipairs(waypoints) do
        local newWaypoint = {}
        newWaypoint.x = value3.x
        newWaypoint.y = value3.y
        newWaypoint.trackingType = value3.trackingType
        newWaypoint.trackingInfo = value3.trackingInfo
        newWaypoint.trackingInfo2 = value3.trackingInfo2
        newWaypoint.notes = value3.notes
        local criteriaString, criteriaType, completed, quantity, reqQuantity, charName, flags, assetID, quantityString, criteriaID, eligible = GetAchievementCriteriaInfo(value3.trackingInfo, value3.trackingInfo2)
        local _, _, _, completedAchievement, _, _, _, _, _, _, _, _, wasEarnedByMe = GetAchievementInfo(value3.trackingInfo)
        if wasEarnedByMe == false and completed == false then
            print("Adding: " .. GetAchievementCriteriaInfo(value3.trackingInfo, value3.trackingInfo2) .. " to tmp array")
            table.insert(waypointsTmp, newWaypoint)
        end
    end

    --Add current player position
    local playerX, playerY = C_Map.GetPlayerMapPosition(core.zone, "Player"):GetXY()
    -- local newWaypoint = {}
    -- newWaypoint.x = playerX
    -- newWaypoint.y = playerY
    -- table.insert(waypointsTmp, newWaypoint)
    -- print("Inserting players current position into tmp array (" .. newWaypoint.x .. "," .. newWaypoint.y .. ")")

    --Remove completed waypoints
    -- for index, value in ipairs(waypointsTmp) do
    --     if value.trackingInfo ~= nil then
    --         local criteriaString, criteriaType, completed, quantity, reqQuantity, charName, flags, assetID, quantityString, criteriaID, eligible = GetAchievementCriteriaInfo(value.trackingInfo, value.trackingInfo2)
    --         local _, _, _, completedAchievement, _, _, _, _, _, _, _, _, wasEarnedByMe = GetAchievementInfo(value.trackingInfo)
    --         print(wasEarnedByMe, completed)
    --         if wasEarnedByMe == true or completed == true then
    --             print("Removing " .. criteriaString .. " before performing algorithm (" .. value.x .. "," .. value.y .. ")")
    --             table.remove(waypointsTmp, index)
    --         else
    --             print("OK " .. criteriaString)
    --         end
    --     else
    --         print("NIL DETECTED :(")
    --     end
    -- end

    print("Waypoints loaded: " .. #waypointsTmp .. ". Calculating route using Nearest Neighbour algorithm")

    --Loop through all waypoints in tmp array (so we can get each root position)
    for index, value in ipairs(waypointsTmp) do
        print("Root position set to (" .. value.x .. "," .. value.y .. ")")
        --Loop through all waypoints in tmp array (so we can calculate the distance)
        local waypointRouteX = nil
        local waypointRouteY = nil
        local calculatedDistance = 0
        local calculatedRoute = {}

        local waypointsTmp2 = {}
        for index3, value3 in ipairs(waypointsTmp) do
            local newWaypoint = {}
            newWaypoint.x = value3.x
            newWaypoint.y = value3.y
            newWaypoint.trackingType = value3.trackingType
            newWaypoint.trackingInfo = value3.trackingInfo
            newWaypoint.trackingInfo2 = value3.trackingInfo2
            newWaypoint.notes = value3.notes
            table.insert(waypointsTmp2, newWaypoint)
        end

        for i = 1, #waypointsTmp do
            --print("Performing Iteration " .. i .. " size " .. #waypointsTmp)
            local distanceFound = nil
            local tableIndex = nil
            local routeDetails = {}

            --Get closest point to last point
            for index2, value2 in ipairs(waypointsTmp2) do
                --Find waypoint with shortest distance
                if waypointRouteX == nil and waypointRouteY == nil then
                    distance = core:GetDistance(value.x,value.y,value2.x,value2.y)
                    --print("(1) Distance from (" .. value.x .. "," .. value.y .. ") to (" .. value2.x .. "," .. value2.y .. ") is " .. distance)
                else
                    distance = core:GetDistance(waypointRouteX,waypointRouteY,value2.x,value2.y)
                    --print("Distance from (" .. waypointRouteX .. "," .. waypointRouteY .. ") to (" .. value2.x .. "," .. value2.y .. ") is " .. distance)
                end

                if distanceFound == nil then
                    distanceFound = distance
                    routeDetails = value2
                    tableIndex = index2
                    --print("New best distance is " .. distanceFound)
                elseif distance < distanceFound then
                    distanceFound = distance
                    routeDetails = value2
                    tableIndex = index2
                    --print("New best distance is " .. distanceFound)
                end
            end

            --print("Best Next stop distance is " .. distanceFound)
            waypointRouteX = routeDetails.x
            waypointRouteY = routeDetails.y
            calculatedDistance = calculatedDistance + distanceFound
            table.remove(waypointsTmp2, tableIndex)

            --Add route if not players position
            if waypointRouteX ~= playerX then
                local newWaypoint = {}
                newWaypoint.x = waypointRouteX
                newWaypoint.y = waypointRouteY
                newWaypoint.trackingType = routeDetails.trackingType
                newWaypoint.trackingInfo = routeDetails.trackingInfo
                newWaypoint.trackingInfo2 = routeDetails.trackingInfo2
                newWaypoint.notes = routeDetails.notes
                table.insert(calculatedRoute, newWaypoint)
            end
        end

        --Add distance back to starting point
        distance = core:GetDistance(value.x,value.y,playerX,playerY)
        calculatedDistance = calculatedDistance + distance
        print("Adding distance from player to first point: " .. distance)

        print("Total distance for the route is " .. calculatedDistance .. " " .. #calculatedRoute)
        --Check if distance is lowest
        if bestDistance == nil then
            bestDistance = calculatedDistance
            waypoints = calculatedRoute
            print("This is the lowest distance")
        elseif calculatedDistance < bestDistance then
            bestDistance = calculatedDistance
            waypoints = calculatedRoute
            print("This is the lowest distance")
        end
    end

    --Output route
    local routeStr = "Route Calculated: "
    for index,value in ipairs(waypoints) do
        if index ~= #waypoints then
            routeStr = routeStr .. GetAchievementCriteriaInfo(value.trackingInfo, value.trackingInfo2) .. ", "
        else
            routeStr = routeStr .. GetAchievementCriteriaInfo(value.trackingInfo, value.trackingInfo2)
        end
    end
    core:printMessage(routeStr)
end

function core:getNextWaypoint()
    C_Timer.After(1, function()
        C_Map.ClearUserWaypoint()

        --Route has been sorted using Nearest Neighbour algorithmn.
        if #waypoints > 0 then
            print("Found coordinate at position 1 (" .. waypoints[1].x .. "," .. waypoints[1].y .. ")")
            if waypoints[1].trackingType == 1 then
                --Use achievement criteria to determine if step has been completed
                print("Detected criteria to track")
                local criteriaString, criteriaType, completed, quantity, reqQuantity, charName, flags, assetID, quantityString, criteriaID, eligible = GetAchievementCriteriaInfo(waypoints[1].trackingInfo, waypoints[1].trackingInfo2)
                local _, _, _, completedAchievement, _, _, _, _, _, _, _, _, wasEarnedByMe = GetAchievementInfo(waypoints[1].trackingInfo)
                if (wasEarnedByMe == false) and (completed == false or charName ~= UnitName("Player")) then
                    print("Criteria not completed. Displaying waypoint")
                    core.Config:EAT_InfoFrameSetNextWaypoint(waypoints[1].trackingInfo, GetAchievementCriteriaInfo(waypoints[1].trackingInfo,waypoints[1].trackingInfo2), "Go to Waypoint")
                    local uiMapPoint = UiMapPoint.CreateFromCoordinates(core.zone, waypoints[1].x, waypoints[1].y)
                    C_Map.SetUserWaypoint(uiMapPoint)
                    C_SuperTrack.SetSuperTrackedUserWaypoint(true)
                else
                    print("Removing completed waypoint")
                    table.remove(waypoints, 1)

                    --Call scheduler again to get next waypoint
                    core:getNextWaypoint()
                end
            end
        else
            print("All waypoints have been explored. Hiding InfoFrame")
            --We have been to all waypoints, so toggle InfoFrame off
            core.Config:InfoFrameToggleOff()
        end
    end)
end

function core:InsertWaypoint(x,y,trackingType,trackingInfo,trackingInfo2,notes)
    --Insert Waypoint into scheduler
    local newWaypoint = {}
    if x > 1 then
        --Convert tomtom waypoint
        newWaypoint.x = x / 100
    else
        newWaypoint.x = x
    end
    if y > 1 then
        newWaypoint.y = y / 100
    else
        newWaypoint.y = y
    end
    newWaypoint.trackingType = trackingType
    newWaypoint.trackingInfo = trackingInfo
    newWaypoint.trackingInfo2 = trackingInfo2
    newWaypoint.notes = notes
    table.insert(waypoints, newWaypoint)
    print("Inserting New Waypoint: (" .. newWaypoint.x .. ", " .. newWaypoint.y .. ")")
end

function core:GetDistance(x1,y1,x2,y2)
    return math.abs(math.sqrt((x1-x2)^2 + (y1-y2)^2))
end

function core:has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

function core:printMessage(message)
	print("|cff00ccffEAT: |cffffffff" .. message)
	--core:logMessage("|cff00ccffIAT: |cffffffff" .. message)
end