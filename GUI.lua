--Namespace and initital setup
local _, core = ...         --Global addon namespace
local L = core.L            --Global localisation table
core.Config = {}            --Add a config table to the addon namespace
local EAT_InfoFrameConfig

--Tab Frames
local Config = core.Config
local EasternKingdomsContent
local EasternKingdomsContentButtons = {}
local KalimdorContent
local KalimdorContentButtons = {}
local OutlandContent
local OutlandContentButtons = {}
local NorthrendContent
local NorthrendContentButtons = {}
local CataclysmContent
local CataclysmContentButtons = {}
local PandariaContent
local PandariaContentButtons = {}
local DraenorContent
local DraenorContentButtons = {}
local LegionContent
local LegionContentButtons = {}
local BattleForAzerothContent
local BattleForAzerothContentButtons = {}
local ShadowlandsContent
local ShadowlandsContentButtons = {}

--EATAchievementTrackerTracking = {}

--Tab Config
Config.currentTab = nil         --Stores which tab is currently selected
Config.currentZone = nil        --Current area we are in

--Options
EATAchievementTrackerOptions = {}
EATAchievementTrackerTracking = {}

--Release Info
Config.majorVersion = 1						--Addon with a higher major version change have priority over a lower major version
Config.minorVersion = 0    				--Addon with a minor version change have prioirty over a lower minor version
Config.revisionVersion = 0					--Addon with a revision change have the same priorty as a lower revision verison

--Localisation functions
function Config:getLocalisedMapName(uiMapID)
    local info = C_Map.GetMapInfo(uiMapID)
    return info.name
end

--Toggles the GUI to show or hide
function Config:Toggle()
    local GUI = EATUIConfig or Config:CreateGUI()
    GUI:SetShown(not GUI:IsShown())
    AltGameTooltip:Hide()
end

function Config:InfoFrameToggleOn()
    print("Showing InfoFrame")
    local InfoFrame = EAT_InfoFrameConfig
    if not InfoFrame:IsShown() then
        InfoFrame:SetShown(true)
    end
end

function Config:InfoFrameToggleOff()
    print("Hiding InfoFrame")
    local InfoFrame = EAT_InfoFrameConfig
    if InfoFrame:IsShown() then
        InfoFrame:SetShown(false)
    end
end

function EAT_GlobalToggle()
    local GUI = EATUIConfig or Config:CreateGUI()
    GUI:SetShown(not GUI:IsShown())
    AltGameTooltip:Hide()
end

--GUI elements helper functions
function Config:CreateButton(point, relativeFrame, relativePoint, yOffset, text, mapID)
	local btn = CreateFrame("Button", nil, relativeFrame, "GameMenuButtonTemplate");
	btn:SetPoint(point, relativeFrame, relativePoint, 0, yOffset);
	btn:SetSize(200, 30);
	btn:SetText(text);
	btn:SetNormalFontObject("GameFontNormal");
    btn:SetHighlightFontObject("GameFontHighlight");
    if mapID ~= nil then                                                                --If the mapID paramters was passed, set the ID of the button the mapID
        local mapID = tostring(mapID)                                                   --This is used so when the user clicks on the button we can fetch the
        mapID = mapID:gsub('%-', '')                                                    --information relating to that ID from the instances table.
        btn:SetID(tonumber(mapID))
    end
	return btn;
end

function Config:CreateButton2(point, relativeFrame, relativePoint, xOffset, yOffset, text)
	local btn = CreateFrame("Button", nil, relativeFrame, "GameMenuButtonTemplate");
	btn:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset);
	btn:SetSize(200, 30);
	btn:SetText(text);
	btn:SetNormalFontObject("GameFontNormal");
	btn:SetHighlightFontObject("GameFontHighlight");
	return btn;
end

function Config:CreateCheckBox(point, relativeFrame, relativePoint, xOffset, yOffset, checkboxName)
    local chk = CreateFrame("CheckButton", checkboxName, relativeFrame, "UICheckButtonTemplate")
	chk:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset);
	return chk;
end

function Config:CreateSlider(point, relativeFrame, relativePoint, xOffset, yOffset, sliderName)
    local chk = CreateFrame("Slider", sliderName, relativeFrame, "OptionsSliderTemplate")
	chk:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset);
	return chk;
end

function Config:CreateText(point, relativeFrame, relativePoint, xOffset, yOffset, textString)
    local text = relativeFrame:CreateFontString(nil, relativeFrame, "GameFontHighlightSmall")
    text:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset)
    text:SetText(textString)
    return text
end

function Config:CreateText2(point, relativeFrame, relativePoint, xOffset, yOffset, textString, size)
    local text = EATUIConfig:CreateFontString(nil, relativeFrame, size)
    text:SetPoint(point, relativeFrame, relativePoint, xOffset, yOffset)
    text:SetText(textString)
    return text
end

