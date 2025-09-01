--[[
    Utility Functions
    Provides helper functions for GUI operations and common tasks
--]]

local Utils = {}

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Math utilities
function Utils.Lerp(a, b, t)
    return a + (b - a) * t
end

function Utils.Clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

function Utils.Round(number, decimals)
    local mult = 10^(decimals or 0)
    return math.floor(number * mult + 0.5) / mult
end

function Utils.Map(value, inMin, inMax, outMin, outMax)
    return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
end

-- Color utilities
function Utils.ColorToHex(color)
    local r = math.floor(color.R * 255)
    local g = math.floor(color.G * 255)
    local b = math.floor(color.B * 255)
    return string.format("#%02X%02X%02X", r, g, b)
end

function Utils.HexToColor(hex)
    hex = hex:gsub("#", "")
    if string.len(hex) ~= 6 then
        return Color3.fromRGB(255, 255, 255)
    end
    
    local r = tonumber(hex:sub(1, 2), 16) / 255
    local g = tonumber(hex:sub(3, 4), 16) / 255
    local b = tonumber(hex:sub(5, 6), 16) / 255
    
    return Color3.fromRGB(r * 255, g * 255, b * 255)
end

function Utils.BlendColors(color1, color2, alpha)
    return Color3.new(
        Utils.Lerp(color1.R, color2.R, alpha),
        Utils.Lerp(color1.G, color2.G, alpha),
        Utils.Lerp(color1.B, color2.B, alpha)
    )
end

function Utils.GetContrastColor(backgroundColor)
    local brightness = (backgroundColor.R * 299 + backgroundColor.G * 587 + backgroundColor.B * 114) / 1000
    return brightness > 0.5 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
end

-- String utilities
function Utils.SplitString(str, delimiter)
    local result = {}
    local pattern = string.format("([^%s]+)", delimiter)
    
    for match in string.gmatch(str, pattern) do
        table.insert(result, match)
    end
    
    return result
end

function Utils.TrimString(str)
    return str:match("^%s*(.-)%s*$")
end

function Utils.CapitalizeFirst(str)
    return str:sub(1, 1):upper() .. str:sub(2):lower()
end

function Utils.FormatNumber(number, decimals)
    decimals = decimals or 0
    local formatted = string.format("%." .. decimals .. "f", number)
    
    -- Add thousands separators
    local parts = Utils.SplitString(formatted, ".")
    local integerPart = parts[1]
    local decimalPart = parts[2]
    
    -- Reverse and add commas
    local reversed = string.reverse(integerPart)
    local withCommas = string.gsub(reversed, "(%d%d%d)", "%1,")
    withCommas = string.reverse(withCommas)
    
    -- Remove leading comma if present
    if withCommas:sub(1, 1) == "," then
        withCommas = withCommas:sub(2)
    end
    
    if decimalPart then
        return withCommas .. "." .. decimalPart
    else
        return withCommas
    end
end

-- Table utilities
function Utils.DeepCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            copy[key] = Utils.DeepCopy(value)
        else
            copy[key] = value
        end
    end
    return copy
end

function Utils.MergeTables(table1, table2)
    local result = Utils.DeepCopy(table1)
    for key, value in pairs(table2) do
        if type(value) == "table" and type(result[key]) == "table" then
            result[key] = Utils.MergeTables(result[key], value)
        else
            result[key] = value
        end
    end
    return result
end

function Utils.TableContains(table, value)
    for _, v in pairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

