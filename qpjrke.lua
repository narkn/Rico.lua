local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local players = game:GetService("Players")
local wrk = game:GetService("Workspace")
local plr = players.LocalPlayer
local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
local humanoid = plr.Character:FindFirstChild("Humanoid")

local function onCharacterAdded(character)
    hrp = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
end

plr.CharacterAdded:Connect(onCharacterAdded)

if plr.Character then
    onCharacterAdded(plr.Character)
end

local camera = wrk.CurrentCamera
local mouse = plr:GetMouse()

local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local hue = 0
local rainbowFov = false
local rainbowSpeed = 0.005

local aimFov = 100
local aimParts = {"Head"}
local aiming = false
local predictionStrength = 0.065
local smoothing = 0.05

local aimbotEnabled = false
local wallCheck = true
local stickyAimEnabled = false
local teamCheck = false
local healthCheck = false
local minHealth = 0

local antiAim = false

local antiAimAmountX = 0
local antiAimAmountY = -100
local antiAimAmountZ = 0

local antiAimMethod = "Reset Velo"

local randomVeloRange = 100

local spinBot = false
local spinBotSpeed = 20

local circleColor = Color3.fromRGB(255, 0, 0)
local targetedCircleColor = Color3.fromRGB(0, 255, 0)

local aimViewerEnabled = false
local ignoreSelf = true

local Window = Rayfield:CreateWindow({
    Name = "▶ ايم بوت ◀",
    LoadingTitle = "جار التحميل...",
    LoadingSubtitle = "by Agreed 🥵",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "UniversalHub",
        FileName = "byAgreed"
    },
})

local Aimbot = Window:CreateTab("ايم بوت 🎯")
local AntiAim = Window:CreateTab("مكافحة الهدف 😡")
local Misc = Window:CreateTab("متنوعات 🤷‍♂️")

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.Radius = aimFov
fovCircle.Filled = false
fovCircle.Color = circleColor
fovCircle.Visible = false

local currentTarget = nil

local function checkTeam(player)
    if teamCheck and player.Team == plr.Team then
        return true
    end
    return false
end

local function checkWall(targetCharacter)
    local targetHead = targetCharacter:FindFirstChild("Head")
    if not targetHead then return true end

    local origin = camera.CFrame.Position
    local direction = (targetHead.Position - origin).unit * (targetHead.Position - origin).magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {plr.Character, targetCharacter}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local raycastResult = wrk:Raycast(origin, direction, raycastParams)
    return raycastResult and raycastResult.Instance ~= nil
end

local function getClosestPart(character)
    local closestPart = nil
    local shortestCursorDistance = aimFov
    local cameraPos = camera.CFrame.Position

    for _, partName in ipairs(aimParts) do
        local part = character:FindFirstChild(partName)
        if part then
            local partPos = camera:WorldToViewportPoint(part.Position)
            local screenPos = Vector2.new(partPos.X, partPos.Y)
            local cursorDistance = (screenPos - Vector2.new(mouse.X, mouse.Y)).Magnitude

            if cursorDistance < shortestCursorDistance and partPos.Z > 0 then
                shortestCursorDistance = cursorDistance
                closestPart = part
            end
        end
    end

    return closestPart
end

local function getTarget()
    local nearestPlayer = nil
    local closestPart = nil
    local shortestCursorDistance = aimFov

    for _, player in ipairs(players:GetPlayers()) do
        if player ~= plr and player.Character and not checkTeam(player) then
            if player.Character.Humanoid.Health >= minHealth or not healthCheck then
                local targetPart = getClosestPart(player.Character)
                if targetPart then
                    local screenPos = camera:WorldToViewportPoint(targetPart.Position)
                    local cursorDistance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude

                    if cursorDistance < shortestCursorDistance then
                        if not checkWall(player.Character) or not wallCheck then
                            shortestCursorDistance = cursorDistance
                            nearestPlayer = player
                            closestPart = targetPart
                        end
                    end
                end
            end
        end
    end

    return nearestPlayer, closestPart
end

