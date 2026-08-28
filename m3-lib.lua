local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TextService = game:GetService("TextService")

local M3 = {
    Connections = {},
    ActiveWindows = {},
    ActiveSubWindows = {},
    FloatingWindows = {},
    Themes = {
        Dark = {
            Primary = Color3.fromRGB(208, 188, 255),
            OnPrimary = Color3.fromRGB(56, 30, 114),
            PrimaryContainer = Color3.fromRGB(79, 55, 139),
            OnPrimaryContainer = Color3.fromRGB(234, 221, 255),
            Secondary = Color3.fromRGB(204, 194, 220),
            OnSecondary = Color3.fromRGB(51, 45, 65),
            SecondaryContainer = Color3.fromRGB(74, 68, 88),
            OnSecondaryContainer = Color3.fromRGB(232, 222, 248),
            Surface = Color3.fromRGB(20, 18, 24),
            OnSurface = Color3.fromRGB(230, 224, 233),
            OnSurfaceVariant = Color3.fromRGB(202, 196, 208),
            SurfaceContainerLowest = Color3.fromRGB(15, 13, 19),
            SurfaceContainerLow = Color3.fromRGB(29, 27, 32),
            SurfaceContainer = Color3.fromRGB(33, 31, 38),
            SurfaceContainerHigh = Color3.fromRGB(43, 41, 48),
            SurfaceContainerHighest = Color3.fromRGB(54, 52, 59),
            Outline = Color3.fromRGB(147, 143, 153),
            OutlineVariant = Color3.fromRGB(73, 69, 79),
            Error = Color3.fromRGB(255, 180, 171),
            OnError = Color3.fromRGB(105, 0, 5),
            CornerRadius = UDim.new(0, 16),
            CornerSmall = UDim.new(0, 8),
            CornerLarge = UDim.new(0, 28),
            Font = Enum.Font.BuilderSans,
            FontBold = Enum.Font.BuilderSansBold
        },
        Light = {
            Primary = Color3.fromRGB(103, 80, 164),
            OnPrimary = Color3.fromRGB(255, 255, 255),
            PrimaryContainer = Color3.fromRGB(234, 221, 255),
            OnPrimaryContainer = Color3.fromRGB(33, 0, 93),
            Secondary = Color3.fromRGB(98, 91, 113),
            OnSecondary = Color3.fromRGB(255, 255, 255),
            SecondaryContainer = Color3.fromRGB(232, 222, 248),
            OnSecondaryContainer = Color3.fromRGB(29, 25, 43),
            Surface = Color3.fromRGB(254, 247, 255),
            OnSurface = Color3.fromRGB(29, 27, 32),
            OnSurfaceVariant = Color3.fromRGB(73, 69, 79),
            SurfaceContainerLowest = Color3.fromRGB(255, 255, 255),
            SurfaceContainerLow = Color3.fromRGB(247, 242, 250),
            SurfaceContainer = Color3.fromRGB(243, 237, 247),
            SurfaceContainerHigh = Color3.fromRGB(236, 230, 240),
            SurfaceContainerHighest = Color3.fromRGB(230, 224, 233),
            Outline = Color3.fromRGB(121, 116, 126),
            OutlineVariant = Color3.fromRGB(202, 196, 208),
            Error = Color3.fromRGB(179, 38, 30),
            OnError = Color3.fromRGB(255, 255, 255),
            CornerRadius = UDim.new(0, 16),
            CornerSmall = UDim.new(0, 8),
            CornerLarge = UDim.new(0, 28),
            Font = Enum.Font.BuilderSans,
            FontBold = Enum.Font.BuilderSansBold
        },
        OLED = {
            Primary = Color3.fromRGB(208, 188, 255),
            OnPrimary = Color3.fromRGB(0, 0, 0),
            PrimaryContainer = Color3.fromRGB(45, 30, 90),
            OnPrimaryContainer = Color3.fromRGB(234, 221, 255),
            Secondary = Color3.fromRGB(180, 170, 200),
            OnSecondary = Color3.fromRGB(0, 0, 0),
            SecondaryContainer = Color3.fromRGB(40, 40, 40),
            OnSecondaryContainer = Color3.fromRGB(240, 240, 240),
            Surface = Color3.fromRGB(0, 0, 0),
            OnSurface = Color3.fromRGB(255, 255, 255),
            OnSurfaceVariant = Color3.fromRGB(180, 180, 180),
            SurfaceContainerLowest = Color3.fromRGB(0, 0, 0),
            SurfaceContainerLow = Color3.fromRGB(10, 10, 10),
            SurfaceContainer = Color3.fromRGB(18, 18, 18),
            SurfaceContainerHigh = Color3.fromRGB(28, 28, 28),
            SurfaceContainerHighest = Color3.fromRGB(38, 38, 38),
            Outline = Color3.fromRGB(90, 90, 90),
            OutlineVariant = Color3.fromRGB(50, 50, 50),
            Error = Color3.fromRGB(255, 100, 100),
            OnError = Color3.fromRGB(0, 0, 0),
            CornerRadius = UDim.new(0, 16),
            CornerSmall = UDim.new(0, 8),
            CornerLarge = UDim.new(0, 28),
            Font = Enum.Font.BuilderSans,
            FontBold = Enum.Font.BuilderSansBold
        }
    },
    CurrentThemeName = "Dark",
    CurrentTheme = nil,
    Device = "PC",
    IsHidden = false,
    HideKey = Enum.KeyCode.RightControl,
    ScriptNamespace = "DefaultScript",
    ConfigFolder = "M3_Configs",
    Springs = {},
    CleanupTasks = {}
}

M3.CurrentTheme = M3.Themes.Dark

-- Cleanup registry: track connections, threads, and instances for auto-destruction
function M3:TrackConnection(conn)
    if conn then
        table.insert(M3.CleanupTasks, {
            Type = "Connection",
            Value = conn
        })
    end
    return conn
end

function M3:TrackThread(thread)
    if thread and coroutine.status(thread) ~= "dead" then
        table.insert(M3.CleanupTasks, {
            Type = "Thread",
            Value = thread
        })
    end
    return thread
end

function M3:TrackInstance(instance)
    if instance then
        table.insert(M3.CleanupTasks, {
            Type = "Instance",
            Value = instance
        })
    end
    return instance
end

function M3:Untrack(connOrThread)
    for i = #M3.CleanupTasks, 1, -1 do
        if M3.CleanupTasks[i].Value == connOrThread then
            table.remove(M3.CleanupTasks, i)
        end
    end
end

local SafeParent = (gethui and gethui()) or CoreGui:FindFirstChild("RobloxGui") or CoreGui

if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
    M3.Device = "Mobile"
elseif UserInputService.TouchEnabled and UserInputService.KeyboardEnabled then
    M3.Device = "Tablet"
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "M3_Framework_" .. HttpService:GenerateGUID(false)
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = SafeParent

local MobileExpandButton = Instance.new("TextButton")
MobileExpandButton.Name = "M3_MobileExpand"
MobileExpandButton.Size = UDim2.new(0, 110, 0, 36)
MobileExpandButton.Position = UDim2.new(0.5, -55, 0, 10)
MobileExpandButton.BackgroundColor3 = M3.CurrentTheme.PrimaryContainer
MobileExpandButton.TextColor3 = M3.CurrentTheme.OnPrimaryContainer
MobileExpandButton.Font = M3.CurrentTheme.FontBold
MobileExpandButton.TextSize = 13
MobileExpandButton.Text = "Expand UI"
MobileExpandButton.Visible = false
MobileExpandButton.ZIndex = 9999
MobileExpandButton.Parent = ScreenGui

local MobileExpandCorner = Instance.new("UICorner")
MobileExpandCorner.CornerRadius = UDim.new(1, 0)
MobileExpandCorner.Parent = MobileExpandButton

function M3:SetClipboard(text)
    local str = tostring(text or "")
    if setclipboard then
        setclipboard(str)
    elseif toclipboard then
        toclipboard(str)
    elseif (Syn and Syn.set_thread_identity) or (syn and syn.set_thread_identity) then
        if setclipboard then
            setclipboard(str)
        else
            warn("SetClipboard is not available on this environment.")
        end
    else
        warn("SetClipboard is not supported on this environment.")
    end
end

function M3:CreateSpring(initialPos, mass, damping, stiffness)
    local spring = {
        Target = initialPos or 0,
        Position = initialPos or 0,
        Velocity = 0,
        Mass = mass or 1,
        Damping = damping or 18,
        Stiffness = stiffness or 160
    }
    function spring:Update(dt)
        local force = (self.Target - self.Position) * self.Stiffness
        force = force - self.Velocity * self.Damping
        self.Velocity = self.Velocity + (force / self.Mass) * dt
        self.Position = self.Position + self.Velocity * dt
        return self.Position
    end
    function spring:Destroy()
        self.Enabled = false
        for i = #M3.Springs, 1, -1 do
            if M3.Springs[i] == self then
                table.remove(M3.Springs, i)
            end
        end
    end
    table.insert(M3.Springs, spring)
    return spring
end

local springLoopConn = RunService.RenderStepped:Connect(function(dt)
    for i = #M3.Springs, 1, -1 do
        local s = M3.Springs[i]
        if s and s.Enabled ~= false then
            s:Update(dt)
        end
    end
end)
if M3.TrackConnection then
    M3:TrackConnection(springLoopConn)
else
    table.insert(M3.Connections, springLoopConn)
end

function M3:Tween(instance, time, style, direction, props)
    local info = TweenInfo.new(time or 0.25, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, info, props)
    tween:Play()
    return tween
end

function M3:Ripple(button, x, y)
    local ripple = Instance.new("Frame")
    ripple.Name = "M3_Ripple"
    ripple.BackgroundColor3 = M3.CurrentTheme.OnSurface
    ripple.BackgroundTransparency = 0.85
    ripple.BorderSizePixel = 0
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.Position = UDim2.new(0, x - button.AbsolutePosition.X, 0, y - button.AbsolutePosition.Y)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.ZIndex = button.ZIndex + 5
    ripple.ClipsDescendants = true
    ripple.Parent = button

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = ripple

    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.2
    M3:Tween(ripple, 0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }).Completed:Connect(function()
        ripple:Destroy()
    end)
end

