--[[
    Icon Library
     Lucide icons
--]]

local Icons = {
    -- Window controls
    Close = "rbxassetid://10747384394", -- X icon
    Minimize = "rbxassetid://10723407389", -- Minimize icon
    Maximize = "rbxassetid://10723345496", -- Maximize icon
    Restore = "rbxassetid://10723345496", -- Restore icon
    Theme = "rbxassetid://10734886004", -- Palette icon
    Eye = "rbxassetid://10747372992", -- Eye icon
    EyeOff = "rbxassetid://10747372685", -- Eye off icon
    
    -- Navigation
    Home = "rbxassetid://10734919336", -- Home icon
    ArrowLeft = "rbxassetid://10709790948", -- Arrow left
    ArrowRight = "rbxassetid://10709791437", -- Arrow right
    ArrowUp = "rbxassetid://10709792175", -- Arrow up
    ArrowDown = "rbxassetid://10709790644", -- Arrow down
    ChevronLeft = "rbxassetid://10709781389", -- Chevron left
    ChevronRight = "rbxassetid://10709781845", -- Chevron right
    ChevronUp = "rbxassetid://10709782154", -- Chevron up
    ChevronDown = "rbxassetid://10709781125", -- Chevron down
    Menu = "rbxassetid://10734896771", -- Menu icon
    MoreHorizontal = "rbxassetid://10734898592", -- More horizontal
    MoreVertical = "rbxassetid://10734898831", -- More vertical
    
    -- Actions  
    Plus = "rbxassetid://10734884548", -- Plus icon
    Minus = "rbxassetid://10734897518", -- Minus icon
    Check = "rbxassetid://10709774989", -- Check icon
    X = "rbxassetid://10747384394", -- X icon
    Edit = "rbxassetid://10734929516", -- Edit icon
    Delete = "rbxassetid://10734884226", -- Trash icon
    Save = "rbxassetid://10734885386", -- Save icon
    Copy = "rbxassetid://10734921751", -- Copy icon
    Paste = "rbxassetid://10734922112", -- Clipboard icon
    Cut = "rbxassetid://10734925049", -- Scissors icon
    Undo = "rbxassetid://10734926969", -- Undo icon
    Redo = "rbxassetid://10734927198", -- Redo icon
    Refresh = "rbxassetid://10734884548", -- Refresh icon
    
    -- UI Elements
    Search = "rbxassetid://10734885386", -- Search icon
    Filter = "rbxassetid://10734889214", -- Filter icon
    Sort = "rbxassetid://10734886773", -- Sort icon
    Settings = "rbxassetid://10734886004", -- Settings icon
    Gear = "rbxassetid://10734886004", -- Gear icon
    Tool = "rbxassetid://10734896294", -- Tool icon
    Wrench = "rbxassetid://10734896294", -- Wrench icon
    
    -- Status & Feedback
    Info = "rbxassetid://10734896602", -- Info icon
    Warning = "rbxassetid://10734897013", -- Alert triangle
    Error = "rbxassetid://10734896869", -- Alert circle
    Success = "rbxassetid://10709774989", -- Check circle
    Question = "rbxassetid://10734896235", -- Help circle
    Exclamation = "rbxassetid://10734896869", -- Alert circle
    
    -- Media
    Play = "rbxassetid://10734885123", -- Play icon
    Pause = "rbxassetid://10734884918", -- Pause icon
    Stop = "rbxassetid://10734885652", -- Stop icon
    Record = "rbxassetid://10734884713", -- Circle icon
    SkipForward = "rbxassetid://10734885917", -- Skip forward
    SkipBack = "rbxassetid://10734885739", -- Skip back
    FastForward = "rbxassetid://10734929516", -- Fast forward
    Rewind = "rbxassetid://10734929231", -- Rewind
    
    -- Communication
    Bell = "rbxassetid://10734919692", -- Bell icon
    Mail = "rbxassetid://10734897054", -- Mail icon
    Message = "rbxassetid://10734897313", -- Message circle
    Phone = "rbxassetid://10734884372", -- Phone icon
    
    -- File & Folder
    File = "rbxassetid://10734930003", -- File icon
    FileText = "rbxassetid://10734930174", -- File text
    Folder = "rbxassetid://10734930451", -- Folder icon
    FolderOpen = "rbxassetid://10734930609", -- Folder open
    Upload = "rbxassetid://10734926969", -- Upload icon
    Download = "rbxassetid://10734925683", -- Download icon
    
    -- User & People
    User = "rbxassetid://10734926827", -- User icon
    Users = "rbxassetid://10734926647", -- Users icon
    UserPlus = "rbxassetid://10734926465", -- User plus
    UserMinus = "rbxassetid://10734926315", -- User minus
    UserCheck = "rbxassetid://10734926169", -- User check
    UserX = "rbxassetid://10734926023", -- User x
    
    -- System
    Power = "rbxassetid://10734884918", -- Power icon
    Wifi = "rbxassetid://10734896294", -- Wifi icon
    WifiOff = "rbxassetid://10734896869", -- Wifi off icon
    Battery = "rbxassetid://10734919692", -- Battery icon
    BatteryLow = "rbxassetid://10734896869", -- Battery low icon
    Signal = "rbxassetid://10734896294", -- Signal icon
    
    -- Shapes & Objects
    Circle = "rbxassetid://10734884713", -- Circle icon
    Square = "rbxassetid://10734885652", -- Square icon
    Triangle = "rbxassetid://10734896235", -- Triangle icon
    Star = "rbxassetid://10734926023", -- Star icon
    Heart = "rbxassetid://10734930003", -- Heart icon
    Diamond = "rbxassetid://10734930174", -- Diamond icon
    
    -- Time & Calendar
    Clock = "rbxassetid://10734930451", -- Clock icon
    Calendar = "rbxassetid://10734930609", -- Calendar icon
    Timer = "rbxassetid://10734926969", -- Timer icon
    Stopwatch = "rbxassetid://10734925683", -- Stopwatch icon
    
    -- Security
    Lock = "rbxassetid://10734926827", -- Lock icon
    Unlock = "rbxassetid://10734926647", -- Unlock icon
    Key = "rbxassetid://10734926465", -- Key icon
    Shield = "rbxassetid://10734926315", -- Shield icon
    ShieldCheck = "rbxassetid://10734926169", -- Shield check icon
    
    -- Weather
    Sun = "rbxassetid://10734884548", -- Sun icon
    Moon = "rbxassetid://10734897518", -- Moon icon
    Cloud = "rbxassetid://10734886004", -- Cloud icon
    Rain = "rbxassetid://10734919336", -- Rain icon
    Snow = "rbxassetid://10747372992", -- Snow icon
    
    -- Technology
    Monitor = "rbxassetid://10734896771", -- Monitor icon
    Smartphone = "rbxassetid://10734884372", -- Smartphone icon
    Laptop = "rbxassetid://10734897054", -- Laptop icon
    Keyboard = "rbxassetid://10734897313", -- Keyboard icon
    Mouse = "rbxassetid://10734896294", -- Mouse icon
    
    -- Gaming
    Gamepad = "rbxassetid://10734930003", -- Gamepad icon
    Joystick = "rbxassetid://10734930174", -- Joystick icon
    Dice = "rbxassetid://10734930451", -- Dice icon
    Target = "rbxassetid://10734930609", -- Target icon
    
    -- Misc
    Magic = "rbxassetid://10734926969", -- Magic icon
    Fire = "rbxassetid://10734925683", -- Fire icon
    Water = "rbxassetid://10734926827", -- Water icon
    Lightning = "rbxassetid://10734926647", -- Lightning icon
    Sparkles = "rbxassetid://10734926465", -- Sparkles icon
    
    -- Arrows (Extended)
    ArrowUpRight = "rbxassetid://10709792175", -- Arrow up right
    ArrowDownRight = "rbxassetid://10709790644", -- Arrow down right
    ArrowDownLeft = "rbxassetid://10709790948", -- Arrow down left
    ArrowUpLeft = "rbxassetid://10709791437", -- Arrow up left
    
    -- Special Characters
    Bullet = "rbxassetid://10734884713", -- Bullet icon
    Dash = "rbxassetid://10723407389", -- Dash icon
    Ellipsis = "rbxassetid://10734898592", -- Ellipsis icon
    Infinity = "rbxassetid://10734926315", -- Infinity icon
    Degree = "rbxassetid://10734884713", -- Degree icon
    
    -- Math & Science
    Plus2 = "rbxassetid://10734884548", -- Plus icon
    Minus2 = "rbxassetid://10734897518", -- Minus icon
    Multiply = "rbxassetid://10747384394", -- Multiply icon
    Divide = "rbxassetid://10734897518", -- Divide icon
    Equals = "rbxassetid://10734884713", -- Equals icon
    NotEquals = "rbxassetid://10747384394", -- Not equals icon
    LessThan = "rbxassetid://10709781389", -- Less than icon
    GreaterThan = "rbxassetid://10709781845", -- Greater than icon,
    
    -- Categories for easy access
    WindowControls = {
        Close = "rbxassetid://10747384394", -- X icon
        Minimize = "rbxassetid://10723407389", -- Minimize icon
        Theme = "rbxassetid://10734886004", -- Palette icon
        Eye = "rbxassetid://10747372992" -- Eye icon
    },
    
    Actions = {
        Plus = "rbxassetid://10734884548", -- Plus icon
        Minus = "rbxassetid://10734897518", -- Minus icon
        Check = "rbxassetid://10709774989", -- Check icon
        X = "rbxassetid://10747384394", -- X icon
        Save = "rbxassetid://10734885386", -- Save icon
        Delete = "rbxassetid://10734884226", -- Trash icon
        Refresh = "rbxassetid://10734884548" -- Refresh icon
    },
    
    Status = {
        Info = "rbxassetid://10734896602", -- Info icon
        Warning = "rbxassetid://10734897013", -- Alert triangle
        Error = "rbxassetid://10734896869", -- Alert circle
        Success = "rbxassetid://10709774989" -- Check circle
    }
}

-- Helper function to get icon by name
function Icons:Get(iconName)
    return self[iconName] or iconName
end

-- Helper function to check if icon exists
function Icons:Exists(iconName)
    return self[iconName] ~= nil
end

-- Get all icons in a category
function Icons:GetCategory(categoryName)
    return self[categoryName] or {}
end

-- Get random icon
function Icons:Random()
    local iconNames = {}
    for name, icon in pairs(self) do
        if type(icon) == "string" and type(name) == "string" then
            table.insert(iconNames, name)
        end
    end
    
    if #iconNames > 0 then
        local randomName = iconNames[math.random(1, #iconNames)]
        return self[randomName], randomName
    end
    
    return "?", "Unknown"
end

return Icons