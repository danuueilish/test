local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Notification helper
local function showNotification(text)
  local notifGui = Instance.new("ScreenGui", game.CoreGui)
  notifGui.Name = "KeyNotifGui"
  local frame = Instance.new("Frame", notifGui)
  frame.Size = UDim2.fromOffset(200, 40)
  frame.Position = UDim2.new(1, -210, 1, -50)
  frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
  frame.BackgroundTransparency = 0.2
  frame.BorderSizePixel = 0
  frame.ZIndex = 10
  local corner = Instance.new("UICorner", frame)
  corner.CornerRadius = UDim.new(0, 8)
  local label = Instance.new("TextLabel", frame)
  label.Size = UDim2.new(1, -10, 1, -10)
  label.Position = UDim2.fromOffset(5, 5)
  label.BackgroundTransparency = 1
  label.Font = Enum.Font.Gotham
  label.TextSize = 14
  label.TextColor3 = Color3.new(1,1,1)
  label.Text = text
  label.TextWrapped = true
  label.ZIndex = 11

  local tweenIn = TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 0})
  tweenIn:Play()
  delay(2, function()
    local tweenOut = TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 1})
    tweenOut:Play()
    tweenOut.Completed:Wait()
    notifGui:Destroy()
  end)
end

local keyFile = "key_accepted.txt"
local function fileExists(name)
  return pcall(function() readfile(name) end)
end
local function markKeyAccepted()
  if writefile then
    writefile(keyFile, "accepted")
  end
end
local function isKeyAccepted()
  if fileExists(keyFile) then
    return readfile(keyFile) == "accepted"
  end
  return false
end

if not isKeyAccepted() then
  local keyGui = Instance.new("ScreenGui", game.CoreGui)
  keyGui.Name = "KeyGui"
  
  local frame = Instance.new("Frame", keyGui)
  frame.Size = UDim2.fromOffset(300, 140)
  frame.Position = UDim2.new(0.5, -150, 0.4, -70)
  frame.BackgroundColor3 = Color3.fromRGB(31,31,53)
  frame.BorderSizePixel = 0
  frame.ZIndex = 1
  local function corner(o) local c=Instance.new("UICorner",o); c.CornerRadius=UDim.new(0,10) end
  corner(frame)
  
  local closeBtn = Instance.new("TextButton", frame)
  closeBtn.Size = UDim2.new(0, 24, 0, 24)
  closeBtn.Position = UDim2.new(1, -28, 0, 4)
  closeBtn.Text = "X"
  closeBtn.Font = Enum.Font.GothamBold
  closeBtn.TextSize = 18
  closeBtn.TextColor3 = Color3.new(1,1,1)
  closeBtn.BackgroundColor3 = Color3.fromRGB(80,80,120)
  corner(closeBtn)
  closeBtn.MouseButton1Click:Connect(function()
    keyGui:Destroy()
  end)

  local title = Instance.new("TextLabel", frame)
  title.Size = UDim2.new(1, -60, 0, 30)
  title.Position = UDim2.fromOffset(10, 10)
  title.BackgroundTransparency = 1
  title.Font = Enum.Font.GothamBold
  title.TextSize = 18
  title.TextColor3 = Color3.new(1,1,1)
  title.Text = "danuu eilish. Key System"
  
  local input = Instance.new("TextBox", frame)
  input.Size = UDim2.new(1, -20, 0, 30)
  input.Position = UDim2.fromOffset(10, 50)
  input.PlaceholderText = "Enter your key"
  input.Text = ""
  input.TextSize = 16
  input.Font = Enum.Font.Gotham
  input.BackgroundColor3 = Color3.fromRGB(52,52,72)
  input.TextColor3 = Color3.new(1,1,1)
  corner(input)
  
  local submitBtn = Instance.new("TextButton", frame)
  submitBtn.Size = UDim2.new(0.5, -15, 0, 30)
  submitBtn.Position = UDim2.fromOffset(10, 90)
  submitBtn.Text = "Submit"
  submitBtn.Font = Enum.Font.GothamBold
  submitBtn.TextSize = 14
  submitBtn.BackgroundColor3 = Color3.fromRGB(110,212,140)
  corner(submitBtn)
  
  local getKeyBtn = Instance.new("TextButton", frame)
  getKeyBtn.Size = UDim2.new(0.5, -15, 0, 30)
  getKeyBtn.Position = UDim2.new(0.5, 5, 0, 90)
  getKeyBtn.Text = "Get Key"
  getKeyBtn.Font = Enum.Font.GothamBold
  getKeyBtn.TextSize = 14
  getKeyBtn.BackgroundColor3 = Color3.fromRGB(110,212,140)
  corner(getKeyBtn)
  
  local function validateKey(k)
    return k == "susukintilminis"
  end
  
  submitBtn.MouseButton1Click:Connect(function()
    if validateKey(input.Text) then
      markKeyAccepted()
      _G.keyAccepted = true
      keyGui:Destroy()
      showNotification("Key valid!")
    else
      showNotification("Invalid Key")
    end
  end)
  
  getKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
      setclipboard("https://discord.gg/Wkk7SVHvjV")
      showNotification("Copied to clipboard!")
    else
      showNotification("Copy failed")
    end
  end)
  
  do
    local drag, startPos, origPos
    frame.InputBegan:Connect(function(i)
      if i.UserInputType == Enum.UserInputType.MouseButton1 or
         i.UserInputType == Enum.UserInputType.Touch then
        drag = true
        startPos = i.Position
        origPos = frame.Position
        i.Changed:Connect(function()
          if i.UserInputState == Enum.UserInputState.End then
            drag = false
          end
        end)
      end
    end)
    UserInputService.InputChanged:Connect(function(i)
      if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or
                   i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - startPos
        frame.Position = UDim2.new(
          origPos.X.Scale, origPos.X.Offset + delta.X,
          origPos.Y.Scale, origPos.Y.Offset + delta.Y
        )
      end
    end)
  end

  repeat wait() until _G.keyAccepted
