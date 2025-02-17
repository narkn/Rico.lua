local NotificationLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/IceMinisterq/Notification-Library/Main/Library.lua"))()

if game:GetService("CoreGui"):FindFirstChild("RogueDZ_GUI") then
    NotificationLibrary:SendNotification("Warning", "RogueDZ is already running!", 3)
    return
end

local analyzers = {
    Http = false,
    Remotes = false,
    Namecalls = false,
    Indexes = false,
    GTSpy = false,
    DisableHttpReq = false,
    DisableWebhookReq = false
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RogueDZ_GUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
local UICorner_Main = Instance.new("UICorner")
local Title = Instance.new("TextLabel")
local UICorner_Title = Instance.new("UICorner")
local CommandBox = Instance.new("TextBox")
local UICorner_CmdBox = Instance.new("UICorner")
local ExecuteButton = Instance.new("TextButton")
local UICorner_ExecBtn = Instance.new("UICorner")
local MinimizeButton = Instance.new("TextButton")
local UICorner_MinBtn = Instance.new("UICorner")
local ConsoleFrame = Instance.new("Frame")
local UICorner_Console = Instance.new("UICorner")
local LogList = Instance.new("ScrollingFrame")
local UIListLayout = Instance.new("UIListLayout")
local UICorner_LogList = Instance.new("UICorner")
local UIStroke_Main = Instance.new("UIStroke")

local COLORS = {
    BACKGROUND = Color3.fromHex("#272222"),
    DARKER = Color3.fromHex("#1a1717"),
    LIGHTER = Color3.fromHex("#342e2e"),
    ACCENT = Color3.fromHex("#ff3333"),
    TEXT = Color3.fromRGB(255, 255, 255),
    TEXT_DARK = Color3.fromRGB(200, 200, 200)
}

local isRunning = false

MainFrame.Name = "RogueDZ"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = COLORS.BACKGROUND
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -150)
MainFrame.Size = UDim2.new(0, 350, 0, 300)
MainFrame.ClipsDescendants = true

UICorner_Main.Parent = MainFrame
UICorner_Main.CornerRadius = UDim.new(0, 8)

UIStroke_Main.Parent = MainFrame
UIStroke_Main.Color = COLORS.LIGHTER
UIStroke_Main.Thickness = 1.5

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = COLORS.DARKER
Title.BorderSizePixel = 0
Title.Size = UDim2.new(0.8, 0, 0, 35)
Title.Font = Enum.Font.GothamBold
Title.Text = "RogueDZ"
Title.TextColor3 = COLORS.TEXT
Title.TextSize = 18

UICorner_Title.Parent = Title
UICorner_Title.CornerRadius = UDim.new(0, 8)

local DiscordButton = Instance.new("TextButton")
DiscordButton.Name = "DiscordButton"
DiscordButton.Parent = MainFrame
DiscordButton.BackgroundColor3 = COLORS.DARKER
DiscordButton.BorderSizePixel = 0
DiscordButton.Position = UDim2.new(0.8, 0, 0, 0)
DiscordButton.Size = UDim2.new(0.1, 0, 0, 35)
DiscordButton.Font = Enum.Font.GothamBold
DiscordButton.Text = ""
DiscordButton.TextColor3 = Color3.fromRGB(114, 137, 218)
DiscordButton.AutoButtonColor = false

local DiscordImage = Instance.new("ImageLabel")
DiscordImage.Name = "DiscordImage"
DiscordImage.Parent = DiscordButton
DiscordImage.BackgroundTransparency = 1
DiscordImage.Position = UDim2.new(0.1, 0, 0.1, 0)
DiscordImage.Size = UDim2.new(0.8, 0, 0.8, 0)
DiscordImage.Image = "rbxassetid://129802722801186"
DiscordImage.ImageColor3 = Color3.fromRGB(114, 137, 218)
DiscordImage.ScaleType = Enum.ScaleType.Fit

local UICorner_Discord = Instance.new("UICorner")
UICorner_Discord.Parent = DiscordButton
UICorner_Discord.CornerRadius = UDim.new(0, 8)

CommandBox.Name = "CommandBox"
CommandBox.Parent = MainFrame
CommandBox.BackgroundColor3 = COLORS.DARKER
CommandBox.BorderSizePixel = 0
CommandBox.Position = UDim2.new(0.05, 0, 0.15, 0)
CommandBox.Size = UDim2.new(0.9, 0, 0, 35)
CommandBox.Font = Enum.Font.Gotham
CommandBox.PlaceholderText = "Enter command here..."
CommandBox.Text = ""
CommandBox.TextColor3 = COLORS.TEXT
CommandBox.TextSize = 14
CommandBox.PlaceholderColor3 = COLORS.TEXT_DARK

