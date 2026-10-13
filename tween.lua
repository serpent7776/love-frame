-- Drawing between update steps. Updates run at a fixed rate and drawing at the display's, so a
-- frame usually falls between two steps. Remember everything that moves at the start of each step
-- and draw it with at/lerp: each thing is shown that far along the way from where it was to where
-- it is. Motion stays smooth at any refresh rate, one step behind the simulation.
local tween = {
	alpha = 1, -- how far the frame being drawn is into the current step, 0 to 1; set by love-frame
}

-- a scalar, between its value at the start of the step and now
function tween.lerp(prev, cur)
	if not prev then return cur end
	return prev + (cur - prev) * tween.alpha
end

-- a clock: a jump back (restart, rewind) or further ahead than max_jump is shown as a jump
function tween.clock(prev, cur, max_jump)
	if not prev or cur < prev or cur - prev > (max_jump or 0.5) then return cur end
	return prev + (cur - prev) * tween.alpha
end

-- where to draw a moving thing this frame, from its x, y and the remembered px, py
function tween.at(o)
	if not o.px then return o.x, o.y end
	return o.px + (o.x - o.px) * tween.alpha, o.py + (o.y - o.py) * tween.alpha
end

-- remember where a thing (or every thing in a list) is at the start of a step
function tween.remember(o)
	o.px, o.py = o.x, o.y
end

function tween.remember_all(list)
	for i = 1, #list do
		local o = list[i]
		o.px, o.py = o.x, o.y
	end
end

-- put a thing somewhere without drawing it travelling there
function tween.place(o, x, y)
	o.x, o.y, o.px, o.py = x, y, x, y
end

return tween