-- MD3 press-morph: idle = rounded rectangle (light rounding), pressed = full pill, release = back.
-- `targetCorner` is the UICorner instance to animate; `idleRadius` is the idle corner radius.
-- Optional `triggerButton` overrides the button that fires the morph (defaults to targetCorner's ancestor TextButton).
function M3:PressMorph(targetCorner, idleRadius, triggerButton)
    if not targetCorner then return end
    local idle = idleRadius or targetCorner.CornerRadius
    local pill = UDim.new(1, 0)

    local btn = triggerButton or targetCorner:FindFirstAncestorOfClass("TextButton")
    if not btn then return end

    local b = btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            M3:Tween(targetCorner, 0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.In, {
                CornerRadius = pill
            })
        end
    end)
    M3:TrackConnection(b)

    local e = btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            M3:Tween(targetCorner, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
                CornerRadius = idle
            })
        end
    end)
    M3:TrackConnection(e)
end

function M3:SetTheme(themeName)
    if M3.Themes[themeName] then
        M3.CurrentThemeName = themeName
        M3.CurrentTheme = M3.Themes[themeName]
        MobileExpandButton.BackgroundColor3 = M3.CurrentTheme.PrimaryContainer
        MobileExpandButton.TextColor3 = M3.CurrentTheme.OnPrimaryContainer
    end
end

local ConfigManager = {}
function ConfigManager:GetPath(filename)
    if not isfolder(M3.ConfigFolder) then
        makefolder(M3.ConfigFolder)
    end
    local scriptFolder = M3.ConfigFolder .. "/" .. M3.ScriptNamespace
    if not isfolder(scriptFolder) then
        makefolder(scriptFolder)
    end
    return scriptFolder .. "/" .. filename .. ".json"
end

function ConfigManager:Save(filename, data)
    if writefile then
        local path = ConfigManager:GetPath(filename)
        local encoded = HttpService:JSONEncode(data or {})
        writefile(path, encoded)
        return true
    end
    return false
end

function ConfigManager:Load(filename)
    if readfile and isfile then
        local path = ConfigManager:GetPath(filename)
        if isfile(path) then
            local contents = readfile(path)
            local decoded = HttpService:JSONDecode(contents)
            return decoded
        end
    end
    return nil
end

function ConfigManager:Delete(filename)
    if delfile and isfile then
        local path = ConfigManager:GetPath(filename)
        if isfile(path) then
            delfile(path)
            return true
        end
    end
    return false
end

function ConfigManager:List()
    local result = {}
    if listfiles and isfolder then
        local scriptFolder = M3.ConfigFolder .. "/" .. M3.ScriptNamespace
        if isfolder(scriptFolder) then
            local files = listfiles(scriptFolder)
            for _, f in ipairs(files) do
                local name = f:match("([^/%\\]+)%.json$")
                if name then
                    table.insert(result, name)
                end
            end
        end
    end
    return result
end

M3.ConfigManager = ConfigManager

-- Icon cache for downloaded PNGs
M3.IconCache = {}

-- Resolve an icon reference to an Image property value for an ImageLabel/ImageButton.
-- Accepts:
--   * nil / "": empty (no icon)
--   * "rbxassetid://123..." or a plain number: treated as an asset id
--   * "http(s)://...": full custom URL (used as-is for getcustomasset download)
--   * a name (e.g. "cog", "home", "close"): downloads a Material Design icon PNG via writefile/getcustomasset, cached per session.
-- Returns an Image string, or "" if nothing usable could be resolved.
function M3:LoadIcon(iconId)
    if iconId == nil or iconId == "" then return "" end

    local str = tostring(iconId)

    -- Plain numeric asset id
    if tonumber(str) then
        return "rbxassetid://" .. tostring(math.floor(tonumber(str)))
    end

    -- Already a Roblox asset reference
    if str:lower():match("^rbxassetid://") then
        return str
    end

    -- Full http(s) URL: fetch and cache as a custom asset
    if str:lower():match("^https?://") then
        if getcustomasset and isfile and writefile then
            if M3.IconCache[str] then return M3.IconCache[str] end
            local fileName = "m3_icons/" .. string.gsub(str, "[^%w]", "_"):sub(1, 80) .. ".png"
            local ok, data = pcall(function() return game:HttpGet(str) end)
            if ok and data and #data > 100 then
                local saved = pcall(function()
                    if isfolder("m3_icons") == false then
                        makefolder("m3_icons")
                    end
                    writefile(fileName, data)
                end)
                if saved then
                    local got, asset = pcall(getcustomasset, fileName)
                    if got and asset then
                        M3.IconCache[str] = asset
                        return asset
                    end
                end
            end
        end
        return ""
    end

    -- Named Material Design icon: try several hosted PNG mirrors
    if getcustomasset and isfile and writefile then
        if M3.IconCache[str] then return M3.IconCache[str] end

        local name = string.gsub(str, "[^%w]", "")
        if name == "" then return "" end

        local sources = {
            "https://raw.githubusercontent.com/Templarian/MaterialDesign/master/png/" .. name .. ".png",
            "https://cdn.jsdelivr.net/gh/Templarian/MaterialDesign@master/png/" .. name .. ".png",
        }

        for _, url in ipairs(sources) do
            local ok, data = pcall(function() return game:HttpGet(url) end)
            if ok and data and #data > 100 then
                local fileName = "m3_icons/" .. name .. ".png"
                local saved = pcall(function()
                    if isfolder("m3_icons") == false then
                        makefolder("m3_icons")
                    end
                    writefile(fileName, data)
                end)
                if saved then
                    local got, asset = pcall(getcustomasset, fileName)
                    if got and asset then
                        M3.IconCache[str] = asset
                        return asset
                    end
                end
            end
        end
    end

    return ""
end

-- Notification holder: bottom-right, stacked manually (dynamic-island style).
local NotificationHolder = Instance.new("Frame")
NotificationHolder.Name = "M3_NotificationHolder"
NotificationHolder.Size = UDim2.new(0, 320, 1, 0)
NotificationHolder.Position = UDim2.new(1, -16, 1, -10)
NotificationHolder.AnchorPoint = Vector2.new(1, 1)
NotificationHolder.BackgroundTransparency = 1
NotificationHolder.ZIndex = 999
NotificationHolder.Parent = ScreenGui

M3.ActiveNotifs = {}

-- Notification sound (rbxassetid): created once, reused for every Notify.
local NotifySound
M3.NotifySoundId = "rbxassetid://139746569667955"
M3.NotifySoundVolume = 0.5
M3.NotifySoundEnabled = true
do
    local ok, sound = pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = M3.NotifySoundId
        s.Volume = M3.NotifySoundVolume
        s.Parent = ScreenGui
        return s
    end)
    if ok and sound then NotifySound = sound end
end

function M3:PlayNotifySound()
    if M3.NotifySoundEnabled == false then return end
    if NotifySound and M3.NotifySoundId ~= "" then
        pcall(function()
            NotifySound.Volume = M3.NotifySoundVolume
            NotifySound.SoundId = M3.NotifySoundId
            NotifySound:Play()
        end)
    end
end