local function predict(player, part)
    if player and part then
        local velocity = player.Character.HumanoidRootPart.Velocity
        local predictedPosition = part.Position + (velocity * predictionStrength)
        return predictedPosition
    end
    return nil
end

local function smooth(from, to)
    return from:Lerp(to, smoothing)
end

local function aimAt(player, part)
    local predictedPosition = predict(player, part)
    if predictedPosition then
        if player.Character.Humanoid.Health >= minHealth or not healthCheck then
            local targetCFrame = CFrame.new(camera.CFrame.Position, predictedPosition)
            camera.CFrame = smooth(camera.CFrame, targetCFrame)
        end
    end
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local offset = 50
        fovCircle.Position = Vector2.new(mouse.X, mouse.Y + offset)

        if rainbowFov then
            hue = hue + rainbowSpeed
            if hue > 1 then hue = 0 end
            fovCircle.Color = Color3.fromHSV(hue, 1, 1)
        else
            if aiming and currentTarget then
                fovCircle.Color = targetedCircleColor
            else
                fovCircle.Color = circleColor
            end
        end

        if aiming then
            if stickyAimEnabled and currentTarget then
                local headPos = camera:WorldToViewportPoint(currentTarget.Character.Head.Position)
                local screenPos = Vector2.new(headPos.X, headPos.Y)
                local cursorDistance = (screenPos - Vector2.new(mouse.X, mouse.Y)).Magnitude

                if cursorDistance > aimFov or (wallCheck and checkWall(currentTarget.Character)) or checkTeam(currentTarget) then
                    currentTarget = nil
                end
            end

            if not stickyAimEnabled or not currentTarget then
                local target, targetPart = getTarget()
                currentTarget = target
                currentTargetPart = targetPart
            end

            if currentTarget and currentTargetPart then
                aimAt(currentTarget, currentTargetPart)
            end
        else
            currentTarget = nil
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if antiAim then
        if antiAimMethod == "Reset Velo" then
            local vel = hrp.Velocity
            hrp.Velocity = Vector3.new(antiAimAmountX, antiAimAmountY, antiAimAmountZ)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
        elseif antiAimMethod == "Reset Pos [BROKEN]" then
            local pos = hrp.CFrame
            hrp.Velocity = Vector3.new(antiAimAmountX, antiAimAmountY, antiAimAmountZ)
            RunService.RenderStepped:Wait()
            hrp.CFrame = pos
        elseif antiAimMethod == "Random Velo" then
            local vel = hrp.Velocity
            local a = math.random(-randomVeloRange,randomVeloRange)
            local s = math.random(-randomVeloRange,randomVeloRange)
            local d = math.random(-randomVeloRange,randomVeloRange)
            hrp.Velocity = Vector3.new(a,s,d)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
        end
    end
end)

mouse.Button2Down:Connect(function()
    if aimbotEnabled then
        aiming = true
    end
end)

mouse.Button2Up:Connect(function()
    if aimbotEnabled then
        aiming = false
    end
end)

local aimbot = Aimbot:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "Aimbot",
    Callback = function(Value)
        aimbotEnabled = Value
        fovCircle.Visible = Value
    end
})

local aimpart = Aimbot:CreateDropdown({
    Name = "الهدف الجزء",
    Options = {"رائس","جزء الجذر البشري","ذراع اليسرى","ذراء اليمنى","الجذع","الساق اليسرى","الساق اليمنى"},
    CurrentOption = {"رائس"},
    MultipleOptions = true,
    Flag = "الهدف الجزء",
    Callback = function(Options)
        aimParts = Options
    end,
 })

local smoothingslider = Aimbot:CreateSlider({
    Name = "تنعيم",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 5,
    Flag = "تنعيم",
    Callback = function(Value)
        smoothing = 1 - (Value / 100)
    end,
})

local predictionstrength = Aimbot:CreateSlider({
    Name = "قوة التبؤ",
    Range = {0, 0.2},
    Increment = 0.001,
    CurrentValue = 0.065,
    Flag = "قوة التبؤ",
    Callback = function(Value)
        predictionStrength = Value
    end,
})