UICorner_CmdBox.Parent = CommandBox
UICorner_CmdBox.CornerRadius = UDim.new(0, 6)

ExecuteButton.Name = "ExecuteButton"
ExecuteButton.Parent = MainFrame
ExecuteButton.BackgroundColor3 = COLORS.ACCENT
ExecuteButton.BorderSizePixel = 0
ExecuteButton.Position = UDim2.new(0.05, 0, 0.3, 0)
ExecuteButton.Size = UDim2.new(0.9, 0, 0, 35)
ExecuteButton.Font = Enum.Font.GothamBold
ExecuteButton.Text = "Execute"
ExecuteButton.TextColor3 = COLORS.TEXT
ExecuteButton.TextSize = 14
ExecuteButton.AutoButtonColor = false

UICorner_ExecBtn.Parent = ExecuteButton
UICorner_ExecBtn.CornerRadius = UDim.new(0, 6)

MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = MainFrame
MinimizeButton.BackgroundColor3 = COLORS.DARKER
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Position = UDim2.new(0.9, 0, 0, 0)
MinimizeButton.Size = UDim2.new(0.1, 0, 0, 35)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = COLORS.TEXT
MinimizeButton.TextSize = 20
MinimizeButton.AutoButtonColor = false

UICorner_MinBtn.Parent = MinimizeButton
UICorner_MinBtn.CornerRadius = UDim.new(0, 8)

ConsoleFrame.Name = "ConsoleFrame"
ConsoleFrame.Parent = MainFrame
ConsoleFrame.BackgroundColor3 = COLORS.DARKER
ConsoleFrame.BorderSizePixel = 0
ConsoleFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
ConsoleFrame.Size = UDim2.new(0.9, 0, 0.55, 0)
ConsoleFrame.ClipsDescendants = true

UICorner_Console.Parent = ConsoleFrame
UICorner_Console.CornerRadius = UDim.new(0, 6)

LogList.Name = "LogList"
LogList.Parent = ConsoleFrame
LogList.BackgroundTransparency = 1
LogList.BorderSizePixel = 0
LogList.Size = UDim2.new(1, -4, 1, 0)
LogList.Position = UDim2.new(0, 4, 0, 0)
LogList.CanvasSize = UDim2.new(0, 0, 0, 0)
LogList.ScrollBarThickness = 3
LogList.ScrollBarImageColor3 = COLORS.LIGHTER
LogList.ScrollingEnabled = true
LogList.AutomaticCanvasSize = Enum.AutomaticSize.Y

UIListLayout.Parent = LogList
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 2)

UICorner_LogList.Parent = LogList
UICorner_LogList.CornerRadius = UDim.new(0, 6)

local function log(text, type, useNotification)
    local timestamp = os.date("%H:%M:%S")
    local prefix = type == "warning" and "[WARNING]" or type == "error" and "[ERROR]" or "[INFO]"
    for line in text:gmatch("[^\n]+") do
        local terminalText = string.format("%s -- %s %s", timestamp, prefix, line)
        
        local LogEntry = Instance.new("TextLabel")
        LogEntry.BackgroundTransparency = 1
        LogEntry.Size = UDim2.new(1, -8, 0, 20)
        LogEntry.Font = Enum.Font.Gotham
        LogEntry.Text = terminalText
        LogEntry.TextColor3 = type == "warning" and Color3.fromRGB(255, 200, 0) 
                             or type == "error" and Color3.fromRGB(255, 100, 100)
                             or COLORS.TEXT
        LogEntry.TextSize = 12
        LogEntry.TextXAlignment = Enum.TextXAlignment.Left
        LogEntry.TextWrapped = true
        LogEntry.Parent = LogList
    end
    
    LogList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
    LogList.CanvasPosition = Vector2.new(0, LogList.CanvasSize.Y.Offset)
    
    if useNotification then
        if type == "warning" then
            NotificationLibrary:SendNotification("Warning", text, 2)
        elseif type == "error" then
            NotificationLibrary:SendNotification("Error", text, 2)
        else
            NotificationLibrary:SendNotification("Success", text, 2)
        end
    end
end

