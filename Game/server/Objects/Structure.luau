local TweenService = game:GetService("TweenService")
local self = {}
self.__index = self

function self.initialize()
	
end

function self.start()
	
end

function self:Animate()
    local compArr = {} -- Components array
    
    -- Segregate structure components with priority number
    -- and modify them to their pre-construct state
    for _, descendant in self.Instance:GetDescendants() do
        if not descendant:GetAttribute("PrioNum") then continue end

        local prioNum = descendant:GetAttribute("PrioNum")
        -- create secondary array based on
        -- prio num if it does not yet exist
        if compArr[prioNum] == nil then compArr[prioNum] = {} end

        compArr[prioNum][descendant] = {cf = descendant:GetPivot()}

        local targetCf = descendant:GetPivot() + Vector3.new(0, 5, 0)

        descendant:ScaleTo(0.1)
        descendant:PivotTo(targetCf)
    end

    -- Tween all components back to their original
    -- properties in order 
    for prio, comps in compArr do
        for comp, properties in comps do
            self:Tween(comp, properties)
        end
        task.wait(0.25)
    end


end

function self:Tween(comp, properties)
    shared.Classes.Threads:Spawn(function()
        -- Play woosh
        local sound = Instance.new("Sound", comp)
        sound.SoundId = "rbxassetid://135595810064855"
        sound:Play()
        
        -- tween to original scale
        local conn
        local numVal = Instance.new("NumberValue")
        numVal.Value = 0.1

        conn = numVal:GetPropertyChangedSignal("Value"):Connect(function()
            local num = numVal.Value
            comp:ScaleTo(num)
        end)

        local info = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local changes  = {Value = 1}
        local tween = TweenService:Create(numVal, info, changes)
        tween:Play()
        tween.Completed:Wait()
        conn:Disconnect()

        -- tween to original cframe
        local cfVal = Instance.new("CFrameValue")
        cfVal.Value = comp:GetPivot()

        conn = cfVal:GetPropertyChangedSignal("Value"):Connect(function()
            local cf = cfVal.Value
            comp:PivotTo(cf)
        end)

        info = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        changes = {Value = properties.cf}
        tween = TweenService:Create(cfVal, info, changes)
        tween:Play()
        tween.Completed:Wait()

        -- Audio effect
        sound:Destroy()
        sound = Instance.new("Sound", comp)
        sound.SoundId = "rbxassetid://9116541944"
        sound:Play()

        -- clean-up
        conn:Disconnect()
        cfVal:Destroy()
        numVal:Destroy()
        tween:Destroy()
        sound:Destroy()

    end)
end



return self
