--[[
    Theme System
    Loads individual theme files and provides theme management
--]]

local Themes = {}

-- Load individual theme files
local DarkTheme = require(script.dark)
local LightTheme = require(script.light)
local BlueTheme = require(script.blue)
local RedTheme = require(script.red)

-- Available themes
Themes.Available = {
    "Dark",
    "Light", 
    "Blue",
    "Red"
}

-- Default theme
Themes.Current = "Dark"

-- Theme definitions
Themes.Colors = {
    Dark = DarkTheme,
    Light = LightTheme,
    Blue = BlueTheme,
    Red = RedTheme
}

-- Get theme colors
function Themes:GetTheme(themeName)
    themeName = themeName or self.Current
    return self.Colors[themeName] or self.Colors.Dark
end

-- Set current theme
function Themes:SetTheme(themeName)
    if self.Colors[themeName] then
        self.Current = themeName
        return true
    end
    return false
end

-- Get available theme names
function Themes:GetAvailableThemes()
    return self.Available
end

-- Apply theme to a component
function Themes:ApplyToComponent(component, themeName)
    local theme = self:GetTheme(themeName)
    
    if component.Frame then
        -- Apply basic styling
        if component.Frame.BackgroundColor3 then
            component.Frame.BackgroundColor3 = theme.Primary
        end
        
        -- Apply text color if it's a text element
        if component.Frame.TextColor3 then
            component.Frame.TextColor3 = theme.TextPrimary
        end
        
        -- Apply button styling
        if component.Frame.ClassName == "TextButton" then
            component.Frame.BackgroundColor3 = theme.Button
        end
    end
end

-- Create theme picker function
function Themes:CreateThemePicker(parent, callback)
    local Dropdown = require(script.Parent.elements.dropdown)
    
    local themePicker = Dropdown:Create(parent, {
        Name = "ThemePicker",
        Text = "Theme",
        Options = self.Available,
        Default = self.Current,
        Size = UDim2.new(0, 200, 0, 35),
        Callback = function(selectedTheme)
            self:SetTheme(selectedTheme)
            if callback then
                callback(selectedTheme)
            end
        end
    })
    
    return themePicker
end

return Themes