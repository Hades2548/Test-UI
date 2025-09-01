--[[
    Slider Component
    Creates draggable sliders with customizable ranges and increments
--]]

local Slider = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Create a new slider
function Slider:Create(parent, options)
    options = options or {}
    
    local slider = {
        Name = options.Name or "Slider",
        Text = options.Text or "Slider",
        Min = options.Min or 0,
        Max = options.Max or 100,
        Default = options.Default or 50,
        Increment = options.Increment or 1,
        Size = options.Size or UDim2.new(0, 200, 0, 50),
        Position = options.Position or UDim2.new(0, 0, 0, 0),
        BackgroundColor = options.BackgroundColor or Color3.fromRGB(40, 40, 40),
        TextColor = options.TextColor or Color3.fromRGB(255, 255, 255),
        TrackColor = options.TrackColor or Color3.fromRGB(60, 60, 60),
        FillColor = options.FillColor or Color3.fromRGB(40, 167, 69),
        HandleColor = options.HandleColor or Color3.fromRGB(255, 255, 255),
        CornerRadius = options.CornerRadius or 6,
        Callback = options.Callback or function() end
    }
    
    -- Clamp default value
    slider.Value = math.clamp(slider.Default, slider.Min, slider.Max)
    slider.Dragging = false
    
    -- Main frame
    slider.Frame = Instance.new("Frame")
    slider.Frame.Name = slider.Name
    slider.Frame.Size = slider.Size
    slider.Frame.Position = slider.Position
    slider.Frame.BackgroundColor3 = slider.BackgroundColor
    slider.Frame.BorderSizePixel = 0
    slider.Frame.Parent = parent
    
    -- Corner rounding
    if slider.CornerRadius > 0 then
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, slider.CornerRadius)
        frameCorner.Parent = slider.Frame
    end
    
    -- Label
    slider.Label = Instance.new("TextLabel")
    slider.Label.Size = UDim2.new(0.7, 0, 0, 20)
    slider.Label.Position = UDim2.new(0, 10, 0, 5)
    slider.Label.BackgroundTransparency = 1
    slider.Label.Text = slider.Text
    slider.Label.TextColor3 = slider.TextColor
    slider.Label.TextSize = 14
    slider.Label.Font = Enum.Font.Gotham
    slider.Label.TextXAlignment = Enum.TextXAlignment.Left
    slider.Label.Parent = slider.Frame
    
    -- Value label
    slider.ValueLabel = Instance.new("TextLabel")
    slider.ValueLabel.Size = UDim2.new(0.3, -10, 0, 20)
    slider.ValueLabel.Position = UDim2.new(0.7, 0, 0, 5)
    slider.ValueLabel.BackgroundTransparency = 1
    slider.ValueLabel.Text = tostring(slider.Value)
    slider.ValueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    slider.ValueLabel.TextSize = 12
    slider.ValueLabel.Font = Enum.Font.Gotham
    slider.ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    slider.ValueLabel.Parent = slider.Frame
    
    -- Slider track
    slider.Track = Instance.new("Frame")
    slider.Track.Size = UDim2.new(1, -20, 0, 4)
    slider.Track.Position = UDim2.new(0, 10, 0, 35)
    slider.Track.BackgroundColor3 = slider.TrackColor
    slider.Track.BorderSizePixel = 0
    slider.Track.Parent = slider.Frame
    
    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0, 2)
    trackCorner.Parent = slider.Track
    
    -- Slider fill
    local fillPercent = (slider.Value - slider.Min) / (slider.Max - slider.Min)
    slider.Fill = Instance.new("Frame")
    slider.Fill.Size = UDim2.new(fillPercent, 0, 1, 0)
    slider.Fill.Position = UDim2.new(0, 0, 0, 0)
    slider.Fill.BackgroundColor3 = slider.FillColor
    slider.Fill.BorderSizePixel = 0
    slider.Fill.Parent = slider.Track
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 2)
    fillCorner.Parent = slider.Fill
    
    -- Slider handle
    slider.Handle = Instance.new("Frame")
    slider.Handle.Size = UDim2.new(0, 12, 0, 12)
    slider.Handle.Position = UDim2.new(fillPercent, -6, 0.5, -6)
    slider.Handle.BackgroundColor3 = slider.HandleColor
    slider.Handle.BorderSizePixel = 0
    slider.Handle.Parent = slider.Track
    
    local handleCorner = Instance.new("UICorner")
    handleCorner.CornerRadius = UDim.new(0.5, 0)
    handleCorner.Parent = slider.Handle
    
    -- Handle interaction
    local handleButton = Instance.new("TextButton")
    handleButton.Size = UDim2.new(0, 20, 0, 20)
    handleButton.Position = UDim2.new(0.5, -10, 0.5, -10)
    handleButton.BackgroundTransparency = 1
    handleButton.Text = ""
    handleButton.Parent = slider.Handle
    
    -- Update slider value and visuals
    local function updateSlider(percentage)
        percentage = math.clamp(percentage, 0, 1)
        local newValue = slider.Min + percentage * (slider.Max - slider.Min)
        newValue = math.floor(newValue / slider.Increment + 0.5) * slider.Increment
        newValue = math.clamp(newValue, slider.Min, slider.Max)
        
        if newValue ~= slider.Value then
            slider.Value = newValue
            slider.ValueLabel.Text = tostring(slider.Value)
            
            -- Update visuals
            local fillPercent = (slider.Value - slider.Min) / (slider.Max - slider.Min)
            
            local fillTween = TweenService:Create(slider.Fill, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(fillPercent, 0, 1, 0)
            })
            fillTween:Play()
            
            local handleTween = TweenService:Create(slider.Handle, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(fillPercent, -6, 0.5, -6)
            })
            handleTween:Play()
            
            slider.Callback(slider.Value)
        end
    end
    
    -- Dragging functionality
    handleButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            slider.Dragging = true
            
            -- Handle hover effect
            local hoverTween = TweenService:Create(slider.Handle, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), -8, 0.5, -8)
            })
            hoverTween:Play()
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and slider.Dragging then
            slider.Dragging = false
            
            -- Reset handle size
            local resetTween = TweenService:Create(slider.Handle, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), -6, 0.5, -6)
            })
            resetTween:Play()
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if slider.Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = UserInputService:GetMouseLocation()
            local trackPos = slider.Track.AbsolutePosition.X
            local trackSize = slider.Track.AbsoluteSize.X
            
            local percentage = (mouse.X - trackPos) / trackSize
            updateSlider(percentage)
        end
    end)
    
    -- Track click functionality
    local trackButton = Instance.new("TextButton")
    trackButton.Size = UDim2.new(1, 0, 1, 10)
    trackButton.Position = UDim2.new(0, 0, 0, -5)
    trackButton.BackgroundTransparency = 1
    trackButton.Text = ""
    trackButton.Parent = slider.Track
    
    trackButton.MouseButton1Click:Connect(function()
        local mouse = UserInputService:GetMouseLocation()
        local trackPos = slider.Track.AbsolutePosition.X
        local trackSize = slider.Track.AbsoluteSize.X
        
        local percentage = (mouse.X - trackPos) / trackSize
        updateSlider(percentage)
    end)
    
    -- Methods
    function slider:SetValue(value)
        local newValue = math.clamp(value, self.Min, self.Max)
        local percentage = (newValue - self.Min) / (self.Max - self.Min)
        updateSlider(percentage)
    end
    
    function slider:GetValue()
        return self.Value
    end
    
    function slider:SetText(text)
        self.Text = text
        self.Label.Text = text
    end
    
    function slider:SetVisible(visible)
        self.Frame.Visible = visible
    end
    
    function slider:SetEnabled(enabled)
        handleButton.Active = enabled
        trackButton.Active = enabled
        self.Frame.BackgroundTransparency = enabled and 0 or 0.5
        self.Label.TextTransparency = enabled and 0 or 0.5
        self.ValueLabel.TextTransparency = enabled and 0 or 0.5
        self.Track.BackgroundTransparency = enabled and 0 or 0.5
        self.Fill.BackgroundTransparency = enabled and 0 or 0.5
        self.Handle.BackgroundTransparency = enabled and 0 or 0.5
    end
    
    function slider:Destroy()
        if self.Frame then
            self.Frame:Destroy()
        end
    end
    
    return slider
end

return Slider