end

print("Key accepted; initializing features...")

if game.CoreGui:FindFirstChild("AutoFishGUI") then
	game.CoreGui.AutoFishGUI:Destroy()
end

local rodOptions = {
	"Basic Rod","Party Rod","Shark Rod","Piranha Rod","Flowers Rod",
	"Thermo Rod","Trisula Rod","Feather Rod","Wave Rod","Duck Rod"
}
local currentRodIndex = 1
local rodName = rodOptions[currentRodIndex]

local REMOTE = game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("RodRemoteEvent")
local SellRemote = game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("SellItemRemoteFunction")
local VirtualInputManager = game:GetService("VirtualInputManager")
local plr = game.Players.LocalPlayer

-- Webhook Stats
local WEBHOOK_URL = "https://discord.com/api/webhooks/1422514810305773682/zDuuvrmC05rO58NHoQmzWuRQ3qVvUGrfalv8osSmjPW5-pxVqMB5LXl5MugeYdWkxh8a"

local webhookStats = {
	totalFishCaught = 0,
	totalFishSold = 0,
	startTime = tick(),
	webhookEnabled = false
}

-- Anti-AFK System
local antiAFKEnabled = true
spawn(function()
	while wait(120) do
		if antiAFKEnabled and plr.Character then
			local humanoid = plr.Character:FindFirstChild("Humanoid")
			if humanoid then
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end
	end
end)

-- Request function
local function req(body)
    local request = (http_request or request or syn and syn.request)
    if not request then 
		warn("Executor tidak support http_request")
		return false
	end
    
	local success, err = pcall(function()
		request({
			Url = WEBHOOK_URL,
			Method = "POST",
			Headers = {["Content-Type"] = "application/json"},
			Body = HttpService:JSONEncode(body)
		})
	end)
	
	return success, err
end

