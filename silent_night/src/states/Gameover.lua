--
--  Game
--


Gameover = Gamestate.new()

local color = { 255, 255, 255, 0 }

local center = {
    x = love.graphics.getWidth() / 2, 
    y = love.graphics.getHeight() / 2
}

local bigFont   =   love.graphics.newFont(32)
local smallFont =   love.graphics.newFont(16)

function Gameover:enter()
    tween(2, color, { 255, 255, 0, 255 }, 'outExpo' )
end

function Gameover:update( dt )
    timer.update(dt)
    if gui.Button{text = "Go back"} then
        timer.clear()
        Gamestate.switch(Menu)
    end
end

function Gameover:draw()
    love.graphics.setFont(bigFont)
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", 0, 0, center.x*2, color[4])
    love.graphics.print("You lost.", center.x, center.y)
    love.graphics.setFont(smallFont)
    gui.core.draw()
end