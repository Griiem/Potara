return function (Window, WindUI)
    local SettingsTab = Window:Tab({
        Title = "Settings",
        Icon = "settings",
        Locked = false,
    })

    local Themes = {
        "Dark",
        "Light",
        "Rose",
        "Plant",
        "Red",
        "Indigo",
        "Sky",
        "Violet",
        "Amber",
        "Emerald",
        "Midnight",
        "Crimson",
        "MonokaiPro",
        "CottonCandy",
        "Mellowsi",
        "Rainbow",
    }

    local ThemesDropdown = SettingsTab:Dropdown({
        Title = "Themes",
        Desc = "Select a theme for the UI.",
        Values = Themes,
        Value = "Dark",
        Callback = function(option)
            WindUI:SetTheme(option)
        end
    })

    return SettingsTab, Themes
end