local function addLogEntry(text)
    local LogEntry = Instance.new("TextLabel")
    LogEntry.BackgroundTransparency = 1
    LogEntry.Size = UDim2.new(1, -4, 0, 20)
    LogEntry.Font = Enum.Font.SourceSans
    LogEntry.Text = text
    LogEntry.TextColor3 = Color3.fromRGB(255, 255, 255)
    LogEntry.TextSize = 14
    LogEntry.TextXAlignment = Enum.TextXAlignment.Left
    LogEntry.Parent = LogList
    
    LogList.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
    LogList.CanvasPosition = Vector2.new(0, LogList.CanvasSize.Y.Offset)
end

local function checkIdentity()
    local identity = {
        name = "Unknown",
        level = 0,
        capabilities = {}
    }
    
    
    local success, execName, execVersion = pcall(function()
        return identifyexecutor()
    end)
    if success then
        identity.name = execName .. " " .. (execVersion or "")
    end
    
    
    local function checkFunction(name)
        local success = pcall(function()
            return _G[name] ~= nil or getgenv()[name] ~= nil
        end)
        return success
    end
    
    
    local capabilities = identity.capabilities
    
    
    if checkFunction("print") and checkFunction("warn") then
        identity.level = 1
        capabilities["basic"] = true
    end
    
    
    if checkFunction("readfile") and checkFunction("writefile") then
        identity.level = 2
        capabilities["filesystem"] = true
    end
    
    
    if checkFunction("request") or checkFunction("http_request") or (syn and syn.request) then
        identity.level = 3
        capabilities["http"] = true
    end
    
    
    if checkFunction("getgc") and checkFunction("getconnections") then
        identity.level = 4
        capabilities["debug"] = true
    end
    
    
    if checkFunction("getrawmetatable") and checkFunction("setrawmetatable") then
        identity.level = 5
        capabilities["memory"] = true
    end
    
    
    if syn and syn.websocket and syn.crypt then
        identity.level = 6
        capabilities["full"] = true
    end
    
    
    capabilities["drawing"] = checkFunction("Drawing") or (syn and syn.protect_gui)
    capabilities["websockets"] = checkFunction("WebSocket") or (syn and syn.websocket)
    capabilities["crypto"] = checkFunction("crypt") or (syn and syn.crypt)
    capabilities["secure_lua"] = checkFunction("newcclosure") or (syn and syn.newcclosure)
    
    return identity
end

local function getHWID()
    local hwids = {
        roblox = "Unknown",
        executor = "Unknown"
    }
    
    
    local success, result = pcall(function()
        
        local analytics = game:GetService("RbxAnalyticsService")
        if analytics then
            return analytics:GetClientId()
        end
        return "Unknown"
    end)
    if success then
        hwids.roblox = result
    end
    
    
    local function tryGetExecutorHWID()
        
        if syn and syn.request then
            local response = syn.request({Url = "https://httpbin.org/get"})
            if response and response.Headers then
                return response.Headers["Syn-Fingerprint"] or response.Headers["SW-Fingerprint"] or response.Headers["Fingerprint"]
            end
        end
        
        
        if get_hwid then return get_hwid() end
        if getexecutorname and gethwid then return gethwid() end
        
        
        local request = (syn and syn.request) or (http and http.request) or http_request or request
        if request then
            local response = request({Url = "https://httpbin.org/get"})
            if response and response.Headers then
                for k, v in pairs(response.Headers) do
                    if k:lower():match("fingerprint") then
                        return v
                    end
                end
            end
        end
        
        return "Unknown"
    end
    
    hwids.executor = tryGetExecutorHWID()
    return hwids
end

