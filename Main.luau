-- V2 IS FINALLY FUCKING OUT, LET'S FUCKING GOOOOOOOOO!!!!!!1

local CoreGui = game:GetService("CoreGui")

-- === WHITELIST DOWN BELOW (dont touch this shit nigga) ===
local whitelistedContainers = {
    ["RobloxGui"] = true,
    ["PlayerList"] = true,
    ["ExperienceChat"] = true,
    ["BubbleChat"] = true,
    ["DevConsole"] = true, 
    ["SocialService"] = true,
    ["PerformanceStats"] = true,
    ["ScreenShotTool"] = true,
    ["EmotesMenu"] = true,
    ["CallDialogScreen"] = true,
    ["CaptureManager"] = true,
    ["CaptureOverlay"] = true,
    ["Composer"] = true,
    ["ContactList"] = true,
    ["Chat"] = true,
    ["HeadsetDisconnectedDialog"] = true,
    ["InExperienceInterventionApp"] = true,
    ["PlayerMenuScreen"] = true,
    ["PurchasePromptApp"] = true,
    ["RobloxPromptGui"] = true,
    ["ScreenshotsCarousel"] = true,
    ["TeleportEffectGui"] = true,
    ["TopBarApp"] = true,
    ["ControlGui"] = true,
    ["VehicleGui"] = true,
    ["NotificationGui"] = true,
    ["DescendantProtector"] = true,
    ["AppUpdaterGui"] = true,
    ["FaceTrackingGui"] = true,
    ["ExperienceNotificationGui"] = true,
    ["VoiceChatGui"] = true,
    ["SafetyCheckGui"] = true,
    ["ToastGui"] = true,
    ["InGameMenuV2"] = true,
    ["RightClickMenu"] = true,
    ["VoiceChatPromptGui"] = true,
    ["BottomBarGui"] = true,
    ["GuiService"] = true,
    ["FullscreenTitleBar"] = true,
    ["TextureView"] = true,
    ["ChromeGui"] = true,
    ["BlockingApp"] = true,
    ["HealthGui"] = true,
    ["StutterDetector"] = true,
    ["AvatarContextMenuItem"] = true
}

-- helper func to find the ancestor thats a direct child of CoreGui
local function getTopLevelContainer(object)
    local current = object
    -- traverse up until the parent of this nigga is CoreGui or the game root
    while current.Parent and current.Parent ~= CoreGui and current.Parent ~= game do
        current = current.Parent
    end
    return current
end

-- === 1. HEURISTICS FOR IDENTIFYING "JUMBLED" NAMES (and other random bullshit) ===
local function isJumbled(name)
    -- 1. check for non-standard characters cuz legit stuff dont use weird shit
    if string.match(name, "[^%w%s%-%.]") then
        return true
    end

    -- 2. check for excessive length cuz no one names shit that long
    if #name > 30 then
        return true
    end

    -- 3. advanced entropy check for random shitstains like "JhQwuIaD"
    local upperCount = #string.gsub(name, "[^A-Z]", "")
    local lowerCount = #string.gsub(name, "[^a-z]", "")
    local totalLetters = upperCount + lowerCount
    
    if totalLetters > 5 then
        -- ROBLOX uses PascalCase. If it has 3+ caps in a row, its probably a random string. (also fuck u roblox)
        if string.match(name, "%u%u%u") then
            return true
        end

        -- check vowel ratio. Random strings are usually full of consonants and look like ass.
        local _, vowelCount = string.gsub(name:lower(), "[aeiouy]", "")
        if vowelCount == 0 or (vowelCount / totalLetters) < 0.15 then
            return true
        end
        
        -- catching weird mixed casing like "jHqW"
        if upperCount > 1 and lowerCount > 1 and string.match(name, "%l%u%l") then
            -- if it looks like absolute keyboard mash, obliterate it
            return true
        end
    end

    return false
end

-- === 2. SINGLE SCAN AND DESTROY FUNC !!!! ===
local function scanCoreGuiAndDestroy()
    print("--- Starting SINGLE SAFE CoreGui Scan & Destruction ---")
    local destroyedCount = 0
    local descendants = CoreGui:GetDescendants()

    for _, object in ipairs(descendants) do
        local name = object.Name
        local topContainer = getTopLevelContainer(object)

        -- if the top-level container is in the whitelist, skip the object entirely.
        if topContainer and whitelistedContainers[topContainer.Name] then
            continue
        end

        -- check the heuristic against the remaining, non-whitelisted objects
        if isJumbled(name) then
            print(string.format(
                "DESTROYING SUSPICIOUS OBJECT: '%s' (Class: %s) Path: %s",
                name,
                object.ClassName,
                object:GetFullName()
            ))

            -- !!! DESTROY THE SUSPICIOUS OBJECT TWIN !!!
            -- use a pcall cuz sometimes roblox locks these objects and it breaks the script
            local success, _ = pcall(function()
                object:Destroy()
            end)
            
            if success then
                destroyedCount = destroyedCount + 1
            end
        end
    end

    if destroyedCount > 0 then
        print(string.format("--- Scan Complete: Successfully DESTROYED %d potentially malicious objects. ---", destroyedCount))
    else
        print("--- Scan Complete: No suspicious objects found outside whitelisted areas. ---")
    end
end

-- run the damn thing once
scanCoreGuiAndDestroy()












-- btw dont use my code on ur public scripts without permission from me fuckhead
-- @j5vz on disc
