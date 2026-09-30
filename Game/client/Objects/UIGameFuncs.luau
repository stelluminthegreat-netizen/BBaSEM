local self = {}

---------------- Structure Cards
function self.CardFillUp(uiCard)
    uiCard.Instance.Icon.Image = uiCard.Image
    uiCard.Instance:FindFirstChild("Name").Text = uiCard.Name
end

function self.CardOnClicked(uiCard)
    uiCard.Conns["OnClicked"] = uiCard.Instance.MouseButton1Click:Connect(function()
        -- Close existing info UI
        local existingInfo = shared.Classes.UI.Objects.StructsFrame.ExistingInfo
        if existingInfo then existingInfo:Close() end


        local StructsFrame = shared.Classes.UI.Objects.StructsFrame
        local newInfo = shared.Classes.UI.new(uiCard.UI_InfoName)
        StructsFrame.ExistingInfo = newInfo
    end)
end

---------------- Structure Informations
function self.InfoFillUp(uiInfo)
    local information = uiInfo.Instance.Information
    information:FindFirstChild("Name").Text = uiInfo.Name
    information:FindFirstChild("Price").Text = uiInfo.Price
    information:FindFirstChild("Stats").Text = uiInfo.Stats
    information:FindFirstChild("Icon").Image = uiInfo.Image
end

return self

