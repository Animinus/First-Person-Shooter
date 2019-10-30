repeat wait() until game.Players.LocalPlayer.Character
repeat wait() until script.Modules

local player		= game.Players.LocalPlayer
local camera		= game.Workspace.CurrentCamera
local stepped		= game:GetService("RunService").RenderStepped
local character	= player.Character

local tick			= tick 
local cf			  = CFrame.new
local cfA			  = CFrame.Angles
local fAA			  = CFrame.fromAxisAngle
local v3			  = Vector3.new 
local inverse		= cf().inverse
local atan			= math.atan 
local atan2			= math.atan2 
local asin			= math.asin
local cos			  = math.cos 
local sin			  = math.sin 
local rad 			= .017453292519943
local deg 			= 57.295779513082
local pi 			  = 3.1415926535898
local tau			  = 6.2831853071796

local Weld			= require(script.Modules.WeldModule)
local Keybinding= require(script.Modules.KeybindingModule)
local Animation	= require(script.Modules.AnimationModule)
local Physics		= require(script.Modules.PhysicsModule)
local Rig			  = require(script.Modules.RigModule)
local GunA			= require(script.Modules["AK47"])

local motion		     = 5/6
local lt 			      = tick()
local framerate,dt	= 0,0
local springlerp	  = Animation.new()
local aimlerp		    = cf()

--Setup Sway 
local psx,psy	= Physics.newspring(),Physics.newspring()
local sx,sy		= 0,0
psx.Impulse(10)
psy.Impulse(10)

local xTilt		= Physics.newspring()
xTilt.Impulse(10)

local function updatesway(dt)
	local nt = Keybinding.nt
	if tick()-nt>.0085 then
		Keybinding.iDx = 0
		Keybinding.iDy = 0
	end
	
	psx.Target(.2*Keybinding.iDx,.5,12.5+dt)
	psy.Target(.2*Keybinding.iDy,.5,12.5+dt)
	sx	= psx.p()
	sy	= psy.p()
	return sx,sy
end

--Main Code
local function runframerate()
	local nt  = tick()
	dt        = nt-lt
	framerate = .95*framerate+.05/dt
	lt        = nt 
	return dt,framerate
end

local SmoothSpeed = 0
local function walkanimation(dt)
	SmoothSpeed	= SmoothSpeed*.9+(character.HumanoidRootPart.Velocity*v3(1,0,1)).magnitude*.1
	local offset= SmoothSpeed/16
	local aim 	= Keybinding.Movement.Aim
	
	local x = (cos(time()*7)/20*offset)
	local y = (sin((time())*14)/20*offset)
	local z = (cos(cos(time()*7/20))/20*offset)

	local walk = cf((aim and x*.8 or x),(aim and y*.8 or y),(aim and z*.8 or z))
	return walk
end

local Base,BaseWeld,Gun,GunWeld,LeftArm,LeftArmWeld,RightArm,RightArmWeld = Rig.Init()
Keybinding.Active()

LeftArmWeld.C0  = GunA.LeftHand
RightArmWeld.C0 = GunA.RightHand

stepped:connect(function()
	local dt		    = runframerate()
	local aim		    = Keybinding.Movement.Aim
	local forward	  = Keybinding.Movement.Forward
	local backward	= Keybinding.Movement.Backward
	local left		  = Keybinding.Movement.Left
	local right		  = Keybinding.Movement.Right
	
	local xTiltLogic = (right and -1 or left and 1 or 0)
	xTilt.Target(xTiltLogic,.35,7.5+dt)
	
	local sx,sy = updatesway(dt)
	local walk  = walkanimation(dt)
	aimlerp 	  = springlerp.lerpcf(aimlerp,(aim and cf(-.5,.2,.2) or cf()),.2+dt) 
	
	BaseWeld.C0 = cf(0,1.5,0)
	*cfA(asin(camera.CoordinateFrame.lookVector.Y),0,0)
	*GunA.Offset
	*walk
	*aimlerp
	*cfA(0,pi,0)
	*cfA(.125*-sy*rad,.125*sx*rad,.8*sx*rad)
	*cfA(0,.35*xTilt.p()*rad,21.8*xTilt.p()*rad)
	
	GunWeld.C0 = cf(0,0,-(camera.CoordinateFrame.lookVector.Y)/10)
	
end)