local fovvisibility = Aimbot:CreateToggle({
    Name = "رؤية فوف",
    CurrentValue = true,
    Flag = "رؤية فوف",
    Callback = function(Value)
        fovCircle.Visible = Value
    end
})

local aimbotfov = Aimbot:CreateSlider({
    Name = "ايمبوت فوف",
    Range = {0, 1000},
    Increment = 1,
    CurrentValue = 100,
    Flag = "ايمبوت فوف",
    Callback = function(Value)
        aimFov = Value
        fovCircle.Radius = aimFov
    end,
})

local wallcheck = Aimbot:CreateToggle({
    Name = "فحص الحائط",
    CurrentValue = true,
    Flag = "فحص الحائط",
    Callback = function(Value)
        wallCheck = Value
    end
})

local stickyaim = Aimbot:CreateToggle({
    Name = "الهدف لزجة",
    CurrentValue = false,
    Flag = "الهدف لزجة",
    Callback = function(Value)
        stickyAimEnabled = Value
    end
})

local teamchecktoggle = Aimbot:CreateToggle({
    Name = "فحص الفريق",
    CurrentValue = false,
    Flag = "فحص الفريق",
    Callback = function(Value)
        teamCheck = Value
    end
})

local healthchecktoggle = Aimbot:CreateToggle({
    Name = "فحص الصحة",
    CurrentValue = false,
    Flag = "فحص الصحة",
    Callback = function(Value)
        healthCheck = Value
    end
})

local minhealth = Aimbot:CreateSlider({
    Name = "مين هيلث",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 0,
    Flag = "مين هيلث",
    Callback = function(Value)
        minHealth = Value
    end,
})

local circlecolor = Aimbot:CreateColorPicker({
    Name = "لون فوف",
    Color = circleColor,
    Callback = function(Color)
        circleColor = Color
        fovCircle.Color = Color
    end
})

local targetedcirclecolor = Aimbot:CreateColorPicker({
    Name = "لون Fov المستهدف",
    Color = targetedCircleColor,
    Callback = function(Color)
        targetedCircleColor = Color
    end
})

local circlerainbow = Aimbot:CreateToggle({
    Name = "قوس قزح فوف",
    CurrentValue = false,
    Flag = "قوس قزح فوف",
    Callback = function(Value)
        rainbowFov = Value
    end
})

local antiaimtoggle = AntiAim:CreateToggle({
    Name = "مكافحة الهدف",
    CurrentValue = false,
    Flag = "AntiAim",
    Callback = function(Value)
        antiAim = Value
        if Value then
            Rayfield:Notify({Title = "Anti-Aim", Content = "Enabled!", Duration = 1, Image = 4483362458,})
        else
            Rayfield:Notify({Title = "Anti-Aim", Content = "Disabled!", Duration = 1, Image = 4483362458,})
        end
    end
})

local antiaimmethod = AntiAim:CreateDropdown({
    Name = "طريقة مكافحة الهدف",
    Options = {"اعادة ضبط السرعة","سرعة عشوائية","إعادة ضبط الموضع معطل"},
    CurrentOption = "إعادة ضبط السرعة",
    Flag = "AntiAimMethod",
    Callback = function(Option)
        antiAimMethod = type(Option) == "table" and Option[1] or Option
        if antiAimMethod == "Reset Velo" then
            Rayfield:Notify({Title = "Reset Velocity", Content = "Nobody will see it, but exploiters will aim in the wrong place.", Duration = 5, Image = 4483362458,})
        elseif antiAimMethod == "Reset Pos [BROKEN]" then
            Rayfield:Notify({Title = "Reset Pos [BROKEN]", Content = "This is a bit buggy right now, so idk if it works that well", Duration = 5, Image = 4483362458,})
        elseif antiAimMethod == "Random Velo" then
            Rayfield:Notify({Title = "Random Velocity", Content = "Depending on ping some peoplev will see u 'teleporting' around but you are actually in the same spot the entire time.", Duration = 5, Image = 4483362458,})
        end
    end,
})

