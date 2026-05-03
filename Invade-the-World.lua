local rs = game:GetService("ReplicatedStorage")

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/lxte/lates-lib/main/Main.lua"))()

local win = lib:CreateWindow({
	Title = "niokaqweWARE",
	Theme = "Dark",
	Size = UDim2.fromOffset(300, 150),
	Transparency = 0.1,
	Blurring = false,
	MinimizeKeybind = Enum.KeyCode.LeftAlt,
})

pcall(function() win:SetTheme({Primary=Color3.fromRGB(30,30,30),Secondary=Color3.fromRGB(35,35,35),Component=Color3.fromRGB(45,45,45),Interactables=Color3.fromRGB(65,65,65),Tab=Color3.fromRGB(200,200,200),Title=Color3.fromRGB(240,240,240),Description=Color3.fromRGB(180,180,180),Shadow=Color3.fromRGB(0,0,0),Outline=Color3.fromRGB(50,50,50),Icon=Color3.fromRGB(220,220,220)}) end)

local cfg = {af = false}

win:AddTabSection({Name = "Main", Order = 1})
local tab = win:AddTab({Title = "Farm", Section = "Main"})

win:AddToggle({Title = "Auto Farm", Tab = tab, Callback = function(v) cfg.af = v end})
pcall(function() win:SelectTab(tab) end)

local knit = rs:WaitForChild("Packages", 5) and rs.Packages:WaitForChild("Knit", 5) and rs.Packages.Knit:WaitForChild("Services", 5)
local invS = knit and knit:FindFirstChild("InvasionService")
local tutS = knit and knit:FindFirstChild("TutorialService")

task.spawn(function()
	local stages = {"Ramil", "Desert_01", "Forest_01", "City_01"}
	
	while task.wait(1) do
		if not cfg.af or not invS then continue end
		
		pcall(function()
			if tutS then tutS.RE.CompleteStructuredTutorialStage:FireServer("Launch") end
			
			for _, stg in next, stages do
				invS.RF.RequestStartInvasion:InvokeServer(stg)
			end
			
			for _, d in next, rs.Invasion.Defenders:GetDescendants() do
				if d:IsA("Model") and d.Name:find("Defender") then
					invS.RE.Synchronize:FireServer(d.Name, 2)
				end
			end
			
			invS.RF.RequestStageClearance:InvokeServer(2)
		end)
	end
end)
