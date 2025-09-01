--[[
    Window Management System
    Handles window creation, dragging, resizing, and management
    Integrated with gethui() for secure execution
--]]

local Window = {}
Window.__index = Window

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Load icons
local Icons = require(script.Parent.icons)

-- Window class
function Window.new(options)
    local self = setmetatable({}, Window)
    
    -- Configuration
    self.Name = options.Name or "Window"
    self.Size = options.Size or UDim2.new(0, 500, 0, 350)
    self.Theme = options.Theme or "Dark"
    self.Parent = options.Parent
    self.Author = options.Author or "Custom GUI Library"
    self.Icon = options.Icon or nil -- Window icon
    
    -- State
    self.Visible = true
    self.Dragging = false
    self.Resizing = false
    self.Minimized = false
    self.TransparentMode = false
    self.CurrentThemeIndex = 1
    
    -- Available themes
    self.AvailableThemes = {"Dark", "Light", "Blue", "Red"}
    
    -- Components
    self.Tabs = {}
    self.Elements = {}
    
    self:CreateWindow()
    self:SetupEvents()
    
    return self
end

-- Create the main window GUI
function Window:CreateWindow()
    -- Main ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = self.Name .. "_GUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    self.ScreenGui.Parent = self.Parent
    
    -- Main Frame
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = self.Size
    self.MainFrame.Position = UDim2.new(0.5, -self.Size.X.Offset/2, 0.5, -self.Size.Y.Offset/2)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.ClipsDescendants = true
    self.MainFrame.Parent = self.ScreenGui
    
    -- Corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = self.MainFrame
    
    -- Drop shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ZIndex = -1
    shadow.Parent = self.MainFrame
    
    -- Title Bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 35)
    self.TitleBar.Position = UDim2.new(0, 0, 0, 0)
    self.TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = self.TitleBar
    
    -- Title corner fix
    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 8)
    titleFix.Position = UDim2.new(0, 0, 1, -8)
    titleFix.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    titleFix.BorderSizePixel = 0
    titleFix.Parent = self.TitleBar
    
    -- Title Text
    self.TitleLabel = Instance.new("TextLabel")
    self.TitleLabel.Name = "Title"
    self.TitleLabel.Size = UDim2.new(1, -110, 1, 0)
    self.TitleLabel.Position = UDim2.new(0, self.Icon and 35 or 10, 0, 0)
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.Text = self.Name .. " - " .. self.Author
    self.TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.TitleLabel.TextScaled = false
    self.TitleLabel.TextSize = 14
    self.TitleLabel.Font = Enum.Font.GothamMedium
    self.TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.TitleLabel.Parent = self.TitleBar
    
    -- Window Icon (if provided)
    if self.Icon then
        self.IconLabel = Instance.new("ImageLabel")
        self.IconLabel.Name = "WindowIcon"
        self.IconLabel.Size = UDim2.new(0, 25, 0, 25)
        self.IconLabel.Position = UDim2.new(0, 5, 0, 5)
        self.IconLabel.BackgroundTransparency = 1
        self.IconLabel.Image = Icons:Get(self.Icon)
        self.IconLabel.ImageColor3 = Color3.fromRGB(255, 255, 255)
        self.IconLabel.Parent = self.TitleBar
    end
    
    -- Theme Switch Button
    self.ThemeButton = Instance.new("TextButton")
    self.ThemeButton.Name = "ThemeSwitch"
    self.ThemeButton.Size = UDim2.new(0, 25, 0, 25)
    self.ThemeButton.Position = UDim2.new(1, -90, 0, 5)
    self.ThemeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    self.ThemeButton.BorderSizePixel = 0
    self.ThemeButton.Text = ""
    
    -- Theme button icon
    local themeIcon = Instance.new("ImageLabel")
    themeIcon.Size = UDim2.new(0, 16, 0, 16)
    themeIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
    themeIcon.BackgroundTransparency = 1
    themeIcon.Image = Icons:Get("Theme")
    themeIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    themeIcon.Parent = self.ThemeButton
    self.ThemeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.ThemeButton.TextSize = 14
    self.ThemeButton.Font = Enum.Font.Gotham
    self.ThemeButton.Parent = self.TitleBar
    
    local themeCorner = Instance.new("UICorner")
    themeCorner.CornerRadius = UDim.new(0, 4)
    themeCorner.Parent = self.ThemeButton
    
    -- Transparent Mode Button
    self.TransparentButton = Instance.new("TextButton")
    self.TransparentButton.Name = "TransparentMode"
    self.TransparentButton.Size = UDim2.new(0, 25, 0, 25)
    self.TransparentButton.Position = UDim2.new(1, -120, 0, 5)
    self.TransparentButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    self.TransparentButton.BorderSizePixel = 0
    self.TransparentButton.Text = ""
    
    -- Transparent button icon
    local transparentIcon = Instance.new("ImageLabel")
    transparentIcon.Size = UDim2.new(0, 16, 0, 16)
    transparentIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
    transparentIcon.BackgroundTransparency = 1
    transparentIcon.Image = Icons:Get("Eye")
    transparentIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    transparentIcon.Parent = self.TransparentButton
    self.TransparentButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.TransparentButton.TextSize = 14
    self.TransparentButton.Font = Enum.Font.Gotham
    self.TransparentButton.Parent = self.TitleBar
    
    local transparentCorner = Instance.new("UICorner")
    transparentCorner.CornerRadius = UDim.new(0, 4)
    transparentCorner.Parent = self.TransparentButton
    
    -- Minimize Button
    self.MinimizeButton = Instance.new("TextButton")
    self.MinimizeButton.Name = "Minimize"
    self.MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
    self.MinimizeButton.Position = UDim2.new(1, -60, 0, 5)
    self.MinimizeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    self.MinimizeButton.BorderSizePixel = 0
    self.MinimizeButton.Text = ""
    
    -- Minimize button icon
    local minimizeIcon = Instance.new("ImageLabel")
    minimizeIcon.Size = UDim2.new(0, 16, 0, 16)
    minimizeIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
    minimizeIcon.BackgroundTransparency = 1
    minimizeIcon.Image = Icons:Get("Minimize")
    minimizeIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    minimizeIcon.Parent = self.MinimizeButton
    self.MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.MinimizeButton.TextSize = 16
    self.MinimizeButton.Font = Enum.Font.GothamBold
    self.MinimizeButton.Parent = self.TitleBar
    
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 4)
    minCorner.Parent = self.MinimizeButton
    
    -- Close Button
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "Close"
    self.CloseButton.Size = UDim2.new(0, 25, 0, 25)
    self.CloseButton.Position = UDim2.new(1, -30, 0, 5)
    self.CloseButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
    self.CloseButton.BorderSizePixel = 0
    self.CloseButton.Text = ""
    
    -- Close button icon
    local closeIcon = Instance.new("ImageLabel")
    closeIcon.Size = UDim2.new(0, 16, 0, 16)
    closeIcon.Position = UDim2.new(0.5, -8, 0.5, -8)
    closeIcon.BackgroundTransparency = 1
    closeIcon.Image = Icons:Get("Close")
    closeIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    closeIcon.Parent = self.CloseButton
    self.CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.CloseButton.TextSize = 16
    self.CloseButton.Font = Enum.Font.GothamBold
    self.CloseButton.Parent = self.TitleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = self.CloseButton
    
    -- Content Frame
    self.ContentFrame = Instance.new("Frame")
    self.ContentFrame.Name = "Content"
    self.ContentFrame.Size = UDim2.new(1, 0, 1, -35)
    self.ContentFrame.Position = UDim2.new(0, 0, 0, 35)
    self.ContentFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    self.ContentFrame.BorderSizePixel = 0
    self.ContentFrame.Parent = self.MainFrame
    
    -- Tab Container
    self.TabContainer = Instance.new("Frame")
    self.TabContainer.Name = "TabContainer"
    self.TabContainer.Size = UDim2.new(1, 0, 0, 30)
    self.TabContainer.Position = UDim2.new(0, 0, 0, 0)
    self.TabContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.TabContainer.BorderSizePixel = 0
    self.TabContainer.Parent = self.ContentFrame
    
    -- Tab List Layout
    self.TabLayout = Instance.new("UIListLayout")
    self.TabLayout.FillDirection = Enum.FillDirection.Horizontal
    self.TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    self.TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    self.TabLayout.Padding = UDim.new(0, 2)
    self.TabLayout.Parent = self.TabContainer
    
    -- Main Content Area
    self.MainContent = Instance.new("Frame")
    self.MainContent.Name = "MainContent"
    self.MainContent.Size = UDim2.new(1, 0, 1, -30)
    self.MainContent.Position = UDim2.new(0, 0, 0, 30)
    self.MainContent.BackgroundTransparency = 1
    self.MainContent.BorderSizePixel = 0
    self.MainContent.Parent = self.ContentFrame
