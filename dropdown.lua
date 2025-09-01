--[[
    Dropdown Component
    Creates expandable dropdown menus with option selection
--]]

local Dropdown = {}

-- Services
local TweenService = game:GetService("TweenService")

-- Create a new dropdown
function Dropdown:Create(parent, options)
    options = options or {}
    
    local dropdown = {
        Name = options.Name or "Dropdown",
        Text = options.Text or "Dropdown",
        Options = options.Options or {"Option 1", "Option 2", "Option 3"},
        Default = options.Default,
        Size = options.Size or UDim2.new(0, 200, 0, 35),
        Position = options.Position or UDim2.new(0, 0, 0, 0),
        BackgroundColor = options.BackgroundColor or Color3.fromRGB(40, 40, 40),
        OptionColor = options.OptionColor or Color3.fromRGB(50, 50, 50),
        HoverColor = options.HoverColor or Color3.fromRGB(60, 60, 60),
        TextColor = options.TextColor or Color3.fromRGB(255, 255, 255),
        LabelColor = options.LabelColor or Color3.fromRGB(200, 200, 200),
        CornerRadius = options.CornerRadius or 6,
        MaxVisibleOptions = options.MaxVisibleOptions or 5,
        Callback = options.Callback or function() end
    }
    
    -- Set default selection
    dropdown.Selected = dropdown.Default or dropdown.Options[1] or "None"
    dropdown.Open = false
    dropdown.OptionHeight = 25
    
    -- Main frame
    dropdown.Frame = Instance.new("Frame")
    dropdown.Frame.Name = dropdown.Name
    dropdown.Frame.Size = dropdown.Size
    dropdown.Frame.Position = dropdown.Position
    dropdown.Frame.BackgroundColor3 = dropdown.BackgroundColor
    dropdown.Frame.BorderSizePixel = 0
    dropdown.Frame.Parent = parent
    
    -- Corner rounding
    if dropdown.CornerRadius > 0 then
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, dropdown.CornerRadius)
        frameCorner.Parent = dropdown.Frame
    end
    
    -- Label
    dropdown.Label = Instance.new("TextLabel")
    dropdown.Label.Size = UDim2.new(1, 0, 0, 15)
    dropdown.Label.Position = UDim2.new(0, 10, 0, 2)
    dropdown.Label.BackgroundTransparency = 1
    dropdown.Label.Text = dropdown.Text
    dropdown.Label.TextColor3 = dropdown.LabelColor
    dropdown.Label.TextSize = 12
    dropdown.Label.Font = Enum.Font.Gotham
    dropdown.Label.TextXAlignment = Enum.TextXAlignment.Left
    dropdown.Label.Parent = dropdown.Frame
    
    -- Selected option display
    dropdown.SelectedDisplay = Instance.new("TextLabel")
    dropdown.SelectedDisplay.Size = UDim2.new(1, -30, 0, 18)
    dropdown.SelectedDisplay.Position = UDim2.new(0, 10, 0, 15)
    dropdown.SelectedDisplay.BackgroundTransparency = 1
    dropdown.SelectedDisplay.Text = dropdown.Selected
    dropdown.SelectedDisplay.TextColor3 = dropdown.TextColor
    dropdown.SelectedDisplay.TextSize = 14
    dropdown.SelectedDisplay.Font = Enum.Font.Gotham
    dropdown.SelectedDisplay.TextXAlignment = Enum.TextXAlignment.Left
    dropdown.SelectedDisplay.TextTruncate = Enum.TextTruncate.AtEnd
    dropdown.SelectedDisplay.Parent = dropdown.Frame
    
    -- Dropdown arrow
    dropdown.Arrow = Instance.new("TextLabel")
    dropdown.Arrow.Size = UDim2.new(0, 20, 0, 18)
    dropdown.Arrow.Position = UDim2.new(1, -25, 0, 15)
    dropdown.Arrow.BackgroundTransparency = 1
    dropdown.Arrow.Text = "▼"
    dropdown.Arrow.TextColor3 = dropdown.LabelColor
    dropdown.Arrow.TextSize = 12
    dropdown.Arrow.Font = Enum.Font.Gotham
    dropdown.Arrow.TextXAlignment = Enum.TextXAlignment.Center
    dropdown.Arrow.Parent = dropdown.Frame
    
    -- Options container
    local maxHeight = math.min(#dropdown.Options, dropdown.MaxVisibleOptions) * dropdown.OptionHeight
    dropdown.OptionsFrame = Instance.new("Frame")
    dropdown.OptionsFrame.Size = UDim2.new(1, 0, 0, maxHeight)
    dropdown.OptionsFrame.Position = UDim2.new(0, 0, 1, 2)
    dropdown.OptionsFrame.BackgroundColor3 = dropdown.OptionColor
    dropdown.OptionsFrame.BorderSizePixel = 0
    dropdown.OptionsFrame.Visible = false
    dropdown.OptionsFrame.ZIndex = 10
    dropdown.OptionsFrame.ClipsDescendants = true
    dropdown.OptionsFrame.Parent = dropdown.Frame
    
    -- Options frame corner
    if dropdown.CornerRadius > 0 then
        local optionsCorner = Instance.new("UICorner")
        optionsCorner.CornerRadius = UDim.new(0, dropdown.CornerRadius)
        optionsCorner.Parent = dropdown.OptionsFrame
    end
    
    -- Shadow for options frame
    local optionsShadow = Instance.new("ImageLabel")
    optionsShadow.Name = "Shadow"
    optionsShadow.Size = UDim2.new(1, 6, 1, 6)
    optionsShadow.Position = UDim2.new(0, -3, 0, -3)
    optionsShadow.BackgroundTransparency = 1
    optionsShadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    optionsShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    optionsShadow.ImageTransparency = 0.8
    optionsShadow.ZIndex = 9
    optionsShadow.Parent = dropdown.OptionsFrame
    
    -- Scrolling frame for options (if needed)
    dropdown.OptionsScroll = Instance.new("ScrollingFrame")
    dropdown.OptionsScroll.Size = UDim2.new(1, 0, 1, 0)
    dropdown.OptionsScroll.Position = UDim2.new(0, 0, 0, 0)
    dropdown.OptionsScroll.BackgroundTransparency = 1
    dropdown.OptionsScroll.BorderSizePixel = 0
    dropdown.OptionsScroll.ScrollBarThickness = 4
    dropdown.OptionsScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    dropdown.OptionsScroll.CanvasSize = UDim2.new(0, 0, 0, #dropdown.Options * dropdown.OptionHeight)
    dropdown.OptionsScroll.Parent = dropdown.OptionsFrame
    
    -- Options layout
    local optionsLayout = Instance.new("UIListLayout")
    optionsLayout.FillDirection = Enum.FillDirection.Vertical
    optionsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    optionsLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    optionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    optionsLayout.Parent = dropdown.OptionsScroll
    
    -- Create option buttons
    dropdown.OptionButtons = {}
    for i, option in ipairs(dropdown.Options) do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = "Option_" .. i
        optionButton.Size = UDim2.new(1, 0, 0, dropdown.OptionHeight)
        optionButton.BackgroundColor3 = dropdown.OptionColor
        optionButton.BorderSizePixel = 0
        optionButton.Text = option
        optionButton.TextColor3 = dropdown.TextColor
        optionButton.TextSize = 14
        optionButton.Font = Enum.Font.Gotham
        optionButton.TextXAlignment = Enum.TextXAlignment.Left
        optionButton.LayoutOrder = i
        optionButton.AutoButtonColor = false
        optionButton.Parent = dropdown.OptionsScroll
        
        -- Option padding
        local optionPadding = Instance.new("UIPadding")
        optionPadding.PaddingLeft = UDim.new(0, 10)
        optionPadding.Parent = optionButton
        
        -- Hover effects
        optionButton.MouseEnter:Connect(function()
            local hoverTween = TweenService:Create(optionButton, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundColor3 = dropdown.HoverColor
            })
            hoverTween:Play()
        end)
        
        optionButton.MouseLeave:Connect(function()
            local hoverTween = TweenService:Create(optionButton, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundColor3 = dropdown.OptionColor
            })
            hoverTween:Play()
        end)
        
        -- Selection
        optionButton.MouseButton1Click:Connect(function()
            dropdown.Selected = option
            dropdown.SelectedDisplay.Text = option
            dropdown:Close()
            dropdown.Callback(option, i)
        end)
        
        table.insert(dropdown.OptionButtons, optionButton)
    end
    
    -- Toggle button (invisible overlay)
    dropdown.ToggleButton = Instance.new("TextButton")
    dropdown.ToggleButton.Size = UDim2.new(1, 0, 1, 0)
    dropdown.ToggleButton.BackgroundTransparency = 1
    dropdown.ToggleButton.Text = ""
    dropdown.ToggleButton.ZIndex = 5
    dropdown.ToggleButton.Parent = dropdown.Frame
    
    -- Open/Close functionality
    function dropdown:Open()
        if self.Open then return end
        self.Open = true
        
        -- Arrow animation
        local arrowTween = TweenService:Create(self.Arrow, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Rotation = 180
        })
        arrowTween:Play()
        
        -- Show options frame
        self.OptionsFrame.Visible = true
        self.OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
        
        -- Animate options frame
        local openTween = TweenService:Create(self.OptionsFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 0, maxHeight)
        })
        openTween:Play()
        
        -- Animate options appearing
        for i, button in ipairs(self.OptionButtons) do
            button.BackgroundTransparency = 1
            button.TextTransparency = 1
            
            local delay = i * 0.02
            wait(delay)
            
            local buttonTween = TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0,
                TextTransparency = 0
            })
            buttonTween:Play()
        end
    end
    
    function dropdown:Close()
        if not self.Open then return end
        self.Open = false
        
        -- Arrow animation
        local arrowTween = TweenService:Create(self.Arrow, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Rotation = 0
        })
        arrowTween:Play()
        
        -- Hide options frame
        local closeTween = TweenService:Create(self.OptionsFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 0, 0)
        })
        closeTween:Play()
        
        closeTween.Completed:Connect(function()
            self.OptionsFrame.Visible = false
        end)
    end
    
    -- Toggle on click
    dropdown.ToggleButton.MouseButton1Click:Connect(function()
        if dropdown.Open then
            dropdown:Close()
        else
            dropdown:Open()
        end
    end)
    
    -- Close when clicking outside (basic implementation)
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and dropdown.Open then
            local mouse = game:GetService("UserInputService"):GetMouseLocation()
            local framePos = dropdown.Frame.AbsolutePosition
            local frameSize = dropdown.Frame.AbsoluteSize
            local optionsPos = dropdown.OptionsFrame.AbsolutePosition
            local optionsSize = dropdown.OptionsFrame.AbsoluteSize
            
            -- Check if click is outside both main frame and options frame
            local outsideMain = mouse.X < framePos.X or mouse.X > framePos.X + frameSize.X or 
                              mouse.Y < framePos.Y or mouse.Y > framePos.Y + frameSize.Y
            local outsideOptions = mouse.X < optionsPos.X or mouse.X > optionsPos.X + optionsSize.X or 
                                 mouse.Y < optionsPos.Y or mouse.Y > optionsPos.Y + optionsSize.Y
            
            if outsideMain and outsideOptions then
                dropdown:Close()
            end
        end
    end)
    
    -- Methods
    function dropdown:SetOptions(options)
        -- Clear existing options
        for _, button in ipairs(self.OptionButtons) do
            button:Destroy()
        end
        self.OptionButtons = {}
        
        -- Update options list
        self.Options = options
        
        -- Recreate option buttons (simplified version)
        for i, option in ipairs(self.Options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Name = "Option_" .. i
            optionButton.Size = UDim2.new(1, 0, 0, self.OptionHeight)
            optionButton.BackgroundColor3 = self.OptionColor
            optionButton.BorderSizePixel = 0
            optionButton.Text = option
            optionButton.TextColor3 = self.TextColor
            optionButton.TextSize = 14
            optionButton.Font = Enum.Font.Gotham
            optionButton.TextXAlignment = Enum.TextXAlignment.Left
            optionButton.LayoutOrder = i
            optionButton.AutoButtonColor = false
            optionButton.Parent = self.OptionsScroll
            
            local optionPadding = Instance.new("UIPadding")
            optionPadding.PaddingLeft = UDim.new(0, 10)
            optionPadding.Parent = optionButton
            
            -- Re-add hover and click events
            optionButton.MouseEnter:Connect(function()
                local hoverTween = TweenService:Create(optionButton, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    BackgroundColor3 = self.HoverColor
                })
                hoverTween:Play()
            end)
            
            optionButton.MouseLeave:Connect(function()
                local hoverTween = TweenService:Create(optionButton, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    BackgroundColor3 = self.OptionColor
                })
                hoverTween:Play()
            end)
            
            optionButton.MouseButton1Click:Connect(function()
                self.Selected = option
                self.SelectedDisplay.Text = option
                self:Close()
                self.Callback(option, i)
            end)
            
            table.insert(self.OptionButtons, optionButton)
        end
        
        -- Update canvas size
        self.OptionsScroll.CanvasSize = UDim2.new(0, 0, 0, #self.Options * self.OptionHeight)
        
        -- Update frame size
        local newMaxHeight = math.min(#self.Options, self.MaxVisibleOptions) * self.OptionHeight
        self.OptionsFrame.Size = UDim2.new(1, 0, 0, newMaxHeight)
    end
    
    function dropdown:SetSelected(option)
        if table.find(self.Options, option) then
            self.Selected = option
            self.SelectedDisplay.Text = option
        end
    end
    
    function dropdown:GetSelected()
        return self.Selected
    end
    
    function dropdown:SetText(text)
        self.Text = text
        self.Label.Text = text
    end
    
    function dropdown:SetVisible(visible)
        self.Frame.Visible = visible
        if not visible and self.Open then
            self:Close()
        end
    end
    
    function dropdown:SetEnabled(enabled)
        self.ToggleButton.Active = enabled
        self.Frame.BackgroundTransparency = enabled and 0 or 0.5
        self.Label.TextTransparency = enabled and 0 or 0.5
        self.SelectedDisplay.TextTransparency = enabled and 0 or 0.5
        self.Arrow.TextTransparency = enabled and 0 or 0.5
        
        if not enabled and self.Open then
            self:Close()
        end
    end
    
    function dropdown:Destroy()
        if self.Frame then
            self.Frame:Destroy()
        end
    end
    
    return dropdown
end

return Dropdown