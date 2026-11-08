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
        local whoosh = game.ReplicatedStorage.ToClone.Server.Sound.Whoosh:Clone()
        whoosh.Parent = comp:FindFirstChildWhichIsA("BasePart")
        whoosh:Play()
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
        local clank = game.ReplicatedStorage.ToClone.Server.Sound.Clank:Clone()
        clank.Parent = comp:FindFirstChildWhichIsA("BasePart")
        clank:Play()

        -- Spark effect
        local spark = game.ReplicatedStorage.ToClone.Server.Particles.Spark:Clone()
        spark.Parent = comp
        spark.Position = Vector3.zero
        spark.Spark:Emit(100)

        
        -- Highlight effect
        local highlight = Instance.new("Highlight", comp)
        highlight.FillColor = Color3.new(0, 255, 0)
        highlight.FillTransparency = 1

        local in_change = {FillTransparency = 0.9}
        local out_change = {FillTransparency = 1}
        info = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        tween = TweenService:Create(highlight, info, in_change)
        
        tween:Play()
        tween.Completed:Wait()

        tween:Destroy()
        tween = TweenService:Create(highlight, info, out_change)
        tween:Play()
        tween.Completed:Wait()
        highlight.OutlineTransparency = 1

        task.wait(0.5)


        -- clean-up
        conn:Disconnect()
        cfVal:Destroy()
        numVal:Destroy()
        tween:Destroy()
        clank:Destroy()
        spark:Destroy()
        highlight:Destroy()
        whoosh:Destroy()


    end)
end



return self
