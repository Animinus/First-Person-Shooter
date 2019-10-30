repeat wait() until script.Parent.WeldModule

local player 	= game.Players.LocalPlayer
local ins	 	  = Instance.new
local Weld		= require(script.Parent.WeldModule)
local camera	= game.Workspace.CurrentCamera
local v3		= Vector3.new
local cf		= CFrame.new

local Rig = {}

Rig.Init = function()
	game:GetService("UserInputService").MouseIconEnabled = false 
	player.CameraMode	= Enum.CameraMode.LockFirstPerson
	local weldings		= Weld.new()
	
	local Base			  = ins("Part",camera)
	Base.TopSurface		= "Smooth"
	Base.BottomSurface= "Smooth"
	Base.FormFactor   = "Custom"
	Base.Size			    = v3(1,1,1)
	Base.Transparency	= 1
	Base.CanCollide		= true
	Base.Anchored		  = false
	local BaseWeld		= weldings.weldparts(player.Character.HumanoidRootPart,Base,cf(),cf(0,1.5,0))
	
	local Gun			    = game.Lighting["AK47"]:Clone()
	local GunWeld		  = weldings.weldparts(Base,Gun.Base)
	weldings.massweld(Gun.Base,Gun)
	Gun.Parent			  = camera
	
	local LeftArm		  = game.Lighting["LeftArm"]:Clone()
	LeftArm.Name		  = "Left Arm"
	LeftArm.Parent		= camera
	weldings.massweld(LeftArm.Base,LeftArm)
	local LeftArmWeld	= weldings.weldparts(Gun.Base,LeftArm.Base)
	
	local RightArm		= game.Lighting["RightArm"]:Clone()
	RightArm.Name		  = "Right Arm"
	RightArm.Parent		= camera 
	weldings.massweld(RightArm.Base,RightArm)
	local RightArmWeld= weldings.weldparts(Gun.Base,RightArm.Base)
	
	return Base,BaseWeld,Gun,GunWeld,LeftArm,LeftArmWeld,RightArm,RightArmWeld
end

return Rig