local function handleCommand(cmd)
    cmd = cmd:lower():gsub("/", "")
    local validCommands = {
        "commands", "cmds", "remote", "namecall", "index", 
        "gtable", "http", "blockhttps", "blockwebhooks", 
        "identity", "gethwid"
    }
    
    local isValidCommand = false
    for _, validCmd in ipairs(validCommands) do
        if cmd == validCmd then
            isValidCommand = true
            break
        end
    end
    
    if not isValidCommand then
        log("Command not found: " .. cmd, "error", true)
        return
    end
    
    if cmd == "commands" or cmd == "cmds" then
        log([[Available Commands:
/commands or /cmds - Show this help message
/remote - Toggle remote spy
/namecall - Toggle namecall spy
/index - Toggle index spy
/gtable - Toggle _G table spy
/http - Toggle HTTP logging
/blockhttps - Toggle HTTP request blocking
/blockwebhooks - Toggle webhook blocking
/identity - Check executor identity
/gethwid - Get Roblox and Executor HWIDs]], "info", false)
        NotificationLibrary:SendNotification("Success", "Commands list shown in console", 2)
    elseif cmd == "remote" then
        analyzers.Remotes = not analyzers.Remotes
        log("Remote spy: " .. tostring(analyzers.Remotes), "info", true)
    elseif cmd == "namecall" then
        analyzers.Namecalls = not analyzers.Namecalls
        log("Namecall spy: " .. tostring(analyzers.Namecalls), "info", true)
    elseif cmd == "index" then
        analyzers.Indexes = not analyzers.Indexes
        log("Index spy: " .. tostring(analyzers.Indexes), "info", true)
    elseif cmd == "gtable" then
        analyzers.GTSpy = not analyzers.GTSpy
        log("_G table spy: " .. tostring(analyzers.GTSpy), "info", true)
    elseif cmd == "http" then
        analyzers.Http = not analyzers.Http
        log("HTTP logging: " .. tostring(analyzers.Http), "info", true)
    elseif cmd == "blockhttps" then
        analyzers.DisableHttpReq = not analyzers.DisableHttpReq
        log("HTTP blocking: " .. tostring(analyzers.DisableHttpReq), "info", true)
    elseif cmd == "blockwebhooks" then
        analyzers.DisableWebhookReq = not analyzers.DisableWebhookReq
        log("Webhook blocking: " .. tostring(analyzers.DisableWebhookReq), "info", true)
    elseif cmd == "identity" then
        local identity = checkIdentity()
        log(string.format([[
🔍 Executor Identity:
Name: %s
Level: %d/6
Capabilities:
%s]], 
            identity.name,
            identity.level,
            table.concat(
                (function()
                    local caps = {}
                    for k, v in pairs(identity.capabilities) do
                        table.insert(caps, "- " .. k .. ": " .. tostring(v))
                    end
                    return caps
                end)(),
                "\n"
            )
        ), "info", false)
    elseif cmd == "gethwid" then
        local hwids = getHWID()
        log(string.format([[
🔒 Hardware IDs:
Roblox HWID: %s
Executor HWID: %s]], 
            hwids.roblox,
            hwids.executor
        ), "info", false)
    end
end

local UserInputService = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

Title.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

ExecuteButton.MouseButton1Click:Connect(function()
    handleCommand(CommandBox.Text)
    CommandBox.Text = ""
end)

local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetSize = minimized and UDim2.new(0, 350, 0, 35) or UDim2.new(0, 350, 0, 300)
    
    game:GetService("TweenService"):Create(MainFrame, TweenInfo.new(0.2), {
        Size = targetSize
    }):Play()
    
    CommandBox.Visible = not minimized
    ExecuteButton.Visible = not minimized
    ConsoleFrame.Visible = not minimized
    
    MinimizeButton.Text = minimized and "+" or "-"
end)

DiscordButton.MouseButton1Click:Connect(function()
    local success, result = pcall(function()
        setclipboard("https://discord.gg/9VJuNutke6")
    end)
    if success then
        NotificationLibrary:SendNotification("Success", "Discord invite copied to clipboard!", 2)
    else
        NotificationLibrary:SendNotification("Error", "Failed to copy Discord invite", 2)
    end
end)

game:GetService("Players").LocalPlayer.Chatted:Connect(function(msg)
    handleCommand(msg)
end)

local function hookRemotes()
    local Event = Instance.new("RemoteEvent")
    local Function = Instance.new("RemoteFunction")
    
    local oldFireServer = Event.FireServer
    Event.FireServer = function(self, ...)
        if analyzers.Remotes then
            log("Remote Fired: " .. self:GetFullName(), "info", false)
            NotificationLibrary:SendNotification("Success", "Remote Fired: " .. self:GetFullName(), 3)
        end
        return oldFireServer(self, ...)
    end
    
    local oldInvokeServer = Function.InvokeServer
    Function.InvokeServer = function(self, ...)
        if analyzers.Remotes then
            log("Remote Invoked: " .. self:GetFullName(), "info", false)
            NotificationLibrary:SendNotification("Success", "Remote Invoked: " .. self:GetFullName(), 3)
        end
        return oldInvokeServer(self, ...)
    end
    
    Event:Destroy()
    Function:Destroy()
end

