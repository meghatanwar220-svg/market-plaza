-- TableUtils.lua
-- Utility functions for table operations

local TableUtils = {}

-- Deep copy a table
function TableUtils:DeepCopy(tbl)
	if type(tbl) ~= "table" then return tbl end
	
	local copy = {}
	for key, value in pairs(tbl) do
		if type(value) == "table" then
			copy[key] = self:DeepCopy(value)
		else
			copy[key] = value
		end
	end
	return copy
end

-- Find element in table
function TableUtils:Find(tbl, value)
	for i, v in ipairs(tbl) do
		if v == value then return i end
	end
	return nil
end

-- Check if table contains value
function TableUtils:Contains(tbl, value)
	return self:Find(tbl, value) ~= nil
end

-- Get table size
function TableUtils:Size(tbl)
	local count = 0
	for _ in pairs(tbl) do
		count = count + 1
	end
	return count
end

return TableUtils
