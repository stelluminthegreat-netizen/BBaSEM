local self = {}

function self.initialize()
	self.Cash = 1
end

function self:IncrementCash(n: number)
    local check = self.Cash + n
    if check <= 0 then return false end
    
    self.Cash += n
    return true
end

function self:Replicate()
    
end

return self
