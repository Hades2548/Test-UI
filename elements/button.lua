--[[
    Button Component
    Creates interactive button elements with hover effects and callbacks
--]]

local Button = {}

-- Services
local TweenService = game:GetService("TweenService")

-- Create a new button
function Button:Create(parent, options)
    options = options or {}
    
    local button = {
        Name = options.Name or "Button",
        Text = options.Text or "Button",
        Size = options.Size or UDim2.new(0, 200, 0, 35),
        Position = options.Position or UDim2.new(0, 0, 0, 0),
        TextColor = options.TextColor or Color3.fromRGB(255, 255, 255),
        Callback = options.Callback or function() end
    }
    
    -- Main button frame
    button.Frame = Instance.new("TextButton")
    button.Frame.Name = button.Name
    button.Frame.Size = button.Size
    button.Frame.Position = button.Position
    button.Frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.Frame.BorderSizePixel = 0
    button.Frame.Text = button.Text
    button.Frame.TextColor3 = button.TextColor
    button.Frame.TextSize = 14
    button.Frame.Font = Enum.Font.Gotham
    button.Frame.AutoButtonColor = false
    button.Frame.Parent = parent
    
    -- Corner rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button.Frame
    
    -- Store original color for hover effects
    button.OriginalColor = Color3.fromRGB(60, 60, 60)
    button.HoverColor = button.OriginalColor:lerp(Color3.fromRGB(255, 255, 255), 0.1)
    button.PressColor = button.OriginalColor:lerp(Color3.fromRGB(0, 0, 0), 0.1)
    
    -- Hover effects
    button.Frame.MouseEnter:Connect(function()
        local tween = TweenService:Create(button.Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            BackgroundColor3 = button.HoverColor
        })
        tween:Play()
    end)
    
    button.Frame.MouseLeave:Connect(function()
        local tween = TweenService:Create(button.Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            BackgroundColor3 = button.OriginalColor
        })
        tween:Play()
    end)
    
    -- Press effect
    button.Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local tween = TweenService:Create(button.Frame, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundColor3 = button.PressColor,
                Size = button.Size - UDim2.new(0, 2, 0, 2)
            })
            tween:Play()
        end
    end)
    
    button.Frame.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local tween = TweenService:Create(button.Frame, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundColor3 = button.HoverColor,
                Size = button.Size
            })
            tween:Play()
        end
    end)
    
    -- Click event
    button.Frame.MouseButton1Click:Connect(function()
        button.Callback()
    end)
    
    -- Methods
    function button:SetText(text)
        self.Text = text
        self.Frame.Text = text
    end
    
    function button:SetVisible(visible)
        self.Frame.Visible = visible
    end
    
    function button:SetEnabled(enabled)
        self.Frame.Active = enabled
        self.Frame.AutoButtonColor = enabled
        self.Frame.TextTransparency = enabled and 0 or 0.5
        self.Frame.BackgroundTransparency = enabled and 0 or 0.5
    end
    
    function button:Destroy()
        if self.Frame then
            self.Frame:Destroy()
        end
    end
    
    return button
end

return Button
