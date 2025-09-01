--[[
    Roblox GUI Library
    Main initialization file 
    Uses gethui() for secure GUI creation
--]]

local Library = {}
Library.__index = Library


-- Services
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Local modules
local Window = require(script.window)
local Themes = require(script.Parent.themes)
local Utils = require(script.Parent.utils)
local Icons = require(script.icons)

-- Component modules
local Button = require(script.Parent.elements.button)
local Toggle = require(script.Parent.elements.toggle)
local Slider = require(script.Parent.elements.slider)
local Textbox = require(script.Parent.elements.textbox)
local Dropdown = require(script.Parent.elements.dropdown)
local Label = require(script.Parent.elements.label)


Library.Config = {
    Name = "Custom GUI Library",
    Version = "1.0.0",
    SaveConfig = true,
    ConfigFolder = "CustomGUI"
}


-- Initialize the library
function Library:Init()
    -- Get the secure GUI parent using gethui()
    local success, gui_parent = pcall(function()
        return gethui()
    end)
    
    if not success then
        warn("gethui() not available, falling back to PlayerGui")
        gui_parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end
    
    self.GuiParent = gui_parent
    self.Windows = {}
    self.Themes = Themes
    self.Utils = Utils
    self.Icons = Icons
    
    -- Store component references
    self.Components = {
        Button = Button,
        Toggle = Toggle,
        Slider = Slider,
        Textbox = Textbox,
        Dropdown = Dropdown,
        Label = Label
    }
    
    print("[Custom GUI] Library initialized successfully")
    return self
end


function Library:CreateWindow(options)
    options = options or {}
    
    local window = Window.new({
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


function Library:GetTheme(themeName)
    return self.Themes:GetTheme(themeName or "Dark")
end


function Library:Destroy()
    for _, window in pairs(self.Windows) do
        if window.Destroy then
            window:Destroy()
        end
    end
    self.Windows = {}
end


return Library:Init()