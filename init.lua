local scale = require((...) .. '/scaling')

local initial_window_width, initial_window_height
local window_width, window_height
local music, current_music
local sounds
local textures
local viewport_width
local viewport_height
local viewport_scaling = scale.fit
local time_step
local time_acc
local game_time
local prefs
local data = {}
local screens = {}
local current_screen

local max_vol = 100

local lf = {
	_VERSION = '0.4.0',
}

local empty_screen = {
	update = function(_)
	end,
	draw = function()
	end,
}

local function default_prefs()
	return {
		music_vol = max_vol,
		sound_vol = max_vol,
	}
end

local function read_prefs()
	local fname = 'prefs'
	if not love.filesystem.getInfo(fname) then
		return false
	end
	for line in love.filesystem.lines(fname) do
		local var, val = string.match(line, '^([%a_]*)%s*=%s*([%a%d]*)$')
		if prefs[var] ~= nil then
			prefs[var] = val
		end
	end
	return true
end

local function preload_music(dir)
	music = {}
	local music_dir = dir .. '/music'
	local files = love.filesystem.getDirectoryItems(music_dir)
	for _, file in pairs(files) do
		local path = music_dir .. '/' .. file
		local m = love.audio.newSource(path, 'stream')
		m:setLooping(true)
		m:setVolume(prefs.music_vol / max_vol)
		music[file] = m
	end
end

local function preload_sounds(dir)
	sounds = {}
	local sounds_dir = dir .. '/sounds'
	local files = love.filesystem.getDirectoryItems(sounds_dir)
	for _, file in pairs(files) do
		local path = sounds_dir .. '/' .. file
		local s = love.audio.newSource(path, 'static')
		s:setVolume(prefs.sound_vol / max_vol)
		sounds[file] = s
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

function lf.setup_viewport(width, height, scaling)
	viewport_width = width
	viewport_height = height
	viewport_scaling = scaling or scale.fit
end

function lf.toggle_fullscreen()
	local switching_to_windowed = love.window.getFullscreen()
	local switching_to_fullscreen = not switching_to_windowed
	love.window.setFullscreen(switching_to_fullscreen, 'desktop')
	if switching_to_windowed then
		love.window.setMode(initial_window_width, initial_window_height)
		window_width = initial_window_width
		window_height = initial_window_height
	end
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

function lf.load_font(file_name, font_size)
	return love.graphics.newFont('assets/fonts/' .. file_name, font_size)
end

function lf.play_music(file_name)
	if current_music then
		current_music:stop()
	end
	current_music = music[file_name]
	current_music:play()
	return current_music
end

function lf.stop_music()
	if current_music then
		current_music:stop()
	end
end

function lf.play_sound(file_name)
	local sound = sounds[file_name]
	sound:play()
	return sound
end

function lf.screens()
	return screens
end

function lf.current_screen()
	return current_screen
end

function lf.add_screen(name, screen)
	screens[name] = screen
end

function lf.load_screen(name, path)
	local m = require(path)
	m.load()
	lf.add_screen(name, m)
end

function lf.switch_to(new_scene)
	if current_screen.hide then
		current_screen.hide()
	end
	current_screen = new_scene
	if current_screen.show then
		current_screen.show()
	end
end

function lf.data(new_data)
	data = new_data or data
	return data
end

function lf.game_time()
	return game_time
end

function love.load()
	initial_window_width, initial_window_height = love.graphics.getDimensions()
	window_width = initial_window_width
	window_height = initial_window_height
	viewport_width = window_width
	viewport_height = window_height
	time_step = 1 / 50
	time_acc = time_step
	game_time = 0
	prefs = default_prefs()
	read_prefs()
	preload_assets()
	current_screen = empty_screen
	lf.init()
end

function love.resize(w, h)
	window_width = w
	window_height = h
	if lf.resize then
		lf.resize(w, h)
	end
end

function love.update(dt)
	game_time = game_time + dt
	time_acc = time_acc + dt
	while time_acc >= time_step do
		time_acc = time_acc - time_step
		lf.update(time_step)
	end
end

function love.draw()
	-- setup viewport
	local sx, sy = viewport_scaling(viewport_width, viewport_height, window_width, window_height)
	love.graphics.scale(sx, sy)
	-- do actual drawing
	lf.draw()
end

return lf
