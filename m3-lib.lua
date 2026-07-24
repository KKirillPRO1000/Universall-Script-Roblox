local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

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
    Springs = {}
}

M3.CurrentTheme = M3.Themes.Dark

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
    elseif Syn and Syn.set_thread_identity then
        setclipboard(str)
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
    table.insert(M3.Springs, spring)
    return spring
end

RunService.RenderStepped:Connect(function(dt)
    for i = #M3.Springs, 1, -1 do
        local s = M3.Springs[i]
        s:Update(dt)
    end
end)

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

local NotificationHolder = Instance.new("Frame")
NotificationHolder.Name = "M3_NotificationHolder"
NotificationHolder.Size = UDim2.new(0, 320, 1, -30)
NotificationHolder.Position = UDim2.new(1, -330, 0, 15)
NotificationHolder.BackgroundTransparency = 1
NotificationHolder.ZIndex = 999
NotificationHolder.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Padding = UDim.new(0, 10)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifLayout.Parent = NotificationHolder

function M3:Notify(options)
    options = options or {}
    local titleText = options.Title or "Notification"
    local contentText = options.Content or ""
    local duration = options.Duration or 4.5
    local iconId = options.Icon or ""
    local buttons = options.Buttons or {}

    local card = Instance.new("Frame")
    card.Name = "NotifCard"
    card.Size = UDim2.new(1, 0, 0, 85)
    card.BackgroundColor3 = M3.CurrentTheme.SurfaceContainerHigh
    card.Position = UDim2.new(1, 350, 0, 0)
    card.ClipsDescendants = true
    card.Parent = NotificationHolder

    local corner = Instance.new("UICorner")
    corner.CornerRadius = M3.CurrentTheme.CornerRadius
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = M3.CurrentTheme.OutlineVariant
    stroke.Thickness = 1
    stroke.Parent = card

    local contentOffset = 16
    if iconId ~= "" then
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
    title.Position = UDim2.new(0, contentOffset, 0, 12)
    title.Size = UDim2.new(1, -contentOffset - 14, 0, 20)
    title.BackgroundTransparency = 1
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = card

    local body = Instance.new("TextLabel")
    body.Text = contentText
    body.Font = M3.CurrentTheme.Font
    body.TextSize = 13
    body.TextColor3 = M3.CurrentTheme.OnSurfaceVariant
    body.Position = UDim2.new(0, contentOffset, 0, 32)
    body.Size = UDim2.new(1, -contentOffset - 14, 0, 32)
    body.BackgroundTransparency = 1
    body.TextWrapped = true
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.Parent = card

    local timerBar = Instance.new("Frame")
    timerBar.Size = UDim2.new(1, 0, 0, 3)
    timerBar.Position = UDim2.new(0, 0, 1, -3)
    timerBar.BackgroundColor3 = M3.CurrentTheme.Primary
    timerBar.BorderSizePixel = 0
    timerBar.Parent = card

    if #buttons > 0 then
        card.Size = UDim2.new(1, 0, 0, 120)
        body.Size = UDim2.new(1, -contentOffset - 14, 0, 28)

        local btnContainer = Instance.new("Frame")
        btnContainer.Size = UDim2.new(1, -20, 0, 30)
        btnContainer.Position = UDim2.new(0, 10, 1, -38)
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

            actionBtn.MouseButton1Click:Connect(function()
                if btnData.Callback then
                    btnData.Callback()
                end
                M3:Tween(card, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In, {
                    Position = UDim2.new(1, 350, 0, 0)
                }).Completed:Connect(function()
                    card:Destroy()
                end)
            end)
        end
    end

    M3:Tween(card, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {
        Position = UDim2.new(0, 0, 0, 0)
    })

    M3:Tween(timerBar, duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, {
        Size = UDim2.new(0, 0, 0, 3)
    })

    task.delay(duration, function()
        if card and card.Parent then
            M3:Tween(card, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In, {
                Position = UDim2.new(1, 350, 0, 0)
            }).Completed:Connect(function()
                card:Destroy()
            end)
        end
    end)
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
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = floatFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            floatFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        floatFrame:Destroy()
    end)

    table.insert(M3.FloatingWindows, floatFrame)
    return floatFrame
end

