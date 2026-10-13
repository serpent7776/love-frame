local array = {}

function array.tabulate(n, f)
	local tab = {}
	for i=1,n do
		tab[i] = f(i)
	end
	return tab
end

-- removes every item for which f(item) is true, in place and keeping the order of the rest; f may
-- update the item as it goes. Returns the list.
function array.remove_if(list, f)
	local n = #list
	local j = 0
	for i = 1, n do
		local item = list[i]
		if not f(item) then
			j = j + 1
			list[j] = item
		end
	end
	for i = j + 1, n do
		list[i] = nil
	end
	return list
end

return array
