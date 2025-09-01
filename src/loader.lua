--[[
    GUI Library Loader
    Easy to use loader for executors
    
    Usage:
    loadstring(game:HttpGet("https://raw.githubusercontent.com/YOURUSERNAME/YOURREPO/main/src/loader.lua"))()
--]]

-- GitHub configuration
local GITHUB_USER = "YOURUSERNAME"  -- Replace with your GitHub username
local GITHUB_REPO = "YOURREPO"      -- Replace with your repository name  
local GITHUB_BRANCH = "main"        -- Usually "main" or "master"

-- Base URL for raw GitHub content
local BASE_URL = string.format("https://raw.githubusercontent.com/%s/%s/%s/", GITHUB_USER, GITHUB_REPO, GITHUB_BRANCH)

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

-- Load components (GitHub URLs)
local components = {
    Window = loadstring(game:HttpGet(BASE_URL .. "src/window.lua"))(),
    Button = loadstring(game:HttpGet(BASE_URL .. "elements/button.lua"))(),
    Toggle = loadstring(game:HttpGet(BASE_URL .. "elements/toggle.lua"))(),
    Slider = loadstring(game:HttpGet(BASE_URL .. "elements/slider.lua"))(),
    Textbox = loadstring(game:HttpGet(BASE_URL .. "elements/textbox.lua"))(),
    Dropdown = loadstring(game:HttpGet(BASE_URL .. "elements/dropdown.lua"))(),
    Label = loadstring(game:HttpGet(BASE_URL .. "elements/label.lua"))(),
    Themes = loadstring(game:HttpGet(BASE_URL .. "themes/init.lua"))(),
    Utils = loadstring(game:HttpGet(BASE_URL .. "utils/init.lua"))(),
    Icons = loadstring(game:HttpGet(BASE_URL .. "src/icons.lua"))()
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
