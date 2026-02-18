local TweenService = game:GetService("TweenService")

local Notification = {}
Notification.__index = Notification

-- Settings
local SETTINGS = {
    Width = 300,
    Height = 60,
    Padding = 10,
    Duration = 4,
    CornerRadius = 12
}

-- Create main container
local function getContainer()
    local player = game.Players.LocalPlayer
    local gui = player:WaitForChild("PlayerGui")

    local container = gui:FindFirstChild("ModernNotifications")
    if container then
        return container
    end

    container = Instance.new("ScreenGui")
    container.Name = "ModernNotifications"
    container.ResetOnSpawn = false
    container.IgnoreGuiInset = true
    container.Parent = gui

    local holder = Instance.new("Frame")
    holder.Name = "Holder"
    holder.AnchorPoint = Vector2.new(1, 1)
    holder.Position = UDim2.new(1, -20, 1, -20)
    holder.Size = UDim2.new(0, SETTINGS.Width, 1, -40)
    holder.BackgroundTransparency = 1
    holder.Parent = container

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, SETTINGS.Padding)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.Parent = holder

    return container
end

function Notification:Notify(title, text, duration)
    duration = duration or SETTINGS.Duration

    local container = getContainer()
    local holder = container:FindFirstChild("Holder")

    -- Main frame
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, SETTINGS.Width, 0, SETTINGS.Height)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = holder

    -- Glass stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.8
    stroke.Thickness = 1
    stroke.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, SETTINGS.CornerRadius)
    corner.Parent = frame

    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 22)
    titleLabel.Position = UDim2.new(0, 10, 0, 6)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "Notification"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame

    -- Body
    local bodyLabel = Instance.new("TextLabel")
    bodyLabel.Size = UDim2.new(1, -20, 0, 20)
    bodyLabel.Position = UDim2.new(0, 10, 0, 28)
    bodyLabel.BackgroundTransparency = 1
    bodyLabel.Text = text or ""
    bodyLabel.Font = Enum.Font.Gotham
    bodyLabel.TextSize = 14
    bodyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    bodyLabel.TextXAlignment = Enum.TextXAlignment.Left
    bodyLabel.Parent = frame

    -- Progress bar background
    local barBG = Instance.new("Frame")
    barBG.Size = UDim2.new(1, -12, 0, 4)
    barBG.Position = UDim2.new(0, 6, 1, -8)
    barBG.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    barBG.BorderSizePixel = 0
    barBG.Parent = frame

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = barBG

    -- Progress bar fill
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 1, 0)
    bar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    bar.BorderSizePixel = 0
    bar.Parent = barBG

    local barFillCorner = Instance.new("UICorner")
    barFillCorner.CornerRadius = UDim.new(1, 0)
    barFillCorner.Parent = bar

    -- Initial animation
    frame.Position = UDim2.new(1, 50, 0, 0)
    frame.BackgroundTransparency = 1

    local inTween = TweenService:Create(
        frame,
        TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
        {
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 0.2
        }
    )
    inTween:Play()

    -- Progress bar tween
    local barTween = TweenService:Create(
        bar,
        TweenInfo.new(duration, Enum.EasingStyle.Linear),
        { Size = UDim2.new(0, 0, 1, 0) }
    )
    barTween:Play()

    -- Auto remove
    task.delay(duration, function()
        if frame then
            local outTween = TweenService:Create(
                frame,
                TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
                {
                    Position = UDim2.new(1, 50, 0, 0),
                    BackgroundTransparency = 1
                }
            )
            outTween:Play()
            outTween.Completed:Wait()
            frame:Destroy()
        end
    end)
end

return setmetatable({}, Notification)
