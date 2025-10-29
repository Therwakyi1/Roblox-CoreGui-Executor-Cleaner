local CoreGui = game:GetService("CoreGui")

-- === WHITELIST DOWN BELOW ===
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
                                                                                            ["TeleportEffectGui"] = true
                                                                                            }

                                                                                            -- Helper function to find the ancestor that is a direct child of CoreGui
                                                                                            local function getTopLevelContainer(object)
                                                                                                local current = object
                                                                                                    -- Traverse up until the parent of this nigga is CoreGui or the game root
                                                                                                        while current.Parent and current.Parent ~= CoreGui and current.Parent ~= game do
                                                                                                                current = current.Parent
                                                                                                                    end
                                                                                                                        return current
                                                                                                                        end

                                                                                                                        -- === 1. HEURISTICS FOR IDENTIFYING "JUMBLED" NAMES (blah blah blah) ===
                                                                                                                        local function isJumbled(name)
                                                                                                                            -- 1. Check for non-standard characters
                                                                                                                                if string.match(name, "[^%w%s%-%.]") then
                                                                                                                                        return true
                                                                                                                                            end

                                                                                                                                                -- 2. Check for excessive length
                                                                                                                                                    if #name > 30 then
                                                                                                                                                            return true
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

                                                                                                                                                                                                            -- If the top-level container is in the whitelist, skip the object entirely.
                                                                                                                                                                                                                    if topContainer and whitelistedContainers[topContainer.Name] then
                                                                                                                                                                                                                                continue
                                                                                                                                                                                                                                        end

                                                                                                                                                                                                                                                -- Check the heuristic against the remaining, non-whitelisted objects
                                                                                                                                                                                                                                                        if isJumbled(name) then
                                                                                                                                                                                                                                                                    print(string.format(
                                                                                                                                                                                                                                                                                    "DESTROYING SUSPICIOUS OBJECT: '%s' (Class: %s) Path: %s",
                                                                                                                                                                                                                                                                                                    name,
                                                                                                                                                                                                                                                                                                                    object.ClassName,
                                                                                                                                                                                                                                                                                                                                    object:GetFullName()
                                                                                                                                                                                                                                                                                                                                                ))

                                                                                                                                                                                                                                                                                                                                                            -- !!! DESTROY THE SUSPICIOUS OBJECT TWIN !!!
                                                                                                                                                                                                                                                                                                                                                                        object:Destroy()
                                                                                                                                                                                                                                                                                                                                                                                    destroyedCount = destroyedCount + 1
                                                                                                                                                                                                                                                                                                                                                                                            end
                                                                                                                                                                                                                                                                                                                                                                                                end

                                                                                                                                                                                                                                                                                                                                                                                                    if destroyedCount > 0 then
                                                                                                                                                                                                                                                                                                                                                                                                            print(string.format("--- Scan Complete: Successfully DESTROYED %d potentially malicious objects. ---", destroyedCount))
                                                                                                                                                                                                                                                                                                                                                                                                                else
                                                                                                                                                                                                                                                                                                                                                                                                                        print("--- Scan Complete: No suspicious objects found outside whitelisted areas. ---")
                                                                                                                                                                                                                                                                                                                                                                                                                            end
                                                                                                                                                                                                                                                                                                                                                                                                                            end

                                                                                                                                                                                                                                                                                                                                                                                                                            scanCoreGuiAndDestroy()