function Utils.GetTableSize(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

-- Animation utilities
function Utils.CreateTween(object, properties, duration, easingStyle, easingDirection, callback)
    duration = duration or 0.5
    easingStyle = easingStyle or Enum.EasingStyle.Quart
    easingDirection = easingDirection or Enum.EasingDirection.Out
    
    local tween = TweenService:Create(object, TweenInfo.new(duration, easingStyle, easingDirection), properties)
    
    if callback then
        tween.Completed:Connect(callback)
    end
    
    tween:Play()
    return tween
end

function Utils.FadeIn(object, duration, callback)
    local originalTransparency = object.BackgroundTransparency or 0
    object.BackgroundTransparency = 1
    
    return Utils.CreateTween(object, {BackgroundTransparency = originalTransparency}, duration, nil, nil, callback)
end

function Utils.FadeOut(object, duration, callback)
    return Utils.CreateTween(object, {BackgroundTransparency = 1}, duration, nil, nil, callback)
end

function Utils.SlideIn(object, direction, duration, callback)
    duration = duration or 0.5
    direction = direction or "Bottom"
    
    local originalPosition = object.Position
    local screenSize = object.Parent.AbsoluteSize
    
    local startPositions = {
        Top = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, 0, -screenSize.Y),
        Bottom = UDim2.new(originalPosition.X.Scale, originalPosition.X.Offset, 1, screenSize.Y),
        Left = UDim2.new(0, -screenSize.X, originalPosition.Y.Scale, originalPosition.Y.Offset),
        Right = UDim2.new(1, screenSize.X, originalPosition.Y.Scale, originalPosition.Y.Offset)
    }
    
    object.Position = startPositions[direction] or startPositions.Bottom
    
    return Utils.CreateTween(object, {Position = originalPosition}, duration, nil, nil, callback)
end

function Utils.Pulse(object, scale, duration, callback)
    scale = scale or 1.1
    duration = duration or 0.5
    
    local originalSize = object.Size
    local pulseSize = UDim2.new(originalSize.X.Scale * scale, originalSize.X.Offset, originalSize.Y.Scale * scale, originalSize.Y.Offset)
    
    local pulseTween = Utils.CreateTween(object, {Size = pulseSize}, duration / 2)
    
    pulseTween.Completed:Connect(function()
        Utils.CreateTween(object, {Size = originalSize}, duration / 2, nil, nil, callback)
    end)
    
    return pulseTween
end

-- Input utilities
function Utils.IsMouseOver(object)
    local mouse = UserInputService:GetMouseLocation()
    local objectPos = object.AbsolutePosition
    local objectSize = object.AbsoluteSize
    
    return mouse.X >= objectPos.X and mouse.X <= objectPos.X + objectSize.X and
           mouse.Y >= objectPos.Y and mouse.Y <= objectPos.Y + objectSize.Y
end

function Utils.GetMousePosition()
    return UserInputService:GetMouseLocation()
end

function Utils.IsKeyPressed(keyCode)
    return UserInputService:IsKeyDown(keyCode)
end

-- GUI utilities
function Utils.CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