function M3:Notify(options)
    options = options or {}
    local titleText = options.Title or "Notification"
    local contentText = options.Content or ""
    local displayMs = options.Duration or 5000
    local iconId = M3:LoadIcon(options.Icon or "")
    local buttons = options.Buttons or {}
    local autoHide = displayMs ~= nil and displayMs > 0 or false

    M3:PlayNotifySound()

    local PAD_TOP = 12
    local PAD_BOTTOM = 12
    local TITLE_H = 20
    local BODY_GAP = 3
    local BAR_H = 3
    local CARD_W = 320

    local card = Instance.new("Frame")
    card.Name = "NotifCard"
    card.Size = UDim2.new(0, CARD_W, 0, 40)
    card.BackgroundColor3 = M3.CurrentTheme.SurfaceContainerHigh
    card.ClipsDescendants = true
    card.ZIndex = 999
    card.Parent = NotificationHolder

    local corner = Instance.new("UICorner")
    corner.CornerRadius = M3.CurrentTheme.CornerRadius
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = M3.CurrentTheme.OutlineVariant
    stroke.Thickness = 1
    stroke.Parent = card

    local contentOffset = 16
    if iconId ~= "" and iconId ~= nil then
        local iconImg = Instance.new("ImageLabel")
        iconImg.Size = UDim2.new(0, 24, 0, 24)
        iconImg.Position = UDim2.new(0, 14, 0, 14)
        iconImg.BackgroundTransparency = 1
        iconImg.Image = iconId
        iconImg.ImageColor3 = M3.CurrentTheme.Primary
        iconImg.Parent = card
        contentOffset = 46
    end

    local title = Instance.new("TextLabel")
    title.Text = titleText
    title.Font = M3.CurrentTheme.FontBold
    title.TextSize = 15
    title.TextColor3 = M3.CurrentTheme.OnSurface
    title.Position = UDim2.new(0, contentOffset, 0, PAD_TOP)
    title.Size = UDim2.new(1, -contentOffset - 14, 0, TITLE_H)
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextWrapped = true
    title.Parent = card

    local body = Instance.new("TextLabel")
    body.Text = contentText
    body.Font = M3.CurrentTheme.Font
    body.TextSize = 13
    body.TextColor3 = M3.CurrentTheme.OnSurfaceVariant
    body.Position = UDim2.new(0, contentOffset, 0, PAD_TOP + TITLE_H + BODY_GAP)
    body.Size = UDim2.new(1, -contentOffset - 14, 0, 32)
    body.BackgroundTransparency = 1
    body.TextWrapped = true
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.Parent = card

    -- Measure body height accurately with TextService (2 lines max before growing the card)
    local bodyH = 0
    if contentText ~= "" then
        local availW = CARD_W - contentOffset - 14
        local sz = pcall(function()
            return TextService:GetTextSize(contentText, 13, M3.CurrentTheme.Font, Vector2.new(availW, 512))
        end)
        if sz then
            bodyH = math.max(18, math.min(48, sz.Y))
        else
            bodyH = 18
        end
    end
    body.Size = UDim2.new(1, -contentOffset - 14, 0, bodyH)

    -- Buttons area (optional)
    local btnAreaH = 0
    if #buttons > 0 then
        btnAreaH = 32
    end

    local cardH = PAD_TOP + TITLE_H + BODY_GAP + bodyH + PAD_BOTTOM + btnAreaH + BAR_H
    card.Size = UDim2.new(0, CARD_W, 0, cardH)

    local timerBar = Instance.new("Frame")
    timerBar.Size = UDim2.new(1, 0, 0, BAR_H)
    timerBar.Position = UDim2.new(0, 0, 1, -BAR_H)
    timerBar.BackgroundColor3 = M3.CurrentTheme.Primary
    timerBar.BorderSizePixel = 0
    timerBar.Parent = card
    if not autoHide then
        timerBar.BackgroundTransparency = 1
    end

    if #buttons > 0 then
        local btnContainer = Instance.new("Frame")
        btnContainer.Size = UDim2.new(1, -20, 0, 30)
        btnContainer.Position = UDim2.new(0, 10, 1, -(30 + BAR_H))
        btnContainer.BackgroundTransparency = 1
        btnContainer.Parent = card

        local btnLayout = Instance.new("UIListLayout")
        btnLayout.FillDirection = Enum.FillDirection.Horizontal
        btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        btnLayout.Padding = UDim.new(0, 8)
        btnLayout.Parent = btnContainer

        for _, btnData in ipairs(buttons) do
            local actionBtn = Instance.new("TextButton")
            actionBtn.Size = UDim2.new(0, 75, 1, 0)
            actionBtn.BackgroundColor3 = M3.CurrentTheme.PrimaryContainer
            actionBtn.TextColor3 = M3.CurrentTheme.OnPrimaryContainer
            actionBtn.Font = M3.CurrentTheme.FontBold
            actionBtn.TextSize = 12
            actionBtn.Text = btnData.Text or "Action"
            actionBtn.Parent = btnContainer

            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 8)
            btnCorner.Parent = actionBtn

            M3:PressMorph(btnCorner, UDim.new(0, 8))

            actionBtn.MouseButton1Click:Connect(function()
                if btnData.Callback then
                    btnData.Callback()
                end
                M3.HideNotif(n)
            end)
        end
    end

    -- Manual bottom-up stacking (newest at the bottom)
    local n = {
        Card = card,
        Height = cardH,
        SlotY = 0,
        Closing = false,
    }
    table.insert(M3.ActiveNotifs, n)

    -- Entry: start off-screen (bottom-right), fly in to its slot
    card.AnchorPoint = Vector2.new(0, 1)
    card.Position = UDim2.new(1, 60, 0, n.SlotY - 6)

    M3:Tween(card, 0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {
        Position = UDim2.new(0, 0, 0, n.SlotY)
    })

    -- Timer / progress bar
    local total = autoHide and (displayMs / 1000) or 0
    local remaining = total
    local paused = false
    timerBar.Size = UDim2.new(1, 0, 0, BAR_H)

    local heartbeat
    if autoHide then
        heartbeat = RunService.Heartbeat:Connect(function(dt)
            if n.Closing then return end
            if paused then return end
            if remaining > 0 then
                remaining = remaining - dt
                if remaining < 0 then remaining = 0 end
                timerBar.Size = UDim2.new(remaining / total, 0, 0, BAR_H)
                if remaining <= 0 then
                    M3.HideNotif(n, "timeout")
                end
            end
        end)
        M3:TrackConnection(heartbeat)
    end

    -- Hover -> pause
    card.MouseEnter:Connect(function()
        paused = true
    end)
    card.MouseLeave:Connect(function()
        if not dragging then paused = false end
    end)

    -- Drag / swipe
    local dragging = false
    local dragStartMouse
    local dragStartPos

    card.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            paused = true
            dragStartMouse = input.Position
            dragStartPos = card.Position
        end
    end)

    local dragMoved = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local mp = input.Position or UserInputService:GetMouseLocation()
            if mp then
                local dx = mp.X - dragStartMouse.X
                local dy = mp.Y - dragStartMouse.Y
                -- card is bottom-anchored: moving down on screen reduces Y offset
                card.Position = UDim2.new(0, math.max(0, dragStartPos.X.Offset + dx), 0, dragStartPos.Y.Offset - dy)
            end
        end
    end)
    M3:TrackConnection(dragMoved)

    local dragEnded = UserInputService.InputEnded:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = false
            local dxX = card.Position.X.Offset
            local dyDown = n.SlotY - card.Position.Y.Offset
            paused = false
            if dxX > 120 then
                M3.HideNotif(n, "right")
            elseif dyDown > 90 then
                M3.HideNotif(n, "down")
            else
                -- spring back to rest
                M3:Tween(card, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {
                    Position = UDim2.new(0, 0, 0, n.SlotY)
                })
            end
        end
    end)
    M3:TrackConnection(dragEnded)

    return function()
        M3.HideNotif(n, "timeout")
    end
end

-- Remove a notification from the stack (with optional exit direction: "timeout", "right", "down").
function M3:HideNotif(n, direction)
    if not n or n.Closing then return end
    n.Closing = true
    if n.Card and n.Card.Parent then
        -- remove from stack + reflow others
        local idx
        for i, e in ipairs(M3.ActiveNotifs) do
            if e == n then idx = i end
        end
        if idx then table.remove(M3.ActiveNotifs, idx) end
        M3.ReflowNotifs()

        local card = n.Card
        if direction == "right" then
            M3:Tween(card, 0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In, {
                Position = UDim2.new(2, 40, 0, card.Position.Y.Offset),
                BackgroundTransparency = 1
            })
        elseif direction == "down" then
            M3:Tween(card, 0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In, {
                Position = UDim2.new(0, card.Position.X.Offset, 0, -(NotificationHolder.AbsoluteSize.Y or 300) - 60),
                BackgroundTransparency = 1
            })
        else
            -- timeout / default: fold back toward bottom-right corner
            M3:Tween(card, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In, {
                Position = UDim2.new(1, 60, 0, card.Position.Y.Offset),
                BackgroundTransparency = 1
            })
        end
        task.delay(0.45, function()
            if card and card.Parent then card:Destroy() end
        end)
    end
end

-- Reposition all active notifications to their correct stacked slots.
function M3:ReflowNotifs()
    local y = 0
    for i = #M3.ActiveNotifs, 1, -1 do
        local cardN = M3.ActiveNotifs[i]
        local targetY = y
        cardN.SlotY = targetY
        if cardN.Card and cardN.Card.Parent and not cardN.Closing then
            M3:Tween(cardN.Card, 0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
                Position = UDim2.new(0, 0, 0, targetY)
            })
        end
        y = y + cardN.Height + 8
    end
end

function M3:CreateFloatingWindow(elementName, contentConstructFn)
    local floatFrame = Instance.new("Frame")
    floatFrame.Name = "M3_Floating_" .. elementName
    floatFrame.Size = UDim2.new(0, 240, 0, 110)
    floatFrame.Position = UDim2.new(0.5, -120, 0.4, -55)
    floatFrame.BackgroundColor3 = M3.CurrentTheme.SurfaceContainerHigh
    floatFrame.ClipsDescendants = true
    floatFrame.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = M3.CurrentTheme.CornerRadius
    corner.Parent = floatFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = M3.CurrentTheme.Primary
    stroke.Thickness = 1.5
    stroke.Parent = floatFrame

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = M3.CurrentTheme.SurfaceContainerHighest
    topBar.BorderSizePixel = 0
    topBar.Parent = floatFrame

    local title = Instance.new("TextLabel")
    title.Text = "Floating: " .. elementName
    title.Font = M3.CurrentTheme.FontBold
    title.TextSize = 12
    title.TextColor3 = M3.CurrentTheme.OnSurface
    title.Position = UDim2.new(0, 10, 0, 0)
    title.Size = UDim2.new(1, -40, 1, 0)
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -27, 0, 3)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"
    closeBtn.TextColor3 = M3.CurrentTheme.Error
    closeBtn.Font = M3.CurrentTheme.FontBold
    closeBtn.TextSize = 12
    closeBtn.Parent = topBar

    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, -16, 1, -38)
    body.Position = UDim2.new(0, 8, 0, 34)
    body.BackgroundTransparency = 1
    body.Parent = floatFrame

    contentConstructFn(body)

    local dragging, dragStart, startPos
    local topBarBeganConn = topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = floatFrame.Position
        end
    end)

    local inputChangedConn = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            if floatFrame and floatFrame.Parent then
                local delta = input.Position - dragStart
                floatFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)

    local inputEndedConn = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    M3:TrackConnection(topBarBeganConn)
    M3:TrackConnection(inputChangedConn)
    M3:TrackConnection(inputEndedConn)

    local function DestroyFloat()
        if floatFrame and floatFrame.Parent then
            floatFrame:Destroy()
        end
        M3:Untrack(topBarBeganConn)
        M3:Untrack(inputChangedConn)
        M3:Untrack(inputEndedConn)
    end

    local closeClickConn = closeBtn.MouseButton1Click:Connect(function()
        DestroyFloat()
    end)
    M3:TrackConnection(closeClickConn)

    table.insert(M3.FloatingWindows, floatFrame)
    return floatFrame
end