local function hookMetamethods()
    local success, err = pcall(function()
        local mt = getrawmetatable(game)
        local oldIndex = mt.__index
        local oldNamecall = mt.__namecall
        
        setreadonly(mt, false)
        
        mt.__index = newcclosure(function(self, key)
            if analyzers.Indexes then
                log("Index: " .. tostring(key), "info", false)
                NotificationLibrary:SendNotification("Info", "Index: " .. tostring(key), 3)
            end
            return oldIndex(self, key)
        end)
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if analyzers.Namecalls and method then
                pcall(function()
                    log("Namecall: " .. tostring(method), "info", false)
                    NotificationLibrary:SendNotification("Info", "Namecall: " .. tostring(method), 3)
                end)
            end
            return oldNamecall(self, ...)
        end)
        
        setreadonly(mt, true)
    end)
    
    if not success then
        log("Metatable hook failed: " .. tostring(err), "error", false)
    end
end

local function hookHttp()
    
    local originalFunctions = {
        syn_request = syn and syn.request,
        http_request = http_request,
        request = request,
        http_func = http and http.request
    }

    
    local function createHook(original)
        if not original then return nil end
        
        return function(options)
            if type(options) ~= "table" or type(options.Url) ~= "string" then 
                return original(options)
            end
            
            if analyzers.Http then
                log("Request: " .. tostring(options.Url), "info", false)
            end
            
            if analyzers.DisableHttpReq then
                log("🚫 Blocked HTTP request", "warning", false)
                NotificationLibrary:SendNotification("Warning", "HTTP request blocked", 2)
                return {
                    Success = false,
                    StatusCode = 403,
                    Body = "Request blocked by RogueDZ",
                    Headers = {},
                    StatusMessage = "Forbidden by RogueDZ"
                }
            end
            
            if analyzers.DisableWebhookReq and (options.Url:match("discord") or options.Url:match("webhook")) then
                log("🚫 Blocked Discord webhook", "warning", false)
                NotificationLibrary:SendNotification("Warning", "Discord webhook blocked", 2)
                return {
                    Success = false,
                    StatusCode = 403,
                    Body = "Discord webhook blocked by RogueDZ",
                    Headers = {},
                    StatusMessage = "Forbidden by RogueDZ"
                }
            end
            
            return original(options)
        end
    end

    
    if syn then
        syn.request = createHook(originalFunctions.syn_request)
    end
    
    if http then
        http.request = createHook(originalFunctions.http_func)
    end
    
    if getgenv then
        local env = getgenv()
        if originalFunctions.http_request then
            env.http_request = createHook(originalFunctions.http_request)
        end
        if originalFunctions.request then
            env.request = createHook(originalFunctions.request)
        end
    end

    
    local success, result = pcall(function()
        local HttpService = game:GetService("HttpService")
        if HttpService then
            local oldRequest = HttpService.RequestAsync
            HttpService.RequestAsync = function(self, options)
                if analyzers.DisableHttpReq then
                    log("HTTP Request blocked: " .. tostring(options.Url), "warning", false)
                    NotificationLibrary:SendNotification("Blocked", "HTTP Request was blocked", 3)
                    return {
                        Success = false,
                        StatusCode = 403,
                        Body = "Request blocked by RogueDZ",
                        Headers = {},
                        StatusMessage = "Forbidden by RogueDZ"
                    }
                end
                return oldRequest(self, options)
            end
        end
    end)
    
    
    local env = getfenv(0)
    local protected = {}
    
    
    local mt = {
        __index = function(_, key)
            if key == "request" then
                return protected.request or originalFunctions.request
            elseif key == "http_request" then
                return protected.http_request or originalFunctions.http_request
            end
            return env[key]
        end,
        __newindex = function(_, key, value)
            if key == "request" or key == "http_request" then
                protected[key] = createHook(value)
            else
                env[key] = value
            end
        end
    }
    
    setfenv(1, setmetatable({}, mt))
end


hookHttp()

local realG = _G
local spyMetatable = {
    __index = function(t, k)
        if analyzers.GTSpy then
            log("_G Read: " .. tostring(k), "info", false)
            NotificationLibrary:SendNotification("Info", "_G Read: " .. tostring(k), 3)
        end
        return realG[k]
    end,
    __newindex = function(t, k, v)
        if analyzers.GTSpy then
            log("_G Write: " .. tostring(k) .. " = " .. tostring(v), "info", false)
            NotificationLibrary:SendNotification("Info", "_G Write: " .. tostring(k) .. " = " .. tostring(v), 3)
        end
        realG[k] = v
    end
}

pcall(function()
    hookRemotes()
    hookMetamethods()
    hookHttp()
    if not getmetatable(_G) then
        setmetatable(_G, spyMetatable)
    end
end)

log("RogueDZ initialized successfully!", "info", false)

return {
    handleCommand = handleCommand
		}
