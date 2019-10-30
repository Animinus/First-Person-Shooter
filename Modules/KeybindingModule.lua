local player 	   = game.Players.LocalPlayer
local mouse		   = player:GetMouse()
local character  = player.Character
local UIS		     = game:GetService("UserInputService")
local lower		   = string.lower 
local len		     = string.len 
local tick		   = tick 
local Gun 		   = require(script.Parent["AK47"])
local Animation  = require(script.Parent.AnimationModule)
local keybinding = {}

keybinding.Movement 			    = {}
keybinding.Movement.Forward		= false
keybinding.Movement.Backwards	= false
keybinding.Movement.Left		  = false
keybinding.Movement.Right		  = false
keybinding.Movement.Aim			  = false 
keybinding.Movement.Shoot		  = false 
keybinding.Movement.Action		= false

local binding = {}
	
function keybinding.Active()	
	binding["w"] = {
	(function()
		keybinding.Movement.Forward   = true
		keybinding.Movement.Backwards = false
	end),
	(function()
		keybinding.Movement.Forward	  = false
	end)} 
		
	binding["s"] = {
	(function()
		keybinding.Movement.Backwards   = true
		keybinding.Movement.Forward 	= false
	end),
	(function()
		keybinding.Movement.Backwards  = false
	end)}
		
	binding["a"] = {
	(function()
		keybinding.Movement.Left = true
		keybinding.Movement.Right = false
	end),
	(function()
		keybinding.Movement.Left = false
	end)}
		
	binding["d"] = {
	(function()
		keybinding.Movement.Right = true
		keybinding.Movement.Left = false
	end),
	(function()
		keybinding.Movement.Right = false
	end)}
	
	mouse.Button1Down:connect(function()
		local sequence = Gun.Shoot()
		--Animation.Unpack(sequence)
	end)
	
	mouse.Button2Down:connect(function()
		keybinding.Movement.Aim = true
	end)
	
	mouse.Button2Up:connect(function()
		keybinding.Movement.Aim = false
	end)

	UIS.InputChanged:connect(function(input,a,b)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			keybinding.iDx = input.Delta.x
			keybinding.iDy = input.Delta.y
			keybinding.nt = tick()
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			print("Shooting")
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			print("Aiming")
		end
	end)
		
	UIS.InputBegan:connect(function(Input)
		if keybinding.Movement.Active then
			local keyinput = tostring(Input.KeyCode):gsub("Enum.Keycode.","")
			local x
			if len(keyinput) > 1 then
				if not binding[keyinput] then
					return
				end
				x = binding[keyinput]
			else
				if not binding[lower(keyinput)] then
					return 
				end
				x = binding[lower(keyinput)]
			end
			if x then 
				if type(x) == "table" then 
					local Function = x[1]
					Function()
				else
					local Function = x
					Function()
				end
			end
		end 
	end)
		
	UIS.InputEnded:connect(function(Input)
		if keybinding.Movement.Active then
			local keyinput = tostring(Input.KeyCode):gsub("Enum.Keycode.","")
			local x
			if len(keyinput) > 1 then
				if not binding[keyinput] then
					return
				end
				x = binding[keyinput]
			else
				if not binding[lower(keyinput)] then
					return 
				end
				x = binding[lower(keyinput)]
			end
			if x then 
				if type(x) == "table" then 
					local Function = x[2]
					Function()
				else
					local Function = x
					Function()
				end
			end
		end 
	end)
end

return keybinding