-- Webhook Function
local function sendWebhook(fishName, fishWeight)
	if not webhookStats.webhookEnabled then 
		return 
	end
	
	local playerData = plr:FindFirstChild("PlayerData")
	if not playerData then 
		return 
	end
	
	local strikeStreak = playerData:FindFirstChild("StrikeStreak")
	local uang = playerData:FindFirstChild("Uang")
	local ikanFolder = playerData:FindFirstChild("Ikan")
	
	local strikeValue = strikeStreak and strikeStreak.Value or 0
	local moneyValue = uang and uang.Value or 0
	local fishCount = ikanFolder and #ikanFolder:GetChildren() or 0
	
	local elapsedTime = tick() - webhookStats.startTime
	local hours = math.floor(elapsedTime / 3600)
	local minutes = math.floor((elapsedTime % 3600) / 60)
	local seconds = math.floor(elapsedTime % 60)
	local farmingTime = string.format("%02d:%02d:%02d", hours, minutes, seconds)
	
	local mapName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
	local jobId = "https://www.roblox.com/games/" .. game.PlaceId .. "?jobId=" .. game.JobId
	
	local content = ""
	local embedColor = 0x3498db
	if fishWeight > 500 then
		content = "@everyone 🚨 **RARE FISH ALERT!** 🚨"
		embedColor = 0xFF0000
	else
		embedColor = 0x2ecc71
	end
	
	local body = {
		username = "👧🏻 Nahe baw ee",
		content = content,
		embeds = {{
			title = fishWeight > 500 and "🔥 IKAN GEDE CUY! 🔥" or "Stats Update",
			color = embedColor,
			fields = {
				{name = "Fish Name:", value = "**" .. fishName .. "**", inline = true},
				{name = "Weight:", value = "**" .. fishWeight .. " Kg**", inline = true},
				{name = "Rod Type:", value = "**" .. rodName .. "**", inline = true},
				{name = "Strike Streak:", value = "**" .. tostring(strikeValue) .. "**", inline = true},
				{name = "Total Fish:", value = "**" .. tostring(fishCount) .. "**", inline = true},
				{name = "Sold Fish:", value = "**" .. tostring(webhookStats.totalFishSold) .. "**", inline = true},
				{name = "Current Money:", value = "**Rp " .. tostring(moneyValue):reverse():gsub("(%d%d%d)", "%1."):reverse():gsub("^%.", "") .. "**", inline = true},
				{name = "Farming Time:", value = "**" .. farmingTime .. "**", inline = true},
				{name = "Map:", value = "**" .. mapName .. "**", inline = true},
				{name = "Join Server:", value = "[Click to Join](" .. jobId .. ")", inline = false}
			},
			footer = {
				text = "Indo Hangout • " .. os.date("%H:%M:%S")
			},
			timestamp = os.date("!%Y-%m-%dT%H:%M:%S")
		}}
	}
	
	spawn(function()
		req(body)
	end)
end

-- Get fish info from PlayerData.Ikan folder
local function getLatestFishInfo()
	local fishName = "Unknown Fish"
	local fishWeight = 0
	
	local playerData = plr:FindFirstChild("PlayerData")
	if not playerData then return fishName, fishWeight end
	
	local ikanFolder = playerData:FindFirstChild("Ikan")
	if not ikanFolder then return fishName, fishWeight end
	
	local fishes = ikanFolder:GetChildren()
	if #fishes > 0 then
		local lastFish = fishes[#fishes]
		if lastFish.Name:match("%((.+) Kg%)") then
			local weight = lastFish.Name:match("%((.+) Kg%)")
			if weight then
				fishWeight = tonumber(weight) or 0
				fishName = lastFish.Name:gsub(" %(.+ Kg%)", "")
			end
		end
	end
	
	return fishName, fishWeight
end

local sg = Instance.new("ScreenGui", game.CoreGui)
sg.Name = "AutoFishGUI"

local function corner(obj)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 10)
	c.Parent = obj
end

local mainFrm = Instance.new("Frame", sg)
local origSize = UDim2.fromOffset(260, 360)
mainFrm.Size = origSize
mainFrm.Position = UDim2.new(0.5, -130, 0.1, 0)
mainFrm.BackgroundColor3 = Color3.fromRGB(31,31,53)
mainFrm.BorderSizePixel = 0
mainFrm.Active = true
corner(mainFrm)

local minimizeBtn = Instance.new("TextButton", mainFrm)
local origMinPos = UDim2.new(1, -35, 0, 5)
minimizeBtn.Size = UDim2.new(0, 30, 0, 20)
minimizeBtn.Position = origMinPos
minimizeBtn.Text = "-"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80,80,120)
corner(minimizeBtn)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, child in ipairs(mainFrm:GetChildren()) do
		if child:IsA("GuiObject") and child ~= minimizeBtn then
			child.Visible = not minimized
		end
	end
	if minimized then
		mainFrm.Size = UDim2.fromOffset(40, 30)
		minimizeBtn.Position = UDim2.fromOffset(5, 5)
	else
		mainFrm.Size = origSize
		minimizeBtn.Position = origMinPos
	end
