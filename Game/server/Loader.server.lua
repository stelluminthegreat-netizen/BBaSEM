shared["Classes"] = {}

for index, descendant in script.Parent:GetDescendants() do
	if descendant.ClassName == "ModuleScript" then shared.Classes[descendant.Name] = require(descendant) end
end

for index, module in shared.Classes do if type(module.initialize) == "function" and index ~= "Libraries" then module.initialize() end end
for index, module in shared.Classes do if type(module.start) == "function" and index ~= "Libraries" then task.defer(module.start) end end
