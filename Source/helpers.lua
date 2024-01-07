function contains(table, item)
	for i,v in ipairs(table) do
		if (v==item) then
			return true
		end
	end
	return false
end

function containsKey(key)
	for k, v in pairs(table) do
		if (k==key) then
			return true
		end
	end
	return false
end

function clear(table)
	for k, v in pairs(table) do
		table[k] = nil
	end
end