function Utils.CreateStroke(parent, thickness, color, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 1
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Transparency = transparency or 0
    stroke.Parent = parent
    return stroke
end

function Utils.CreateGradient(parent, colors, direction)
    direction = direction or "Vertical"
    
    local gradient = Instance.new("UIGradient")
    
    if type(colors) == "table" and #colors >= 2 then
        local colorSequence = {}
        for i, color in ipairs(colors) do
            table.insert(colorSequence, ColorSequenceKeypoint.new((i - 1) / (#colors - 1), color))
        end
        gradient.Color = ColorSequence.new(colorSequence)
    else
        gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        }
    end
    
    if direction == "Horizontal" then
        gradient.Rotation = 90
    elseif direction == "Diagonal" then
        gradient.Rotation = 45
    end
    
    gradient.Parent = parent
    return gradient
end

function Utils.CreateShadow(parent, size, color, transparency)
    size = size or 10
    color = color or Color3.fromRGB(0, 0, 0)
    transparency = transparency or 0.5
    
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, size * 2, 1, size * 2)
    shadow.Position = UDim2.new(0, -size, 0, -size)
    shadow.BackgroundColor3 = color
    shadow.BackgroundTransparency = transparency
    shadow.BorderSizePixel = 0
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent.Parent
    
    Utils.CreateCorner(shadow, size / 2)
    
    return shadow
end

-- Notification utilities
function Utils.CreateNotification(message, duration, notificationType)
    duration = duration or 3
    notificationType = notificationType or "Info"
    
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    
    -- Create notification container if it doesn't exist
    local notificationContainer = playerGui:FindFirstChild("NotificationContainer")
    if not notificationContainer then
        notificationContainer = Instance.new("ScreenGui")
        notificationContainer.Name = "NotificationContainer"
        notificationContainer.ResetOnSpawn = false
        notificationContainer.Parent = playerGui
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.FillDirection = Enum.FillDirection.Vertical
        listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        listLayout.Padding = UDim.new(0, 5)
        listLayout.Parent = notificationContainer
    end
    
    -- Notification colors
    local colors = {
        Info = Color3.fromRGB(23, 162, 184),
        Success = Color3.fromRGB(40, 167, 69),
        Warning = Color3.fromRGB(255, 193, 7),
        Error = Color3.fromRGB(220, 53, 69)
    }
    
    -- Create notification frame
    local notification = Instance.new("Frame")
    notification.Size = UDim2.new(0, 300, 0, 60)
    notification.Position = UDim2.new(1, 320, 0, 20)
    notification.BackgroundColor3 = colors[notificationType] or colors.Info
    notification.BorderSizePixel = 0
    notification.Parent = notificationContainer
    
    Utils.CreateCorner(notification, 8)
    
    -- Message text
    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -20, 1, 0)
    messageLabel.Position = UDim2.new(0, 10, 0, 0)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Text = message
    messageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    messageLabel.TextSize = 14
    messageLabel.Font = Enum.Font.Gotham
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextWrapped = true
    messageLabel.Parent = notification
    
    -- Slide in animation
    Utils.SlideIn(notification, "Right", 0.3)
    
    -- Auto remove after duration
    game:GetService("Debris"):AddItem(notification, duration)
    
    -- Fade out before removal
    wait(duration - 0.5)
    Utils.FadeOut(notification, 0.5)
    
    return notification
end

-- Debug utilities
function Utils.PrintTable(t, indent)
    indent = indent or 0
    local spacing = string.rep("  ", indent)
    
    for key, value in pairs(t) do
        if type(value) == "table" then
            print(spacing .. tostring(key) .. ":")
            Utils.PrintTable(value, indent + 1)
        else
            print(spacing .. tostring(key) .. ": " .. tostring(value))
        end
    end
end

function Utils.Benchmark(func, iterations)
    iterations = iterations or 1000
    local startTime = tick()
    
    for i = 1, iterations do
        func()
    end
    
    local endTime = tick()
    local totalTime = endTime - startTime
    local averageTime = totalTime / iterations
    
    print(string.format("Benchmark Results:"))
    print(string.format("Total Time: %.4f seconds", totalTime))
    print(string.format("Average Time: %.6f seconds", averageTime))
    print(string.format("Iterations: %d", iterations))
    
    return {
        totalTime = totalTime,
        averageTime = averageTime,
        iterations = iterations
    }
end

-- Validation utilities
function Utils.ValidateType(value, expectedType, name)
    name = name or "value"
    if type(value) ~= expectedType then
        error(string.format("%s must be of type %s, got %s", name, expectedType, type(value)))
    end
    return true
end

function Utils.ValidateRange(value, min, max, name)
    name = name or "value"
    if value < min or value > max then
        error(string.format("%s must be between %s and %s, got %s", name, tostring(min), tostring(max), tostring(value)))
    end
    return true
end

function Utils.ValidateOptions(value, options, name)
    name = name or "value"
    if not Utils.TableContains(options, value) then
        error(string.format("%s must be one of: %s, got %s", name, table.concat(options, ", "), tostring(value)))
    end
    return true
end

return Utils
