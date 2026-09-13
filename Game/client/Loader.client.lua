while not shared.Loaded do
	task.wait()
end

shared["GameClasses"] = {}

for index, descendant in script.Parent:GetDescendants() do
	if descendant.ClassName == "ModuleScript" then shared.GameClasses[descendant.Name] = require(descendant) end
end

for index, module in shared.GameClasses do if type(module.initialize) == "function" and index ~= "Libraries" then module.initialize() end end
for index, module in shared.GameClasses do if type(module.start) == "function" and index ~= "Libraries" then task.defer(module.start) end end
