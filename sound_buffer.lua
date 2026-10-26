local modules = (...):gsub('/[^/]+$', '') .. "/"
local array = require(modules .. 'array')

local buffer = {}

local function cloneSound(sound)
	return function(_)
		return sound:clone()
	end
end

function buffer.new(size, sound)
	local sounds = array.tabulate(size, cloneSound(sound))
	local current = 1
	return {
		play_next = function()
			local s = sounds[current]
			s:stop()
			s:play()
			current = (current + 1) % size + 1
			return s
		end,
	}
end

return buffer
