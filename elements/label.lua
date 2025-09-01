--[[
    Label Component
    Creates text labels with various styling options and icon support
--]]

local Label = {}

-- Services
local TweenService = game:GetService("TweenService")

-- Load icons
local Icons = require(script.Parent.Parent.src.icons)

-- Create a new label
function Label:Create(parent, options)
    options = options or {}
    
    local label = {
        Name = options.Name or "Label",
        Text = options.Text or "Label",
        Size = options.Size or UDim2.new(0, 200, 0, 25),
        Position = options.Position or UDim2.new(0, 0, 0, 0),
        TextColor = options.TextColor or Color3.fromRGB(255, 255, 255),
        TextXAlignment = options.TextXAlignment or Enum.TextXAlignment.Left,
        TextYAlignment = options.TextYAlignment or Enum.TextYAlignment.Center,
        BackgroundTransparency = options.BackgroundTransparency or 1,
        TextWrapped = options.TextWrapped or false,
        RichText = options.RichText or false,
        Icon = options.Icon or nil, -- Icon name from Icons library
        IconSide = options.IconSide or "Left" -- "Left" or "Right"
    }
    
    -- Main label frame
    if label.BackgroundTransparency < 1 then
        -- Create frame if background is visible
        label.Frame = Instance.new("Frame")
        label.Frame.Name = label.Name .. "_Frame"
        label.Frame.Size = label.Size
        label.Frame.Position = label.Position
        label.Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        label.Frame.BackgroundTransparency = label.BackgroundTransparency
        label.Frame.BorderSizePixel = 0
        label.Frame.Parent = parent
        
        -- Corner rounding
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = label.Frame
        
        -- Create container for text and icon
        label.Container = Instance.new("Frame")
        label.Container.Size = UDim2.new(1, -10, 1, 0)
        label.Container.Position = UDim2.new(0, 5, 0, 0)
        label.Container.BackgroundTransparency = 1
        label.Container.Parent = label.Frame
    else
        -- Direct container if no background
        label.Container = Instance.new("Frame")
        label.Container.Name = label.Name .. "_Container"
        label.Container.Size = label.Size
        label.Container.Position = label.Position
        label.Container.BackgroundTransparency = 1
        label.Container.Parent = parent
        
        label.Frame = label.Container
    end
    
    -- Layout for icon and text
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = label.TextXAlignment == Enum.TextXAlignment.Center and Enum.HorizontalAlignment.Center or
                                label.TextXAlignment == Enum.TextXAlignment.Right and Enum.HorizontalAlignment.Right or
                                Enum.HorizontalAlignment.Left
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 5)
    layout.Parent = label.Container
    
    -- Icon (if provided)
    if label.Icon then
        label.IconLabel = Instance.new("ImageLabel")
        label.IconLabel.Name = "Icon"
        label.IconLabel.Size = UDim2.new(0, 20, 0, 20)
        label.IconLabel.BackgroundTransparency = 1
        label.IconLabel.Image = Icons:Get(label.Icon)
        label.IconLabel.ImageColor3 = label.TextColor
        label.IconLabel.LayoutOrder = label.IconSide == "Right" and 2 or 1
        label.IconLabel.Parent = label.Container
    end
    
    -- Text label
    label.TextLabel = Instance.new("TextLabel")
    label.TextLabel.Name = "Text"
    label.TextLabel.Size = label.Icon and UDim2.new(1, -25, 1, 0) or UDim2.new(1, 0, 1, 0)
    label.TextLabel.BackgroundTransparency = 1
    label.TextLabel.Text = label.Text
    label.TextLabel.TextColor3 = label.TextColor
    label.TextLabel.TextSize = 14
    label.TextLabel.Font = Enum.Font.Gotham
    label.TextLabel.TextXAlignment = label.TextXAlignment
    label.TextLabel.TextYAlignment = label.TextYAlignment
    label.TextLabel.TextWrapped = label.TextWrapped
    label.TextLabel.RichText = label.RichText
    label.TextLabel.LayoutOrder = label.IconSide == "Right" and 1 or 2
    label.TextLabel.Parent = label.Container
    
    -- Methods
    function label:SetText(text)
        self.Text = text
        self.TextLabel.Text = text
    end
    
    function label:GetText()
        return self.TextLabel.Text
    end
    
    function label:SetTextColor(color)
        self.TextColor = color
        self.TextLabel.TextColor3 = color
        if self.IconLabel then
            self.IconLabel.ImageColor3 = color
        end
    end
    
    function label:SetIcon(iconName)
        self.Icon = iconName
        if self.IconLabel then
            self.IconLabel.Image = Icons:Get(iconName)
        elseif iconName then
            -- Create icon if it doesn't exist
            self.IconLabel = Instance.new("ImageLabel")
            self.IconLabel.Name = "Icon"
            self.IconLabel.Size = UDim2.new(0, 20, 0, 20)
            self.IconLabel.BackgroundTransparency = 1
            self.IconLabel.Image = Icons:Get(iconName)
            self.IconLabel.ImageColor3 = self.TextColor
            self.IconLabel.LayoutOrder = self.IconSide == "Right" and 2 or 1
            self.IconLabel.Parent = self.Container
            
            -- Adjust text label size
            self.TextLabel.Size = UDim2.new(1, -25, 1, 0)
        end
    end
    
    function label:RemoveIcon()
        if self.IconLabel then
            self.IconLabel:Destroy()
            self.IconLabel = nil
            self.Icon = nil
            
            -- Adjust text label size
            self.TextLabel.Size = UDim2.new(1, 0, 1, 0)
        end
    end
    
    function label:SetIconSide(side)
        self.IconSide = side
        if self.IconLabel then
            self.IconLabel.LayoutOrder = side == "Right" and 2 or 1
            self.TextLabel.LayoutOrder = side == "Right" and 1 or 2
        end
    end
    
    function label:SetTextSize(size)
        self.TextSize = size
        self.TextLabel.TextSize = size
    end
    
    function label:SetFont(font)
        self.Font = font
        self.TextLabel.Font = font
    end
    
    function label:SetBackgroundColor(color)
        if self.Frame ~= self.TextLabel then
            self.BackgroundColor = color
            self.Frame.BackgroundColor3 = color
        end
    end
    
    function label:SetBackgroundTransparency(transparency)
        if self.Frame ~= self.TextLabel then
            self.BackgroundTransparency = transparency
            self.Frame.BackgroundTransparency = transparency
        end
    end
    
    function label:SetTextTransparency(transparency)
        self.TextLabel.TextTransparency = transparency
    end
    
    function label:SetVisible(visible)
        self.Frame.Visible = visible
    end
    
    function label:SetPosition(position)
        self.Position = position
        self.Frame.Position = position
    end
    
    function label:SetSize(size)
        self.Size = size
        self.Frame.Size = size
    end
    
    function label:SetTextAlignment(xAlignment, yAlignment)
        if xAlignment then
            self.TextXAlignment = xAlignment
            self.TextLabel.TextXAlignment = xAlignment
        end
        if yAlignment then
            self.TextYAlignment = yAlignment
            self.TextLabel.TextYAlignment = yAlignment
        end
    end
    
    function label:SetTextWrapped(wrapped)
        self.TextWrapped = wrapped
        self.TextLabel.TextWrapped = wrapped
    end
    
    function label:SetRichText(richText)
        self.RichText = richText
        self.TextLabel.RichText = richText
    end
    
    -- Animation methods
    function label:FadeIn(duration)
        duration = duration or 0.5
        self.TextLabel.TextTransparency = 1
        if self.Frame ~= self.TextLabel then
            self.Frame.BackgroundTransparency = 1
        end
        
        local textTween = TweenService:Create(self.TextLabel, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            TextTransparency = 0
        })
        textTween:Play()
        
        if self.Frame ~= self.TextLabel then
            local bgTween = TweenService:Create(self.Frame, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundTransparency = self.BackgroundTransparency
            })
            bgTween:Play()
        end
    end
    
    function label:FadeOut(duration)
        duration = duration or 0.5
        
        local textTween = TweenService:Create(self.TextLabel, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            TextTransparency = 1
        })
        textTween:Play()
        
        if self.Frame ~= self.TextLabel then
            local bgTween = TweenService:Create(self.Frame, TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundTransparency = 1
            })
            bgTween:Play()
        end
    end
    
    function label:TypeWriter(duration, callback)
        duration = duration or 2
        callback = callback or function() end
        
        local fullText = self.Text
        local textLength = string.len(fullText)
        
        self.TextLabel.Text = ""
        
        for i = 1, textLength do
            wait(duration / textLength)
            self.TextLabel.Text = string.sub(fullText, 1, i)
        end
        
        callback()
    end
    
    function label:Pulse(duration, intensity)
        duration = duration or 1
        intensity = intensity or 0.2
        
        local originalSize = self.Frame.Size
        local pulseSize = UDim2.new(
            originalSize.X.Scale + intensity,
            originalSize.X.Offset,
            originalSize.Y.Scale + intensity,
            originalSize.Y.Offset
        )
        
        local pulseTween = TweenService:Create(self.Frame, TweenInfo.new(duration/2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = pulseSize
        })
        pulseTween:Play()
        
        pulseTween.Completed:Connect(function()
            local returnTween = TweenService:Create(self.Frame, TweenInfo.new(duration/2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = originalSize
            })
            returnTween:Play()
        end)
    end
    
    function label:Shake(duration, intensity)
        duration = duration or 0.5
        intensity = intensity or 5
        
        local originalPosition = self.Frame.Position
        local shakeCount = 10
        local shakeInterval = duration / shakeCount
        
        for i = 1, shakeCount do
            local randomX = math.random(-intensity, intensity)
            local randomY = math.random(-intensity, intensity)
            local shakePosition = UDim2.new(
                originalPosition.X.Scale,
                originalPosition.X.Offset + randomX,
                originalPosition.Y.Scale,
                originalPosition.Y.Offset + randomY
            )
            
            local shakeTween = TweenService:Create(self.Frame, TweenInfo.new(shakeInterval, Enum.EasingStyle.Linear), {
                Position = shakePosition
            })
            shakeTween:Play()
            
            wait(shakeInterval)
        end
        
        -- Return to original position
        local returnTween = TweenService:Create(self.Frame, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = originalPosition
        })
        returnTween:Play()
    end
    
    function label:Destroy()
        if self.Frame then
            self.Frame:Destroy()
        end
    end
    
    return label
