local W, H

local lf = {
	_VERSION = '0.1.0',
	viewport_width = 0,
	viewport_height = 0,
}

function lf.setup_viewport(width, height)
	lf.viewport_width = width
	lf.viewport_height = height
end

function love.load()
	W, H = love.graphics.getPixelDimensions()
	lf.init()
end

function love.update(dt)
	lf.update(dt)
end

function love.draw()
	-- setup viewport
	love.graphics.scale(W / lf.viewport_width, H / lf.viewport_width)
	-- do actual drawing
	lf.draw()
end

return lf
