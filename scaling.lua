local scaling = {}

function scaling.stretch(src_w, src_h, dst_w, dst_h)
	return dst_w / src_w, dst_h / src_h
end

function scaling.fit(src_w, src_h, dst_w, dst_h)
	local sx = dst_w / src_w
	local sy = dst_h / src_h
	local scale = math.min(sx, sy)
	return scale, scale
end

return scaling
