local cr     = coroutine.resume
local cc     = coroutine.create
local min    = math.min
local cf     = CFrame.new
local v3     = Vector3.new
local cfLerp = cf().lerp
local v3Lerp = v3().lerp
local tick   = tick
local wait   = wait
local Run    = game:GetService("RunService").RenderStepped

local Animations = {}
local Animation	 = {}
	
function Animation.Unpack(Data)
	local newAnimation = Animation.new()
	for i,v in pairs(Data) do
		for ii,vv in pairs(Data[i]) do
			if type(vv) == "table" then
				--print(unpack(vv))
				newAnimation.cfAnimationLerp(unpack(vv))
			elseif type(vv) == "number" then
				--print("Delay: "..(vv))
				wait(vv)
			elseif type(vv) == "string" then
				-- free fall physics, sound handling
			elseif type(vv) == "boolean" then
				-- weld mag to the hand
			end
		end
	end
end	
	
function Animation.new()
	return
	{
		lerpv3 = function(mx,tx,a) -- Start, Ending, Alpha
			return v3Lerp(mx,tx,a)
		end;
			
		lerpcf = function(mx,tx,a)
			return cfLerp(mx,tx,a)
		end;
			
		lerp = function(mx,tx,a)
			return mx+(tx-mx)*a
		end;
			
		cfAnimationLerp = function(obj,index,goal,t,a) -- obj, index, goal, time, step
			cr(cc(function()
				local Id = Animations[obj] and (1+Animations[obj])%50 or 1
				Animations[obj] = Id
				local Start = tick()
				local i = obj[index] -- initial
				local mx = 0
				local s = (a or .25)
				repeat
					if not obj or Animations[obj]			
					local Percent = min(1,(tick()-Start)/t)
					mx = mx+(Percent-mx)*(s)
					obj[index] = cfLerp(i,goal,mx)
					Run:wait()
				until a == 1 or not obj or Animations[obj] ~= Id
			end))
		end;	
	}		
end

return Animation
