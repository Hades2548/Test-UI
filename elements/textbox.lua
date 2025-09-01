--[[
    Textbox Component
    Creates input fields with focus effects and validation
--]]

local Textbox = {}

-- Services
local TweenService = game:GetService("TweenService")

-- Create a new textbox
function Textbox:Create(parent, options)
    options = options or {}
    
    local textbox = {
        Name = options.Name or "Textbox",
        Text = options.Text or "Textbox",
        PlaceholderText = options.PlaceholderText or "Enter text...",
        DefaultValue = options.DefaultValue or "",
        Size = options.Size or UDim2.new(0, 200, 0, 35),
        Position = options.Position or UDim2.new(0, 0, 0, 0),
        BackgroundColor = options.BackgroundColor or Color3.fromRGB(40, 40, 40),
        InputColor = options.InputColor or Color3.fromRGB(50, 50, 50),
        FocusColor = options.FocusColor or Color3.fromRGB(60, 60, 60),
        TextColor = options.TextColor or Color3.fromRGB(255, 255, 255),
        PlaceholderColor = options.PlaceholderColor or Color3.fromRGB(128, 128, 128),
        LabelColor = options.LabelColor or Color3.fromRGB(200, 200, 200),
        CornerRadius = options.CornerRadius or 6,
        TextSize = options.TextSize or 14,
        Font = options.Font or Enum.Font.Gotham,
        ClearTextOnFocus = options.ClearTextOnFocus or false,
        Callback = options.Callback or function() end
    }
    
    -- Main frame
    textbox.Frame = Instance.new("Frame")
    textbox.Frame.Name = textbox.Name
    textbox.Frame.Size = textbox.Size
    textbox.Frame.Position = textbox.Position
    textbox.Frame.BackgroundColor3 = textbox.BackgroundColor
    textbox.Frame.BorderSizePixel = 0
    textbox.Frame.Parent = parent
    
    -- Corner rounding
    if textbox.CornerRadius > 0 then
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, textbox.CornerRadius)
        frameCorner.Parent = textbox.Frame
    end
    
    -- Label
    textbox.Label = Instance.new("TextLabel")
    textbox.Label.Size = UDim2.new(1, 0, 0, 20)
    textbox.Label.Position = UDim2.new(0, 10, 0, 5)
    textbox.Label.BackgroundTransparency = 1
    textbox.Label.Text = textbox.Text
    textbox.Label.TextColor3 = textbox.LabelColor
    textbox.Label.TextSize = 12
    textbox.Label.Font = textbox.Font
    textbox.Label.TextXAlignment = Enum.TextXAlignment.Left
    textbox.Label.Parent = textbox.Frame
    
    -- Text input field
    textbox.Input = Instance.new("TextBox")
    textbox.Input.Size = UDim2.new(1, -20, 0, 25)
    textbox.Input.Position = UDim2.new(0, 10, 0, 20)
    textbox.Input.BackgroundColor3 = textbox.InputColor
    textbox.Input.BorderSizePixel = 0
    textbox.Input.Text = textbox.DefaultValue
    textbox.Input.PlaceholderText = textbox.PlaceholderText
    textbox.Input.TextColor3 = textbox.TextColor
    textbox.Input.PlaceholderColor3 = textbox.PlaceholderColor
    textbox.Input.TextSize = textbox.TextSize
    textbox.Input.Font = textbox.Font
    textbox.Input.ClearTextOnFocus = textbox.ClearTextOnFocus
    textbox.Input.TextXAlignment = Enum.TextXAlignment.Left
    textbox.Input.Parent = textbox.Frame
    
    -- Input corner rounding
    if textbox.CornerRadius > 0 then
        local inputCorner = Instance.new("UICorner")
        inputCorner.CornerRadius = UDim.new(0, textbox.CornerRadius - 2)
        inputCorner.Parent = textbox.Input
    end
    
    -- Focus indicator (thin line at bottom)
    textbox.FocusIndicator = Instance.new("Frame")
    textbox.FocusIndicator.Size = UDim2.new(0, 0, 0, 2)
    textbox.FocusIndicator.Position = UDim2.new(0, 10, 1, -7)
    textbox.FocusIndicator.BackgroundColor3 = Color3.fromRGB(40, 167, 69)
    textbox.FocusIndicator.BorderSizePixel = 0
    textbox.FocusIndicator.Parent = textbox.Frame
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(0, 1)
    indicatorCorner.Parent = textbox.FocusIndicator
    
    -- Focus effects
    textbox.Input.Focused:Connect(function()
        -- Background color change
        local bgTween = TweenService:Create(textbox.Input, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            BackgroundColor3 = textbox.FocusColor
        })
        bgTween:Play()
        
        -- Focus indicator animation
        local indicatorTween = TweenService:Create(textbox.FocusIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, -20, 0, 2)
        })
        indicatorTween:Play()
    end)
    
    textbox.Input.FocusLost:Connect(function(enterPressed)
        -- Background color reset
        local bgTween = TweenService:Create(textbox.Input, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            BackgroundColor3 = textbox.InputColor
        })
        bgTween:Play()
        
        -- Focus indicator reset
        local indicatorTween = TweenService:Create(textbox.FocusIndicator, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 0, 0, 2)
        })
        indicatorTween:Play()
        
        -- Call callback if Enter was pressed or on focus lost
        if enterPressed or not textbox.RequireEnter then
            textbox.Callback(textbox.Input.Text)
        end
    end)
    
    -- Hover effects
    textbox.Input.MouseEnter:Connect(function()
        if not textbox.Input:IsFocused() then
            local hoverTween = TweenService:Create(textbox.Input, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundColor3 = textbox.InputColor:lerp(Color3.fromRGB(255, 255, 255), 0.05)
            })
            hoverTween:Play()
        end
    end)
    
    textbox.Input.MouseLeave:Connect(function()
        if not textbox.Input:IsFocused() then
            local hoverTween = TweenService:Create(textbox.Input, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundColor3 = textbox.InputColor
            })
            hoverTween:Play()
        end
    end)
    
    -- Character limit (if specified)
    if options.CharacterLimit then
        textbox.CharacterLimit = options.CharacterLimit
        
        -- Character counter
        textbox.CharacterCounter = Instance.new("TextLabel")
        textbox.CharacterCounter.Size = UDim2.new(0, 50, 0, 15)
        textbox.CharacterCounter.Position = UDim2.new(1, -60, 0, 5)
        textbox.CharacterCounter.BackgroundTransparency = 1
        textbox.CharacterCounter.Text = "0/" .. textbox.CharacterLimit
        textbox.CharacterCounter.TextColor3 = textbox.PlaceholderColor
        textbox.CharacterCounter.TextSize = 10
        textbox.CharacterCounter.Font = textbox.Font
        textbox.CharacterCounter.TextXAlignment = Enum.TextXAlignment.Right
        textbox.CharacterCounter.Parent = textbox.Frame
        
        -- Update character counter
        textbox.Input:GetPropertyChangedSignal("Text"):Connect(function()
            local currentLength = string.len(textbox.Input.Text)
            textbox.CharacterCounter.Text = currentLength .. "/" .. textbox.CharacterLimit
            
            -- Color feedback
            if currentLength >= textbox.CharacterLimit * 0.9 then
                textbox.CharacterCounter.TextColor3 = Color3.fromRGB(220, 53, 69)
            elseif currentLength >= textbox.CharacterLimit * 0.7 then
                textbox.CharacterCounter.TextColor3 = Color3.fromRGB(255, 193, 7)
            else
                textbox.CharacterCounter.TextColor3 = textbox.PlaceholderColor
            end
            
            -- Enforce limit
            if currentLength > textbox.CharacterLimit then
                textbox.Input.Text = string.sub(textbox.Input.Text, 1, textbox.CharacterLimit)
            end
        end)
    end
    
    -- Methods
    function textbox:SetText(text)
        self.Input.Text = text
    end
    
    function textbox:GetText()
        return self.Input.Text
    end
    
    function textbox:SetPlaceholder(text)
        self.PlaceholderText = text
        self.Input.PlaceholderText = text
    end
    
    function textbox:SetLabel(text)
        self.Text = text
        self.Label.Text = text
    end
    
    function textbox:SetVisible(visible)
        self.Frame.Visible = visible
    end
    
    function textbox:SetEnabled(enabled)
        self.Input.Editable = enabled
        self.Frame.BackgroundTransparency = enabled and 0 or 0.5
        self.Label.TextTransparency = enabled and 0 or 0.5
        self.Input.BackgroundTransparency = enabled and 0 or 0.5
        self.Input.TextTransparency = enabled and 0 or 0.5
    end
    
    function textbox:Focus()
        self.Input:CaptureFocus()
    end
    
    function textbox:ClearText()
        self.Input.Text = ""
    end
    
    function textbox:Destroy()
        if self.Frame then
            self.Frame:Destroy()
        end
    end
    
    return textbox
end

return Textbox