end

-- Setup event handlers
function Window:SetupEvents()
    -- Dragging
    local dragStart = nil
    local startPos = nil
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if self.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.Dragging = false
        end
    end)
    
    -- Minimize functionality
    self.MinimizeButton.MouseButton1Click:Connect(function()
        self:ToggleMinimize()
    end)
    
    -- Close functionality
    self.CloseButton.MouseButton1Click:Connect(function()
        self:Destroy()
    end)
    
    -- Theme switch functionality
    self.ThemeButton.MouseButton1Click:Connect(function()
        self:SwitchTheme()
    end)
    
    -- Transparent mode functionality
    self.TransparentButton.MouseButton1Click:Connect(function()
        self:ToggleTransparentMode()
    end)
    
    -- Button hover effects
    self:SetupButtonHover(self.MinimizeButton)
    self:SetupButtonHover(self.CloseButton)
    self:SetupButtonHover(self.ThemeButton)
    self:SetupButtonHover(self.TransparentButton)
end

-- Setup button hover effects
function Window:SetupButtonHover(button)
    local originalColor = button.BackgroundColor3
    
    button.MouseEnter:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = originalColor:lerp(Color3.fromRGB(255, 255, 255), 0.1)})
        tween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local tween = TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = originalColor})
        tween:Play()
    end)