local antiaimamountx = AntiAim:CreateSlider({
    Name = "كمية مكافحة الهدف X",
    Range = {-1000, 1000},
    Increment = 10,
    CurrentValue = 0,
    Flag = "AntiAimAmountX",
    Callback = function(Value)
        antiAimAmountX = Value
    end,
})

local antiaimamounty = AntiAim:CreateSlider({
    Name = "كمية مكافحة الهدف Y",
    Range = {-1000, 1000},
    Increment = 10,
    CurrentValue = -100,
    Flag = "AntiAimAmountY",
    Callback = function(Value)
        antiAimAmountY = Value
    end,
})

local antiaimamountz = AntiAim:CreateSlider({
    Name = "كمية مكافحة الهدف Z",
    Range = {-1000, 1000},
    Increment = 10,
    CurrentValue = 0,
    Flag = "AntiAimAmountZ",
    Callback = function(Value)
        antiAimAmountZ = Value
    end,
})

local randomvelorange = AntiAim:CreateSlider({
    Name = "نطاق فيلو العشوائي",
    Range = {0, 1000},
    Increment = 10,
    CurrentValue = 100,
    Flag = "RandomVeloRange",
    Callback = function(Value)
        randomVeloRange = Value
    end,
})

-- [< Misc >]

local spinbottoggle = Misc:CreateToggle({
    Name = "سبين بوت",
    CurrentValue = false,
    Flag = "SpinBot",
    Callback = function(Value)
        spinBot = Value
        if Value then
            for i,v in pairs(hrp:GetChildren()) do
                if v.Name == "Spinning" then
                    v:Destroy()
                end
            end
            plr.Character.Humanoid.AutoRotate = false
            local Spin = Instance.new("BodyAngularVelocity")
            Spin.Name = "Spinning"
            Spin.Parent = hrp
            Spin.MaxTorque = Vector3.new(0, math.huge, 0)
            Spin.AngularVelocity = Vector3.new(0,spinBotSpeed,0)
            Rayfield:Notify({Title = "Spin Bot", Content = "Enabled!", Duration = 1, Image = 4483362458,})
        else
            for i,v in pairs(hrp:GetChildren()) do
                if v.Name == "Spinning" then
                    v:Destroy()
                end
            end
            plr.Character.Humanoid.AutoRotate = true
            Rayfield:Notify({Title = "Spin Bot", Content = "Disabled!", Duration = 1, Image = 4483362458,})
        end
    end
})

local spinbotspeed = Misc:CreateSlider({
    Name = "سرعة الدوران بوت",
    Range = {0, 1000},
    Increment = 1,
    CurrentValue = 20,
    Flag = "SpinBotSpeed",
    Callback = function(Value)
        spinBotSpeed = Value
        if spinBot then
            for i,v in pairs(hrp:GetChildren()) do
                if v.Name == "Spinning" then
                    v:Destroy()
                end
            end
            local Spin = Instance.new("BodyAngularVelocity")
            Spin.Name = "Spinning"
            Spin.Parent = hrp
            Spin.MaxTorque = Vector3.new(0, math.huge, 0)
            Spin.AngularVelocity = Vector3.new(0,Value,0)
        end
    end,
})

local ServerHop = Misc:CreateButton({
	Name = "اعادة دخول سيرفر",
	Callback = function()
		if httprequest then
            local servers = {}
            local req = httprequest({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", game.PlaceId)})
            local body = HttpService:JSONDecode(req.Body)
        
            if body and body.data then
                for i, v in next, body.data do
                    if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                        table.insert(servers, 1, v.id)
                    end
                end
            end
        
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], plr)
            else
                Rayfield:Notify({Title = "Server Hop", Content = "Couldn't find a valid server!!!", Duration = 1, Image = 4483362458,})
            end
        else
            Rayfield:Notify({Title = "Server Hop", Content = "Your executor is ass!", Duration = 1, Image = 4483362458,})
        end
	end,
})