function M3:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "Material Design 3"
    local defaultSize = (M3.Device == "Mobile") and UDim2.new(0.92, 0, 0.85, 0) or (config.Size or UDim2.new(0, 680, 0, 460))
    local windowId = config.Id or windowTitle

    if M3.ActiveWindows[windowId] then
        local oldWindow = M3.ActiveWindows[windowId]
        pcall(function()
            oldWindow:Destroy()
        end)
        M3.ActiveWindows[windowId] = nil
    end

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "M3_Window_" .. windowId
    mainFrame.Size = defaultSize
    mainFrame.Position = UDim2.new(0.5, -defaultSize.X.Offset/2, 0.5, -defaultSize.Y.Offset/2)
    mainFrame.BackgroundColor3 = M3.CurrentTheme.Surface
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = ScreenGui

    M3.ActiveWindows[windowId] = mainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = M3.CurrentTheme.CornerLarge
    corner.Parent = mainFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = M3.CurrentTheme.OutlineVariant
    stroke.Thickness = 1
    stroke.Parent = mainFrame

    local wallpaperLabel = Instance.new("ImageLabel")
    wallpaperLabel.Name = "M3_Wallpaper"
    wallpaperLabel.Size = UDim2.new(1, 0, 1, 0)
    wallpaperLabel.BackgroundTransparency = 1
    wallpaperLabel.ScaleType = Enum.ScaleType.Crop
    wallpaperLabel.ImageTransparency = 0.85
    wallpaperLabel.ZIndex = 0
    wallpaperLabel.Parent = mainFrame

    local topBar = Instance.new("Frame")
    topBar.Name = "TopAppBar"
    topBar.Size = UDim2.new(1, 0, 0, 54)
    topBar.BackgroundColor3 = M3.CurrentTheme.SurfaceContainer
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 2
    topBar.Parent = mainFrame

    local topBarCorner = Instance.new("UICorner")
    topBarCorner.CornerRadius = M3.CurrentTheme.CornerLarge
    topBarCorner.Parent = topBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Text = windowTitle
    titleLabel.Font = M3.CurrentTheme.FontBold
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = M3.CurrentTheme.OnSurface
    titleLabel.Position = UDim2.new(0, 20, 0, 0)
    titleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 3
    titleLabel.Parent = topBar

    local windowControls = Instance.new("Frame")
    windowControls.Size = UDim2.new(0, 100, 1, 0)
    windowControls.Position = UDim2.new(1, -110, 0, 0)
    windowControls.BackgroundTransparency = 1
    windowControls.ZIndex = 3
    windowControls.Parent = topBar

    local ctrlLayout = Instance.new("UIListLayout")
    ctrlLayout.FillDirection = Enum.FillDirection.Horizontal
    ctrlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ctrlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ctrlLayout.Padding = UDim.new(0, 6)
    ctrlLayout.Parent = windowControls

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
    minimizeBtn.BackgroundColor3 = M3.CurrentTheme.SurfaceContainerHigh
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = M3.CurrentTheme.OnSurface
    minimizeBtn.Font = M3.CurrentTheme.FontBold
    minimizeBtn.TextSize = 16
    minimizeBtn.Parent = windowControls

    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(1, 0)
    minCorner.Parent = minimizeBtn

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.BackgroundColor3 = M3.CurrentTheme.Error
    closeBtn.Text = "X"
    closeBtn.TextColor3 = M3.CurrentTheme.OnError
    closeBtn.Font = M3.CurrentTheme.FontBold
    closeBtn.TextSize = 12
    closeBtn.Parent = windowControls

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn

    local sideNav = Instance.new("Frame")
    sideNav.Name = "SideNav"
    sideNav.Size = (M3.Device == "Mobile") and UDim2.new(1, -20, 0, 42) or UDim2.new(0, 160, 1, -74)
    sideNav.Position = (M3.Device == "Mobile") and UDim2.new(0, 10, 0, 60) or UDim2.new(0, 12, 0, 62)
    sideNav.BackgroundColor3 = M3.CurrentTheme.SurfaceContainerLow
    sideNav.ZIndex = 2
    sideNav.Parent = mainFrame

    local sideNavCorner = Instance.new("UICorner")
    sideNavCorner.CornerRadius = M3.CurrentTheme.CornerRadius
    sideNavCorner.Parent = sideNav

    local tabListContainer = Instance.new("ScrollingFrame")
    tabListContainer.Size = UDim2.new(1, -12, 1, -12)
    tabListContainer.Position = UDim2.new(0, 6, 0, 6)
    tabListContainer.BackgroundTransparency = 1
    tabListContainer.ScrollBarThickness = 2
    tabListContainer.ScrollBarImageColor3 = M3.CurrentTheme.Outline
    tabListContainer.ZIndex = 3
    tabListContainer.Parent = sideNav

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = (M3.Device == "Mobile") and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
    tabLayout.Padding = UDim.new(0, 6)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabListContainer

    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentArea"
    contentFrame.Size = (M3.Device == "Mobile") and UDim2.new(1, -20, 1, -114) or UDim2.new(1, -192, 1, -74)
    contentFrame.Position = (M3.Device == "Mobile") and UDim2.new(0, 10, 0, 106) or UDim2.new(0, 180, 0, 62)
    contentFrame.BackgroundTransparency = 1
    contentFrame.ZIndex = 2
    contentFrame.Parent = mainFrame

    local resizeHandle = Instance.new("ImageButton")
    resizeHandle.Size = UDim2.new(0, 18, 0, 18)
    resizeHandle.Position = UDim2.new(1, -18, 1, -18)
    resizeHandle.BackgroundTransparency = 1
    resizeHandle.Image = "rbxassetid://6031280882"
    resizeHandle.ImageColor3 = M3.CurrentTheme.Outline
    resizeHandle.ZIndex = 10
    resizeHandle.Parent = mainFrame

    local dragging, dragStart, startPos
    local topBarBeganConn = topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    local inputChangedConn = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            if mainFrame and mainFrame.Parent then
                local delta = input.Position - dragStart
                mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)

    local inputEndedConn = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    M3:TrackConnection(topBarBeganConn)
    M3:TrackConnection(inputChangedConn)
    M3:TrackConnection(inputEndedConn)

    local resizing, resizeStart, startSize
    local resizeBeganConn = resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startSize = mainFrame.AbsoluteSize
        end
    end)

    local resizeChangedConn = UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            if mainFrame and mainFrame.Parent then
                local delta = input.Position - resizeStart
                local newX = math.max(340, startSize.X + delta.X)
                local newY = math.max(260, startSize.Y + delta.Y)
                mainFrame.Size = UDim2.new(0, newX, 0, newY)
            end
        end
    end)

    local resizeEndedConn = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)

    M3:TrackConnection(resizeBeganConn)
    M3:TrackConnection(resizeChangedConn)
    M3:TrackConnection(resizeEndedConn)

    local isMinimized = false
    local function ToggleMinimize()
        isMinimized = not isMinimized
        if isMinimized then
            M3:Tween(mainFrame, 0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
                Size = UDim2.new(0, mainFrame.AbsoluteSize.X, 0, 54)
            })
            if M3.Device == "Mobile" then
                MobileExpandButton.Visible = true
            end
        else
            M3:Tween(mainFrame, 0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
                Size = defaultSize
            })
            MobileExpandButton.Visible = false
        end
    end

    minimizeBtn.MouseButton1Click:Connect(ToggleMinimize)
    MobileExpandButton.MouseButton1Click:Connect(ToggleMinimize)

    local WindowAPI = {
        Tabs = {},
        CurrentTab = nil,
        MainFrame = mainFrame
    }

    function WindowAPI:SetTitle(newTitle)
        titleLabel.Text = tostring(newTitle or "")
    end

    function WindowAPI:SetWallpaper(imageUrl, transparency)
        wallpaperLabel.Image = imageUrl or ""
        wallpaperLabel.ImageTransparency = transparency or 0.85
    end

    function WindowAPI:SetVisible(visible)
        mainFrame.Visible = visible
    end

    function WindowAPI:GetVisible()
        return mainFrame.Visible
    end

    function WindowAPI:Destroy()
        mainFrame:Destroy()
        M3.ActiveWindows[windowId] = nil
        M3:Untrack(topBarBeganConn)
        M3:Untrack(inputChangedConn)
        M3:Untrack(inputEndedConn)
        M3:Untrack(resizeBeganConn)
        M3:Untrack(resizeChangedConn)
        M3:Untrack(resizeEndedConn)
        if WindowAPI.OnClose then
            pcall(WindowAPI.OnClose)
        end
    end

    WindowAPI.OnClose = nil

    closeBtn.MouseButton1Click:Connect(function()
        WindowAPI:Destroy()
    end)

    function WindowAPI:CreateTab(tabName, iconId)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = (M3.Device == "Mobile") and UDim2.new(0, 100, 1, 0) or UDim2.new(1, 0, 0, 36)
        tabBtn.BackgroundColor3 = M3.CurrentTheme.SurfaceContainer
        tabBtn.Text = ""
        tabBtn.ZIndex = 4
        tabBtn.Parent = tabListContainer

        local tabBtnText = Instance.new("TextLabel")
        tabBtnText.Text = tabName
        tabBtnText.TextColor3 = M3.CurrentTheme.OnSurfaceVariant
        tabBtnText.Font = M3.CurrentTheme.FontBold
        tabBtnText.TextSize = 13
        tabBtnText.BackgroundTransparency = 1
        tabBtnText.TextXAlignment = Enum.TextXAlignment.Left
        tabBtnText.ZIndex = 5
        tabBtnText.Parent = tabBtn

        -- Resolve optional icon (name / asset id / url) and show it left of the text
        local tabIconImage = M3:LoadIcon(iconId)
        local tabIcon
        if tabIconImage ~= "" then
            tabIcon = Instance.new("ImageLabel")
            tabIcon.Size = UDim2.new(0, 18, 0, 18)
            tabIcon.Position = UDim2.new(0, 10, 0.5, -9)
            tabIcon.BackgroundTransparency = 1
            tabIcon.Image = tabIconImage
            tabIcon.ImageColor3 = M3.CurrentTheme.OnSurfaceVariant
            tabIcon.ScaleType = Enum.ScaleType.Fit
            tabIcon.ZIndex = 6
            tabIcon.Parent = tabBtn

            tabBtnText.Position = UDim2.new(0, 34, 0, 0)
            tabBtnText.Size = UDim2.new(1, -40, 1, 0)
        else
            tabBtnText.Position = UDim2.new(0, 12, 0, 0)
            tabBtnText.Size = UDim2.new(1, -20, 1, 0)
        end

        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 10)
        tabCorner.Parent = tabBtn

        M3:PressMorph(tabCorner, UDim.new(0, 10))

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = "TabContent_" .. tabName
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 3
        tabContent.ScrollBarImageColor3 = M3.CurrentTheme.Outline
        tabContent.Visible = false
        tabContent.ZIndex = 3
        tabContent.Parent = contentFrame

        local tabLayout = Instance.new("UIListLayout")
        tabLayout.Padding = UDim.new(0, 10)
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Parent = tabContent

        tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 16)
        end)

        local TabAPI = {
            Button = tabBtn,
            Text = tabBtnText,
            Icon = tabIcon,
            Container = tabContent
        }

        local function SelectTab()
            for _, t in pairs(WindowAPI.Tabs) do
                t.Container.Visible = false
                M3:Tween(t.Button, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
                    BackgroundColor3 = M3.CurrentTheme.SurfaceContainer
                })
                if t.Text then
                    M3:Tween(t.Text, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
                        TextColor3 = M3.CurrentTheme.OnSurfaceVariant
                    })
                end
                if t.Icon then
                    M3:Tween(t.Icon, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
                        ImageColor3 = M3.CurrentTheme.OnSurfaceVariant
                    })
                end
            end
            tabContent.Visible = true
            WindowAPI.CurrentTab = TabAPI
            M3:Tween(tabBtn, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
                BackgroundColor3 = M3.CurrentTheme.PrimaryContainer
            })
            M3:Tween(tabBtnText, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
                TextColor3 = M3.CurrentTheme.OnPrimaryContainer
            })
            if tabIcon then
                M3:Tween(tabIcon, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
                    ImageColor3 = M3.CurrentTheme.OnPrimaryContainer
                })
            end
        end

        tabBtn.MouseButton1Click:Connect(SelectTab)

        if #WindowAPI.Tabs == 0 then
            SelectTab()
        end

        table.insert(WindowAPI.Tabs, TabAPI)

        function TabAPI:CreateGroup(groupTitle)
            local groupFrame = Instance.new("Frame")
            groupFrame.Size = UDim2.new(1, -6, 0, 40)
            groupFrame.BackgroundColor3 = M3.CurrentTheme.SurfaceContainer
            groupFrame.ZIndex = 3
            groupFrame.Parent = tabContent

            local groupCorner = Instance.new("UICorner")
            groupCorner.CornerRadius = M3.CurrentTheme.CornerRadius
            groupCorner.Parent = groupFrame

            local groupStroke = Instance.new("UIStroke")
            groupStroke.Color = M3.CurrentTheme.OutlineVariant
            groupStroke.Thickness = 1
            groupStroke.Parent = groupFrame

            local groupTitleLabel = Instance.new("TextLabel")
            groupTitleLabel.Text = groupTitle
            groupTitleLabel.Font = M3.CurrentTheme.FontBold
            groupTitleLabel.TextSize = 14
            groupTitleLabel.TextColor3 = M3.CurrentTheme.Primary
            groupTitleLabel.Position = UDim2.new(0, 14, 0, 8)
            groupTitleLabel.Size = UDim2.new(1, -28, 0, 20)
            groupTitleLabel.BackgroundTransparency = 1
            groupTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            groupTitleLabel.ZIndex = 4
            groupTitleLabel.Parent = groupFrame

            local groupLayout = Instance.new("UIListLayout")
            groupLayout.Padding = UDim.new(0, 8)
            groupLayout.SortOrder = Enum.SortOrder.LayoutOrder
            groupLayout.Parent = groupFrame

            local groupPadding = Instance.new("UIPadding")
            groupPadding.PaddingTop = UDim.new(0, 32)
            groupPadding.PaddingBottom = UDim.new(0, 10)
            groupPadding.PaddingLeft = UDim.new(0, 10)
            groupPadding.PaddingRight = UDim.new(0, 10)
            groupPadding.Parent = groupFrame

            groupLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                groupFrame.Size = UDim2.new(1, -6, 0, groupLayout.AbsoluteContentSize.Y + 42)
            end)

            local GroupAPI = {}

            local function SetupKeybindAndFloat(elementBtn, name, primaryCallback, constructFloatContent)
                local holdTime = 0
                local holding = false
                local floated = false

                elementBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        holding = true
                        floated = false
                        holdTime = tick()
                        task.delay(0.8, function()
                            if holding and (tick() - holdTime >= 0.75) then
                                holding = false
                                floated = true
                                M3:Notify({Title = "Floating Mode", Content = "Detached '" .. name .. "' to floating window.", Duration = 2.5})
                                M3:CreateFloatingWindow(name, constructFloatContent)
                            end
                        end)
                    end
                end)

                elementBtn.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        holding = false
                    end
                end)

                elementBtn.MouseButton2Click:Connect(function()
                    M3:Notify({Title = "Keybind Setup", Content = "Press any key/button to bind to " .. name .. "...", Duration = 3})
                    local conn
                    conn = UserInputService.InputBegan:Connect(function(inp, gpe)
                        if not gpe then
                            local boundKey = inp.KeyCode ~= Enum.KeyCode.Unknown and inp.KeyCode or inp.UserInputType
                            M3:Notify({Title = "Keybound!", Content = name .. " bound to " .. tostring(boundKey.Name), Duration = 2.5})
                            conn:Disconnect()
                            M3:Untrack(conn)
                            local bindConn
                            bindConn = UserInputService.InputBegan:Connect(function(execInp, execGpe)
                                if not execGpe and (execInp.KeyCode == boundKey or execInp.UserInputType == boundKey) then
                                    primaryCallback()
                                end
                            end)
                            table.insert(M3.Connections, bindConn)
                            M3:TrackConnection(bindConn)
                        end
                    end)
                    M3:TrackConnection(conn)
                end)
            end

            function GroupAPI:AddButton(text, callback)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 38)
                btn.BackgroundColor3 = M3.CurrentTheme.Primary
                btn.Text = text
                btn.TextColor3 = M3.CurrentTheme.OnPrimary
                btn.Font = M3.CurrentTheme.FontBold
                btn.TextSize = 13
                btn.ZIndex = 5
                btn.Parent = groupFrame

                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 10)
                btnCorner.Parent = btn
                M3:PressMorph(btnCorner, UDim.new(0, 10))

                btn.MouseButton1Click:Connect(function()
                    if floated then floated = false return end
                    M3:Ripple(btn, UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                    callback()
                end)

                SetupKeybindAndFloat(btn, text, callback, function(floatContainer)
                    local fBtn = Instance.new("TextButton")
                    fBtn.Size = UDim2.new(1, 0, 0, 38)
                    fBtn.BackgroundColor3 = M3.CurrentTheme.Primary
                    fBtn.Text = text
                    fBtn.TextColor3 = M3.CurrentTheme.OnPrimary
                    fBtn.Font = M3.CurrentTheme.FontBold
                    fBtn.TextSize = 13
                    fBtn.Parent = floatContainer
                    local c = Instance.new("UICorner")
                    c.CornerRadius = UDim.new(0, 10)
                    c.Parent = fBtn
                    M3:PressMorph(c, UDim.new(0, 10))
                    fBtn.MouseButton1Click:Connect(callback)
                end)
            end

            function GroupAPI:AddToggle(text, defaultState, callback)
                local state = defaultState or false

                local toggleFrame = Instance.new("TextButton")
                toggleFrame.Size = UDim2.new(1, 0, 0, 40)
                toggleFrame.BackgroundColor3 = M3.CurrentTheme.SurfaceContainerHigh
                toggleFrame.Text = ""
                toggleFrame.ZIndex = 5
                toggleFrame.Parent = groupFrame

                local toggleCorner = Instance.new("UICorner")
                toggleCorner.CornerRadius = UDim.new(0, 12)
                toggleCorner.Parent = toggleFrame

                M3:PressMorph(toggleCorner, UDim.new(0, 12))

                local label = Instance.new("TextLabel")
                label.Text = text
                label.Font = M3.CurrentTheme.Font
                label.TextSize = 13
                label.TextColor3 = M3.CurrentTheme.OnSurface
                label.Position = UDim2.new(0, 12, 0, 0)
                label.Size = UDim2.new(1, -70, 1, 0)
                label.BackgroundTransparency = 1
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.ZIndex = 6
                label.Parent = toggleFrame

                local switchTrack = Instance.new("Frame")
                switchTrack.Size = UDim2.new(0, 44, 0, 24)
                switchTrack.Position = UDim2.new(1, -52, 0.5, -12)
                switchTrack.BackgroundColor3 = state and M3.CurrentTheme.Primary or M3.CurrentTheme.SurfaceContainerHighest
                switchTrack.ZIndex = 6
                switchTrack.Parent = toggleFrame

                local trackCorner = Instance.new("UICorner")
                trackCorner.CornerRadius = UDim.new(1, 0)
                trackCorner.Parent = switchTrack

                local switchKnob = Instance.new("Frame")
                switchKnob.Size = UDim2.new(0, 18, 0, 18)
                switchKnob.Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                switchKnob.BackgroundColor3 = state and M3.CurrentTheme.OnPrimary or M3.CurrentTheme.Outline
                switchKnob.ZIndex = 7
                switchKnob.Parent = switchTrack

                local knobCorner = Instance.new("UICorner")
                knobCorner.CornerRadius = UDim.new(1, 0)
                knobCorner.Parent = switchKnob

                local function SetState(newState)
                    state = newState
                    M3:Tween(switchTrack, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
                        BackgroundColor3 = state and M3.CurrentTheme.Primary or M3.CurrentTheme.SurfaceContainerHighest
                    })
                    M3:Tween(switchKnob, 0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {
                        Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
                        BackgroundColor3 = state and M3.CurrentTheme.OnPrimary or M3.CurrentTheme.Outline
                    })
                    callback(state)
                end

                toggleFrame.MouseButton1Click:Connect(function()
                    if floated then floated = false return end
                    SetState(not state)
                end)

                SetupKeybindAndFloat(toggleFrame, text, function() SetState(not state) end, function(floatContainer)
                    local fTrack = Instance.new("TextButton")
                    fTrack.Size = UDim2.new(1, 0, 0, 36)
                    fTrack.BackgroundColor3 = M3.CurrentTheme.PrimaryContainer
                    fTrack.Text = text .. ": " .. (state and "ON" or "OFF")
                    fTrack.TextColor3 = M3.CurrentTheme.OnPrimaryContainer
                    fTrack.Font = M3.CurrentTheme.FontBold
                    fTrack.TextSize = 13
                    fTrack.Parent = floatContainer
                    local c = Instance.new("UICorner")
                    c.CornerRadius = UDim.new(0, 10)
                    c.Parent = fTrack
                    M3:PressMorph(c, UDim.new(0, 10))
                    fTrack.MouseButton1Click:Connect(function()
                        SetState(not state)
                        fTrack.Text = text .. ": " .. (state and "ON" or "OFF")
                    end)
                end)
            end

            -- MD3 Switch (переключатель): трек + ползунок, с иконками внутри (✓/✕) или без.
            -- Group:AddSwitch(text, { Default=false, WithIcon=true, Enabled=true, Callback=fn })
            --   или Group:AddSwitch(text, defaultState, callback)
            function GroupAPI:AddSwitch(text, opts, legacyCallback)
                local cfg = {}
                if type(opts) == "table" then
                    cfg = opts or {}
                else
                    cfg.Default = opts
                    cfg.Callback = legacyCallback
                end

                local state = cfg.Default == true
                local withIcon = cfg.WithIcon ~= false
                local enabled = cfg.Enabled ~= false

                local iconOn = withIcon and M3:LoadIcon("check") or ""
                local iconOff = withIcon and M3:LoadIcon("close") or ""

                local switchFrame = Instance.new("TextButton")
                switchFrame.Size = UDim2.new(1, 0, 0, 44)
                switchFrame.BackgroundColor3 = M3.CurrentTheme.SurfaceContainerHigh
                switchFrame.Text = ""
                switchFrame.ZIndex = 5
                switchFrame.Parent = groupFrame

                local switchCorner = Instance.new("UICorner")
                switchCorner.CornerRadius = UDim.new(0, 12)
                switchCorner.Parent = switchFrame
                M3:PressMorph(switchCorner, UDim.new(0, 12))

                local label = Instance.new("TextLabel")
                label.Text = text
                label.Font = M3.CurrentTheme.Font
                label.TextSize = 13
                label.TextColor3 = M3.CurrentTheme.OnSurface
                label.Position = UDim2.new(0, 12, 0, 0)
                label.Size = UDim2.new(1, -90, 1, 0)
                label.BackgroundTransparency = 1
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.ZIndex = 6
                label.Parent = switchFrame

                -- Трек (слева отступ, высота 28px как в MD3)
                local switchTrack = Instance.new("Frame")
                switchTrack.Size = UDim2.new(0, 56, 0, 28)
                switchTrack.Position = UDim2.new(1, -68, 0.5, -14)
                switchTrack.BackgroundColor3 = state and M3.CurrentTheme.Primary or M3.CurrentTheme.SurfaceContainerHighest
                switchTrack.ZIndex = 6
                switchTrack.Parent = switchFrame

                local trackCorner = Instance.new("UICorner")
                trackCorner.CornerRadius = UDim.new(1, 0)
                trackCorner.Parent = switchTrack

                -- Ползунок (круглый, растёт при включении и при нажатии)
                local switchKnob = Instance.new("Frame")
                switchKnob.Size = UDim2.new(0, state and 24 or 16, 0, state and 24 or 16)
                switchKnob.Position = state and UDim2.new(1, -28, 0.5, -12) or UDim2.new(0, 2, 0.5, -8)
                switchKnob.BackgroundColor3 = state and M3.CurrentTheme.OnPrimary or M3.CurrentTheme.Outline
                switchKnob.ZIndex = 8
                switchKnob.Parent = switchTrack

                local knobCorner = Instance.new("UICorner")
                knobCorner.CornerRadius = UDim.new(1, 0)
                knobCorner.Parent = switchKnob

                local knobIcon
                if withIcon then
                    knobIcon = Instance.new("ImageLabel")
                    knobIcon.Size = UDim2.new(0, 14, 0, 14)
                    knobIcon.Position = UDim2.new(0.5, -7, 0.5, -7)
                    knobIcon.BackgroundTransparency = 1
                    knobIcon.Image = state and iconOn or iconOff
                    knobIcon.ImageColor3 = state and M3.CurrentTheme.Primary or M3.CurrentTheme.SurfaceContainerHighest
                    knobIcon.ScaleType = Enum.ScaleType.Fit
                    knobIcon.ZIndex = 9
                    knobIcon.Parent = switchKnob
                end

                local function applyColors()
                    local onCol = enabled and M3.CurrentTheme.Primary or M3.CurrentTheme.SurfaceContainerHighest
                    local offCol = enabled and M3.CurrentTheme.SurfaceContainerHighest or M3.CurrentTheme.SurfaceContainerHighest
                    local knobCol = enabled and (state and M3.CurrentTheme.OnPrimary or M3.CurrentTheme.Outline) or M3.CurrentTheme.SurfaceContainerHighest
                    switchTrack.BackgroundColor3 = state and onCol or offCol
                    switchKnob.BackgroundColor3 = knobCol
                    if knobIcon then
                        knobIcon.Image = state and iconOn or (iconOff ~= "" and iconOff or iconOn)
                        knobIcon.ImageColor3 = state and M3.CurrentTheme.Primary or M3.CurrentTheme.SurfaceContainerHighest
                    end
                end

                local function SetState(newState, pressed)
                    state = newState
                    local push = (enabled and pressed) and 6 or 0
                    local knobSize = (state and 24 or 16) + push
                    local knobPos
                    if state then
                        knobPos = UDim2.new(1, -28 - push / 2 - 0, 0.5, -knobSize / 2)
                    else
                        knobPos = UDim2.new(0, 2 - push / 2, 0.5, -knobSize / 2 + 0)
                    end
                    M3:Tween(switchTrack, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
                        BackgroundColor3 = state and M3.CurrentTheme.Primary or M3.CurrentTheme.SurfaceContainerHighest
                    })
                    M3:Tween(switchKnob, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {
                        Size = UDim2.new(0, knobSize, 0, knobSize),
                        Position = knobPos,
                        BackgroundColor3 = state and M3.CurrentTheme.OnPrimary or M3.CurrentTheme.Outline
                    })
                    if knobIcon then
                        M3:Tween(knobIcon, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
                            Image = state and iconOn or (iconOff ~= "" and iconOff or iconOn)
                        })
                    end
                    if not pressed then
                        if cfg.Callback then cfg.Callback(state) end
                    end
                end

                switchFrame.MouseButton1Down:Connect(function()
                    if not enabled then return end
                    if floated then floated = false return end
                    -- сжатие ползунка при нажатии
                    SetState(state, true)
                end)

                switchFrame.MouseButton1Up:Connect(function()
                    if not enabled then return end
                    local newState = not state
                    -- отпускаем — ползунок возвращается к нормальному размеру и переключается
                    SetState(newState, false)
                end)

                applyColors()

                -- Программное управление
                return {
                    GetState = function() return state end,
                    SetState = function(v)
                        SetState(v == true, false)
                    end,
                    SetEnabled = function(v)
                        enabled = v == true
                        applyColors()
                    end
                }
            end

            function GroupAPI:AddSlider(text, minVal, maxVal, defaultVal, opts, legacyCallback)
                -- Flexible API: positional text,min,max,value OR a single options table
                local cfg = {}
                if type(minVal) == "table" then
                    -- AddSlider(text, {Min=,Max=,Value=,Style=,Step=,Precise=,Callback=})
                    cfg = minVal
                    text = text
                else
                    cfg.Min = minVal
                    cfg.Max = maxVal
                    cfg.Value = defaultVal
                    if type(opts) == "table" then
                        cfg.Style = opts.Style
                        cfg.Step = opts.Step
                        cfg.Precise = opts.Precise
                        cfg.Callback = opts.Callback
                        cfg.RangeMin = opts.RangeMin
                        cfg.RangeMax = opts.RangeMax
                        cfg.ShowValue = opts.ShowValue
                    else
                        cfg.Precise = (type(opts) == "boolean") and opts or nil
                    end
                    cfg.Callback = cfg.Callback or legacyCallback
                end

                local style = (cfg.Style or "Continuous"):lower()
                local min = tonumber(cfg.Min) or 0
                local max = tonumber(cfg.Max) or 100
                local step = tonumber(cfg.Step) or 1
                local precise = cfg.Precise == true
                local showValue = cfg.ShowValue ~= false
                if max == min then max = min + 1 end

                local rangeMin = cfg.RangeMin ~= nil and tonumber(cfg.RangeMin) or min
                local rangeMax = cfg.RangeMax ~= nil and tonumber(cfg.RangeMax) or max
                local isRange = style == "range"
                local isCentered = style == "centered"

                -- Centered: mid is zero; supports negative/positive symmetric min/max
                local centerVal = (min + max) / 2

                -- Values (single) or [low, high] (range)
                local snap = (style == "discrete" or isRange)
                local function roundVal(v)
                    v = math.clamp(v, min, max)
                    if precise then
                        return math.floor(v * 100 + 0.5) / 100
                    end
                    if snap then
                        local s = step or 1
                        if s <= 0 then s = 1 end
                        return min + math.round((v - min) / s) * s
                    end
                    return v
                end

                local function roundValRange(v)
                    if precise then
                        return math.floor(v * 100 + 0.5) / 100
                    end
                    local s = step or 1
                    if s <= 0 then s = 1 end
                    return rangeMin + math.round((v - rangeMin) / s) * s
                end

                local val
                if isRange then
                    val = {
                        math.clamp(cfg.Value ~= nil and cfg.Value[1] or rangeMin, rangeMin, rangeMax),
                        math.clamp(cfg.Value ~= nil and cfg.Value[2] or rangeMax, rangeMin, rangeMax),
                    }
                else
                    val = math.clamp(cfg.Value or centerVal, min, max)
                end

                local sliderFrame = Instance.new("Frame")
                sliderFrame.Size = UDim2.new(1, 0, 0, 64)
                sliderFrame.BackgroundColor3 = M3.CurrentTheme.SurfaceContainerHigh
                sliderFrame.ZIndex = 5
                sliderFrame.Parent = groupFrame

                local sliderCorner = Instance.new("UICorner")
                sliderCorner.CornerRadius = UDim.new(0, 12)
                sliderCorner.Parent = sliderFrame

                local label = Instance.new("TextLabel")
                label.Text = text
                label.Font = M3.CurrentTheme.Font
                label.TextSize = 13
                label.TextColor3 = M3.CurrentTheme.OnSurface
                label.Position = UDim2.new(0, 12, 0, 6)
                label.Size = UDim2.new(0.6, 0, 0, 18)
                label.BackgroundTransparency = 1
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.ZIndex = 6
                label.Parent = sliderFrame

                local valLabel = Instance.new("TextLabel")
                valLabel.Font = M3.CurrentTheme.FontBold
                valLabel.TextSize = 13
                valLabel.TextColor3 = M3.CurrentTheme.Primary
                valLabel.Position = UDim2.new(0.5, 0, 0, 6)
                valLabel.Size = UDim2.new(0.5, -12, 0, 18)
                valLabel.BackgroundTransparency = 1
                valLabel.TextXAlignment = Enum.TextXAlignment.Right
                valLabel.ZIndex = 6
                valLabel.Parent = sliderFrame
                if not showValue then valLabel.Visible = false end

                -- Track container (clickable)
                local track = Instance.new("TextButton")
                track.Name = "Track"
                track.Size = UDim2.new(1, -24, 0, 20)
                track.Position = UDim2.new(0, 12, 0, 30)
                track.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
                track.BackgroundTransparency = 1
                track.Text = ""
                track.ZIndex = 6
                track.Parent = sliderFrame

                -- Inactive track line (full width)
                local trackLine = Instance.new("Frame")
                trackLine.Size = UDim2.new(1, 0, 0, 4)
                trackLine.Position = UDim2.new(0, 0, 0.5, -2)
                trackLine.BackgroundColor3 = M3.CurrentTheme.SurfaceContainerHighest
                trackLine.BorderSizePixel = 0
                trackLine.ZIndex = 7
                trackLine.Parent = track

                local trackLineCorner = Instance.new("UICorner")
                trackLineCorner.CornerRadius = UDim.new(1, 0)
                trackLineCorner.Parent = trackLine

                -- Active fill (dimension differs per style)
                local fill = Instance.new("Frame")
                fill.BackgroundColor3 = M3.CurrentTheme.Primary
                fill.BorderSizePixel = 0
                fill.ZIndex = 8
                fill.Parent = track
                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(1, 0)
                fillCorner.Parent = fill
                if isCentered then
                    fill.Size = UDim2.new(0, 0, 1, 0)
                elseif isRange then
                    fill.Size = UDim2.new(0, 0, 1, 0)
                else
                    fill.AnchorPoint = Vector2.new(0, 0.5)
                    fill.Position = UDim2.new(0, 0, 0.5, -2)
                    fill.Size = UDim2.new(0, 0, 0, 4)
                end

                -- Thumb handle(s)
                local function makeThumb()
                    local thumb = Instance.new("Frame")
                    thumb.Size = UDim2.new(0, 16, 0, 16)
                    thumb.AnchorPoint = Vector2.new(0.5, 0.5)
                    thumb.BackgroundColor3 = M3.CurrentTheme.Primary
                    thumb.ZIndex = 9
                    thumb.Parent = track

                    local c = Instance.new("UICorner")
                    c.CornerRadius = UDim.new(1, 0)
                    c.Parent = thumb

                    local stroke = Instance.new("UIStroke")
                    stroke.Color = M3.CurrentTheme.Surface
                    stroke.Thickness = 2
                    stroke.Parent = thumb

                    return thumb
                end

                local thumbSingle
                local thumbLow, thumbHigh

                if isRange then
                    thumbLow = makeThumb()
                    thumbHigh = makeThumb()
                else
                    thumbSingle = makeThumb()
                end

                -- Discrete tick marks
                local tickContainer
                if style == "discrete" then
                    tickContainer = Instance.new("Frame")
                    tickContainer.Size = UDim2.new(1, 0, 0, 4)
                    tickContainer.Position = UDim2.new(0, 0, 0.5, -2)
                    tickContainer.BackgroundTransparency = 1
                    tickContainer.ZIndex = 7
                    tickContainer.Parent = track
                    local tickCount = math.floor((max - min) / step) + 1
                    if tickCount > 40 then tickCount = 40 end
                    if tickCount > 1 then
                        for i = 0, tickCount - 1 do
                            local tick = Instance.new("Frame")
                            local x = (i / (tickCount - 1))
                            tick.Size = UDim2.new(0, 1, 1, 0)
                            tick.Position = UDim2.new(x, -0.5, 0, 0)
                            tick.BackgroundColor3 = M3.CurrentTheme.OnSurfaceVariant
                            tick.BorderSizePixel = 0
                            tick.ZIndex = 7
                            tick.Parent = tickContainer
                        end
                    end
                end

                -- Discrete value popup label
                local popup
                if style == "discrete" then
                    popup = Instance.new("Frame")
                    popup.Size = UDim2.new(0, 42, 0, 28)
                    popup.AnchorPoint = Vector2.new(0.5, 0.5)
                    popup.BackgroundColor3 = M3.CurrentTheme.Primary
                    popup.ZIndex = 20
                    popup.Visible = false
                    popup.Parent = track

                    local pcorner = Instance.new("UICorner")
                    pcorner.CornerRadius = UDim.new(0, 8)
                    pcorner.Parent = popup

                    local plabel = Instance.new("TextLabel")
                    plabel.Size = UDim2.new(1, 0, 1, 0)
                    plabel.BackgroundTransparency = 1
                    plabel.TextColor3 = M3.CurrentTheme.OnPrimary
                    plabel.Font = M3.CurrentTheme.FontBold
                    plabel.TextSize = 12
                    plabel.Text = ""
                    plabel.Parent = popup
                end

                -- Mapping value <-> pixel X (linear in all styles; centered only changes fill origin)
                local trackW = track.AbsoluteSize.X
                local function valueToPct(v)
                    return (v - min) / (max - min)
                end
                local function pctToValue(pct)
                    return min + (max - min) * pct
                end

                local function paint()
                    if not trackLine then return end
                    trackW = math.max(track.AbsoluteSize.X, 1)

                    local function placeFill(v1, v2)
                        local p1 = valueToPct(math.clamp(v1, min, max))
                        local p2 = valueToPct(math.clamp(v2, min, max))
                        local x1 = p1 * trackW
                        local x2 = p2 * trackW
                        fill.Position = UDim2.new(0, x1, 0, 0)
                        fill.Size = UDim2.new(0, math.max(0, x2 - x1), 1, 0)
                    end

                    if isCentered then
                        local cv = valueToPct(centerVal)
                        local vv = valueToPct(val)
                        local xc = cv * trackW
                        local xv = vv * trackW
                        fill.AnchorPoint = Vector2.new(0, 0)
                        fill.Position = UDim2.new(0, math.min(xc, xv), 0, 0)
                        fill.Size = UDim2.new(0, math.abs(xv - xc), 1, 0)
                        if thumbSingle then
                            thumbSingle.Position = UDim2.new(vv, 0, 0.5, 0)
                        end
                    elseif isRange then
                        placeFill(val[1], val[2])
                        if thumbLow then thumbLow.Position = UDim2.new(valueToPct(val[1]), 0, 0.5, 0) end
                        if thumbHigh then thumbHigh.Position = UDim2.new(valueToPct(val[2]), 0, 0.5, 0) end
                    else
                        local p = valueToPct(val)
                        fill.Position = UDim2.new(0, 0, 0.5, -2)
                        fill.Size = UDim2.new(p, 0, 0, 4)
                        if thumbSingle then
                            thumbSingle.Position = UDim2.new(p, 0, 0.5, 0)
                        end
                    end

                    if popup and thumbSingle then
                        popup.Position = UDim2.new(valueToPct(val), 0, -0.5, 0)
                        plabel.Text = tostring(val)
                    end

                    -- Update value labels
                    if isRange then
                        valLabel.Text = tostring(val[1]) .. " - " .. tostring(val[2])
                    else
                        valLabel.Text = tostring(val)
                    end
                end

                local dragging = false
                local dragIdx = nil
                local function pixelToValue(x)
                    local pct = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    return pctToValue(pct)
                end

                local function apply(v, idx)
                    if precise then
                        if isRange then
                            val[idx] = math.round(v * 100) / 100
                        else
                            val = math.round(v * 100) / 100
                        end
                    else
                        if isRange then
                            val[idx] = roundValRange(v)
                        else
                            val = roundVal(v)
                        end
                    end
                    paint()
                    if isRange then
                        if cfg.Callback then cfg.Callback(val[1], val[2]) end
                    else
                        if cfg.Callback then cfg.Callback(val) end
                    end
                end

                local function onDrag(input)
                    local v = pixelToValue(input.Position.X)
                    if isRange then
                        local idx = dragIdx
                        if idx == nil then
                            -- choose nearest thumb
                            local p = valueToPct(v)
                            local p1 = valueToPct(val[1])
                            local p2 = valueToPct(val[2])
                            idx = (math.abs(p - p1) <= math.abs(p - p2)) and 1 or 2
                            dragIdx = idx
                        end
                        apply(v, idx)
                        -- keep low <= high
                        if val[1] > val[2] then
                            val[1], val[2] = val[2], val[1]
                            paint()
                        end
                    else
                        apply(v)
                    end
                end

                track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = true
                        dragIdx = nil
                        if style == "discrete" and popup then
                            popup.Visible = true
                            paint()
                        end
                        onDrag(input)
                    end
                end)

                local sliderChangedConn = UserInputService.InputChanged:Connect(function(input)
                    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        onDrag(input)
                    end
                end)
                M3:TrackConnection(sliderChangedConn)

                local sliderEndedConn = UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        dragging = false
                        dragIdx = nil
                        if popup then popup.Visible = false end
                    end
                end)
                M3:TrackConnection(sliderEndedConn)

                paint()

                -- Return a handle to read/set values programmatically
                return {
                    GetValue = function()
                        if isRange then return val[1], val[2] end
                        return val
                    end,
                    SetValue = function(v)
                        if isRange then
                            val[1] = math.clamp(v[1] or val[1], rangeMin, rangeMax)
                            val[2] = math.clamp(v[2] or val[2], rangeMin, rangeMax)
                            if val[1] > val[2] then val[1], val[2] = val[2], val[1] end
                            paint()
                            if cfg.Callback then cfg.Callback(val[1], val[2]) end
                        else
                            val = math.clamp(v, min, max)
                            paint()
                            if cfg.Callback then cfg.Callback(val) end
                        end
                    end
                }
            end

            function GroupAPI:AddDropdown(text, options, defaultSelected, multiSelect, callback)
                options = options or {}
                local selected = multiSelect and {} or defaultSelected

                local dropFrame = Instance.new("Frame")
                dropFrame.Size = UDim2.new(1, 0, 0, 42)
                dropFrame.BackgroundColor3 = M3.CurrentTheme.SurfaceContainerHigh
                dropFrame.ClipsDescendants = true
                dropFrame.ZIndex = 5
                dropFrame.Parent = groupFrame

                local dropCorner = Instance.new("UICorner")
                dropCorner.CornerRadius = UDim.new(0, 12)
                dropCorner.Parent = dropFrame

                local headerBtn = Instance.new("TextButton")
                headerBtn.Size = UDim2.new(1, 0, 0, 42)
                headerBtn.BackgroundTransparency = 1
                headerBtn.Text = ""
                headerBtn.ZIndex = 6
                headerBtn.Parent = dropFrame

                M3:PressMorph(dropCorner, UDim.new(0, 12), headerBtn)

                local label = Instance.new("TextLabel")
                label.Text = text
                label.Font = M3.CurrentTheme.Font
                label.TextSize = 13
                label.TextColor3 = M3.CurrentTheme.OnSurface
                label.Position = UDim2.new(0, 12, 0, 0)
                label.Size = UDim2.new(0.5, 0, 0, 42)
                label.BackgroundTransparency = 1
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.ZIndex = 7
                label.Parent = headerBtn

                local selLabel = Instance.new("TextLabel")
                selLabel.Text = multiSelect and "Multi-Select" or tostring(defaultSelected or "Select...")
                selLabel.Font = M3.CurrentTheme.FontBold
                selLabel.TextSize = 12
                selLabel.TextColor3 = M3.CurrentTheme.Primary
                selLabel.Position = UDim2.new(0.5, 0, 0, 0)
                selLabel.Size = UDim2.new(0.5, -30, 0, 42)
                selLabel.BackgroundTransparency = 1
                selLabel.TextXAlignment = Enum.TextXAlignment.Right
                selLabel.ZIndex = 7
                selLabel.Parent = headerBtn

                local searchBox = Instance.new("TextBox")
                searchBox.Size = UDim2.new(1, -24, 0, 32)
                searchBox.Position = UDim2.new(0, 12, 0, 46)
                searchBox.BackgroundColor3 = M3.CurrentTheme.SurfaceContainerHighest
                searchBox.TextColor3 = M3.CurrentTheme.OnSurface
                searchBox.PlaceholderText = "Search..."
                searchBox.Font = M3.CurrentTheme.Font
                searchBox.TextSize = 12
                searchBox.ZIndex = 7
                searchBox.Parent = dropFrame

                local searchCorner = Instance.new("UICorner")
                searchCorner.CornerRadius = UDim.new(0, 8)
                searchCorner.Parent = searchBox

                local optionContainer = Instance.new("ScrollingFrame")
                optionContainer.Size = UDim2.new(1, -24, 0, 120)
                optionContainer.Position = UDim2.new(0, 12, 0, 84)
                optionContainer.BackgroundTransparency = 1
                optionContainer.ScrollBarThickness = 2
                optionContainer.ZIndex = 7
                optionContainer.Parent = dropFrame

                local optLayout = Instance.new("UIListLayout")
                optLayout.Padding = UDim.new(0, 4)
                optLayout.Parent = optionContainer

                local isOpen = false
                local function ToggleDrop()
                    isOpen = not isOpen
                    local targetH = isOpen and 215 or 42
                    M3:Tween(dropFrame, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
                        Size = UDim2.new(1, 0, 0, targetH)
                    })
                end

                headerBtn.MouseButton1Click:Connect(ToggleDrop)

                local function Populate(filter)
                    for _, c in ipairs(optionContainer:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    for _, opt in ipairs(options) do
                        if filter == "" or string.find(string.lower(opt), string.lower(filter)) then
                            local oBtn = Instance.new("TextButton")
                            oBtn.Size = UDim2.new(1, 0, 0, 30)
                            oBtn.BackgroundColor3 = M3.CurrentTheme.SurfaceContainer
                            oBtn.Text = opt
                            oBtn.TextColor3 = M3.CurrentTheme.OnSurface
                            oBtn.Font = M3.CurrentTheme.Font
                            oBtn.TextSize = 12
                            oBtn.ZIndex = 8
                            oBtn.Parent = optionContainer

                            local oCorner = Instance.new("UICorner")
                            oCorner.CornerRadius = UDim.new(0, 6)
                            oCorner.Parent = oBtn

                            M3:PressMorph(oCorner, UDim.new(0, 6))

                            oBtn.MouseButton1Click:Connect(function()
                                if multiSelect then
                                    if table.find(selected, opt) then
                                        table.remove(selected, table.find(selected, opt))
                                    else
                                        table.insert(selected, opt)
                                    end
                                    selLabel.Text = #selected .. " Selected"
                                    callback(selected)
                                else
                                    selected = opt
                                    selLabel.Text = opt
                                    ToggleDrop()
                                    callback(selected)
                                end
                            end)
                        end
                    end
                end

                searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                    Populate(searchBox.Text)
                end)

                Populate("")
            end

            function GroupAPI:AddColorPicker(text, defaultColor, callback)
                defaultColor = defaultColor or Color3.fromRGB(208, 188, 255)

                local colorFrame = Instance.new("Frame")
                colorFrame.Size = UDim2.new(1, 0, 0, 42)
                colorFrame.BackgroundColor3 = M3.CurrentTheme.SurfaceContainerHigh
                colorFrame.ClipsDescendants = true
                colorFrame.ZIndex = 5
                colorFrame.Parent = groupFrame

                local colorCorner = Instance.new("UICorner")
                colorCorner.CornerRadius = UDim.new(0, 12)
                colorCorner.Parent = colorFrame

                local headerBtn = Instance.new("TextButton")
                headerBtn.Size = UDim2.new(1, 0, 0, 42)
                headerBtn.BackgroundTransparency = 1
                headerBtn.Text = ""
                headerBtn.ZIndex = 6
                headerBtn.Parent = colorFrame

                M3:PressMorph(colorCorner, UDim.new(0, 12), headerBtn)

                local label = Instance.new("TextLabel")
                label.Text = text
                label.Font = M3.CurrentTheme.Font
                label.TextSize = 13
                label.TextColor3 = M3.CurrentTheme.OnSurface
                label.Position = UDim2.new(0, 12, 0, 0)
                label.Size = UDim2.new(0.6, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.ZIndex = 7
                label.Parent = headerBtn

                local colorPreview = Instance.new("Frame")
                colorPreview.Size = UDim2.new(0, 26, 0, 26)
                colorPreview.Position = UDim2.new(1, -38, 0.5, -13)
                colorPreview.BackgroundColor3 = defaultColor
                colorPreview.ZIndex = 7
                colorPreview.Parent = headerBtn

                local previewCorner = Instance.new("UICorner")
                previewCorner.CornerRadius = UDim.new(1, 0)
                previewCorner.Parent = colorPreview

                local paletteBox = Instance.new("Frame")
                paletteBox.Size = UDim2.new(1, -24, 0, 100)
                paletteBox.Position = UDim2.new(0, 12, 0, 46)
                paletteBox.BackgroundColor3 = M3.CurrentTheme.SurfaceContainerHighest
                paletteBox.ZIndex = 7
                paletteBox.Parent = colorFrame

                local palCorner = Instance.new("UICorner")
                palCorner.CornerRadius = UDim.new(0, 8)
                palCorner.Parent = paletteBox

                local isOpen = false
                headerBtn.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    M3:Tween(colorFrame, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
                        Size = UDim2.new(1, 0, 0, isOpen and 156 or 42)
                    })
                end)
            end

            return GroupAPI
        end

        return TabAPI
    end

    return WindowAPI
