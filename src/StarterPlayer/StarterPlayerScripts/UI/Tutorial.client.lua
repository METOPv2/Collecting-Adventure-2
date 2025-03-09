local tutorialUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("Tutorial")
local pageName = tutorialUI.Container.Topbar.PageName
local descripton = tutorialUI.Container.Description
local tutorialData = require(game.ReplicatedStorage.Source.Stats.Tutorial)

local mainUI = game.Players.LocalPlayer.PlayerGui:WaitForChild("Main")
local tutorialButton = mainUI.Tutorial.TextButton
tutorialButton.Activated:Connect(function()
	tutorialUI.Enabled = true
	game.Lighting.Blur.Enabled = true
end)

local currentPage = 1
local maxPage = #tutorialData

tutorialUI.Container.Topbar.Buttons.Close.TextButton.Activated:Connect(function()
	tutorialUI.Enabled = false
	game.Lighting.Blur.Enabled = false
end)

local function UpdateUI()
	pageName.Text = tutorialData[currentPage].Name
	descripton.Text = tutorialData[currentPage].Description
	tutorialUI.Container.ImageLabel.Image = tutorialData[currentPage].Image
end
UpdateUI()

tutorialUI.Container.Topbar.Buttons.Previoous.TextButton.Activated:Connect(function()
	if currentPage == 1 then
		currentPage = maxPage
	else
		currentPage -= 1
	end
	UpdateUI()
end)

tutorialUI.Container.Topbar.Buttons.Next.TextButton.Activated:Connect(function()
	if currentPage == maxPage then
		currentPage = 1
	else
		currentPage += 1
	end
	UpdateUI()
end)
