local tick  = tick
local cos	= math.cos 
local sin	= math.sin
local e		= 2.718281828459045

local physics = {}

function physics.newspring()
	local c0,c1 = 0,0
	local ti	  = tick()
	local d,s	  = 1,1
	local pf	  = 0
	local cd	  = 0
		
	local function Position()
		local sx = s*(tick()-ti)
		if d == 1 then return (c0+c1*sx)/e^sx+pf
			else return (c0*cos(cd*sx)+c1*sin(cd*sx))/e^(d*sx)+pf
		end
	end
		
	local function Velocity()
		local sx = s*(tick()-ti)
		if d == 1 then return (c1*(s-sx)-c0)/e^sx
			else return s*((cd*c1-c0*d)*cos(cd*sx)-(cd*c0+c1*d)*sin(cd*sx))/e^(d*sx)
		end
	end
		
	return
	{
		Target = function(PF,D,S)
			S = S or s 
			local pi = Position()
			local vi = Velocity()/S
			d  = D or d
			ti = tick()
			pf = PF 
			c0 = pi-pf
			if d == 1 then
				c1 = vi+c0
			else
				cd = (1-d*d)^.5
				c1 = (vi+c0*d)/cd
			end
			s = S
		end;
			
		Impulse = function(v)
			local pi = Position()
			local vi = (Velocity()+v)/s 
			ti = tick()
			c0 = pi-pf 
			if d == 1 then
				c1 = vi+c0
			else
				cd = (1-d*d)^.5
				c1 = (vi+c0*d)/cd
			end
		end;
			
		p = Position;
		v = Velocity;
	}
end

return physics
