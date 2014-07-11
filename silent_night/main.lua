-- some shortcuts to love2D function tables
L = love
LG = love.graphics

local current_gamestate

require 'libs.slam.slam'

-- load libs
require("libs.strict")
require("libs.strict_override")
require("libs.pimplove")
tween = require("libs.tween.tween")
Gamestate = require("libs.hump.gamestate")

-- additional libs
gui = require("libs.Quickie")
timer = require("libs.hump.timer")
-- HC = require("libs.HardonCollider")

-- Global res tables (loaded in load)
Shader = nil
Img = nil
SFX = nil
State = {}


local function recursiveRequire(folder, tree)
    local tree = tree or {}
    for i,file in ipairs(love.filesystem.enumerate(folder)) do
        local filename = folder.."/"..file
        -- print(filename)
        if love.filesystem.isDirectory(filename) then
            recursiveRequire(filename)
        else
            require(filename:gsub(".lua",""))
        end
    end
    return tree
end



function love.load()
	recursiveRequire("src/states")
	-- update and draw manually
	Gamestate.registerEvents({})
    
	Img = require("src.res.images")
	Shader = require("src.res.shaders")
	SFX = require("src.res.sfx")


	Gamestate.switch(Game)

end

function love.update(dt)
	tween.update(dt)
	Gamestate.update(dt)
end

function love.draw()
	Gamestate.draw()
end
