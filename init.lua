local W, H
local music
local sounds
local textures
local viewport_width
local viewport_height
local time_step
local time_acc

local lf = {
	_VERSION = '0.1.0',
}

local function preload_music(dir)
	music = {}
	local music_dir = dir .. '/music'
	local files = love.filesystem.getDirectoryItems(music_dir)
	for _, file in pairs(files) do
		local path = music_dir .. '/' .. file
		local m = love.audio.newSource(path, 'stream')
		m:setLooping(true)
		music[file] = m
	end
end

local function preload_sounds(dir)
	sounds = {}
	local sounds_dir = dir .. '/sounds'
	local files = love.filesystem.getDirectoryItems(sounds_dir)
	for _, file in pairs(files) do
		local path = sounds_dir .. '/' .. file
		sounds[file] = love.audio.newSource(path, 'static')
	end
end

local function preload_textures(dir)
	textures = {}
	local textures_dir = dir .. '/gfx'
	local files = love.filesystem.getDirectoryItems(textures_dir)
	for _, file in pairs(files) do
		local path = textures_dir .. '/' .. file
		textures[file] = love.graphics.newImage(path)
	end
end

local function preload_assets()
	local dir = 'assets/preload'
	preload_music(dir)
	preload_sounds(dir)
	preload_textures(dir)
end

function lf.setup_viewport(width, height)
	viewport_width = width
	viewport_height = height
end

function lf.get_music(file_name)
	return music[file_name]
end

function lf.get_sound(file_name)
	return sounds[file_name]
end

function lf.get_texture(file_name)
	return textures[file_name]
end

function love.load()
	W, H = love.graphics.getDimensions()
	viewport_width = 0
	viewport_height = 0
	time_step = 1 / 50
	time_acc = 0
	preload_assets()
	lf.init()
end

function love.update(dt)
	time_acc = time_acc + dt
	while time_acc >= time_step do
		time_acc = time_acc - time_step
		lf.update(time_step)
	end
end

function love.draw()
	-- setup viewport
	love.graphics.scale(W / viewport_width, H / viewport_width)
	-- do actual drawing
	lf.draw()
end

return lf