end

function M3:CreateSubWindow(config)
    config = config or {}
    local windowTitle = config.Title or "Sub Window"
    local size = config.Size or UDim2.new(0, 320, 0, 240)

    local subFrame = Instance.new("Frame")
    subFrame.Name = "M3_SubWindow_" .. windowTitle
    subFrame.Size = size
    subFrame.Position = UDim2.new(0.4, 0, 0.4, 0)
    subFrame.BackgroundColor3 = M3.CurrentTheme.SurfaceContainer
    subFrame.ClipsDescendants = true
    subFrame.ZIndex = 20
    subFrame.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = M3.CurrentTheme.CornerRadius
    corner.Parent = subFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = M3.CurrentTheme.Outline
    stroke.Thickness = 1
    stroke.Parent = subFrame

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 36)
    topBar.BackgroundColor3 = M3.CurrentTheme.SurfaceContainerHigh
    topBar.ZIndex = 21
    topBar.Parent = subFrame

    local title = Instance.new("TextLabel")
    title.Text = windowTitle
    title.Font = M3.CurrentTheme.FontBold
    title.TextSize = 13
    title.TextColor3 = M3.CurrentTheme.OnSurface
    title.Position = UDim2.new(0, 12, 0, 0)
    title.Size = UDim2.new(1, -50, 1, 0)
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 22
    title.Parent = topBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 24, 0, 24)
    closeBtn.Position = UDim2.new(1, -28, 0.5, -12)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"
    closeBtn.TextColor3 = M3.CurrentTheme.Error
    closeBtn.Font = M3.CurrentTheme.FontBold
    closeBtn.TextSize = 12
    closeBtn.ZIndex = 22
    closeBtn.Parent = topBar

    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, -16, 1, -48)
    body.Position = UDim2.new(0, 8, 0, 40)
    body.BackgroundTransparency = 1
    body.ZIndex = 21
    body.Parent = subFrame

    local dragging, dragStart, startPos
    local topBarBeganConn = topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = subFrame.Position
        end
    end)

    local inputChangedConn = UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            if subFrame and subFrame.Parent then
                local delta = input.Position - dragStart
                subFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)

    local inputEndedConn = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    M3:TrackConnection(topBarBeganConn)
    M3:TrackConnection(inputChangedConn)
    M3:TrackConnection(inputEndedConn)

    local closeClickConn = closeBtn.MouseButton1Click:Connect(function()
        if subFrame and subFrame.Parent then
            subFrame:Destroy()
        end
        M3:Untrack(topBarBeganConn)
        M3:Untrack(inputChangedConn)
        M3:Untrack(inputEndedConn)
        M3:Untrack(closeClickConn)
    end)
    M3:TrackConnection(closeClickConn)

    table.insert(M3.ActiveSubWindows, subFrame)
    return {
        Frame = subFrame,
        Body = body,
        Destroy = function()
            if subFrame and subFrame.Parent then
                subFrame:Destroy()
            end
            M3:Untrack(topBarBeganConn)
            M3:Untrack(inputChangedConn)
            M3:Untrack(inputEndedConn)
            M3:Untrack(closeClickConn)
        end
    }
