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
 
    BackgroundImageTransparency = 0.42,
    Background = "rbxassetid://1234",
    
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function() 
            WindUI:Notify({
                Title = "User Button",
                Content = "No function yet",
                Icon = "check-circle",
                Duration = 3,
            })
        end,
    },
})

local plr = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Cam = Workspace.CurrentCamera

local CamTab = {}
CamTab.Functions = {}
CamTab.Variables = {}

CamTab.Variables.CustomResolution = false
CamTab.Variables.yCustomResolution = Cam.ViewportSize.Y
CamTab.Variables.xCustomResolution = Cam.ViewportSize.X
CamTab.Variables.yDefaultResolution = Cam.ViewportSize.Y
CamTab.Variables.xDefaultResolution = Cam.ViewportSize.X

function CamTab.Functions:SetResolution()
    local scaleX = math.max(CamTab.Variables.xCustomResolution / CamTab.Variables.xDefaultResolution, 0.01)
    local scaleY = math.max(CamTab.Variables.yCustomResolution / CamTab.Variables.yDefaultResolution, 0.01)
    
    Cam.CFrame = Cam.CFrame * CFrame.new(0, 0, 0, scaleX, 0, 0, 0, scaleY, 0, 0, 0, 1)
end

local CameraTab = Window:Tab({
    Title = "Camera",
    Desc = "Camera options",
    Icon = "camera",
    Locked = false,
})

local EnableResolutionToggle = CameraTab:Toggle({
    Title = "Enable Resolution",
    Desc = "Toggle custom resolution",
    Icon = "paintbrush",
    Value = false,
    Locked = false,
    Flag = "EnableResolution_CameraTab_Toggle",
    Callback = function(state)
        CamTab.Variables.CustomResolution = state

        if state == true then
            pcall(function() RunService:UnbindFromRenderStep("ResolutionScale") end)
            RunService:BindToRenderStep("ResolutionScale", Enum.RenderPriority.Camera.Value + 1, function()
            CamTab.Functions:SetResolution()
            end)
        else
            RunService:UnbindFromRenderStep("ResolutionScale")
            local cf = Cam.CFrame
            Cam.CFrame = CFrame.new(cf.Position) * (cf - cf.Position)
        end
    end
})

local xResolutionSlider = CameraTab:Slider({
    Title = "Horizontal Resolution",
    Desc = "Horizontal strength resolution",
    Value = {
        Min = 1,
        Max = Cam.ViewportSize.X,
        Default = Cam.ViewportSize.X
    },
    Step = .1,
    Locked = false,
    Flag = "xResolutionSlider_CameraTab_Slider",
    Callback = function(value)
        CamTab.Variables.xCustomResolution = value
    end
})

local yResolutionSlider = CameraTab:Slider({
    Title = "Vertical Resolution",
    Desc = "Vertical strength resolution",
    Value = {
        Min = 1,
        Max = Cam.ViewportSize.Y,
        Default = Cam.ViewportSize.Y
    },
    Step = .1,
    Locked = false,
    Flag = "yResolutionSlider_CameraTab_Slider",
    Callback = function(value)
        CamTab.Variables.yCustomResolution = value
    end
})

local CsResolutionButton = CameraTab:Button({
    Title = "Cs 4:3",
    Desc = "Applies stretched 4:3",
    Icon = "mouse-pointer-click",
    Locked = false,
    Justify = "Between",
    Flag = "CsResolutionButton_CameraTab_Button",
    Callback = function()
        CamTab.Variables.xCustomResolution = Cam.ViewportSize.X
        CamTab.Variables.yCustomResolution = Cam.ViewportSize.Y * (3/4)

        pcall(function() xResolutionSlider:Set(Cam.ViewportSize.X) end)
        pcall(function() yResolutionSlider:Set(Cam.ViewportSize.Y * (3/4)) end)
        pcall(function() EnableResolutionToggle:Set(true) end)

        pcall(function() RunService:UnbindFromRenderStep("ResolutionScale") end)
            RunService:BindToRenderStep("ResolutionScale", Enum.RenderPriority.Camera.Value + 1, function()
            CamTab.Functions:SetResolution()
        end)
    end
})

Cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
    local oldX, oldY = CamTab.Variables.xDefaultResolution, CamTab.Variables.yDefaultResolution
    CamTab.Variables.xDefaultResolution = Cam.ViewportSize.X
    CamTab.Variables.yDefaultResolution = Cam.ViewportSize.Y

    if oldY > 0 then
        CamTab.Variables.yCustomResolution = CamTab.Variables.yCustomResolution * (Cam.ViewportSize.Y / oldY)
    end
    if oldX > 0 then
        CamTab.Variables.xCustomResolution = CamTab.Variables.xCustomResolution * (Cam.ViewportSize.X / oldX)
    end

    if xResolutionSlider and yResolutionSlider then
        pcall(function()
            xResolutionSlider:SetMax(Cam.ViewportSize.X)
            xResolutionSlider:Set(CamTab.Variables.xCustomResolution)
        end)
        pcall(function()
            yResolutionSlider:SetMax(Cam.ViewportSize.Y)
            yResolutionSlider:Set(CamTab.Variables.yCustomResolution)
        end)
    end
end)