end

-- Toggle minimize state
function Window:ToggleMinimize()
    self.Minimized = not self.Minimized
    
    local targetSize = self.Minimized and UDim2.new(self.Size.X.Scale, self.Size.X.Offset, 0, 35) or self.Size
    local tween = TweenService:Create(self.MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize})
    tween:Play()
    
    self.MinimizeButton.Text = self.Minimized and Icons:Get("Plus") or Icons:Get("Minimize")
end

-- Switch theme
function Window:SwitchTheme()
    self.CurrentThemeIndex = self.CurrentThemeIndex + 1
    if self.CurrentThemeIndex > #self.AvailableThemes then
        self.CurrentThemeIndex = 1
    end
    
    local newTheme = self.AvailableThemes[self.CurrentThemeIndex]
    self.Theme = newTheme
    
    -- Update window colors based on theme
    self:ApplyTheme(newTheme)
end

-- Apply theme colors
function Window:ApplyTheme(themeName)
    -- Load theme colors (simplified - in real implementation you'd load from theme files)
    local themeColors = {
        Dark = {
            Primary = Color3.fromRGB(25, 25, 25),
            Secondary = Color3.fromRGB(35, 35, 35),
            Content = Color3.fromRGB(20, 20, 20),
            Panel = Color3.fromRGB(30, 30, 30),
            TextPrimary = Color3.fromRGB(255, 255, 255)
        },
        Light = {
            Primary = Color3.fromRGB(248, 249, 250),
            Secondary = Color3.fromRGB(233, 236, 239),
            Content = Color3.fromRGB(255, 255, 255),
            Panel = Color3.fromRGB(248, 249, 250),
            TextPrimary = Color3.fromRGB(33, 37, 41)
        },
        Blue = {
            Primary = Color3.fromRGB(13, 27, 42),
            Secondary = Color3.fromRGB(27, 38, 59),
            Content = Color3.fromRGB(26, 32, 44),
            Panel = Color3.fromRGB(45, 55, 72),
            TextPrimary = Color3.fromRGB(255, 255, 255)
        },
        Red = {
            Primary = Color3.fromRGB(44, 13, 13),
            Secondary = Color3.fromRGB(68, 26, 26),
            Content = Color3.fromRGB(51, 15, 15),
            Panel = Color3.fromRGB(68, 26, 26),
            TextPrimary = Color3.fromRGB(255, 255, 255)
        }
    }
    
    local colors = themeColors[themeName] or themeColors.Dark
    
    -- Apply colors to window elements
    TweenService:Create(self.MainFrame, TweenInfo.new(0.3), {BackgroundColor3 = colors.Primary}):Play()
    TweenService:Create(self.TitleBar, TweenInfo.new(0.3), {BackgroundColor3 = colors.Secondary}):Play()
    TweenService:Create(self.ContentFrame, TweenInfo.new(0.3), {BackgroundColor3 = colors.Content}):Play()
    TweenService:Create(self.TabContainer, TweenInfo.new(0.3), {BackgroundColor3 = colors.Panel}):Play()
    TweenService:Create(self.TitleLabel, TweenInfo.new(0.3), {TextColor3 = colors.TextPrimary}):Play()
end

-- Toggle transparent mode
function Window:ToggleTransparentMode()
    self.TransparentMode = not self.TransparentMode
    
    local targetTransparency = self.TransparentMode and 0.3 or 0
    
    -- Animate transparency
    TweenService:Create(self.MainFrame, TweenInfo.new(0.3), {BackgroundTransparency = targetTransparency}):Play()
    TweenService:Create(self.TitleBar, TweenInfo.new(0.3), {BackgroundTransparency = targetTransparency}):Play()
    TweenService:Create(self.ContentFrame, TweenInfo.new(0.3), {BackgroundTransparency = targetTransparency}):Play()
    TweenService:Create(self.TabContainer, TweenInfo.new(0.3), {BackgroundTransparency = targetTransparency}):Play()
    
    -- Update button icon
    self.TransparentButton.Text = self.TransparentMode and Icons:Get("EyeOff") or Icons:Get("Eye")
end

-- Create a new tab
function Window:CreateTab(name)
    local tab = {
        Name = name,
        Active = false,
        Elements = {}
    }
    
    -- Tab Button
    tab.Button = Instance.new("TextButton")
    tab.Button.Name = name
    tab.Button.Size = UDim2.new(0, 100, 1, 0)
    tab.Button.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tab.Button.BorderSizePixel = 0
    tab.Button.Text = name
    tab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
    tab.Button.TextSize = 12
    tab.Button.Font = Enum.Font.Gotham
    tab.Button.Parent = self.TabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 4)
    tabCorner.Parent = tab.Button
    
    -- Tab Content
    tab.Content = Instance.new("ScrollingFrame")
    tab.Content.Name = name .. "Content"
    tab.Content.Size = UDim2.new(1, -10, 1, -10)
    tab.Content.Position = UDim2.new(0, 5, 0, 5)
    tab.Content.BackgroundTransparency = 1
    tab.Content.BorderSizePixel = 0
    tab.Content.ScrollBarThickness = 6
    tab.Content.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 60)
    tab.Content.Visible = false
    tab.Content.Parent = self.MainContent
    
    -- Layout for tab content
    tab.Layout = Instance.new("UIListLayout")
    tab.Layout.FillDirection = Enum.FillDirection.Vertical
    tab.Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tab.Layout.VerticalAlignment = Enum.VerticalAlignment.Top
    tab.Layout.Padding = UDim.new(0, 5)
    tab.Layout.Parent = tab.Content
    
    -- Auto-update canvas size when content changes
    tab.Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.Content.CanvasSize = UDim2.new(0, 0, 0, tab.Layout.AbsoluteContentSize.Y + 10)
    end)
    
    -- Tab switching
    tab.Button.MouseButton1Click:Connect(function()
        self:SwitchTab(tab)
    end)
    
    table.insert(self.Tabs, tab)
    
    -- Make first tab active
    if #self.Tabs == 1 then
        self:SwitchTab(tab)
    end
    
    return tab
end

-- Switch to a specific tab
function Window:SwitchTab(targetTab)
    for _, tab in pairs(self.Tabs) do
        tab.Active = (tab == targetTab)
        tab.Content.Visible = tab.Active
        tab.Button.BackgroundColor3 = tab.Active and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(25, 25, 25)
        tab.Button.TextColor3 = tab.Active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(200, 200, 200)
    end
end

-- Show/Hide window
function Window:SetVisible(visible)
    self.Visible = visible
    self.ScreenGui.Enabled = visible
end

-- Destroy the window
function Window:Destroy()
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

return Window