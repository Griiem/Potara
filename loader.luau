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
    Background = "",
    
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

pcall(function() WindUI:SetSaveEnabled(true) end)

local plr = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Cam = Workspace.CurrentCamera

local CamTab = {}
CamTab.Functions = {}
CamTab.Variables = {}

pcall(function() RunService:UnbindFromRenderStep("FovOverride") end)
pcall(function() RunService:UnbindFromRenderStep("ResolutionScale") end)

task.wait(0.2)

CamTab.Variables.CustomResolution = false
CamTab.Variables.yCustomResolution = Cam.ViewportSize.Y
CamTab.Variables.xCustomResolution = Cam.ViewportSize.X
CamTab.Variables.yDefaultResolution = Cam.ViewportSize.Y
CamTab.Variables.xDefaultResolution = Cam.ViewportSize.X
CamTab.Variables.fovBase = Cam.FieldOfView
CamTab.Variables.fovAmount = CamTab.Variables.fovBase
CamTab.Variables.fovDefault = CamTab.Variables.fovBase
CamTab.Variables.customFov = false
CamTab.Variables.lastAppliedFov = nil

local capturedFov = Cam.FieldOfView
if capturedFov > 110 then capturedFov = 70  end
CamTab.Variables.fovBase = capturedFov
CamTab.Variables.fovAmount = capturedFov
CamTab.Variables.fovDefault = capturedFov

function CamTab.Functions:SetResolution()
    local scaleX = math.max(CamTab.Variables.xCustomResolution / CamTab.Variables.xDefaultResolution, 0.01)
    local scaleY = math.max(CamTab.Variables.yCustomResolution / CamTab.Variables.yDefaultResolution, 0.01)
    local pos, rot = Cam.CFrame.Position, Cam.CFrame - Cam.CFrame.Position
    Cam.CFrame = CFrame.new(pos) * (rot * CFrame.new(0,0,0, scaleX,0,0, 0,scaleY,0, 0,0,1))
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
    Flag = "EnableResolutionToggle_CameraTab_Toggle",
    Callback = function(state)
        CamTab.Variables.CustomResolution = state

        if state == true then
            pcall(function() RunService:UnbindFromRenderStep("ResolutionScale") end)
            RunService:BindToRenderStep("ResolutionScale", Enum.RenderPriority.Camera.Value + 1, function()
            CamTab.Functions:SetResolution()
            end)
        else 
            RunService:UnbindFromRenderStep("ResolutionScale") 
        end
    end
})

CameraTab:Space()

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

CameraTab:Divider()

local EnableFovToggle = CameraTab:Toggle({
    Title = "Enable Fov",
    Desc = "Toggle custom fov",
    Icon = "eye",
    Value = false,
    Locked = false,
    Flag = "EnableFovToggle_CameraTab_Toggle",
    Callback = function(state)
        CamTab.Variables.customFov = state
        if state then return end
        Cam.FieldOfView = CamTab.Variables.fovDefault
    end
})

local FovSlider = CameraTab:Slider({
    Title = "Fov Size",
    Desc = "Custom fov size",
    Value = {
        Min = 1,
        Max = 120,
        Default = Cam.FieldOfView
    },
    Step = .1,
    Locked = false,
    Flag = "FovSlider_CameraTab_Slider",
    Callback = function(value)
        CamTab.Variables.fovAmount = value
    end
})

Cam:GetPropertyChangedSignal("ViewportSize"):Connect(function ()
    CamTab.Variables.xDefaultResolution = Cam.ViewportSize.X
    CamTab.Variables.yDefaultResolution = Cam.ViewportSize.Y
    if CamTab.Variables.CustomResolution then CamTab.Functions:SetResolution() end
end)

Cam:GetPropertyChangedSignal("FieldOfView"):Connect(function()
    if not CamTab.Variables.customFov then return end
    task.defer(function()
        if not CamTab.Variables.customFov then return end
        local ratio = CamTab.Variables.fovAmount / CamTab.Variables.fovDefault
        local targetFov = math.clamp(CamTab.Variables.fovBase * ratio, 1, 120)
        if Cam.FieldOfView ~= targetFov then
            Cam.FieldOfView = targetFov
        end
    end)
end)

RunService:BindToRenderStep("FovOverride", Enum.RenderPriority.Last.Value, function()
    if not CamTab.Variables.customFov then return end
    local ratio = CamTab.Variables.fovAmount / CamTab.Variables.fovDefault
    local targetFov = math.clamp(CamTab.Variables.fovBase * ratio, 1, 120)
    Cam.FieldOfView = targetFov
end)

CameraTab:Divider()

local ResetCameraButton = CameraTab:Button({
    Title = "Reset Camera",
    Desc = "Reset all camera config",
    Icon = "mop",
    Locked = false,
    Justify = "Between",
    Flag = "ResetCameraButton_CameraTab_Button",
    Callback = function()
        CamTab.Variables.customFov = false
        CamTab.Variables.CustomResolution = false
        Cam.FieldOfView = CamTab.Variables.fovDefault
        CamTab.Variables.xCustomResolution = CamTab.Variables.xDefaultResolution
        CamTab.Variables.yCustomResolution = CamTab.Variables.yDefaultResolution
        pcall(function() RunService:UnbindFromRenderStep("ResolutionScale") end)
        pcall(function() RunService:UnbindFromRenderStep("FovOverride") end)
        RunService:BindToRenderStep("FovOverride", Enum.RenderPriority.Camera.Value + 1, function()
            if not CamTab.Variables.customFov then return end
            local ratio = CamTab.Variables.fovAmount / CamTab.Variables.fovDefault
            local targetFov = math.clamp(CamTab.Variables.fovBase * ratio, 1, 120)
            if math.abs(Cam.FieldOfView - targetFov) > 0.01 then Cam.FieldOfView = targetFov end
        end)
        pcall(function() EnableFovToggle:Set(false) end)
        pcall(function() EnableResolutionToggle:Set(false) end)
        pcall(function() FovSlider:Set(CamTab.Variables.fovDefault) end)
        pcall(function() xResolutionSlider:Set(CamTab.Variables.xDefaultResolution) end)
        pcall(function() yResolutionSlider:Set(CamTab.Variables.yDefaultResolution) end)
    end
})

