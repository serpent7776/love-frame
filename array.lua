local array = {}

function array.tabulate(n, f)
	local tab = {}
	for i=1,n do
		tab[i] = f(i)
	end
	return tab
end

return array