end)

local titleRod = Instance.new("TextLabel", mainFrm)
titleRod.Size = UDim2.new(1, -16, 0, 20)
titleRod.Position = UDim2.fromOffset(8, 8)
titleRod.BackgroundTransparency = 1
titleRod.Font = Enum.Font.GothamBold
titleRod.TextSize = 15
titleRod.TextColor3 = Color3.new(1,1,1)
titleRod.Text = "Select Rod"

local rodBtn = Instance.new("TextButton", mainFrm)
rodBtn.Size = UDim2.new(1, -16, 0, 28)
rodBtn.Position = UDim2.fromOffset(8, 32)
rodBtn.BackgroundColor3 = Color3.fromRGB(110, 212, 140)
rodBtn.TextColor3 = Color3.new(0, 0, 0)
rodBtn.Font = Enum.Font.GothamBold
rodBtn.TextSize = 14
rodBtn.Text = rodName
corner(rodBtn)

rodBtn.MouseButton1Click:Connect(function()
	currentRodIndex = currentRodIndex % #rodOptions + 1
	rodName = rodOptions[currentRodIndex]
	rodBtn.Text = rodName
end)

local titleFish = Instance.new("TextLabel", mainFrm)
titleFish.Size = UDim2.new(1, -16, 0, 20)
titleFish.Position = UDim2.fromOffset(8, 64)
titleFish.BackgroundTransparency = 1
titleFish.Font = Enum.Font.GothamBold
titleFish.TextSize = 15
titleFish.TextColor3 = Color3.new(1, 1, 1)
titleFish.Text = "Auto Fishing"

local fishFrm = Instance.new("Frame", mainFrm)
fishFrm.Size = UDim2.fromOffset(238, 70)
fishFrm.Position = UDim2.fromOffset(8, 88)
fishFrm.BackgroundColor3 = Color3.fromRGB(31, 31, 53)
fishFrm.BorderSizePixel = 0
corner(fishFrm)

local btn = Instance.new("TextButton", fishFrm)
btn.Size = UDim2.new(1, -16, 0, 36)
btn.Position = UDim2.fromOffset(8, 10)
btn.BackgroundColor3 = Color3.fromRGB(110, 212, 140)
btn.TextColor3 = Color3.new(0, 0, 0)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 16
btn.Text = "Stop Auto Fishing"
corner(btn)

local stat = Instance.new("TextLabel", fishFrm)
stat.Size = UDim2.new(1, -16, 0, 20)
stat.Position = UDim2.fromOffset(8, 54)
stat.BackgroundTransparency = 1
stat.Font = Enum.Font.Gotham
stat.TextSize = 12
stat.TextColor3 = Color3.fromRGB(230, 255, 210)
stat.TextXAlignment = Enum.TextXAlignment.Left
stat.Text = "Status: Standby | Anti-AFK: ON"

do
	local drag, s, p
	fishFrm.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drag = true;
			s = i.Position;
			p = fishFrm.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then
					drag = false
				end
			end)
		end
	end)
	game:GetService("UserInputService").InputChanged:Connect(function(i)
		if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - s
			fishFrm.Position = UDim2.new(p.X.Scale, p.X.Offset + d.X, p.Y.Scale, p.Y.Offset + d.Y)
		end
	end)
end

local titleSell = Instance.new("TextLabel", mainFrm)
titleSell.Size = UDim2.new(1, -16, 0, 20)
titleSell.Position = UDim2.fromOffset(8, 168)
titleSell.BackgroundTransparency = 1
titleSell.Font = Enum.Font.GothamBold
titleSell.TextSize = 15
titleSell.TextColor3 = Color3.new(1, 1, 1)
titleSell.Text = "Auto Sell Fish"

local sellModes = {
	"All under 50 Kg","All under 100 Kg","All under 400 Kg",
	"All under 600 Kg","All under 800 Kg","All under 1000 Kg",
	"Sell this fish","Sell All"
}
local currentSellIndex = 1

local optSell = Instance.new("TextButton", mainFrm)
optSell.Size = UDim2.new(1, -16, 0, 30)
optSell.Position = UDim2.fromOffset(8, 192)
optSell.BackgroundColor3 = Color3.fromRGB(110, 212, 140)
optSell.TextColor3 = Color3.new(0, 0, 0)
optSell.Font = Enum.Font.GothamSemibold
optSell.TextSize = 12
optSell.Text = sellModes[currentSellIndex]
corner(optSell)