--Fired when player clicks on tab at bottom
function Tab_OnClick(self)
    Config.currentTab = self:GetID();                           --Get the ID of the tab the user has selected.
    PanelTemplates_SetTab(self:GetParent(), self:GetID())       --Changed the selected tab to the tab the user has just clicked on

    --This scrollframe holds the button for each zone shown on the expansion tabs
    --If this scrollframe is currently being shown then hide it and shown the correct frame for the tab that has just been clicked
    local scrollChild = EATUIConfig.ScrollFrame:GetScrollChild()
    if scrollChild then
        scrollChild:Hide()
    end
    EATUIConfig.ScrollFrame:SetScrollChild(self.content)

    --This scrollframe holds the tactics, achievements and players for the selected zone.
    --If this scrollframe is currently being shown then hide it and shown the correct frame for the tab that has just been clicked
    local scrollChild2 = EATUIConfig.ScrollFrame2:GetScrollChild()
    if scrollChild2 then
        scrollChild2:Hide()
    end
    EATUIConfig.ScrollFrame2:SetScrollChild(self.contenta)

    --Show the content for the selected instances
    self.content:Show()
    if self.contenta ~= nil then
        self.contenta:Show()
    end

    if Config.currentTab == 1 then      --User has clicked on the "Options" tab
        EATUIConfig.ScrollFrame:Hide()
        EATUIConfig.ScrollFrame2:Hide()

        if EATUIConfig.Main then   --Options tab frames have already been created so just shown them.
            EATUIConfig.Main:Show()
            EATUIConfig.Main2:Show()

            EATUIConfig.Main2.options:Show()
            EATUIConfig.Main2.options:Show()
            EATUIConfig.Main2.options2:Show()
            EATUIConfig.Main2.options3:Show()
            EATUIConfig.Main2.options4:Show()
            EATUIConfig.Main2.options5:Show()
            EATUIConfig.Main2.options6:Show()
            EATUIConfig.Main2.options7:Show()
            EATUIConfig.Main2.options8:Show()
            EATUIConfig.Main2.options9:Show()
            EATUIConfig.Main2.options10:Show()
            EATUIConfig.Main2.options11:Show()
            EATUIConfig.Main2.options12:Show()
            EATUIConfig.Main2.options13:Show()

            EATUIConfig.Main.author:Show()
            EATUIConfig.Main.tacticsCredit:Show()
            EATUIConfig.Main.verison:Show()

            EATUIConfig.Main2.content:Show()
            EATUIConfig.Main2.content2:Show()

            if EATUIConfig.Main.translators ~= nil then
                EATUIConfig.Main.translators:Show()
            end

            if EATUIConfig.achievementsCompleted ~= nil then
                EATUIConfig.achievementsCompleted:Hide()
            end
        else                                    --Main tab frames have not been created so need to create frames first before showing.
            --Heading
            EATUIConfig.Main = Config:CreateText2("TOP", EATAchievementTrackerDialogBG, "TOP", 0, -10, "Exploration Achievement Tracker", "GameFontNormalLarge")
            EATUIConfig.Main:SetWidth(850)

            --Author & Translators
            if (GetLocale() == "enGB" or GetLocale() == "enUS") then
                EATUIConfig.Main.author = Config:CreateText2("BOTTOMRIGHT", EATAchievementTrackerDialogBG, "BOTTOMRIGHT", -5, 20, L["GUI_Author"] .. ": (EU) Whizzey-Doomhammer","GameFontNormal")
                EATUIConfig.Main.tacticsCredit = Config:CreateText2("BOTTOMRIGHT", EATAchievementTrackerDialogBG, "BOTTOMRIGHT", -5, 5,L["GUI_Tactics"] .. ": " .. L["Gui_TacticsNames"],"GameFontNormal")
            else
                EATUIConfig.Main.author = Config:CreateText2("BOTTOMRIGHT", EATAchievementTrackerDialogBG, "BOTTOMRIGHT", -5, 35, L["GUI_Author"] .. ": (EU) Whizzey-Doomhammer","GameFontNormal")
                EATUIConfig.Main.translators = Config:CreateText2("BOTTOMRIGHT", EATAchievementTrackerDialogBG, "BOTTOMRIGHT", -5, 20,L["GUI_Translators"] .. ": " .. L["Gui_TranslatorNames"],"GameFontNormal")
                EATUIConfig.Main.tacticsCredit = Config:CreateText2("BOTTOMRIGHT", EATAchievementTrackerDialogBG, "BOTTOMRIGHT", -5, 5,L["GUI_Tactics"] .. ": " .. L["Gui_TacticsNames"],"GameFontNormal")
            end

            --Version
            EATUIConfig.Main.verison = Config:CreateText2("BOTTOMLEFT", EATAchievementTrackerDialogBG, "BOTTOMLEFT", 5, 5, "v" .. Config.majorVersion .. "." .. Config.minorVersion .. "." .. Config.revisionVersion,"GameFontNormal")

            --Currently tracking
            EATUIConfig.Main2 = Config:CreateText2("TOPLEFT", EATUIConfig.Main, "TOPLEFT", 0, -45, L["GUI_TrackingNumber"] .. ":","GameFontNormalLarge")
            EATUIConfig.Main2:SetWidth(300)
            EATUIConfig.Main2:SetJustifyH("LEFT")

            --Work out how many achievements and tactics are currently being tracked
            local achievementsTracked = 0
            local tacticsTracked = 0

            for island, _ in pairs(core.Database) do
                for zone, _ in pairs(core.Database[island]) do
                    for achievement, _ in pairs(core.Database[island][zone]) do
                        if achievement ~= "name" then
                            if core.Database[island][zone][achievement].track ~= nil then
                                achievementsTracked = achievementsTracked + 1
                            end
                            if #core.Database[island][zone][achievement].tactics > 1 then
                                tacticsTracked = tacticsTracked + 1
                            end
                        end
                    end
                end
            end

            EATUIConfig.Main2.content = Config:CreateText2("TOPLEFT", EATUIConfig.Main2, "TOPLEFT", 0, -20, achievementsTracked .. " " .. L["GUI_Achievements"],"GameFontHighlight")
            EATUIConfig.Main2.content2 = Config:CreateText2("TOPLEFT", EATUIConfig.Main2.content, "TOPLEFT", 0, -15, tacticsTracked .. " " .. L["GUI_Tactics"],"GameFontHighlight")

            --Options
            EATUIConfig.Main2.options = Config:CreateText2("TOPLEFT", EATUIConfig.Main2.content2, "TOPLEFT", 0, -30, L["GUI_Options"] .. ":","GameFontNormalLarge")
            EATUIConfig.Main2.options:SetWidth(850)
            EATUIConfig.Main2.options:SetJustifyH("LEFT")

            --Enable Addon
            EATUIConfig.Main2.options2 = Config:CreateCheckBox("TOPLEFT", EATUIConfig, "TOPLEFT", 20, -160, "EATAchievementTracker_EnableAddon")
            EATUIConfig.Main2.options2:SetScript("OnClick", EATEnableAddon_OnClick)
            EATUIConfig.Main2.options3 = Config:CreateText2("TOPLEFT", EATUIConfig, "TOPLEFT", 51, -170, L["GUI_EnableAddon"],"GameFontHighlight")

            --Toggle Minimap Icon
            EATUIConfig.Main2.options4 = Config:CreateCheckBox("TOPLEFT", EATUIConfig.Main2.options2, "TOPLEFT", 0, -25, "EATAchievementTracker_ToggleMinimapIcon")
            EATUIConfig.Main2.options4:SetScript("OnClick", EATToggleMinimapIcon_OnClick)
            EATUIConfig.Main2.options5 = Config:CreateText2("TOPLEFT", EATUIConfig.Main2.options4, "TOPLEFT", 30, -9, L["GUI_ToggleMinimap"],"GameFontHighlight")

            --Only track achievements in the group that players need.
            EATUIConfig.Main2.options6 = Config:CreateCheckBox("TOPLEFT", EATUIConfig.Main2.options4, "TOPLEFT", 0, -25, "EATAchievementTracker_ToggleTrackMissingAchievementsOnly")
            EATUIConfig.Main2.options6:SetScript("OnClick", EATToggleTrackMissingAchievementsOnly_OnClick)
            EATUIConfig.Main2.options7 = Config:CreateText2("TOPLEFT", EATUIConfig.Main2.options6, "TOPLEFT", 30, -9, L["GUI_OnlyTrackMissingAchievements"],"GameFontHighlight")

            --Hide completed achievements`
            EATUIConfig.Main2.options8 = Config:CreateCheckBox("TOPLEFT", EATUIConfig.Main2.options6, "TOPLEFT", 0, -25, "EATAchievementTracker_HideCompletedAchievements")
            EATUIConfig.Main2.options8:SetScript("OnClick", EATToggleHideCompletedAchievements_OnClick)
            EATUIConfig.Main2.options9 = Config:CreateText2("TOPLEFT", EATUIConfig.Main2.options8, "TOPLEFT", 30, -9, L["GUI_HideCompletedAchievements"],"GameFontHighlight")

            --Grey out completed achievements
            EATUIConfig.Main2.options10 = Config:CreateCheckBox("TOPLEFT", EATUIConfig.Main2.options8, "TOPLEFT", 0, -25, "EATAchievementTracker_GreyOutCompletedAchievements")
            EATUIConfig.Main2.options10:SetScript("OnClick", EATToggleGreyOutCompletedAchievements_OnClick)
            EATUIConfig.Main2.options11 = Config:CreateText2("TOPLEFT", EATUIConfig.Main2.options10, "TOPLEFT", 30, -9, L["GUI_GreyOutCompletedAchievements"],"GameFontHighlight")

            --Track achievements completed by player instead of account
            EATUIConfig.Main2.options12 = Config:CreateCheckBox("TOPLEFT", EATUIConfig.Main2.options10, "TOPLEFT", 363, 0, "EATAchievementTracker_TrackCharacterAchievements")
            EATUIConfig.Main2.options12:SetScript("OnClick", EATToggleTrackCharacterAchievements_OnClick)
            EATUIConfig.Main2.options13 = Config:CreateText2("TOPLEFT", EATUIConfig.Main2.options12, "TOPLEFT", 30, -9, L["GUI_TrackCharacterAchievements"],"GameFontHighlight")
        end
    else                                --User has selected an expansion tab so hide main menu options
        EATUIConfig.ScrollFrame:Show()
        EATUIConfig.ScrollFrame2:Show()

        EATUIConfig.Main:Hide()
        EATUIConfig.Main2:Hide()

        EATUIConfig.Main2.options:Hide()
        EATUIConfig.Main2.options:Hide()
        EATUIConfig.Main2.options2:Hide()
        EATUIConfig.Main2.options3:Hide()
        EATUIConfig.Main2.options4:Hide()
        EATUIConfig.Main2.options5:Hide()
        EATUIConfig.Main2.options6:Hide()
        EATUIConfig.Main2.options7:Hide()
        EATUIConfig.Main2.options8:Hide()
        EATUIConfig.Main2.options9:Hide()
        EATUIConfig.Main2.options10:Hide()
        EATUIConfig.Main2.options11:Hide()
        EATUIConfig.Main2.options12:Hide()
        EATUIConfig.Main2.options13:Hide()

        EATUIConfig.Main.author:Hide()
        EATUIConfig.Main.verison:Hide()
        EATUIConfig.Main.tacticsCredit:Hide()

        EATUIConfig.Main2.content:Hide()
        EATUIConfig.Main2.content2:Hide()

        if EATUIConfig.Main.translators ~= nil then
            EATUIConfig.Main.translators:Hide()
        end

        if EATUIConfig.achievementsCompleted ~= nil then
            EATUIConfig.achievementsCompleted:Hide()
        end
    end
end

function EATToggleHideCompletedAchievements_OnClick(self)
    EATAchievementTrackerOptions["hideCompletedAchievements"] = self:GetChecked()
    EATSetHideCompletedAchievements(self:GetChecked())
end

function EATToggleGreyOutCompletedAchievements_OnClick(self)
    EATAchievementTrackerOptions["greyOutCompletedAchievements"] = self:GetChecked()
    EATSetGreyOutCompletedAchievements(self:GetChecked())
end

function EATToggleTrackMissingAchievementsOnly_OnClick(self)
    EATAchievementTrackerOptions["onlyTrackMissingAchievements"] = self:GetChecked()
    EATSetOnlyTrackMissingAchievements(self:GetChecked())
end

function EATToggleTrackCharacterAchievements_OnClick(self)
    EATAchievementTrackerOptions["trackCharacterAchievements"] = self:GetChecked()
    EATSetTrackCharacterAchievements(self:GetChecked())
end

function EATToggleMinimapIcon_OnClick(self)
    -- EATAchievementTrackerOptions["showMinimap"] = self:GetChecked()
    -- if self:GetChecked() then
    --     core.ATButton:Show("InstanceAchievementTracker")
    -- else
    --     core.ATButton:Hide("InstanceAchievementTracker")
    -- end
end

function EATEnableAddon_OnClick(self)
    if (core.inCombat == false and self:GetChecked() == false) or self:GetChecked() == true then
        EATAchievementTrackerOptions["enableAddon"] = self:GetChecked()
        EATSetAddonEnabled(self:GetChecked())
    else
        core:printMessage(L["GUI_BlockDisableAddon"])
        self:SetChecked(true)
    end
end

local function SetTabs(frame, numTabs, ...)
	frame.numTabs = numTabs     --Number of tabs to create. This will need incrementing by 1 each expansion

	local contents = {} --Stores the frames for each of the tabs
	local frameName = frame:GetName()

    --EAT Expansions Tabs
	for i = 1, numTabs do
		local tab = CreateFrame("Button", frameName.."Tab"..i, frame, "CharacterFrameTabButtonTemplate")
		tab:SetID(i)                                --This is used when clicking on the tab to load the correct frames
		tab:SetText(select(i, ...))                 --This select the variables arguments passed into the function. Needs updating each expansion
		tab:SetScript("OnClick", Tab_OnClick)       --This will run the Tab_OnClick() function once the user has selected a tab so we can load the correct frames into the GUI

        if (i == 1) then
            --For the main frame we only want to create one scroll frame which fills the width of the GUI.
            --This is because we have no buttons to click on like in the expansion tabs
            tab.content = CreateFrame("Frame", nil, EATUIConfig.ScrollFrame)
            tab.content:SetSize(878, 460)
            tab.content:Hide()

            table.insert(contents, tab.content)

			tab:SetPoint("TOPLEFT", EATUIConfig, "BOTTOMLEFT", 5, 7);
        else
            --For the expansion frame, we want to create two scroll frames
            --One for the buttons and one for the content
            tab.content = CreateFrame("Frame", nil, EATUIConfig.ScrollFrame)
            tab.content:SetSize(220, 460)
            tab.content:Hide();

            tab.contenta = CreateFrame("Frame", nil, EATUIConfig.ScrollFrame2)
            tab.contenta:SetSize(658, 460)
            tab.contenta:Hide()

            table.insert(contents, tab.content)
            table.insert(contents, tab.contenta)

			tab:SetPoint("TOPLEFT", _G[frameName.."Tab"..(i - 1)], "TOPRIGHT", -14, 0)
		end
    end

    --Tabs for other addons
    local tab = CreateFrame("Button", "EATInstanceAchievementTrackerTab", frame, "OptionsFrameTabButtonTemplate")
    tab:SetID(100)                                 --This is used when clicking on the tab to load the correct frames
    tab:SetText("Dungeons & Raids")  --This select the variables arguments passed into the function. Needs updating each expansion
    tab:SetScript("OnClick", IAT_OnClick)       --This will run the Tab_OnClick() function once the user has selected a tab so we can load the correct frames into the GUI
    tab:SetPoint("TOPLEFT")
    tab:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 20)

    local tab = CreateFrame("Button", "EATExplorationAchievementTrackerTab", _G["EATInstanceAchievementTrackerTab"], "OptionsFrameTabButtonTemplate")
    tab:SetID(100)                                 --This is used when clicking on the tab to load the correct frames
    tab:SetText("Exploration")  --This select the variables arguments passed into the function. Needs updating each expansion
    tab:SetScript("OnClick", EAT_OnClick)       --This will run the Tab_OnClick() function once the user has selected a tab so we can load the correct frames into the GUI
    tab:SetPoint("TOPLEFT")
    tab:SetPoint("TOPLEFT", _G["EATInstanceAchievementTrackerTab"], "TOPLEFT", 120, 0)

	Tab_OnClick(_G[frameName.."Tab1"]) --Load in the main frame to begin with

	return unpack(contents) --Return the table containing all the frames
end

function IAT_OnClick()
    EAT_GlobalToggle()
    IAT_GlobalToggle()
end

function EAT_OnClick()
    EAT_GlobalToggle()
    IAT_GlobalToggle()
end

function deepdump( tbl )
    local checklist = {}
    local function innerdump( tbl, indent )
        checklist[ tostring(tbl) ] = true
        for k,v in pairs(tbl) do
            print(indent..k,v,type(v),checklist[ tostring(tbl) ])
            if (type(v) == "table" and not checklist[ tostring(v) ]) then innerdump(v,indent.."    ") end
        end
    end
    print("=== DEEPDUMP -----")
    checklist[ tostring(tbl) ] = true
    innerdump( tbl, "" )
    print("------------------")
end

function Config:CreateGUI()
    --Main Frame
    EATUIConfig = CreateFrame("Frame", "EATAchievementTracker", UIParent, "UIPanelDialogTemplate")
    EATUIConfig:SetSize(900, 500)
    EATUIConfig:SetPoint("CENTER")
    EATUIConfig:SetMovable(true)
    EATUIConfig:EnableMouse(true)
    EATUIConfig:SetClampedToScreen(true)
    EATUIConfig:RegisterForDrag("LeftButton")
    EATUIConfig:SetScript("OnDragStart", EATUIConfig.StartMoving)
    EATUIConfig:SetScript("OnDragStop", EATUIConfig.StopMovingOrSizing)

    --Title
    EATUIConfig.title = EATUIConfig:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	EATUIConfig.title:SetPoint("CENTER", EATAchievementTrackerTitleBG, "CENTER", 6, 1);
	EATUIConfig.title:SetText("Exploration Achievement Tracker");

    --Scroll Frame For Buttons
    EATUIConfig.ScrollFrame = CreateFrame("ScrollFrame", nil, EATUIConfig, "UIPanelScrollFrameTemplate")
    EATUIConfig.ScrollFrame:SetPoint("TOPLEFT", EATAchievementTrackerDialogBG, "TOPLEFT", 4, -8)
    EATUIConfig.ScrollFrame:SetWidth(220)
    EATUIConfig.ScrollFrame:SetHeight(460)
    EATUIConfig.ScrollFrame:SetClipsChildren(true)

    --Scroll Bar For Buttons
    EATUIConfig.ScrollFrame.ScrollBar:ClearAllPoints()
    EATUIConfig.ScrollFrame.ScrollBar:SetPoint("TOPLEFT", EATUIConfig.ScrollFrame, "TOPRIGHT", -12, -18)
    EATUIConfig.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", EATUIConfig.ScrollFrame, "BOTTOMRIGHT", -7, 18)

    --Scroll Frame For Content
     EATUIConfig.ScrollFrame2 = CreateFrame("ScrollFrame", nil, EATUIConfig, "UIPanelScrollFrameTemplate")
     EATUIConfig.ScrollFrame2:SetPoint("TOPRIGHT", EATAchievementTrackerDialogBG, "TOPRIGHT", 0, -8)
     EATUIConfig.ScrollFrame2:SetWidth(658)
     EATUIConfig.ScrollFrame2:SetHeight(460)

     --Scroll Bar For Content
     EATUIConfig.ScrollFrame2.ScrollBar:ClearAllPoints()
     EATUIConfig.ScrollFrame2.ScrollBar:SetPoint("TOPLEFT", EATUIConfig.ScrollFrame2, "TOPRIGHT", -12, -18)
     EATUIConfig.ScrollFrame2.ScrollBar:SetPoint("BOTTOMRIGHT", EATUIConfig.ScrollFrame2, "BOTTOMRIGHT", -7, 18)

    --Tabs
    content1, EasternKingdomsNavEAT, EasternKingdomsContent, KalimdorNavEAT, KalimdorContent, OutlandNavEAT, OutlandContent, NorthrendNavEAT, NorthrendContent, CataclysmNavEAT, CataclysmContent, PandariaNavEAT, PandariaContent, DraenorNavEAT, DraenorContent, LegionNavEAT, LegionContent, BattleForAzerothNavEAT, BattleForAzerothContent, ShadowlandsNavEAT, ShadowlandsContent = SetTabs(EATUIConfig, 11, L["GUI_Options"], L["GUI_EasternKingdoms"], L["GUI_Kalimdor"], L["GUI_Outland"], L["GUI_Northrend"], L["GUI_Cataclysm"], L["GUI_Pandaria"], L["GUI_Draenor"], L["GUI_Legion"], L["GUI_BattleForAzeroth"], L["GUI_Shadowlands"])

    --Content (Main)
    content1.title = content1:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
	content1.title:SetPoint("CENTER", EATAchievementTrackerDialogBG, "CENTER", -2, 210);

    --Create the navigation buttons for each expansion
    local expansions = 10

    for i = 2, 11 do
        local localisedZoneNames = {}
        local previousInstance
        local firstZone = false

        --Lets get all localised zones and place in a table, this can then be sorted alphabetically before we create the buttons
        --We need to save the original ID aswell so key value pairs
        for instance,v in pairs(core.Database[i]) do
            local zoneName = Config:getLocalisedMapName(core.Database[i][instance].name)
            if zoneName ~= nil then
                print("Inserting: " .. zoneName)
                table.insert(localisedZoneNames, {name = zoneName, id = instance});
            end
        end

        table.sort(localisedZoneNames, function( a,b ) return a.name < b.name end)

        for instance,instanceTable in pairs(localisedZoneNames) do
            if firstZone == false then
                if i == 2 then
                    EasternKingdomsNavEAT[instanceTable.id] = self:CreateButton("TOPLEFT", EasternKingdomsNavEAT, "TOPLEFT", 0, instanceTable.name, instanceTable.id);
                    EasternKingdomsNavEAT[instanceTable.id]:SetScript("OnClick", EATMap_OnClick);
                elseif i == 3 then
                    KalimdorNavEAT[instanceTable.id] = self:CreateButton("TOPLEFT", KalimdorNavEAT, "TOPLEFT", 0, instanceTable.name, instanceTable.id);
                    KalimdorNavEAT[instanceTable.id]:SetScript("OnClick", EATMap_OnClick);
                elseif i == 4 then
                    OutlandNavEAT[instanceTable.id] = self:CreateButton("TOPLEFT", OutlandNavEAT, "TOPLEFT", 0, instanceTable.name, instanceTable.id);
                    OutlandNavEAT[instanceTable.id]:SetScript("OnClick", EATMap_OnClick);
                elseif i == 5 then
                    NorthrendNavEAT[instanceTable.id] = self:CreateButton("TOPLEFT", NorthrendNavEAT, "TOPLEFT", 0, instanceTable.name, instanceTable.id);
                    NorthrendNavEAT[instanceTable.id]:SetScript("OnClick", EATMap_OnClick);
                elseif i == 6 then
                    CataclysmNavEAT[instanceTable.id] = self:CreateButton("TOPLEFT", CataclysmNavEAT, "TOPLEFT", 0, instanceTable.name, instanceTable.id);
                    CataclysmNavEAT[instanceTable.id]:SetScript("OnClick", EATMap_OnClick);
                elseif i == 7 then
                    PandariaNavEAT[instanceTable.id] = self:CreateButton("TOPLEFT", PandariaNavEAT, "TOPLEFT", 0, instanceTable.name, instanceTable.id);
                    PandariaNavEAT[instanceTable.id]:SetScript("OnClick", EATMap_OnClick);
                elseif i == 8 then
                    DraenorNavEAT[instanceTable.id] = self:CreateButton("TOPLEFT", DraenorNavEAT, "TOPLEFT", 0, instanceTable.name, instanceTable.id);
                    DraenorNavEAT[instanceTable.id]:SetScript("OnClick", EATMap_OnClick);
                elseif i == 9 then
                    LegionNavEAT[instanceTable.id] = self:CreateButton("TOPLEFT", LegionNavEAT, "TOPLEFT", 0, instanceTable.name, instanceTable.id);
                    LegionNavEAT[instanceTable.id]:SetScript("OnClick", EATMap_OnClick);
                elseif i == 10 then
                    BattleForAzerothNavEAT[instanceTable.id] = self:CreateButton("TOPLEFT", BattleForAzerothNavEAT, "TOPLEFT", 0, instanceTable.name, instanceTable.id);
                    BattleForAzerothNavEAT[instanceTable.id]:SetScript("OnClick", EATMap_OnClick);
                elseif i == 11 then
                    ShadowlandsNavEAT[instanceTable.id] = self:CreateButton("TOPLEFT", ShadowlandsNavEAT, "TOPLEFT", 0, instanceTable.name, instanceTable.id);
                    ShadowlandsNavEAT[instanceTable.id]:SetScript("OnClick", EATMap_OnClick);
                end
                firstZone = true
                previousInstance = instanceTable.id
            else
                if i == 2 then
                    EasternKingdomsNavEAT[instanceTable.id] = self:CreateButton("TOPLEFT", EasternKingdomsNavEAT[previousInstance], "TOPLEFT", -32, instanceTable.name, instanceTable.id);
                    EasternKingdomsNavEAT[instanceTable.id]:SetScript("OnClick", EATMap_OnClick);
                elseif i == 3 then
                    KalimdorNavEAT[instanceTable.id] = self:CreateButton("TOPLEFT", KalimdorNavEAT[previousInstance], "TOPLEFT", -32, instanceTable.name, instanceTable.id);
                    KalimdorNavEAT[instanceTable.id]:SetScript("OnClick", EATMap_OnClick);
                elseif i == 4 then
                    OutlandNavEAT[instanceTable.id] = self:CreateButton("TOPLEFT", OutlandNavEAT[previousInstance], "TOPLEFT", -32, instanceTable.name, instanceTable.id);
                    OutlandNavEAT[instanceTable.id]:SetScript("OnClick", EATMap_OnClick);
                elseif i == 5 then
                    NorthrendNavEAT[instanceTable.id] = self:CreateButton("TOPLEFT", NorthrendNavEAT[previousInstance], "TOPLEFT", -32, instanceTable.name, instanceTable.id);
                    NorthrendNavEAT[instanceTable.id]:SetScript("OnClick", EATMap_OnClick);
                elseif i == 6 then
                    CataclysmNavEAT[instanceTable.id] = self:CreateButton("TOPLEFT", CataclysmNavEAT[previousInstance], "TOPLEFT", -32, instanceTable.name, instanceTable.id);
                    CataclysmNavEAT[instanceTable.id]:SetScript("OnClick", EATMap_OnClick);
                elseif i == 7 then
                    PandariaNavEAT[instanceTable.id] = self:CreateButton("TOPLEFT", PandariaNavEAT[previousInstance], "TOPLEFT", -32, instanceTable.name, instanceTable.id);
                    PandariaNavEAT[instanceTable.id]:SetScript("OnClick", EATMap_OnClick);
                elseif i == 8 then
                    DraenorNavEAT[instanceTable.id] = self:CreateButton("TOPLEFT", DraenorNavEAT[previousInstance], "TOPLEFT", -32, instanceTable.name, instanceTable.id);
                    DraenorNavEAT[instanceTable.id]:SetScript("OnClick", EATMap_OnClick);
                elseif i == 9 then
                    LegionNavEAT[instanceTable.id] = self:CreateButton("TOPLEFT", LegionNavEAT[previousInstance], "TOPLEFT", -32, instanceTable.name, instanceTable.id);
                    LegionNavEAT[instanceTable.id]:SetScript("OnClick", EATMap_OnClick);
                elseif i == 10 then
                    BattleForAzerothNavEAT[instanceTable.id] = self:CreateButton("TOPLEFT", BattleForAzerothNavEAT[previousInstance], "TOPLEFT", -32, instanceTable.name, instanceTable.id);
                    BattleForAzerothNavEAT[instanceTable.id]:SetScript("OnClick", EATMap_OnClick);
                elseif i == 11 then
                    ShadowlandsNavEAT[instanceTable.id] = self:CreateButton("TOPLEFT", ShadowlandsNavEAT[previousInstance], "TOPLEFT", -32, instanceTable.name, instanceTable.id);
                    ShadowlandsNavEAT[instanceTable.id]:SetScript("OnClick", EATMap_OnClick);
                end
                previousInstance = instanceTable.id
            end
        end
    end

    --Create 200 buttons for each of the expansion tabs
    local buttonHeight = 30
    local numButtons = 200 --Total number of button we need for any instance. We can hide excess button for raids/dungeons with less bosses
    local idCounter = 0
    for j = 2, 11 do
        for i = 1, numButtons do
            if j == 2 then
                EasternKingdomsContentButtons[i] = CreateFrame("Button",nil,EasternKingdomsContent)
                button = EasternKingdomsContentButtons[i]
                button:SetSize(EasternKingdomsContent:GetWidth()-18,buttonHeight)
                button:SetID(idCounter)
                if i == 1 then
                    button:SetPoint("TOPLEFT",0,0-(i-1)*buttonHeight)
                else
                    button:SetPoint("TOPLEFT",EasternKingdomsContentButtons[i-1],"BOTTOMLEFT",0,0)
                end
            elseif j == 3 then
                KalimdorContentButtons[i] = CreateFrame("Button",nil,KalimdorContent)
                button = KalimdorContentButtons[i]
                button:SetSize(KalimdorContent:GetWidth()-18,buttonHeight)
                button:SetID(idCounter)
                if i == 1 then
                    button:SetPoint("TOPLEFT",0,0-(i-1)*buttonHeight)
                else
                    button:SetPoint("TOPLEFT",KalimdorContentButtons[i-1],"BOTTOMLEFT",0,0)
                end
            elseif j == 4 then
                OutlandContentButtons[i] = CreateFrame("Button",nil,OutlandContent)
                button = OutlandContentButtons[i]
                button:SetSize(OutlandContent:GetWidth()-18,buttonHeight)
                button:SetID(idCounter)
                if i == 1 then
                    button:SetPoint("TOPLEFT",0,0-(i-1)*buttonHeight)
                else
                    button:SetPoint("TOPLEFT",OutlandContentButtons[i-1],"BOTTOMLEFT",0,0)
                end
            elseif j == 5 then
                NorthrendContentButtons[i] = CreateFrame("Button",nil,NorthrendContent)
                button = NorthrendContentButtons[i]
                button:SetSize(NorthrendContent:GetWidth()-18,buttonHeight)
                button:SetID(idCounter)
                if i == 1 then
                    button:SetPoint("TOPLEFT",0,0-(i-1)*buttonHeight)
                else
                    button:SetPoint("TOPLEFT",NorthrendContentButtons[i-1],"BOTTOMLEFT",0,0)
                end
            elseif j == 6 then
                CataclysmContentButtons[i] = CreateFrame("Button",nil,CataclysmContent)
                button = CataclysmContentButtons[i]
                button:SetSize(CataclysmContent:GetWidth()-18,buttonHeight)
                button:SetID(idCounter)
                if i == 1 then
                    button:SetPoint("TOPLEFT",0,0-(i-1)*buttonHeight)
                else
                    button:SetPoint("TOPLEFT",CataclysmContentButtons[i-1],"BOTTOMLEFT",0,0)
                end
            elseif j == 7 then
                PandariaContentButtons[i] = CreateFrame("Button",nil,PandariaContent)
                button = PandariaContentButtons[i]
                button:SetSize(PandariaContent:GetWidth()-18,buttonHeight)
                button:SetID(idCounter)
                if i == 1 then
                    button:SetPoint("TOPLEFT",0,0-(i-1)*buttonHeight)
                else
                    button:SetPoint("TOPLEFT",PandariaContentButtons[i-1],"BOTTOMLEFT",0,0)
                end
            elseif j == 8 then
                DraenorContentButtons[i] = CreateFrame("Button",nil,DraenorContent)
                button = DraenorContentButtons[i]
                button:SetSize(DraenorContent:GetWidth()-18,buttonHeight)
                button:SetID(idCounter)
                if i == 1 then
                    button:SetPoint("TOPLEFT",0,0-(i-1)*buttonHeight)
                else
                    button:SetPoint("TOPLEFT",DraenorContentButtons[i-1],"BOTTOMLEFT",0,0)
                end
            elseif j == 9 then
                LegionContentButtons[i] = CreateFrame("Button",nil,LegionContent)
                button = LegionContentButtons[i]
                button:SetSize(LegionContent:GetWidth()-18,buttonHeight)
                button:SetID(idCounter)
                if i == 1 then
                    button:SetPoint("TOPLEFT",0,0-(i-1)*buttonHeight)
                else
                    button:SetPoint("TOPLEFT",LegionContentButtons[i-1],"BOTTOMLEFT",0,0)
                end
            elseif j == 10 then
                BattleForAzerothContentButtons[i] = CreateFrame("Button",nil,BattleForAzerothContent)
                button = BattleForAzerothContentButtons[i]
                button:SetSize(BattleForAzerothContent:GetWidth()-18,buttonHeight)
                button:SetID(idCounter)
                if i == 1 then
                    button:SetPoint("TOPLEFT",0,0-(i-1)*buttonHeight)
                else
                    button:SetPoint("TOPLEFT",BattleForAzerothContentButtons[i-1],"BOTTOMLEFT",0,0)
                end
            elseif j == 11 then
                ShadowlandsContentButtons[i] = CreateFrame("Button",nil,ShadowlandsContent)
                button = ShadowlandsContentButtons[i]
                button:SetSize(ShadowlandsContent:GetWidth()-18,buttonHeight)
                button:SetID(idCounter)
                if i == 1 then
                    button:SetPoint("TOPLEFT",0,0-(i-1)*buttonHeight)
                else
                    button:SetPoint("TOPLEFT",ShadowlandsContentButtons[i-1],"BOTTOMLEFT",0,0)
                end
            end

            -- the text for the header
            button.headerText = button:CreateFontString(nil,"ARTWORK","GameFontNormalLarge")
            button.headerText:SetPoint("LEFT",12,0)

            -- the text for the content
            button.contentText = button:CreateFontString(nil,"ARTWORK","GameFontHighlight")
            button.contentText:SetPoint("TOPLEFT",16,0)
            button.contentText:SetJustifyH("LEFT")

            --Tactics
            button.tactics = Config:CreateButton2("TOPRIGHT", button, "TOPRIGHT", -1, -7, L["GUI_OutputTactics"])
            button.tactics:SetID(idCounter)

            --Players
            --button.players = Config:CreateButton2("TOPRIGHT", button.tactics, "TOPLEFT", -7, -1, L["GUI_OutputPlayers"])
            --button.players:SetID(idCounter)

            --Enable Tracking
            button.toggleTracking = Config:CreateButton2("TOPRIGHT", button.tactics, "TOPLEFT", -7, -1, L["GUI_StartTracking"])
            button.toggleTracking:SetID(idCounter)

            --Track
            button.enabled = Config:CreateCheckBox("TOPRIGHT", button.toggleTracking, "TOPLEFT", -7, -1)
            button.enabled:SetID(idCounter)

            -- --Track Fontstring
            -- button.enabledText = Config:CreateText("TOPRIGHT", button.enabled, "TOPLEFT", 0, 1, L["GUI_Track"])

            button:Hide()

            --print(idCounter)
            idCounter = idCounter + 1
        end
    end

    local generatedIDCounter = 0
    --Create a unqiue ID for each boss
    for island, _ in pairs(core.Database) do
        for zone, _ in pairs(core.Database[island]) do
            for achievement, _ in pairs(core.Database[island][zone]) do
                if achievement ~= "name" then
                    core.Database[island][zone][achievement].generatedID = generatedIDCounter
                    --print(core.Database[island][zone][achievement].generatedID, core.Database[island][zone][achievement].achievement)
                    generatedIDCounter = generatedIDCounter + 1
                end
            end
        end
    end
end

function Config:EATMap_OnClickAutomatic()
    EATMap_OnClick(nil)
end

function EATMap_OnClick(self)
    local mapLocation
    local currentTabCompressed
    local str
    local numButtons = 200
    local counter = 1
    local counter2 = 1
    local heightDifference = 30
    local instanceType

    if type(self) == "table" then
        --Button has been pressed by the user
        local InstanceID = self:GetID()     --Get the ID of the button that was pressed

        print(Config.currentTab,InstanceID)
        if core.Database[Config.currentTab][InstanceID] ~= nil then
            mapLocation = core.Database[Config.currentTab][InstanceID]
        end
    else
        --Button needs updating for current instance. Automatically clicked by addon
        mapLocation = core.Database[core.island][core.zone]

        --Set the current tab to the expansion of the current instance
        Config.currentTab = core.island

        --Set the current instance
        Config.currentInstance = core.zone
    end

    local achievementFound = false --This is so we can display "All Achievements completed for this instance" if needed
    if EATUIConfig.achievementsCompleted ~= nil then
        EATUIConfig.achievementsCompleted:Hide()
    end

    --Hide all buttons initially
    for i = 1, numButtons do
        local button
        if Config.currentTab == 2 then
            button = EasternKingdomsContentButtons[i]
        elseif Config.currentTab == 3 then
            button = KalimdorContentButtons[i]
        elseif Config.currentTab == 4 then
            button = OutlookContentButtons[i]
        elseif Config.currentTab == 5 then
            button = NorthrendContentButtons[i]
        elseif Config.currentTab == 6 then
            button = CataclysmContentButtons[i]
        elseif Config.currentTab == 7 then
            button = PandariaContentButtons[i]
        elseif Config.currentTab == 8 then
            button = DraenorContentButtons[i]
        elseif Config.currentTab == 9 then
            button = LegionContentButtons[i]
        elseif Config.currentTab == 10 then
            button = BattleForAzerothContentButtons[i]
        elseif Config.currentTab == 11 then
            button = ShadowlandsContentButtons[i]
        end
        button:Hide()
    end

    for achievement,v in pairs(mapLocation) do
        if achievement ~= "name" then --Don't fetch the name of the map that has been clicked
            --Check if any players in the group need the achievement
            local playersFound = true

            --Check if any players in the group need the current achievement for the current instance they are inside off
            -- if core:has_value(mapLocation[achievement].players, L["GUI_NoPlayersNeedAchievement"]) == false and #mapLocation[achievement].players ~= 0 then
            --     playersFound = true
            -- end

            --If we are currently not tracking achievements for the current player then scan the achievements on current tab so we can honor hide/grey achievements option
            if core.achievementTrackingEnabled == false then
                local _, _, _, completed = GetAchievementInfo(mapLocation[achievement].achievement)
                if completed == false then
                    playersFound = true
                end
            end

            --Check whether or not to display the current achievements. This is done incase user wants to hide completed achievements
            if playersFound == true or core.achievementDisplayStatus == "show" or core.achievementDisplayStatus == "grey" then
                achievementFound = true

                --We need to display the current achievement
                local button

                --Header
                --Get the set of buttons for the current selected tab
                if Config.currentTab == 2 then
                    button = EasternKingdomsContentButtons[counter]
                elseif Config.currentTab == 3 then
                    button = KalimdorContentButtons[counter]
                elseif Config.currentTab == 4 then
                    button = OutlookContentButtons[counter]
                elseif Config.currentTab == 5 then
                    button = NorthrendContentButtons[counter]
                elseif Config.currentTab == 6 then
                    button = CataclysmContentButtons[counter]
                elseif Config.currentTab == 7 then
                    button = PandariaContentButtons[counter]
                elseif Config.currentTab == 8 then
                    button = DraenorContentButtons[counter]
                elseif Config.currentTab == 9 then
                    button = LegionContentButtons[counter]
                elseif Config.currentTab == 10 then
                    button = BattleForAzerothContentButtons[counter]
                elseif Config.currentTab == 11 then
                    button = ShadowlandsContentButtons[counter]
                end

                print(Config.currentTab)
                button:Show()

                if counter > 1 then
                    button:ClearAllPoints()
                    if Config.currentTab == 2 then
                        button:SetPoint("TOPLEFT",EasternKingdomsContentButtons[counter-1],"BOTTOMLEFT",0,30-heightDifference)
                    elseif Config.currentTab == 3 then
                        button:SetPoint("TOPLEFT",KalimdorContentButtons[counter-1],"BOTTOMLEFT",0,30-heightDifference)
                    elseif Config.currentTab == 4 then
                        button:SetPoint("TOPLEFT",OutlandContentButtons[counter-1],"BOTTOMLEFT",0,30-heightDifference)
                    elseif Config.currentTab == 5 then
                        button:SetPoint("TOPLEFT",NothrendContentButtons[counter-1],"BOTTOMLEFT",0,30-heightDifference)
                    elseif Config.currentTab == 6 then
                        button:SetPoint("TOPLEFT",CataclysmContentButtons[counter-1],"BOTTOMLEFT",0,30-heightDifference)
                    elseif Config.currentTab == 7 then
                        button:SetPoint("TOPLEFT",PandariaContentButtons[counter-1],"BOTTOMLEFT",0,30-heightDifference)
                    elseif Config.currentTab == 8 then
                        button:SetPoint("TOPLEFT",DraenorContentButtons[counter-1],"BOTTOMLEFT",0,30-heightDifference)
                    elseif Config.currentTab == 9 then
                        button:SetPoint("TOPLEFT",LegionContentButtons[counter-1],"BOTTOMLEFT",0,30-heightDifference)
                    elseif Config.currentTab == 10 then
                        button:SetPoint("TOPLEFT",BattleForAzerothContentButtons[counter-1],"BOTTOMLEFT",0,30-heightDifference)
                    elseif Config.currentTab == 11 then
                        button:SetPoint("TOPLEFT",ShadowlandsContentButtons[counter-1],"BOTTOMLEFT",0,30-heightDifference)
                    end
                end

                print(achievement)
                deepdump(mapLocation)
                print(mapLocation[achievement].achievement)
                local id, name = GetAchievementInfo(mapLocation[achievement].achievement)
                button.headerText:SetText(name)
                button.headerText:Show()
                button.contentText:Hide()
                button:SetNormalTexture("Interface\\Common\\Dark-GoldFrame-Button")

                button.tactics:Show()
                button.tactics:SetSize(120, 15)
                button.tactics:SetScript("OnClick", Tactics_OnClick);
                --button.players:Show()
                --button.players:SetSize(120, 15)
                --button.players:SetScript("OnClick", Player_OnClick);
                button.enabled:Show()
                button.toggleTracking:Show()
                button.toggleTracking:SetSize(120, 15)
                button.toggleTracking:SetScript("OnClick", EATToggleTracking_OnClick)
                button.enabled:SetSize(20, 15)
                button.enabled:SetChecked(mapLocation[achievement].enabled)
                button.enabled:SetScript("OnClick", Enabled_OnClick);
                if mapLocation[achievement].track ~= nil then
                    --button.enabledText:Show()
                    --button.enabledText:SetSize(30, 15)
                else
                    --button.enabledText:Hide()
                    button.enabled:Hide()
                end

                --We need to set the ID of the tactics/players/track buttons to the id of the current boss so when clicked we know which boss we need to fetch info for
                button.tactics:SetID(mapLocation[achievement].generatedID)
                button.toggleTracking:SetID(mapLocation[achievement].generatedID)
                --button.players:SetID(mapLocation[achievement].generatedID)
                --button.enabled:SetID(mapLocation[achievement].generatedID)

                counter = counter + 1

                if playersFound == false and core.achievementDisplayStatus == "grey" then
                    --Grey Out/Hide achievements
                    button.headerText:SetTextColor(0.827, 0.811, 0.811, 0.3)
                else
                    --Show/Un-grey achievements
                    button.headerText:SetTextColor(1, 0.854, 0.039)
                end

                --Get status of tracking
                if EATAchievementTrackerTracking[mapLocation[achievement].achievement] ~= false then
                    --Achievement is being tracked. Button should say stop tracking
                    print("START1", mapLocation[achievement].achievement)
                    button.toggleTracking:SetText(L["GUI_StopTracking"])
                else
                    print("STOP1", mapLocation[achievement].achievement)
                    button.toggleTracking:SetText(L["GUI_StartTracking"])
                end

                --Content
                if Config.currentTab == 2 then
                    button = EasternKingdomsContentButtons[counter]
                elseif Config.currentTab == 3 then
                    button = KalimdorContentButtons[counter]
                elseif Config.currentTab == 4 then
                    button = OutlookContentButtons[counter]
                elseif Config.currentTab == 5 then
                    button = NorthrendContentButtons[counter]
                elseif Config.currentTab == 6 then
                    button = CataclysmContentButtons[counter]
                elseif Config.currentTab == 7 then
                    button = PandariaContentButtons[counter]
                elseif Config.currentTab == 8 then
                    button = DraenorContentButtons[counter]
                elseif Config.currentTab == 9 then
                    button = LegionContentButtons[counter]
                elseif Config.currentTab == 10 then
                    button = BattleForAzerothContentButtons[counter]
                elseif Config.currentTab == 11 then
                    button = ShadowlandsContentButtons[counter]
                end

                local players = L["GUI_Players"] .. ": "
                -- for i = 1, #mapLocation[achievement].players do
                --     players = players .. mapLocation[achievement].players[i] .. ", "
                -- end

                --If tactics are in a table then we need to show diferent tactics for each faction
                local tactics
                if type(mapLocation[achievement].tactics) == "table" then
                    if UnitFactionGroup("player") == "Alliance" then
                        tactics = mapLocation[achievement].tactics[1]
                    else
                        tactics = mapLocation[achievement].tactics[2]
                    end
                else
                    tactics = mapLocation[achievement].tactics
                end


                print(players,tactics)
                --Only show players if user has enabled achievement tracking
                if core.achievementTrackingEnabled == false then
                    button.contentText:SetText(L["GUI_Tactic"] .. ": " .. tactics)
                else
                    button.contentText:SetText(players .. "\n\n" .. L["GUI_Tactic"] .. ": " .. tactics)
                end

                if playersFound == false and core.achievementDisplayStatus == "grey" then
                    --Grey Out/Hide achievements
                    button.contentText:SetTextColor(0.827, 0.811, 0.811, 0.3)
                else
                    --Show/Un-grey achievements
                    button.contentText:SetTextColor(1, 1, 1)
                end

                button.contentText:Show()
                button.headerText:Hide()
                button:SetNormalTexture(nil)
                button.contentText:SetWidth(600)
                button.contentText:SetHeight(500)

                button.contentText:SetWordWrap(true)
                button.contentText:SetHeight(button.contentText:GetStringHeight())
                heightDifference = button.contentText:GetStringHeight();

                button.tactics:Hide()
                --button.players:Hide()
                button.enabled:Hide()
                --button.enabledText:Hide()

                button.achievementID = mapLocation[achievement].achievement
                button:SetScript("OnEnter", EATAchievement_OnEnter)
                button:SetScript("OnLeave", EATAchievement_OnLeave)
                button:SetScript("OnHide", EATAchievement_OnHide)

                button:Show()
                counter = counter + 1
            end
            counter2 = counter2 + 1
        end
    end

    if achievementFound == false then
        if EATUIConfig.achievementsCompleted == nil then
            EATUIConfig.achievementsCompleted = EATUIConfig:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
            EATUIConfig.achievementsCompleted:SetPoint("CENTER", EATUIConfig.ScrollFrame2, "CENTER", -20, 0);
            EATUIConfig.achievementsCompleted:SetWordWrap(true)
            EATUIConfig.achievementsCompleted:SetWidth(600)
        end

        if instanceType == "Scenarios" then
            EATUIConfig.achievementsCompleted:SetText(L["GUI_AchievementsCompletedForInstance"] .. " " .. Config:getLocalisedMapName(mapLocation.name));
        else
            EATUIConfig.achievementsCompleted:SetText(L["GUI_AchievementsCompletedForInstance"] .. " " .. Config:getLocalisedMapName(mapLocation.name));
        end
        EATUIConfig.achievementsCompleted:Show()
    end

    --Hide the remaining buttons
    for i = counter, numButtons do
        local button
        if Config.currentTab == 2 then
            button = EasternKingdomsContentButtons[i]
        elseif Config.currentTab == 3 then
            button = KalimdorContentButtons[i]
        elseif Config.currentTab == 4 then
            button = OutlookContentButtons[i]
        elseif Config.currentTab == 5 then
            button = NorthrendContentButtons[i]
        elseif Config.currentTab == 6 then
            button = CataclysmContentButtons[i]
        elseif Config.currentTab == 7 then
            button = PandariaContentButtons[i]
        elseif Config.currentTab == 8 then
            button = DraenorContentButtons[i]
        elseif Config.currentTab == 9 then
            button = LegionContentButtons[i]
        elseif Config.currentTab == 10 then
            button = BattleForAzerothContentButtons[i]
        elseif Config.currentTab == 11 then
            button = ShadowlandsContentButtons[i]
        end
        button:Hide()
    end
end

function ClearGUITabs()
    for i = 1, 200 do
        local button
        button = ShadowlandsContentButtons[i]
        button:Hide()
        button = BattleForAzerothContentButtons[i]
        button:Hide()
        button = LegionContentButtons[i]
        button:Hide()
        button = DraenorContentButtons[i]
        button:Hide()
        button = PandariaContentButtons[i]
        button:Hide()
        button = CataclysmContentButtons[i]
        button:Hide()
        button = NorthrendContentButtons[i]
        button:Hide()
        button = OutlandContentButtons[i]
        button:Hide()
        button = KalimdorContentButtons[i]
        button:Hide()
        button = EasternKingdomsContentButtons[i]
        button:Hide()
    end
end

function EATAchievement_OnEnter(self)
    AltGameTooltip:Hide()
end

function EATAchievement_OnHide(self)
    AltGameTooltip:Hide()
end

function EATAchievement_OnEnter(self)
    local foundAchievement = false
    if Config.currentTab == 1 then
        for i = 1, #EasternKingdomsContentButtons do
            if MouseIsOver(EasternKingdomsContentButtons[i]) then
                AltGameTooltip:SetOwner(EATUIConfig, "ANCHOR_TOPRIGHT")
                AltGameTooltip:SetHyperlink(GetAchievementLink(EasternKingdomsContentButtons[i].achievementID))
                AltGameTooltip:Show()
                foundAchievement = true
            end
        end
    elseif Config.currentTab == 2 then
        for i = 1, #KalimdorContentButtons do
            if MouseIsOver(KalimdorContentButtons[i]) then
                AltGameTooltip:SetOwner(EATUIConfig, "ANCHOR_TOPRIGHT")
                AltGameTooltip:SetHyperlink(GetAchievementLink(KalimdorContentButtons[i].achievementID))
                AltGameTooltip:Show()
                foundAchievement = true
            end
        end
    elseif Config.currentTab == 3 then
        for i = 1, #OutlandContentButtons do
            if MouseIsOver(OutlandContentButtons[i]) then
                AltGameTooltip:SetOwner(EATUIConfig, "ANCHOR_TOPRIGHT")
                AltGameTooltip:SetHyperlink(GetAchievementLink(OutlandContentButtons[i].achievementID))
                AltGameTooltip:Show()
                foundAchievement = true
            end
        end
    elseif Config.currentTab == 4 then
        for i = 1, #NorthrendContentButtons do
            if MouseIsOver(NothrendContentButtons[i]) then
                AltGameTooltip:SetOwner(EATUIConfig, "ANCHOR_TOPRIGHT")
                AltGameTooltip:SetHyperlink(GetAchievementLink(NothrendContentButtons[i].achievementID))
                AltGameTooltip:Show()
                foundAchievement = true
            end
        end
    elseif Config.currentTab == 5 then
        for i = 1, #CataclysmContentButtons do
            if MouseIsOver(CataclysmContentButtons[i]) then
                AltGameTooltip:SetOwner(EATUIConfig, "ANCHOR_TOPRIGHT")
                AltGameTooltip:SetHyperlink(GetAchievementLink(CataclysmContentButtons[i].achievementID))
                AltGameTooltip:Show()
                foundAchievement = true
            end
        end
    elseif Config.currentTab == 6 then
        for i = 1, #ContentButtons do
            if MouseIsOver(PandariaContentButtons[i]) then
                AltGameTooltip:SetOwner(EATUIConfig, "ANCHOR_TOPRIGHT")
                AltGameTooltip:SetHyperlink(GetAchievementLink(PandariaContentButtons[i].achievementID))
                AltGameTooltip:Show()
                foundAchievement = true
            end
        end
    elseif Config.currentTab == 7 then
        for i = 1, #WarlordsOfDraenorContentButtons do
            if MouseIsOver(DraenorContentButtons[i]) then
                AltGameTooltip:SetOwner(EATUIConfig, "ANCHOR_TOPRIGHT")
                AltGameTooltip:SetHyperlink(GetAchievementLink(DraenorContentButtons[i].achievementID))
                AltGameTooltip:Show()
                foundAchievement = true
            end
        end
    elseif Config.currentTab == 8 then
        for i = 1, #LegionContentButtons do
            if MouseIsOver(LegionContentButtons[i]) then
                AltGameTooltip:SetOwner(EATUIConfig, "ANCHOR_TOPRIGHT")
                AltGameTooltip:SetHyperlink(GetAchievementLink(LegionContentButtons[i].achievementID))
                AltGameTooltip:Show()
                foundAchievement = true
            end
        end
    elseif Config.currentTab == 9 then
        for i = 1, #BattleForAzerothContentButtons do
            if MouseIsOver(BattleForAzerothContentButtons[i]) then
                AltGameTooltip:SetOwner(EATUIConfig, "ANCHOR_TOPRIGHT")
                AltGameTooltip:SetHyperlink(GetAchievementLink(BattleForAzerothContentButtons[i].achievementID))
                AltGameTooltip:Show()
                foundAchievement = true
            end
        end
    elseif Config.currentTab == 10 then
        for i = 1, #ShadowlandsContentButtons do
            if MouseIsOver(ShadowlandsContentButtons[i]) then
                AltGameTooltip:SetOwner(EATUIConfig, "ANCHOR_TOPRIGHT")
                AltGameTooltip:SetHyperlink(GetAchievementLink(ShadowlandsContentButtons[i].achievementID))
                AltGameTooltip:Show()
                foundAchievement = true
            end
        end
    end

    if foundAchievement == false then
        AltGameTooltip:Hide()
    end
end

function EATToggleTracking_OnClick(self)
    for island, _ in pairs(core.Database) do
        for zone, _ in pairs(core.Database[island]) do
            for achievement, _ in pairs(core.Database[island][zone]) do
                if achievement ~= "name" then
                    if core.Database[island][zone][achievement].generatedID == self:GetID() then
                        print("ID",core.Database[island][zone][achievement].achievement)
                        if self:GetText() == L["GUI_StopTracking"] then
                            print("START4")
                            --Start Tracking
                            self:SetText(L["GUI_StartTracking"])
                            EATAchievementTrackerTracking[core.Database[island][zone][achievement].achievement] = false
                            print("Saved", EATAchievementTrackerTracking[core.Database[island][zone][achievement].achievement])
                        elseif self:GetText() == L["GUI_StartTracking"] then
                            --Stop Tracking
                            print("STOP3")
                            self:SetText(L["GUI_StopTracking"])
                            EATAchievementTrackerTracking[core.Database[island][zone][achievement].achievement] = true
                            print("Saved", EATAchievementTrackerTracking[core.Database[island][zone][achievement].achievement])
                        end
                    end
                end
            end
        end
    end

    core:checkForTracking()
end

local frameBackdrop = {
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
	tile = true,
	tileSize = 16,
	insets = { left = 2, right = 14, top = 2, bottom = 2 },
}

function Config:EAT_CreateInfoFrame()
    print("Creating InfoFrame")
    EAT_InfoFrameConfig = CreateFrame("Frame", "EAT_InfoFrame", UIParent, "BackdropTemplate")
    EAT_InfoFrameConfig:SetSize(200, 300)
    EAT_InfoFrameConfig:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", 420, 500)
    EAT_InfoFrameConfig:SetMovable(true)
    EAT_InfoFrameConfig:EnableMouse(true)
    EAT_InfoFrameConfig:SetClampedToScreen(true)
    EAT_InfoFrameConfig:RegisterForDrag("LeftButton")
    --EAT_InfoFrameConfig:SetBackdrop(frameBackdrop);
    EAT_InfoFrameConfig:SetScript("OnDragStart", EAT_InfoFrameConfig.StartMoving)
    EAT_InfoFrameConfig:SetScript("OnDragStop", function(self)
        EAT_InfoFrameConfig:StopMovingOrSizing()
        --AchievementTrackerOptions["infoFrameXPos"] = self:GetLeft()
        --AchievementTrackerOptions["infoFrameYPos"] = self:GetTop()
        --AchievementTrackerOptions["infoFrameScale"] = self:GetScale()
        --print(AchievementTrackerOptions["infoFrameXPos"], AchievementTrackerOptions["infoFrameYPos"])
    end)
end

function Config:EAT_InfoFrameSetNextWaypoint(achievementID,text,instructions)
    if text ~= nil then
        Config:SetHeading(GetAchievementLink(achievementID))
        Config:SetSubHeading1("|cff59FF00Next Stop:|r")
        Config:SetText1(text)
        Config:SetSubHeading2("|cff59FF00Instructions:|r")
        Config:SetText2(instructions)
        C_Timer.After(1, function()
            Config:SetText1(text .. " (" .. math.floor(C_Navigation.GetDistance()) .. " yards) ")
        end)
    end
end

function Config:SetHeading(text)
    if EAT_InfoFrameConfig.heading == nil then
        print("Creating text")
        EAT_InfoFrameConfig.heading = EAT_InfoFrameConfig:CreateFontString(nil, "BACKGROUND", "GameFontHighlightLarge")
    end
    EAT_InfoFrameConfig.heading:SetText(text)
    EAT_InfoFrameConfig.heading:SetHeight(EAT_InfoFrameConfig.heading:GetStringHeight())
    EAT_InfoFrameConfig.heading:SetPoint("TOPLEFT", EAT_InfoFrameConfig, "TOPLEFT", 5, -5)
end

function Config:SetSubHeading1(text)
    if EAT_InfoFrameConfig.subHeading1 == nil then
        EAT_InfoFrameConfig.subHeading1 = EAT_InfoFrameConfig:CreateFontString(nil, "BACKGROUND", "GameFontHighlightLarge")
    end
    EAT_InfoFrameConfig.subHeading1:SetText(text)
    EAT_InfoFrameConfig.subHeading1:SetHeight(EAT_InfoFrameConfig.subHeading1:GetStringHeight())
    EAT_InfoFrameConfig.subHeading1:ClearAllPoints()
    EAT_InfoFrameConfig.subHeading1:SetPoint("TOPLEFT", EAT_InfoFrameConfig.heading, "BOTTOMLEFT", 0, -5)
end

function Config:SetText1(text,size,colour,width)
    if EAT_InfoFrameConfig.setText1 == nil then
        if size == nil then
            EAT_InfoFrameConfig.setText1 = EAT_InfoFrameConfig:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
        else
            EAT_InfoFrameConfig.setText1 = EAT_InfoFrameConfig:CreateFontString(nil, "BACKGROUND", size)
        end
    end

    if width ~= nil then
        EAT_InfoFrameConfig.setText1:SetWidth(width)
    end

    EAT_InfoFrameConfig.setText1:SetText(text)
    EAT_InfoFrameConfig.setText1:SetHeight(EAT_InfoFrameConfig.setText1:GetStringHeight())
    EAT_InfoFrameConfig.setText1:SetPoint("TOPLEFT", EAT_InfoFrameConfig.subHeading1, "BOTTOMLEFT", 0, -5)

    EAT_InfoFrameConfig.setText1:SetJustifyH("LEFT")
    EAT_InfoFrameConfig.setText1:SetJustifyV("TOP")
end

function Config:SetSubHeading2(text)
    if EAT_InfoFrameConfig.setSubHeading2 == nil then
        EAT_InfoFrameConfig.setSubHeading2 = EAT_InfoFrameConfig:CreateFontString(nil, "BACKGROUND", "GameFontHighlightLarge")
    end
    EAT_InfoFrameConfig.setSubHeading2:SetText(text)
    EAT_InfoFrameConfig.setSubHeading2:SetHeight(EAT_InfoFrameConfig.setSubHeading2:GetStringHeight())
    EAT_InfoFrameConfig.setSubHeading2:SetPoint("TOPLEFT", EAT_InfoFrameConfig.setText1, "BOTTOMLEFT", 0, -5)

    EAT_InfoFrameConfig.setSubHeading2:SetJustifyH("LEFT")
    EAT_InfoFrameConfig.setSubHeading2:SetJustifyV("TOP")
end

function Config:SetText2(text,width)
    if EAT_InfoFrameConfig.setText2 == nil then
        EAT_InfoFrameConfig.setText2 = EAT_InfoFrameConfig:CreateFontString(nil, "BACKGROUND", "GameFontHighlight")
    end

    if width ~= nil then
        EAT_InfoFrameConfig.setText2:SetWidth(width)
    end

    EAT_InfoFrameConfig.setText2:SetText(text)
    EAT_InfoFrameConfig.setText2:SetHeight(EAT_InfoFrameConfig.setText2:GetStringHeight())
    EAT_InfoFrameConfig.setText2:SetPoint("TOPLEFT", EAT_InfoFrameConfig.setSubHeading2, "BOTTOMLEFT", 0, -5)

    EAT_InfoFrameConfig.setText2:SetJustifyH("LEFT")
    EAT_InfoFrameConfig.setText2:SetJustifyV("TOP")
end

Config:CreateGUI()
Config:EAT_CreateInfoFrame()
EATUIConfig:Hide()
EAT_InfoFrameConfig:Hide()