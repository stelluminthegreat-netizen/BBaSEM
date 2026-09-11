local self = {}

function self.initialize()
	self.Cash = 0
end

function self:IncrementCash(n: number)
    local check = self.Cash + n
    if check <= 0 then print("EEENNGGKK") return false end
    self.Cash += n
    print(self.Cash)
end

function self:Replicate()
    
end

return self
