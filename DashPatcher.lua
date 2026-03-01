-- DashPatcher.lua
-- Загружается через HttpGet из главного скрипта
-- Возвращает таблицу с функциями: { runAttack, scan, enable, disable }

local LocalPlayer = game:GetService("Players").LocalPlayer

local function scanLuaFunction(funcname)
    if not getgc then return nil end
    local ok1, targetScript = pcall(function()
        return LocalPlayer:WaitForChild("PlayerScripts",5)
            :WaitForChild("Combat",5)
            :WaitForChild("Dash",5)
    end)
    if not ok1 or not targetScript then return nil end
    for _, v in pairs(getgc(true)) do
        if typeof(v) == "function" then
            local ok2, scr = pcall(function() return getfenv(v).script end)
            if ok2 and scr == targetScript then
                local ok3, info = pcall(function() return debug.getinfo(v) end)
                if ok3 and info and info.name == funcname then return v end
            end
        end
    end
    return nil
end

local lkPunchAnimation = nil
local lkVfx = nil

local function dashPatcherRunAttack(p_u_105, p_u_106, p107, p108)
   local v_u_1 = require(game.ReplicatedStorage:WaitForChild("Core"))
   local v109 = v_u_1.Services.Camera.CFrame
   local v110 = os.clock()
   local v_u_111 = tostring(v110)
   local v112 = 0
   local v_u_113 = 0
   local v_u_114 = 0
   local v_u_115 = 0
   local v_u_116, v_u_117, v_u_118, v_u_119, v_u_120
   local v121, v122
   local v_u_13, v_u_12 = false, false

   local function v_u_135(p123, p124, p125, p126, p127)
    local v128 = v_u_1.Get("Combat", "Ragdoll").GetRagdollFrame(p123)
    local v129 = v_u_1.Get("Character", "FullCustomReplication").GetCFrame(p_u_105)
    local v130 = v_u_1.Get("Character", "FullCustomReplication").GetCFrame(p123)
    local v131 = not p125
    if not v131 then
     if v129 and v130 then
      local v132 = p124 + v129.Position.Y - v130.Position.Y
      v131 = math.abs(v132) < p125
     end
    end
    local v133 = not p126
    if v133 then v128 = v133
    elseif v128 then v128 = v128.Velocity.Y < 0 end
    local v134 = not p127
    if v134 then v130 = v134
    elseif v129 and v130 then v130 = v130.Position.Y > v129.Position.Y end
    if v131 then
     if not v128 then v130 = v128 end
    else v130 = v131 end
    v_u_120 = v130
    return v_u_120
   end

   local function v140(p136, p137)
    local v138 = v_u_1.Get("Combat", "Ragdoll").GetRagdollFrame(p136)
    local v139 = v_u_1.Get("Combat", "Ragdoll").UpVelocities[p136]
    if v138 then
     if v138.Velocity.Y < 0 and v139 then
      v139 = v139 > 1 and p137.CollisionGroup ~= "NoCharacterCollisions"
     else v139 = false end
    end
    return v139
   end

   local function v148(p141, p142, p143)
    if v_u_1.Library("Instance").Exists(p_u_106) then
     local v144, v145 = v_u_1.Get("Combat", "Hit").Box(nil, p_u_105, {
      Size = p141, Offset = p142, IgnoreJump = true, IgnoreRagdolls = "Ground",
      IgnoreKnockback = true, NoBaseValidation = true, RequireInFront = true,
      BlockHitsThroughWalls = true, CustomValidation = p143
     })
     v_u_117, v_u_116 = v144, v145
     local v146, v147 = v_u_1.Get("Combat", "Hit").Box(nil, p_u_105, {
      Size = p141, Offset = p142, IgnoreJump = true, IgnoreRagdolls = "Ground",
      IgnoreKnockback = true, RequireInFront = true,
      BlockHitsThroughWalls = true, CustomValidation = p143
     })
     v_u_119, v_u_118 = v146, v147
     return #v_u_116 > 0
    end
   end

   local v_u_149, v150, v151, v152 = v_u_119, v_u_114, v_u_113, v122
   local v_u_153, v_u_154, v155 = v_u_120, v121, nil

   local function v159(p156, p157)
    local v158 = not p156:GetAttribute("Ragdoll") or v_u_135(p156, 2, 0.25, true)
    if v158 then v158 = p157.CollisionGroup ~= "NoCharacterCollisions" end
    return v158
   end

   while true do
    task.wait()
    local v160 = v_u_1.Services.Camera.CFrame
    local _, v161, _ = v109:ToOrientation()
    local _, v162, _ = v160:ToOrientation()
    local v163 = v161 - v162
    local v164 = math.deg(v163)
    if v164 > 180 then v164 = v164 - 360
    elseif v164 < -180 then v164 = v164 + 360 end

    v112 = v112 + v164
    v_u_113 = math.max(v151, v112)
    v_u_114 = math.min(v150, v112)
    v_u_115 = os.clock() - v110
    local v165 = p107 - v_u_115

    if v_u_115 > 0.2125 then
     v121 = v148(Vector3.new(1, 1, 1), CFrame.new(0, 7.5, -0.5), v140)
     v155 = v121 or v148(Vector3.new(5, 5, 4.5), CFrame.new(0, 0, -2), v159)
     v_u_154 = v121
    end

    if v155 or p108 < v_u_115 then
     local v_u_166 = v165 > 0 and true or v152
     local v167 = v155 or v148(Vector3.new(7.5, 5, 7), CFrame.new(0, 0, -2.75), v159)
     if v167 then
      v_u_1.Get("Character", "Move").SetJumpOverride("DashPunch", 0)
      task.delay(0.5, v_u_1.Get("Character", "Move").SetJumpOverride, "DashPunch", nil)
     end

     local function v188()
      local v182 = {
       Guarantees = v_u_149,
       Replace = function(p168)
        local v169 = v_u_1.Get("Combat", "Knockback").CharacterPresets[p168] == "Uppercut" and 0.375 or 0.2625
        local ok1, v170 = pcall(function() return v_u_1.Get("Combat", "Ragdoll").GetRagdoll(p168) end)
        if not ok1 then v170 = nil end
        local ok2, v170Frame = pcall(function() return v_u_1.Get("Combat", "Ragdoll").GetRagdollFrame(p168) end)
        if not ok2 then v170Frame = nil end
        local attrRagdoll = false
        if p168 and p168.GetAttribute then
         pcall(function() attrRagdoll = p168:GetAttribute("Ragdoll") end)
        end
        local isRagdolled = (v170 ~= nil) or (v170Frame ~= nil) or (attrRagdoll == true)
        local v172 = nil
        local ok4, gotCFrame = pcall(function() return p168 and v_u_1.Get("Character", "FullCustomReplication").GetCFrame(p168) end)
        if ok4 and gotCFrame then
         local tmp = p_u_106.CFrame:PointToObjectSpace(gotCFrame.Position)
         local v174 = tmp.X * 180 / 2
         v172 = p_u_106.CFrame * CFrame.Angles(0, math.rad(-math.clamp(v174, -180, 180)), 0)
        end
        local hasKB = false
        if p168 and p168.GetAttribute then
         local okKB, kbVal = pcall(function() return p168:GetAttribute("Knockback") end)
         if okKB and kbVal then hasKB = true end
        end
        if isRagdolled then
         return { ActionNumbers = {2, 6}, ForceDirection = v172 }
        end
        if v_u_115 < v169 then
         if p168 and p168.SetAttribute then
          pcall(function() p168:SetAttribute("Knockback", false) end)
         end
         return { ActionNumbers = {1, 6}, ForceDirection = nil }
        end
        local v179
        if v_u_113 - v_u_114 > 180 then
         v179 = not v170 or v_u_135(p168, 0, 2, nil, true)
        else v179 = false end
        local v180 = false
        local v181 = v_u_166
        if v181 then v181 = not v170 end
        if v180 then
         if v170 then v170 = v_u_154 end
        else v170 = v180 end
        if v180 then v180 = not v170 end
        if v_u_115 >= v169 then
         pcall(function()
          if p168 and p168.SetAttribute then p168:SetAttribute("Knockback", false) end
         end)
        end
        local pick = 1
        if hasKB then pick = 5
        elseif v181 then pick = 4
        elseif v180 then pick = 3
        elseif v170 then pick = 2
        else pick = 1 end
        return { ActionNumbers = { pick, 6 }, ForceDirection = v181 and v172 }
       end,
       UseFromCFrame = v_u_166 and p_u_106.CFrame * CFrame.new(0, 0, -2) or nil
      }

      task.wait(0.15)
      v_u_12 = true
      local v183, v184, _, _, v185 = v_u_1.Get("Combat", "Action").Event(nil, p_u_105, "PunchDash", v_u_111, v182, 0)
      if v183 then
       if lkVfx then lkVfx("DashHit", v183, p_u_106.Position) end
       v_u_1.Get("Camera", "Shake").Shake(nil, nil, {
        Amplitude = 1.25, Frequency = 0.0875, FadeInTime = 0.025, FadeOutTime = 0.5
       }, nil, p_u_105, table.unpack(v184))
      end
      local v186 = false
      for _, v187 in pairs(v185 and (v185.BlockedCharacters or {}) or {}) do
       if not table.find(v185.HitCharacters, v187) then v186 = true end
      end
      v_u_13 = v186
      v_u_12 = false
     end

     task.spawn(v188)
     if v165 > 0 then
      v_u_1.Services.Run.Heartbeat:Wait()
      task.wait(v165 + 0.025)
     end
     if lkPunchAnimation then task.spawn(lkPunchAnimation, p_u_105, v_u_111) end
     return v165 > 0, v167
    end
    v150, v151, v109 = v_u_114, v_u_113, v160
   end
end

-- Возвращаем таблицу для главного скрипта
return {
    runAttack = dashPatcherRunAttack,
    scan = scanLuaFunction,
    getPunchAnim = function() return lkPunchAnimation end,
    getVfx = function() return lkVfx end,
    setPunchAnim = function(v) lkPunchAnimation = v end,
    setVfx = function(v) lkVfx = v end,
}
