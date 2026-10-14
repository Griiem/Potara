local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "Potara",
    Icon = "stone",
    Author = "by Griim and Prince | Lua Vault",
    Folder = "Potara",
    ToggleKey = Enum.KeyCode.L,
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    Transparent = true,
    Theme = "Amber",
    Resizable = true,
    SideBarWidth = 200,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    BackgroundImageTransparency = 1,
    Background = "8508980536",
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            WindUI:Notify({
                Title = "User Button",
                Content = "No function yet",
                Icon = "user",
                Duration = 3,
            })
        end,
    },
})

local BASE_URL = "https://raw.githubusercontent.com/Griiem/Potara/refs/heads/main/tabs/"

local function loadTab(name)
    local url = BASE_URL .. name .. ".luau" .. "?t=" .. tostring(os.time())
    local ok, err = pcall(function()
        local src = game:HttpGet(url)
        local chunk = loadstring(src)
        if not chunk then
            warn("[Potara] Compilation failed: " .. name)
            return
        end
        chunk()(Window, WindUI)
    end)
    if not ok then
        warn("[Potara] Error loading tab '" .. name .. "': " .. tostring(err))
    end
end

loadTab("camera")