function M3:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "Material Design 3"
    local defaultSize = (M3.Device == "Mobile") and UDim2.new(0.92, 0, 0.85, 0) or (config.Size or UDim2.new(0, 680, 0, 460))
    local windowId = config.Id or windowTitle

    if M3.ActiveWindows[windowId] then
        M3.ActiveWindows[windowId]:Destroy()
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
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local resizing, resizeStart, startSize
    resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = input.Position
            startSize = mainFrame.AbsoluteSize
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - resizeStart
            local newX = math.max(340, startSize.X + delta.X)
            local newY = math.max(260, startSize.Y + delta.Y)
            mainFrame.Size = UDim2.new(0, newX, 0, newY)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)

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

    function WindowAPI:Destroy()
        mainFrame:Destroy()
        M3.ActiveWindows[windowId] = nil
    end

    closeBtn.MouseButton1Click:Connect(function()
        WindowAPI:Destroy()
    end)

    function WindowAPI:CreateTab(tabName, iconId)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = (M3.Device == "Mobile") and UDim2.new(0, 100, 1, 0) or UDim2.new(1, 0, 0, 36)
        tabBtn.BackgroundColor3 = M3.CurrentTheme.SurfaceContainer
        tabBtn.Text = tabName
        tabBtn.TextColor3 = M3.CurrentTheme.OnSurfaceVariant
        tabBtn.Font = M3.CurrentTheme.FontBold
        tabBtn.TextSize = 13
        tabBtn.ZIndex = 4
        tabBtn.Parent = tabListContainer

        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 18)
        tabCorner.Parent = tabBtn

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
            Container = tabContent
        }

        local function SelectTab()
            for _, t in pairs(WindowAPI.Tabs) do
                t.Container.Visible = false
                M3:Tween(t.Button, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
                    BackgroundColor3 = M3.CurrentTheme.SurfaceContainer,
                    TextColor3 = M3.CurrentTheme.OnSurfaceVariant
                })
            end
            tabContent.Visible = true
            WindowAPI.CurrentTab = TabAPI
            M3:Tween(tabBtn, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, {
                BackgroundColor3 = M3.CurrentTheme.PrimaryContainer,
                TextColor3 = M3.CurrentTheme.OnPrimaryContainer
            })
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

                elementBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        holding = true
                        holdTime = tick()
                        task.delay(0.8, function()
                            if holding and (tick() - holdTime >= 0.75) then
                                holding = false
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
                            local bindConn
                            bindConn = UserInputService.InputBegan:Connect(function(execInp, execGpe)
                                if not execGpe and (execInp.KeyCode == boundKey or execInp.UserInputType == boundKey) then
                                    primaryCallback()
                                end
                            end)
                            table.insert(M3.Connections, bindConn)
                        end
                    end)
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
                btnCorner.CornerRadius = UDim.new(0, 19)
                btnCorner.Parent = btn

                btn.MouseButton1Click:Connect(function()
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
                    c.CornerRadius = UDim.new(0, 19)
                    c.Parent = fBtn
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
                    fTrack.MouseButton1Click:Connect(function()
                        SetState(not state)
                        fTrack.Text = text .. ": " .. (state and "ON" or "OFF")
                    end)
                end)
            end

            function GroupAPI:AddSlider(text, minVal, maxVal, defaultVal, precise, callback)
                minVal = minVal or 0
                maxVal = maxVal or 100
                defaultVal = math.clamp(defaultVal or minVal, minVal, maxVal)

                local sliderFrame = Instance.new("Frame")
                sliderFrame.Size = UDim2.new(1, 0, 0, 50)
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
                valLabel.Text = tostring(defaultVal)
                valLabel.Font = M3.CurrentTheme.FontBold
                valLabel.TextSize = 13
                valLabel.TextColor3 = M3.CurrentTheme.Primary
                valLabel.Position = UDim2.new(0.6, 0, 0, 6)
                valLabel.Size = UDim2.new(0.4, -12, 0, 18)
                valLabel.BackgroundTransparency = 1
                valLabel.TextXAlignment = Enum.TextXAlignment.Right
                valLabel.ZIndex = 6
                valLabel.Parent = sliderFrame

                local track = Instance.new("TextButton")
                track.Name = "Track"
                track.Size = UDim2.new(1, -24, 0, 8)
                track.Position = UDim2.new(0, 12, 0, 32)
                track.BackgroundColor3 = M3.CurrentTheme.SurfaceContainerHighest
                track.Text = ""
                track.ZIndex = 6
                track.Parent = sliderFrame

                local trackCorner = Instance.new("UICorner")
                trackCorner.CornerRadius = UDim.new(1, 0)
                trackCorner.Parent = track

                local fill = Instance.new("Frame")
                fill.Size = UDim2.new((defaultVal - minVal)/(maxVal - minVal), 0, 1, 0)
                fill.BackgroundColor3 = M3.CurrentTheme.Primary
                fill.BorderSizePixel = 0
                fill.ZIndex = 7
                fill.Parent = track

                local fillCorner = Instance.new("UICorner")
                fillCorner.CornerRadius = UDim.new(1, 0)
                fillCorner.Parent = fill

                local draggingSlider = false
                local function UpdateSlider(input)
                    local pct = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
                    local val = minVal + (maxVal - minVal) * pct
                    if not precise then
                        val = math.floor(val + 0.5)
                    else
                        val = math.floor(val * 100 + 0.5) / 100
                    end
                    fill.Size = UDim2.new((val - minVal)/(maxVal - minVal), 0, 1, 0)
                    valLabel.Text = tostring(val)
                    callback(val)
                end

                track.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        draggingSlider = true
                        UpdateSlider(input)
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        UpdateSlider(input)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        draggingSlider = false
                    end
                end)
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
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = subFrame.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            subFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        subFrame:Destroy()
    end)

    table.insert(M3.ActiveSubWindows, subFrame)
    return {
        Frame = subFrame,
        Body = body,
        Destroy = function() subFrame:Destroy() end
    }
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == M3.HideKey then
        M3.IsHidden = not M3.IsHidden
        ScreenGui.Enabled = not M3.IsHidden
    end
end)

return M3