end

local hideKeyConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == M3.HideKey then
        M3.IsHidden = not M3.IsHidden
        if ScreenGui then
            ScreenGui.Enabled = not M3.IsHidden
        end
    end
end)
M3:TrackConnection(hideKeyConn)

-- Alias: Cleanup all resources (connections, threads, instances, springs, UI)
function M3:Destroy()
    M3:Cleanup()
end

-- Auto-cleanup if the top-level ScreenGui is destroyed externally
local cleanupDone = false
local ancestryConn = ScreenGui.AncestryChanged:Connect(function(_, parent)
    if parent == nil and not cleanupDone then
        M3:Cleanup()
    end
end)
M3:TrackConnection(ancestryConn)

-- Prevents double-cleanup when M3:Cleanup destroys the ScreenGui
function M3:Cleanup()
    if cleanupDone then return end
    cleanupDone = true
    for i = #M3.Connections, 1, -1 do
        local c = M3.Connections[i]
        if c and c.Disconnect then
            pcall(function() c:Disconnect() end)
        end
    end
    for i = #M3.CleanupTasks, 1, -1 do
        local task = M3.CleanupTasks[i]
        if task then
            pcall(function()
                if task.Type == "Connection" then
                    if task.Value and task.Value.Disconnect then
                        task.Value:Disconnect()
                    end
                elseif task.Type == "Instance" then
                    if task.Value and task.Value.Parent then
                        task.Value:Destroy()
                    end
                end
            end)
        end
    end
    M3.CleanupTasks = {}
    M3.Connections = {}
    M3.Springs = {}
    M3.ActiveWindows = {}
    M3.ActiveSubWindows = {}
    M3.FloatingWindows = {}
    M3.ActiveNotifs = {}
    M3.IsHidden = false
    if ScreenGui then
        ScreenGui:Destroy()
    end
    cleanupDone = true
end

return M3
