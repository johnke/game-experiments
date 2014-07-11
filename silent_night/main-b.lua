    dist_x = v.x - player.x
    dist_z = v.z - player.z
    local dz = player.z - v.z
    local dx = player.x - v.x
    local angle = (math.atan2(dz, dx) * 180 / math.pi) - 180
    -- print("DIST", dist_x, dist_z)
    print("PLAYER_ROT", math.deg(player.rot))
    print("ANGLE", angle)
    local angle_diff = angle - math.deg(player.rot)
    dist_x = (angle - math.deg(player.rot)) * 1.1
    if dist_x >= 180 and dist_x <= 360 then
      dist_x = 180 - math.abs(dist_x - 180)
    end
    print("angle_diff", angle_diff)
    -- dist_z = angle * 
    -- local instance = sleighbells:play()
    -- sleighbells:setPosition(dist_x, 0, dist_z)
    local instance = sleighbells:play()
    instance:setPosition(dist_z, 0, dist_x)
  end