optSell.MouseButton1Click:Connect(function()
	currentSellIndex = currentSellIndex % #sellModes + 1
	optSell.Text = sellModes[currentSellIndex]
end)

optSell.MouseButton2Click:Connect(function()
	local mode = sellModes[currentSellIndex]
	if mode == "Sell this fish" then
		SellRemote:InvokeServer("SellFish")
	else
		SellRemote:InvokeServer("SellFish", mode)
	end
	webhookStats.totalFishSold = webhookStats.totalFishSold + 1
end)

local intervalBox = Instance.new("TextBox", mainFrm)
intervalBox.Size = UDim2.new(1, -16, 0, 20)
intervalBox.Position = UDim2.fromOffset(8, 228)
intervalBox.BackgroundColor3 = Color3.fromRGB(52, 52, 72)
intervalBox.TextColor3 = Color3.new(1, 1, 1)
intervalBox.Font = Enum.Font.Gotham
intervalBox.TextSize = 13
intervalBox.Text = "30"
intervalBox.PlaceholderText = "Interval (detik)"
intervalBox.ClearTextOnFocus = false
corner(intervalBox)

local autoBtn = Instance.new("TextButton", mainFrm)
autoBtn.Size = UDim2.fromOffset(120, 22)
autoBtn.Position = UDim2.new(0.5, -60, 0, 258)
autoBtn.BackgroundColor3 = Color3.fromRGB(88, 233, 167)
autoBtn.TextColor3 = Color3.new(0, 0, 0)
autoBtn.Font = Enum.Font.GothamBold
autoBtn.TextSize = 13
autoBtn.Text = "Enable Auto Sell"
corner(autoBtn)

local titleBuyRod = Instance.new("TextLabel", mainFrm)
titleBuyRod.Size = UDim2.new(1, -16, 0, 20)
titleBuyRod.Position = UDim2.fromOffset(8, 288)
titleBuyRod.BackgroundTransparency = 1
titleBuyRod.Font = Enum.Font.GothamBold
titleBuyRod.TextSize = 15
titleBuyRod.TextColor3 = Color3.new(1, 1, 1)
titleBuyRod.Text = "Buy Rod"

local buyRodBtn = Instance.new("TextButton", mainFrm)
buyRodBtn.Size = UDim2.fromOffset(120, 22)
buyRodBtn.Position = UDim2.new(0.5, -60, 0, 308)
buyRodBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
buyRodBtn.TextColor3 = Color3.new(0, 0, 0)
buyRodBtn.Font = Enum.Font.GothamBold
buyRodBtn.TextSize = 13
buyRodBtn.Text = "Open Rod Shop"
corner(buyRodBtn)

buyRodBtn.MouseButton1Click:Connect(function()
	local rodShopGui = plr.PlayerGui:FindFirstChild("RodShop")
	if rodShopGui then
		rodShopGui.Enabled = true
		showNotification("Rod Shop Opened!")
	else
		showNotification("Rod Shop GUI not found!")
	end
end)

local titleWebhook = Instance.new("TextLabel", mainFrm)
titleWebhook.Size = UDim2.new(1, -16, 0, 20)
titleWebhook.Position = UDim2.fromOffset(8, 338)
titleWebhook.BackgroundTransparency = 1
titleWebhook.Font = Enum.Font.GothamBold
titleWebhook.TextSize = 15
titleWebhook.TextColor3 = Color3.new(1, 1, 1)
titleWebhook.Text = "Discord Webhook"

local webhookBtn = Instance.new("TextButton", mainFrm)
webhookBtn.Size = UDim2.fromOffset(120, 22)
webhookBtn.Position = UDim2.new(0.5, -60, 0, 358)
webhookBtn.BackgroundColor3 = Color3.fromRGB(234, 112, 112)
webhookBtn.TextColor3 = Color3.new(0, 0, 0)
webhookBtn.Font = Enum.Font.GothamBold
webhookBtn.TextSize = 13
webhookBtn.Text = "Webhook: OFF"
corner(webhookBtn)

