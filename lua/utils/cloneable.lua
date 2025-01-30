local Cloneable = {}

local function is_clonable(obj)
	if type(obj) ~= "table" then
		return false
	end

	if type(obj["clone"]) == "function" then
		return true
	end

	local mt = getmetatable(obj)

	if mt and type(mt.__index == "table") then
		return is_clonable(mt)
	end
end

function Cloneable:clone()
	local clone = {}

	clone.__index = self.__index
	setmetatable(clone, getmetatable(self))

	for key, value in pairs(self) do
		if is_clonable(value) then
			clone[key] = value:clone()
		else
			clone[key] = value
		end
	end

	return clone
end

return Cloneable
