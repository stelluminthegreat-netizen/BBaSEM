local class = {}
class.__index = class
local count = 0

	local self = setmetatable({}, class)
	return self
end

return class
