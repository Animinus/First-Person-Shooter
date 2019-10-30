local ins     = Instance.new 
local cf      = CFrame.new 
local inverse = cf().inverse

local weld = {}

function weld.new()
	return
	{
		weldparts = function(pA,pB,c0,c1,name)
			local weld 	= ins("Motor6D")
			weld.Part0	= pA
			weld.Part1	= pB
			weld.C0		  = c0 or cf()
			weld.C1		  = c1 or cf()
			weld.Name	  = name or "Weld"
			weld.Parent	= pA
			return weld
		end;
		
		massweld = function(base,model)
			for i,v in pairs(model:GetChildren()) do
				if v.ClassName == "Part" or v.ClassName == "UnionOperation" then
					local weld 	= ins("Motor6D")
					weld.Part0	= base 
					weld.Part1	= v 
					weld.C1		  = inverse(v.CFrame)*base.CFrame
					weld.Parent	= base
					v.Anchored	= false 
				end
			end
		end;
	}
end

return weld
