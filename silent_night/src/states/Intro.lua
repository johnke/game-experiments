Intro = Gamestate.new()

font = love.graphics.newImageFont("imagefont.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\"")
love.graphics.setFont(font)

function Intro:enter(previous)
end

function Intro:leave()

end

function Intro:update(dt)

end

function Intro:draw()
  love.graphics.scale(2, 2)
  love.graphics.print("The night", 110, 100)
  love.graphics.print("the reindeer died", 100, 120)

end

return Intro