webhookBtn.MouseButton1Click:Connect(function()
	webhookStats.webhookEnabled = not webhookStats.webhookEnabled
	if webhookStats.webhookEnabled then
		webhookBtn.Text = "Webhook: ON"
		webhookBtn.BackgroundColor3 = Color3.fromRGB(88, 233, 167)
		showNotification("Webhook Enabled!")
	else
		webhookBtn.Text = "Webhook: OFF"
		webhookBtn.BackgroundColor3 = Color3.fromRGB(234, 112, 112)
		showNotification("Webhook Disabled!")
	end
end)

do
	local drag, startPos, origPos
	mainFrm.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drag = true
			startPos = i.Position
			origPos = mainFrm.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then
					drag = false
				end
			end)
		end
	end)
	game:GetService("UserInputService").InputChanged:Connect(function(i)
		if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local delta = i.Position - startPos
			mainFrm.Position = UDim2.new(
				origPos.X.Scale, origPos.X.Offset + delta.X,
				origPos.Y.Scale, origPos.Y.Offset + delta.Y
			)
		end
	end)
end

local running, looping = false, false
local globalReleaseFlag = false

local function getRod(a)
	if not plr.Character then return end
	if a then
		return plr.Character:FindFirstChild(rodName)
	else
		return plr.Backpack:FindFirstChild(rodName)
	end
end

local function forceEquipRod()
	local rod = getRod()
	if rod and plr.Character then
		local hum = plr.Character:FindFirstChild("Humanoid")
		if hum then pcall(function() hum:EquipTool(rod) end) end
		REMOTE:FireServer("Equipped", rod)
		return true
	end
	return false
end

local function ensureEquipped()
	if getRod() then forceEquipRod() end
end

local function unequipRod()
	if plr.Character then
		local hum = plr.Character:FindFirstChild("Humanoid")
		if hum then pcall(function() hum:UnequipTools() end) end
	end
end

local function throwRod()
	ensureEquipped()
	local rod = getRod(true)
	if rod then
		REMOTE:FireServer(unpack({"Throw", rod, workspace:WaitForChild("Terrain")}))
		return true
	end
	return false
end

local function getActiveRedBar(bars)
	if bars then
		for _, c in pairs(bars:GetChildren()) do
			if c:IsA("Frame") and c.Name == "RedBar" and c.Visible then
				return c
			end
		end
	end 
	return nil
end

local function seekAndImmediateFollow(white, bars)
	local function getRedBar()
		for _, c in pairs(bars:GetChildren()) do
			if c:IsA("Frame") and c.Name == "RedBar" and c.Visible then
				return c
			end
		end
		return nil
	end
	local function getRedBarCenter(red)
		local abs = red.AbsolutePosition or Vector2.new(450, 450)
		local sz = red.AbsoluteSize or Vector2.new(30, 16)
		return Vector2.new(math.floor(abs.X + sz.X / 2), math.floor(abs.Y + sz.Y / 2))
	end

	local holded = false
	spawn(function()
		while plr.PlayerGui:FindFirstChild("Reeling") and plr.PlayerGui.Reeling.Enabled do
			local red = getRedBar()
			local whiteBar = bars:FindFirstChild("WhiteBar")
			if red and red.Visible and whiteBar then
				whiteBar.Position = red.Position
				whiteBar.Size = UDim2.new(red.Size.X.Scale, red.Size.X.Offset, whiteBar.Size.Y.Scale, whiteBar.Size.Y.Offset)
			else
				break
			end
			wait(0.005)
		end
	end)
	
	while plr.PlayerGui:FindFirstChild("Reeling") and plr.PlayerGui.Reeling.Enabled do
		local red = getRedBar()
		if red and red.Visible then
			local redCt = getRedBarCenter(red)
			VirtualInputManager:SendMouseButtonEvent(redCt.X, redCt.Y, 0, true, game, 1)
			holded = true
		else
			break
		end
		wait(0.01)
	end
	
	if holded then
		local red = getRedBar()
		if red then
			local redCt = getRedBarCenter(red)
			VirtualInputManager:SendMouseButtonEvent(redCt.X, redCt.Y, 0, false, game, 1)
		end
	end
	return true
end

local fishDetected = false
local waitingBite = false
local function setupBiteListener()
	REMOTE.OnClientEvent:Connect(function(action)
		if waitingBite and tostring(action):lower():find("reeling") then
			fishDetected = true
		end
	end)