end

-- Static label types for quick creation
function Label:CreateTitle(parent, text, options)
    options = options or {}
    return self:Create(parent, {
        Name = options.Name or "Title",
        Text = text or "Title",
        Size = options.Size or UDim2.new(0, 200, 0, 30),
        Position = options.Position or UDim2.new(0, 0, 0, 0),
        TextColor = options.TextColor or Color3.fromRGB(255, 255, 255),
        TextSize = options.TextSize or 18,
        Font = options.Font or Enum.Font.GothamBold,
        TextXAlignment = options.TextXAlignment or Enum.TextXAlignment.Center
    })
end

function Label:CreateSubtitle(parent, text, options)
    options = options or {}
    return self:Create(parent, {
        Name = options.Name or "Subtitle",
        Text = text or "Subtitle",
        Size = options.Size or UDim2.new(0, 200, 0, 25),
        Position = options.Position or UDim2.new(0, 0, 0, 0),
        TextColor = options.TextColor or Color3.fromRGB(200, 200, 200),
        TextSize = options.TextSize or 14,
        Font = options.Font or Enum.Font.GothamMedium,
        TextXAlignment = options.TextXAlignment or Enum.TextXAlignment.Center
    })
end

function Label:CreateDescription(parent, text, options)
    options = options or {}
    return self:Create(parent, {
        Name = options.Name or "Description",
        Text = text or "Description",
        Size = options.Size or UDim2.new(0, 200, 0, 40),
        Position = options.Position or UDim2.new(0, 0, 0, 0),
        TextColor = options.TextColor or Color3.fromRGB(150, 150, 150),
        TextSize = options.TextSize or 12,
        Font = options.Font or Enum.Font.Gotham,
        TextXAlignment = options.TextXAlignment or Enum.TextXAlignment.Left,
        TextWrapped = true
    })
end

return Label
