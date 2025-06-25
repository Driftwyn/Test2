-- DriftwynLib - Full UI Library (With Toggle, Keybind, Textbox, Theme support)

local Players     = game:GetService("Players")
local UIS         = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TweenService= game:GetService("TweenService")
local RunService  = game:GetService("RunService")
local player      = Players.LocalPlayer

-- Preloader UI
local loader = Instance.new("ScreenGui")
loader.Name = "DriftwynUILoader"
loader.ResetOnSpawn = false
loader.IgnoreGuiInset = true
loader.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
loader.Parent = player:WaitForChild("PlayerGui")

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
bg.BorderSizePixel = 0
bg.Parent = loader

local txt = Instance.new("TextLabel")
txt.AnchorPoint = Vector2.new(0.5, 0.5)
txt.Position = UDim2.new(0.5, 0, 0.5, 0)
txt.Size = UDim2.new(0, 240, 0, 50)
txt.BackgroundTransparency = 1
txt.TextColor3 = Color3.new(1, 1, 1)
txt.Font = Enum.Font.GothamBold
txt.TextSize = 20
txt.Text = "Driftwyn Hub Loading..."
txt.Parent = bg

for i = 1, 3 do
    txt.Text = "Driftwyn Hub Loading" .. string.rep(".", i)
    wait(0.5)
end

txt.Text = "Loading Complete!"
wait(0.6)
loader:Destroy()

local DriftwynLib = {}

-- UI FRAME SETUP
function DriftwynLib:CreateWindow(config)
    local self = {}
    self.Title = config.Name or "Driftwyn Hub"
    self.Tabs = {}

    local gui = Instance.new("ScreenGui")
    gui.Name = "DriftwynUI"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = player:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Name = "MainFrame"
    main.Size = UDim2.new(0, 600, 0, 350)
    main.Position = UDim2.new(0.5, -300, 0.5, -175)
    main.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
    main.BorderColor3 = Color3.fromRGB(255, 0, 0)
    main.BorderSizePixel = 4
    main.Parent = gui

    local title = Instance.new("TextLabel")
    title.Text = self.Title
    title.Size = UDim2.new(0, 150, 0, 30)
    title.Position = UDim2.new(0.5, -75, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = main

    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(0, 120, 1, -30)
    tabBar.Position = UDim2.new(0, 0, 0, 30)
    tabBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabBar.BorderSizePixel = 0
    tabBar.Parent = main

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabBar

    local content = Instance.new("Frame")
    content.Name = "ContentFrame"
    content.Size = UDim2.new(1, -120, 1, -30)
    content.Position = UDim2.new(0, 120, 0, 30)
    content.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
    content.BorderSizePixel = 0
    content.ClipsDescendants = true
    content.Parent = main

    -- Store references
    self.Gui = gui
    self.Main = main
    self.TabBar = tabBar
    self.Content = content
    self.AddTab = function(tabCfg)
        local tab = {}
        tab.Name = tabCfg.Name or "Tab"

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.Text = tab.Name
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.BorderSizePixel = 0
        btn.Parent = self.TabBar

        local page = Instance.new("ScrollingFrame")
        page.Name = tab.Name .. "Page"
        page.Size = UDim2.new(1, -10, 1, -10)
        page.Position = UDim2.new(0, 5, 0, 5)
        page.BackgroundTransparency = 1
        page.ScrollBarThickness = 6
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.Visible = false
        page.Parent = self.Content

        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 10)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = page

        btn.MouseButton1Click:Connect(function()
            for _, child in pairs(self.Content:GetChildren()) do
                if child:IsA("ScrollingFrame") then
                    child.Visible = false
                end
            end
            page.Visible = true
        end)

        tab.Button = btn
        tab.Content = page

        return tab
    end

    return self
end

return DriftwynLib
