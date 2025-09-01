--[[
    GUI Library Loader
    Easy to use loader for executors
    
    Usage:
    loadstring(game:HttpGet("YOUR_URL_HERE"))()
--]]

-- Check if gethui is available (executor environment)
local function getGuiParent()
    local success, result = pcall(function()
        return gethui()
    end)
    
    if success and result then
        return result
    else
        warn("[GUI Library] gethui() not available, using PlayerGui")
        return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end
end

-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Load components (you would replace these URLs with your actual file URLs)
local components = {
    Window = loadstring(game:HttpGet("WINDOW_URL"))(),
    Button = loadstring(game:HttpGet("BUTTON_URL"))(),
    Toggle = loadstring(game:HttpGet("TOGGLE_URL"))(),
    Slider = loadstring(game:HttpGet("SLIDER_URL"))(),
    Textbox = loadstring(game:HttpGet("TEXTBOX_URL"))(),
    Dropdown = loadstring(game:HttpGet("DROPDOWN_URL"))(),
    Label = loadstring(game:HttpGet("LABEL_URL"))(),
    Themes = loadstring(game:HttpGet("THEMES_URL"))(),
    Utils = loadstring(game:HttpGet("UTILS_URL"))(),
    Icons = loadstring(game:HttpGet("ICONS_URL"))()
}

-- Create library object
local Library = {}
Library.__index = Library

-- Library configuration
Library.Config = {
    Name = "Custom GUI Library",
    Version = "1.0.0",
    SaveConfig = true,
    ConfigFolder = "CustomGUI"
}

-- Initialize the library
function Library:Init()
    self.GuiParent = getGuiParent()
    self.Windows = {}
    self.Themes = components.Themes
    self.Utils = components.Utils
    self.Icons = components.Icons
    
    -- Store component references
    self.Components = {
        Button = components.Button,
        Toggle = components.Toggle,
        Slider = components.Slider,
        Textbox = components.Textbox,
        Dropdown = components.Dropdown,
        Label = components.Label
    }
    
    print("[Custom GUI] Library loaded successfully!")
    return self
end

-- Create a new window
function Library:CreateWindow(options)
    options = options or {}
    
    local window = components.Window.new({
        Name = options.Name or "Custom Window",
        Size = options.Size or UDim2.new(0, 500, 0, 350),
        Theme = options.Theme or "Dark",
        Author = options.Author or "Custom GUI Library",
        Icon = options.Icon or nil,
        Parent = self.GuiParent
    })
    
    table.insert(self.Windows, window)
    return window
end

-- Get theme colors
function Library:GetTheme(themeName)
    return self.Themes:GetTheme(themeName or "Dark")
end

-- Set theme
function Library:SetTheme(themeName)
    return self.Themes:SetTheme(themeName)
end

-- Create notification
function Library:Notify(message, duration, notificationType)
    return self.Utils.CreateNotification(message, duration, notificationType)
end

-- Destroy all windows
function Library:Destroy()
    for _, window in pairs(self.Windows) do
        if window.Destroy then
            window:Destroy()
        end
    end
    self.Windows = {}
end

-- Auto-initialize and return
return Library:Init()
