local ObjectAndTableConverterService = {}

function ObjectAndTableConverterService.ValueToObject(v: number | string | boolean): ValueBase
	if type(v) == "string" then
		local stringValue = Instance.new("StringValue")
		stringValue.Value = v
		return stringValue
	elseif type(v) == "number" then
		local numberValue = Instance.new("NumberValue")
		numberValue.Value = v
		return numberValue
	elseif type(v) == "boolean" then
		local boolValue = Instance.new("BoolValue")
		boolValue.Value = v
		return boolValue
	end
end

function ObjectAndTableConverterService.TableToObject(t: { any }): Folder
	local folder = Instance.new("Folder")
	for key, value in pairs(t) do
		if type(value) ~= "table" then
			local newValue = ObjectAndTableConverterService.ValueToObject(value)
			newValue.Name = key
			newValue.Parent = folder
		else
			local newValue = ObjectAndTableConverterService.TableToObject(value)
			newValue.Name = key
			newValue.Parent = folder
		end
	end
	return folder
end

function ObjectAndTableConverterService.FolderToTable(folder: Folder): { any }
	local t = {}
	for _, v in ipairs(folder:GetChildren()) do
		if v.ClassName == "Folder" then
			t[v.Name] = ObjectAndTableConverterService.FolderToTable(v)
		else
			t[v.Name] = v.Value
		end
	end
	return t
end

return ObjectAndTableConverterService
