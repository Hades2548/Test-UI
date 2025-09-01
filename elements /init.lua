--[[
    Components Index
    Provides easy access to all UI components
--]]

local Components = {}

-- Import all component modules
Components.Button = require(script.button)
Components.Toggle = require(script.toggle)
Components.Slider = require(script.slider)
Components.Textbox = require(script.textbox)
Components.Dropdown = require(script.dropdown)
Components.Label = require(script.label)

-- Component creation shortcuts
function Components:CreateButton(parent, options)
    return self.Button:Create(parent, options)
end

function Components:CreateToggle(parent, options)
    return self.Toggle:Create(parent, options)
end

function Components:CreateSlider(parent, options)
    return self.Slider:Create(parent, options)
end

function Components:CreateTextbox(parent, options)
    return self.Textbox:Create(parent, options)
end

function Components:CreateDropdown(parent, options)
    return self.Dropdown:Create(parent, options)
end

function Components:CreateLabel(parent, options)
    return self.Label:Create(parent, options)
end

-- Quick label creation methods
function Components:CreateTitle(parent, text, options)
    return self.Label:CreateTitle(parent, text, options)
end

function Components:CreateSubtitle(parent, text, options)
    return self.Label:CreateSubtitle(parent, text, options)
end

function Components:CreateDescription(parent, text, options)
    return self.Label:CreateDescription(parent, text, options)
end

return Components
