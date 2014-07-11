require "camera"

math.randomseed(os.time())
math.random()
math.random()
math.random()

debug = true

function love.load()
  camera.layers = {}

  screen_width = love.graphics.getWidth()
  screen_height = love.graphics.getHeight()

  world_width = 5000
  world_height = 1000

  ground = screen_height - 100

  rot_speed = 2

  plane = {}
  plane.image = love.graphics.newImage("planex1.png")
  plane.image_width = plane.image:getWidth()
  plane.image_height = plane.image:getHeight()
  plane.x = 50
  plane.y = ground
  plane.rot = 0
  plane.xvel = 0
  plane.yvel = 0
  plane.speed = 0
  plane.maxspeed = 6
  plane.accel = 6
  -- gravity = 1.5
  plane.state = "landed"
  plane.scale = 0.25
  plane.yoffset = 0
  plane.xoffset = 0
  plane.fuel = 100



  crash = {}
  crash.x = 0
  crash.y = 0
  crash.image = love.graphics.newImage("explosion.png")

  plane.shots = {}


  -- foods_image = love.graphics.newImage("foods.png")
  food = ""
  chicken = love.graphics.newImage("chicken.png")
  pizza = love.graphics.newImage("pizza.png")
  burger = love.graphics.newImage("hamburger.png")


  food = {}
  food.rot = 0
  food.rot_speed = 4
  bullet_speed = 8


  background_image = love.graphics.newImage("sky-background.png")
  background_image:setWrap("repeat", "clamp")
  background_quad = love.graphics.newQuad( 0, 0, world_width + (screen_width / 2), background_image:getHeight(), background_image:getWidth(), background_image:getHeight() )

  max_scale = 2
  gravity = 0.5
  grass_image = love.graphics.newImage("grass.png")
  ground_image = love.graphics.newImage("ground.png")


  fuel = {}
  fuel.bg = love.graphics.newImage("fuel-bg.png")
  fuel.fg = love.graphics.newImage("fuel.png")
  fuel.text = love.graphics.newImage("fuel-text.png")

end


function love.keyreleased(key)
  if plane.state ~= "crash" and (key == " ") then
    shoot()
  end
end


function love.update(dt)
  if plane.state == "crash" then
    plane.xvel = 0
    plane.yvel = 0
    plane.speed = 0
    plane.image = explosion
    plane.scale = 2
    crash.x = plane.x + 230
    crash.y = plane.y + 50
  end

  if love.keyboard.isDown("left") and plane.state ~= "landed" and plane.state ~= "crash" then
    plane.rot = plane.rot - (dt * rot_speed)
  elseif love.keyboard.isDown("right") and plane.state ~= "landed" and plane.state ~= "crash" then
    plane.rot = plane.rot + (dt * rot_speed)
  end

  local remShot = {}

  for i, v in ipairs(plane.shots) do
    v.x = v.x + v.xvel
    v.y = v.y + v.yvel
    if v.y < -(world_height)  then
      table.insert(remShot, i)
    end

    if v.x < 0 then
      table.insert(remShot, i)
    end
    if v.y > ground + 50 then
      table.insert(remShot, i)
    end

    v.food_rot = v.food_rot + (food.rot_speed * dt)
  end

  for i, v in ipairs(remShot) do
    table.remove(plane.shots, v)
  end

  if plane.rot > 6.3 or plane.rot < -6.3 then
    plane.rot = 0
  end
  if plane.speed > 4 then
    plane.state = "takeoff"
  end
  rot_deg = plane.rot * 57

  if love.keyboard.isDown("up") and plane.state ~= "crash" then
    if plane.speed < plane.maxspeed then
      plane.speed = plane.speed + (dt * plane.accel)
    end
  end

  if love.keyboard.isDown("down") then
    if plane.speed > 2 then
      plane.speed = plane.speed - (dt * plane.accel)
    end
  end


  if plane.speed > 0 then
    plane.xvel = plane.speed * math.cos(plane.rot)
    plane.yvel = plane.speed * math.sin(plane.rot)
    if plane.y > ground then
      plane.y = ground
      plane.yvel = 0
      if plane.state == "takeoff" then
        plane.state = "crash"
      end
    end
  end

  plane.x = plane.x + plane.xvel
  plane.y = plane.y + plane.yvel
  if plane.x > screen_width / 2 and plane.x < world_width then
    camera.x = plane.x - screen_width / 2
  end
  if plane.y < screen_height / 2 and plane.y > (screen_height - world_height) then
    camera.y = plane.y - screen_height / 2
  end

  plane.fuel = plane.fuel - (dt * 2)

end


function love.draw()
  camera:set()
  love.graphics.draw(background_image, background_quad, 0, -800)

  for i,v in ipairs(plane.shots) do
    love.graphics.draw(v.food_type, v.x, v.y, v.food_rot, 1, 1, v.food_type:getWidth() / 2, v.food_type:getHeight() / 2)
  end

  if plane.state == "crash" then
    love.graphics.draw(crash.image, crash.x, crash.y, 0, plane.scale, plane.scale, plane.image_width/2, plane.image_height/2)
  else
    love.graphics.draw(plane.image, plane.x + plane.xoffset, plane.y + plane.yoffset, plane.rot, plane.scale, plane.scale, plane.image_width/2, plane.image_height/2)
  end

  for x = -24, (screen_width * 2) + 24, 24 do
    love.graphics.draw(grass_image, x, ground + 24)
  end
  for y = ground + 48, screen_height + 24, 24 do
    for x = -24, (screen_width * 2) + 24, 24 do
      love.graphics.draw(ground_image, x, y)
    end
  end

  camera:unset()
  if debug == true then
    love.graphics.print("FPS: " .. love.timer.getFPS(), 2, 2)
  end

  --[[ HUD ]]
  love.graphics.draw(fuel.text, screen_width - 120, 7)
  love.graphics.draw(fuel.bg, screen_width - 120, 20)
  -- love.graphics.quad(fuel.fg, screen_width - 117, 23, screen_width - 107, 23, screen_width - 117, 38, screen_width - 107, 38)
  love.graphics.rectangle("fill", screen_width - 117, 23, plane.fuel, 15)

end

function shoot()
  local shot = {}
  shot.rot = plane.rot
  shot.food_rot = plane.rot
  food_type = math.random(3)
  if food_type == 1 then
    shot.food_type = chicken
    shot.food_speed = 8
  elseif food_type == 2 then
    shot.food_type = pizza
    shot.food_speed = 10
  elseif food_type == 3 then
    shot.food_type = burger
    shot.food_speed = 9
  end
  shot.x = plane.x
  shot.y = plane.y

  shot.xvel = shot.food_speed * math.cos(shot.rot)
  shot.yvel = shot.food_speed * math.sin(shot.rot)
  table.insert(plane.shots, shot)
end
