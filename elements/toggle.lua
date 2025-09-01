--[[
    Toggle Component
    Creates toggle switches with smooth animations
--]]

local Toggle = {}

-- Services
local TweenService = game:GetService("TweenService")

-- Create a new toggle
function Toggle:Create(parent, options)
    options = options or {}
    
    local toggle = {
        Name = options.Name or "Toggle",
        Text = options.Text or "Toggle",
        Size = options.Size or UDim2.new(0, 200, 0, 35),
        Position = options.Position or UDim2.new(0, 0, 0, 0),
        Default = options.Default or false,
        TextColor = options.TextColor or Color3.fromRGB(255, 255, 255),
        Callback = options.Callback or function() end
    }
    
    toggle.Value = toggle.Default
    
    -- Main frame
    toggle.Frame = Instance.new("Frame")
    toggle.Frame.Name = toggle.Name
    toggle.Frame.Size = toggle.Size
    toggle.Frame.Position = toggle.Position
    toggle.Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    toggle.Frame.BorderSizePixel = 0
    toggle.Frame.Parent = parent
    
    -- Corner rounding
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 6)
    frameCorner.Parent = toggle.Frame
    
    -- Label
    toggle.Label = Instance.new("TextLabel")
    toggle.Label.Size = UDim2.new(1, -50, 1, 0)
    toggle.Label.Position = UDim2.new(0, 10, 0, 0)
    toggle.Label.BackgroundTransparency = 1
    toggle.Label.Text = toggle.Text
    toggle.Label.TextColor3 = toggle.TextColor
    toggle.Label.TextSize = 14
    toggle.Label.Font = Enum.Font.Gotham
    toggle.Label.TextXAlignment = Enum.TextXAlignment.Left
    toggle.Label.Parent = toggle.Frame
    
    -- Toggle switch container
    toggle.Switch = Instance.new("Frame")
    toggle.Switch.Size = UDim2.new(0, 35, 0, 20)
    toggle.Switch.Position = UDim2.new(1, -40, 0.5, -10)
    toggle.Switch.BackgroundColor3 = toggle.Value and Color3.fromRGB(40, 167, 69) or Color3.fromRGB(108, 117, 125)
    toggle.Switch.BorderSizePixel = 0
    toggle.Switch.Parent = toggle.Frame
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0.5, 0)
    switchCorner.Parent = toggle.Switch
    
    -- Toggle circle/handle
    toggle.Circle = Instance.new("Frame")
    toggle.Circle.Size = UDim2.new(0, 16, 0, 16)
    toggle.Circle.Position = toggle.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    toggle.Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggle.Circle.BorderSizePixel = 0
    toggle.Circle.Parent = toggle.Switch
    
    local circleCorner = Instance.new("UICorner")
    circleCorner.CornerRadius = UDim.new(0.5, 0)
    circleCorner.Parent = toggle.Circle
    
    -- Click detector
    local clickDetector = Instance.new("TextButton")
    clickDetector.Size = UDim2.new(1, 0, 1, 0)
    clickDetector.BackgroundTransparency = 1
    clickDetector.Text = ""
    clickDetector.Parent = toggle.Frame
    
    -- Toggle functionality
    local function toggleState()
        toggle.Value = not toggle.Value
        
        -- Animate switch background
        local switchColor = toggle.Value and Color3.fromRGB(40, 167, 69) or Color3.fromRGB(108, 117, 125)
        local switchTween = TweenService:Create(toggle.Switch, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            BackgroundColor3 = switchColor
        })
        switchTween:Play()
        
        -- Animate circle position
        local circlePos = toggle.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local circleTween = TweenService:Create(toggle.Circle, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = circlePos
        })
        circleTween:Play()
        
        -- Call callback
        toggle.Callback(toggle.Value)
    end
    
    -- Click event
    clickDetector.MouseButton1Click:Connect(toggleState)
    
    -- Hover effects
    clickDetector.MouseEnter:Connect(function()
        local hoverTween = TweenService:Create(toggle.Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 40):lerp(Color3.fromRGB(255, 255, 255), 0.05)
        })
        hoverTween:Play()
    end)
    
    clickDetector.MouseLeave:Connect(function()
        local hoverTween = TweenService:Create(toggle.Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        })
        hoverTween:Play()
    end)
    
    -- Methods
    function toggle:SetValue(value)
        if self.Value ~= value then
            toggleState()
        end
    end
    
    function toggle:GetValue()
        return self.Value
    end
    
    function toggle:SetText(text)
        self.Text = text
        self.Label.Text = text
    end
    
    function toggle:SetVisible(visible)
        self.Frame.Visible = visible
    end
    
    function toggle:SetEnabled(enabled)
        clickDetector.Active = enabled
        self.Frame.BackgroundTransparency = enabled and 0 or 0.5
        self.Label.TextTransparency = enabled and 0 or 0.5
        self.Switch.BackgroundTransparency = enabled and 0 or 0.5
        self.Circle.BackgroundTransparency = enabled and 0 or 0.5
    end
    
    function toggle:Destroy()
        if self.Frame then
            self.Frame:Destroy()
        end
    end
    
    return toggle
end

return Toggle
