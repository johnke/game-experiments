Game = Gamestate.new()
joystick_dead_zone = 0.25
button_already_pressed = false
reindeersWentBaa = false
called_reindeers = false
sleighbell_playing = false

show_map = false
dist_z = 0
distance = 0

has_moved = false
reindeers_saved = 0
angle_diff = 0

distance_win = 15
footsteps_already_playing = false

player = {}
player.x = 600
player.z = 500
player.rot = 0
player.move_speed = 0.7
player.turn_speed = 0.05
player.moving = false

traveled = {}

p1ud = 0
p1lr = 0
left_joystick = 0
right_joystick = 0
dx = 0
dz = 0
atan2 = 0


reindeers = {}

sleighbells = love.audio.newSource("audio/sleighbells_single.ogg", "static")
so_cold = love.audio.newSource("audio/so_cold.ogg", "static")
breathing_1 = love.audio.newSource("audio/breathing_1.ogg", "static")

footstep = love.audio.newSource("audio/footstep.ogg", "static")
reindeers_1 = love.audio.newSource("audio/reindeers_1.ogg", "static")
reindeers_2 = love.audio.newSource("audio/reindeers_2.ogg", "static")
reindeers_3 = love.audio.newSource("audio/reindeers_3.ogg", "static")
reindeers_4 = love.audio.newSource("audio/reindeers_4.ogg", "static")

footstep:setVolume(0.2)

wind = love.audio.newSource("audio/wind.ogg", "stream")
wind:setLooping(true)
wind:setVolume(0.05)
love.audio.play(wind)

local sleighbell
santa = love.graphics.newImage("santa.png")
local color = { 255, 255, 255, 0 }


function addReindeer(x, z, is_rudolph)
   reindeers[#reindeers+1] = {x=x, z=z, is_rudolph=is_rudolph}
end


function Game:enter(previous)
  local i = 0
  -- addReindeer(300, 150)
  reindeers.x = math.random(love.graphics.getWidth())
  reindeers.z = math.random(love.graphics.getHeight())
  so_cold:setVolume(0.3)
  timer.add(2, function() so_cold:play() end)
  timer.addPeriodic(4, function() breathing_1:play() end)
  sleighbell = sleighbells:play()
  sleighbell:setLooping(true)
  sleighbell:setVolume(3)
end

function Game:leave()

end


function check_saved()
  if player.x > reindeers.x - distance_win and player.x < reindeers.x + distance_win and player.z > reindeers.z  - distance_win and player.z < reindeers.z + distance_win then
    if reindeers_saved < 8 then
      reindeers.x = math.random(love.graphics.getWidth())
      reindeers.z = math.random(love.graphics.getHeight())
      reindeers_saved = reindeers_saved + 1
    end
  end
end


function Game:update(dt)
  timer.update(dt)
  handleInput(dt)
  tween.update(dt)
  check_saved()
  calculate_angle_distance()
end

function calculate_angle_distance()
  local dist_x = 0
  local dz = player.z - reindeers.z
  local dx = player.x - reindeers.x
  distance = math.sqrt(dx * dx + dz * dz)
  local angle = (math.atan2(dz, dx) * 180 / math.pi) - 180

  if player.rot > 6.3 or player.rot < -6.3 then
    player.rot = 0
  end

  local player_rot_deg = math.deg(player.rot)
  angle_diff = angle - player_rot_deg
  if angle_diff <= 0 and angle_diff >= 180 then
    angle_diff = -180 + (math.abs(angle_diff) - 180)
  end
  if angle_diff >=0 and angle_diff <= -180 then
    angle_diff = 180 - (math.abs(angle_diff) - 180)
  end
  dist_z = angle_diff
end


function Game:draw()
  if not sleighbell_playing then
    sleighbell_playing = true
    sleighbell:setPosition(dist_z, 0, distance)
  else
    sleighbell_playing = false
  end

  love.graphics.setBackgroundColor(255, 255, 255)
  if show_map then
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(santa, player.x, player.z, player.rot, 1, 1, 15, 15)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", reindeers.x, reindeers.z, 4)
    love.graphics.setColor(255, 0, 0)
  end
end


function call_reindeer()
  if not called_reindeers then
    called_reindeers = true
    local reindeer_sound = math.random(4)
    if reindeer_sound == 1 then
      local instance = reindeers_1:play()
      instance:setVolume(0.3)
    elseif reindeer_sound == 2 then
      local instance = reindeers_2:play()
      instance:setVolume(0.3)
    elseif reindeer_sound == 3 then
      local instance = reindeers_3:play()
      instance:setVolume(0.3)
    else
      local instance = reindeers_4:play()
      instance:setVolume(0.3)
    end
  else
    called_reindeers = false
  end
end


function handleInput(dt)
  right_joystick = love.joystick.getAxis(1, 3)
  left_joystick = love.joystick.getAxis(1, 2)
  if right_joystick >= -joystick_dead_zone and right_joystick <= joystick_dead_zone then
    right_joystick = 0
  end
  if left_joystick >= -joystick_dead_zone and left_joystick <= joystick_dead_zone then
    left_joystick = 0
  end

  if left_joystick ~= 0 then
    local player_x_vel = player.move_speed * math.cos(player.rot)
    local player_z_vel = player.move_speed * math.sin(player.rot)
    player.moving = true
    if not has_moved then
      has_moved = true
      footstep:play()
      timer.add(0.7, function() has_moved = false end)
    end
    if left_joystick > 0 then
      player.x = player.x - player_x_vel
      player.z = player.z - player_z_vel
    else
      player.x = player.x + player_x_vel
      player.z = player.z + player_z_vel
    end
  end

  if right_joystick ~= 0 then
    player.moving = true
    player.rot = player.rot + (right_joystick * player.turn_speed)
  end

  if left_joystick == 0 and right_joystick == 0 then
    player.moving = false
  end

end

function love.keyreleased(key)
  if key == "m" then
    if not show_map then
      show_map = true
    else
      show_map = false
    end
  end
end

return Game