end
setupBiteListener()

local function autoFishLoop()
	while running do
		stat.Text = "Status: Standby | Anti-AFK: ON"
		wait(0.7)
		if not workspace:FindFirstChild("Pelampung-" .. plr.Name) then
			stat.Text = "Status: Throw | Anti-AFK: ON"
			throwRod()
		end
		wait(0.38)
		stat.Text = "Status: Wait Fish Bait | Anti-AFK: ON"
		waitingBite, fishDetected = true, false
		local t0 = tick()
		while running and not fishDetected and (tick() - t0 < 35) do
			wait(0.22)
			if not workspace:FindFirstChild("Pelampung-" .. plr.Name) then
				throwRod()
			end
			stat.Text = "Status: Wait Fish Bait... " .. math.floor(tick() - t0) .. "s | Anti-AFK: ON"
		end
		waitingBite = false
		if not running then
			break
		end
		if not fishDetected then
			stat.Text = "Status: Timeout, retry | Anti-AFK: ON"
			wait(1.1)
		else
			stat.Text = "Status: Perfect Overlap | Anti-AFK: ON"
			local bars = plr.PlayerGui.Reeling.Frame and plr.PlayerGui.Reeling.Frame:FindFirstChild("Frame")
			local white = bars and bars:FindFirstChild("WhiteBar")
			while plr.PlayerGui.Reeling.Enabled and not globalReleaseFlag do
				if white and white.Visible then
					seekAndImmediateFollow(white, bars)
					break
				end
				if not running or not plr.PlayerGui.Reeling.Enabled then
					break
				end
				wait(0.01)
			end
			
			-- Send webhook after fish caught
			wait(0.5)
			local fishName, fishWeight = getLatestFishInfo()
			if fishWeight > 0 then
				webhookStats.totalFishCaught = webhookStats.totalFishCaught + 1
				sendWebhook(fishName, fishWeight)
			end
		end
		stat.Text = "Status: Standby | Anti-AFK: ON"
		fishDetected = false
		wait(0.7)
	end
	stat.Text = "Status: Standby | Anti-AFK: ON"
	waitingBite = false
	fishDetected = false
end

btn.Text = "Start Auto Fishing"
btn.BackgroundColor3 = Color3.fromRGB(110, 212, 140)
btn.MouseButton1Click:Connect(function()
	running = not running
	btn.Text = running and "Stop Auto Fishing" or "Start Auto Fishing"
	stat.Text = running and "Status: Loading... | Anti-AFK: ON" or "Status: Standby | Anti-AFK: ON"
	if running then
		globalReleaseFlag = false
		spawn(autoFishLoop)
	else
		globalReleaseFlag = true
		unequipRod()
	end
end)

local currentMode = 1
local runAuto = false

optSell.MouseButton1Click:Connect(function()
	currentMode = currentMode + 1
	if currentMode > #sellModes then
		currentMode = 1
	end
	optSell.Text = sellModes[currentMode]
end)

optSell.MouseButton2Click:Connect(function()
	local mode = sellModes[currentMode]
	if mode == "Sell this fish" then
		SellRemote:InvokeServer("SellFish")
	else
		SellRemote:InvokeServer("SellFish", mode)
	end
	webhookStats.totalFishSold = webhookStats.totalFishSold + 1
end)

local function doSell()
	local mode = sellModes[currentMode]
	if mode == "Sell this fish" then
		SellRemote:InvokeServer("SellFish")
	else
		SellRemote:InvokeServer("SellFish", mode)
	end
	webhookStats.totalFishSold = webhookStats.totalFishSold + 1
end

autoBtn.MouseButton1Click:Connect(function()
	runAuto = not runAuto
	autoBtn.Text = runAuto and "Disable Auto Sell" or "Enable Auto Sell"
	autoBtn.BackgroundColor3 = runAuto and Color3.fromRGB(234, 112, 112) or Color3.fromRGB(88, 233, 167)
	if runAuto then
		spawn(function()
			while runAuto do
				doSell()
				local n = tonumber(intervalBox.Text)
				n = (n and n >= 2) and n or 30
				for i = 1, n do
					if not runAuto then
						break
					end
					wait(1)
				end
			end
		end)
	end
end)
