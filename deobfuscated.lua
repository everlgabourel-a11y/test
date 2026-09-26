local replicatedStorage = game:GetService("ReplicatedStorage")
local debris = game:GetService("Debris")
local virtualInputManager = game:GetService("VirtualInputManager")
local guiService = game:GetService("GuiService")

local function helper()
  local function helper2(val2, val, val3)
    if val > val3 then
      return
    end

    return val2[val], helper2(val2, val + 1, val3)
  end

  return function(p4) return helper2(p4[1], 1, p4[2]) end
end

local function closureFactory()
  local val4, val5, val6 = type, getmetatable, pairs

  return function(p5, p6, p7)
    if val4(p5) ~= "function" then
      local element = val5(p5)

      if element ~= nil and element.__iter ~= nil then
        return element.__iter(p5)
      elseif (element and element.__call) == nil and val4(p5) == "table" then
        return val6(p5)
      end
    end

    return p5, p6, p7
  end
end

return ({
  function(p8, p9)
    return function()
      return p9[1][2][p9[1][1]](
        p9[2][2][p9[2][1]].REACT, p9[2][2][p9[2][1]].ForceOf("lowdiveL")
      ) + p9[2][2][p9[2][1]].TOUCH
    end
  end, function(p10, p11)
    return function()
      local character = p11[1][2][p11[1][1]].Character
      local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")

      if not humanoidRootPart then
        return
      end

      local val7 = os.clock()

      if val7 < p11[2][2][p11[2][1]].armUntil and p11[2][2][p11[2][1]].ball
        and p11[2][2][p11[2][1]].ball.Parent == p11[3][2][p11[3][1]]
        and p11[2][2][p11[2][1]].target then
        local ball, networkOwner = p11[2][2][p11[2][1]].ball, p11[2][2][p11[2][1]].ball:FindFirstChild("NetworkOwner")

        if networkOwner and networkOwner.Value == p11[1][2][p11[1][1]] then
          p11[2][2][p11[2][1]].owned = true
        elseif p11[2][2][p11[2][1]].owned then
          p11[2][2][p11[2][1]].armUntil, p11[2][2][p11[2][1]].ball = 0, nil
          return
        else
          p11[4][2][p11[4][1]](ball)
          return
        end

        if (ball.Position - p11[2][2][p11[2][1]].target).Magnitude
            <= p11[2][2][p11[2][1]].ARRIVE
          or p11[2][2][p11[2][1]].nrm
            and (ball.Position - p11[2][2][p11[2][1]].target):Dot(p11[2][2][p11[2][1]].nrm) <= 0 then
          p11[2][2][p11[2][1]].armUntil = 0
          return
        end

        local curveForce = ball:FindFirstChild("CurveForce")

        local agFinesse = curveForce ~= nil and curveForce:IsA("BodyForce")
          and p11[5][2][p11[5][1]].agStyle == "Legit" and p11[5][2][p11[5][1]].agFinesse

        for v6, v7 in ball:GetChildren() do
          if v7.Name ~= "SummitGuide" and (v7 ~= curveForce or not agFinesse)
            and (v7:IsA("BodyVelocity") or v7:IsA("BodyForce")) then
            v7:Destroy()
          end
        end

        local val8 = p11[6][2][p11[6][1]](ball)
        local target = p11[2][2][p11[2][1]].target

        if p11[5][2][p11[5][1]].agStyle ~= "Legit" and p11[2][2][p11[2][1]].startD > 1 then
          local element2 = p11[2][2][p11[2][1]].target - ball.Position
          local magnitude = Vector3.new(element2.X, 0, element2.Z).Magnitude
          local val9 = math.clamp(1 - magnitude / p11[2][2][p11[2][1]].startD, 0, 1)

          if val9 < p11[2][2][p11[2][1]].GATE and p11[5][2][p11[5][1]].agCurve > 0
            and p11[2][2][p11[2][1]].side < 1 then
            local val10 = math.min(
              p11[5][2][p11[5][1]].agCurve, p11[2][2][p11[2][1]].startD * p11[2][2][p11[2][1]].DFAC
            ) * (1 - p11[2][2][p11[2][1]].side * 0.6)

            target = target
              + p11[2][2][p11[2][1]].bend
                * (val10 * math.sin(math.pi * (val9 / p11[2][2][p11[2][1]].GATE)))
          end

          if p11[2][2][p11[2][1]].side > 0.15 and p11[2][2][p11[2][1]].lat0 > 4 then
            local val11 = math.min(p11[2][2][p11[2][1]].OUT * p11[2][2][p11[2][1]].side
              * p11[2][2][p11[2][1]].side, p11[2][2][p11[2][1]].startD * p11[2][2][p11[2][1]].OUTFAC)

            local val12 = math.abs((ball.Position - p11[2][2][p11[2][1]].target):Dot(p11[2][2][p11[2][1]].ax))
              / p11[2][2][p11[2][1]].lat0

            target = target + p11[2][2][p11[2][1]].nrm * (val11 * math.clamp(
              (val12 - (1 - p11[2][2][p11[2][1]].OUTGATE)) / p11[2][2][p11[2][1]].OUTGATE, 0, 1
            ))
          end
        end

        local element3 = target - ball.Position
        local vector = Vector3.new(element3.X, 0, element3.Z)
        local magnitude2 = vector.Magnitude

        if magnitude2 < 1 then
          return
        end

        local unit = vector.Unit

        if p11[5][2][p11[5][1]].agStyle == "Legit" then
          if p11[2][2][p11[2][1]].launched then
            return
          end

          p11[2][2][p11[2][1]].launched = true
          local assemblyLinearVelocity = ball.AssemblyLinearVelocity

          local speed = p11[2][2][p11[2][1]].speed > 1 and p11[2][2][p11[2][1]].speed
            or assemblyLinearVelocity.Magnitude

          local magnitude3 = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z).Magnitude

          local val13 = magnitude3 > 0.001 and math.atan(assemblyLinearVelocity.Y / magnitude3)
            or 0

          local maxelev = p11[2][2][p11[2][1]].root(speed, val8, magnitude2, element3.Y)

          if not maxelev or maxelev > p11[2][2][p11[2][1]].MAXELEV then
            maxelev = val13

            if maxelev > p11[2][2][p11[2][1]].MAXELEV then
              maxelev = p11[2][2][p11[2][1]].MAXELEV
            end
          end

          if agFinesse and maxelev > p11[2][2][p11[2][1]].FINESSE_ELEV then
            maxelev = p11[2][2][p11[2][1]].FINESSE_ELEV
          end

          if agFinesse then
            local getMass = ball:GetMass()
            local zero = getMass > 0 and curveForce.Force / getMass or Vector3.zero

            for i = 1, 2 do
              local val14 = speed * math.cos(maxelev)

              if val14 < 1 then
                break
              end

              local val15 = magnitude2 / val14
              local val16 = math.min(val15, 1)
              local element4 = zero * (val16 * val16 * 0.5 + val16 * math.max(0, val15 - val16))
              target = p11[2][2][p11[2][1]].target - Vector3.new(element4.X, 0, element4.Z)
              element3 = target - ball.Position
              vector = Vector3.new(element3.X, 0, element3.Z)
              magnitude2 = vector.Magnitude

              if magnitude2 < 1 then
                return
              end

              unit = vector.Unit
              local val17 = p11[2][2][p11[2][1]].root(speed, val8, magnitude2, element3.Y)

              if val17 and val17 <= p11[2][2][p11[2][1]].MAXELEV then
                maxelev = val17
              end

              if maxelev > p11[2][2][p11[2][1]].FINESSE_ELEV then
                maxelev = p11[2][2][p11[2][1]].FINESSE_ELEV
              end
            end

            p11[2][2][p11[2][1]].guideBall, p11[2][2][p11[2][1]].guideTarget = ball, p11[2][2][p11[2][1]].target
            p11[2][2][p11[2][1]].guideUntil = val7 + p11[2][2][p11[2][1]].HOLD
          end

          ball.AssemblyLinearVelocity = unit * (speed * math.cos(maxelev))
            + Vector3.new(0, speed * math.sin(maxelev), 0)

          return
        end

        local val18 = math.atan(element3.Y / magnitude2)
        local agPower = p11[5][2][p11[5][1]].agPower
        local val19 = math.max(p11[2][2][p11[2][1]].POWER * p11[2][2][p11[2][1]].BOOST, agPower)

        if p11[2][2][p11[2][1]].vlock > 1 then
          agPower = p11[2][2][p11[2][1]].vlock
        end

        local maxelev2 = p11[2][2][p11[2][1]].root(agPower, val8, magnitude2, element3.Y)

        if not maxelev2 then
          agPower = math.min(math.max(agPower, 1.03 * math.sqrt(math.max(
            0, val8 * (element3.Y + math.sqrt(element3.Y * element3.Y + magnitude2 * magnitude2))
          ))), val19)

          maxelev2 = p11[2][2][p11[2][1]].root(agPower, val8, magnitude2, element3.Y)
            or 2578.3100780887044
        end

        if p11[2][2][p11[2][1]].vlock <= 1
          and p11[5][2][p11[5][1]].agPower >= p11[2][2][p11[2][1]].POWER
          and maxelev2 > val18 + p11[2][2][p11[2][1]].LOFT then
          local val20 = val18 + p11[2][2][p11[2][1]].LOFT
          local val21 = 2 * math.cos(val20) * math.cos(val20) * (magnitude2 * math.tan(val20) - element3.Y)

          local val22 = val21 > 0.001 and math.sqrt(val8 * magnitude2 * magnitude2 / val21) * 1.02
            or nil

          if val22 and val22 <= val19 then
            agPower, maxelev2 = math.max(val22, agPower), val20
          elseif val22 then
            agPower = val19
            maxelev2 = p11[2][2][p11[2][1]].root(agPower, val8, magnitude2, element3.Y) or maxelev2
          end
        end

        if p11[2][2][p11[2][1]].vlock <= 1 and maxelev2 > p11[2][2][p11[2][1]].MAXELEV then
          local val23 = math.cos(p11[2][2][p11[2][1]].MAXELEV)

          local val24 = 2 * val23 * val23
            * (magnitude2 * math.tan(p11[2][2][p11[2][1]].MAXELEV) - element3.Y)

          local val25 = val24 > 0.001 and math.sqrt(val8 * magnitude2 * magnitude2 / val24) * 1.02
            or nil

          if val25 and val25 <= val19 then
            agPower, maxelev2 = math.max(val25, agPower), p11[2][2][p11[2][1]].MAXELEV
          end
        end

        p11[2][2][p11[2][1]].launched = true

        if p11[2][2][p11[2][1]].vlock <= 1 then
          p11[2][2][p11[2][1]].vlock = agPower
        end

        ball.AssemblyLinearVelocity = unit * (agPower * math.cos(maxelev2))
          + Vector3.new(0, agPower * math.sin(maxelev2), 0)

        return
      end

      local shoot = character:FindFirstChild("Shoot") ~= nil

      for j = 1, #p11[7][2][p11[7][1]] do
        local parent = p11[7][2][p11[7][1]][j]

        if parent and parent.Parent then
          local magnitude4 = parent.AssemblyLinearVelocity.Magnitude
          local val26 = p11[2][2][p11[2][1]].lastV[parent]
          p11[2][2][p11[2][1]].lastV[parent] = magnitude4

          if shoot
            and val26
            and val7 >= p11[2][2][p11[2][1]].nxt
            and magnitude4 - val26 >= p11[2][2][p11[2][1]].STRIKE
            and (parent.Position - humanoidRootPart.Position).Magnitude
              <= p11[2][2][p11[2][1]].NEAR then
            local element5, element6, val27 = p11[2][2][p11[2][1]].aim(humanoidRootPart, parent.Position)

            if element5 then
              p11[2][2][p11[2][1]].speed, p11[2][2][p11[2][1]].owned, p11[2][2][p11[2][1]].launched, p11[2][2][p11[2][1]].vlock = magnitude4, false, false, 0
              p11[2][2][p11[2][1]].ball, p11[2][2][p11[2][1]].target, p11[2][2][p11[2][1]].nrm = parent, element5, val27

              local rightVector = element6.CFrame.RightVector
              p11[2][2][p11[2][1]].ax = Vector3.new(rightVector.X, 0, rightVector.Z).Unit
              local vector2 = Vector3.new(element5.X - parent.Position.X, 0, element5.Z - parent.Position.Z)

              p11[2][2][p11[2][1]].startD = vector2.Magnitude

              p11[2][2][p11[2][1]].side = p11[2][2][p11[2][1]].startD > 0.001
                  and math.clamp(1 + vector2.Unit:Dot(val27), 0, 1)
                or 0

              p11[2][2][p11[2][1]].lat0 = math.abs((parent.Position - element5):Dot(p11[2][2][p11[2][1]].ax))

              p11[2][2][p11[2][1]].bend = p11[2][2][p11[2][1]].ax
                * ((parent.Position - element6.Position):Dot(p11[2][2][p11[2][1]].ax) >= 0 and 1 or -1)

              p11[2][2][p11[2][1]].armUntil, p11[2][2][p11[2][1]].nxt = val7
                + p11[2][2][p11[2][1]].HOLD, val7 + 1.2

              return
            end
          end
        end
      end
    end
  end, function(p12, p13)
    return function(p14)
      local val28 = 34
      local val29, val30, gb, rep, val31

      while true do
        if val28 < 116 then
          if val28 <= 53 then
            if val28 > 34 then
              val30, val31, rep, gb = p14, ".....", p13[4][2][p13[4][1]], p12:Gb({ p13[3], p13[1], p13[2] })
              rep = rep(val30, val31, gb)
              val31, gb = 1, 0
              gb = val29 > gb
              val28 = gb and 229 or val28 + 40
            else
              rep, val30 = #p14, 5
              val29, rep = rep % val30, 0
              val28 = val29 > rep and 179 or 53
            end
          else
            val28 = gb and 116 or 339 - val28
          end
        elseif val28 <= 229 then
          if val28 >= 179 then
            if val28 > 179 then
              local val32
              val28, val32 = 21297 / val28, 5 - val29

              gb, val32 = -val32, 1
              gb = gb - val32
            else
              val28, rep, val31 = 232 - val28, "~", 5

              rep, val30, val31 = rep.rep, rep, val31 - val29
              rep = rep(val30, val31)

              p14 = p14 .. rep
            end
          else
            rep, val30 = rep.sub, rep
            rep = p12.c(rep(val30, val31, gb))
            return p12.d(rep)
          end
        else
          val28, gb = 28536 / val28, -1
        end
      end
    end
  end, function(p15, p16)
    return function(p17, at)
      return {
        T = table.clone(p17.T), P = table.clone(p17.P), Count = p17.Count, At = at, Land = p17.Land, LandT = p17.LandT, }
    end
  end, function(p18, p19)
    return function(p20)
      for v40, v41 in p19[1][2][p19[1][1]] do
        local element7 = p19[2][2][p19[2][1]].ModuleOf(p20, v41)

        if element7 and element7.State and (element7.State.hasBall or element7.State.attemptingCatch) then
          return true
        end
      end

      return false
    end
  end, function(p21, p22)
    return function(p23, p24, p25)
      local x, z = p23.X, p23.Z
      local val33, val34 = p24.X - x, p24.Z - z
      local val35 = val33 * val33 + val34 * val34
      local val36 = 0

      if val35 > 1e-9 then
        val36 = ((p25.X - x) * val33 + (p25.Z - z) * val34) / val35

        if val36 < 0 then
          val36 = 0
        elseif val36 > 1 then
          val36 = 1
        end
      end

      local val37, val38 = x + val33 * val36 - p25.X, z + val34 * val36 - p25.Z
      return p22[1][2][p22[1][1]](val37 * val37 + val38 * val38)
    end
  end, function(p26, p27)
    return function(p28)
      local element8 = p27[1][2][p27[1][1]].Keybinds()

      if not element8 then
        return nil
      end

      local val39, element9 = p27[2][2][p27[2][1]](element8.GetKey, element8, "GK", p28)

      if val39 and typeof(element9) == "EnumItem" and element9.EnumType == Enum.KeyCode
        and element9 ~= Enum.KeyCode.Unknown then
        return element9
      end

      return nil
    end
  end, function(p29, p30, p31, p32)
    p29.gc[p32] = p29.a(p30, 49222) + p31
    return p29.gc[p32]
  end, function(p33, p34)
    return function(p35, p36, p37, p38)
      local val40, val41, val42, val43, val44, val45, val46 = p34[1][2][p34[1][1]](p35, p36, p37)
      local val47, huge = nil, math.huge

      for v60, v61 in p34[2][2][p34[2][1]].Balls() do
        local element10 = v61.Position - val40
        local magnitude5 = element10.Magnitude

        if v61 ~= p38 and v61.Parent and magnitude5 < huge and math.abs(element10:Dot(val42)) <= val43
          and math.abs(element10:Dot(val41)) <= val46 and element10.Y <= val45 and element10.Y >= -val44
          and not v61:FindFirstChildOfClass("AlignPosition") then
          val47, huge = v61, magnitude5
        end
      end

      return val47
    end
  end, function(p39, p40)
    return function(p41, ...)
      if p40[1][2][p40[1][1]] then
        pcall(p40[1][2][p40[1][1]], 2)
      end

      return p40[2][2][p40[2][1]](pcall(p41, ...))
    end
  end, function(p42, p43)
    return function()
      if not p43[1][2][p43[1][1]] then
        return
      end

      if os.clock() < p43[2][2][p43[2][1]] then
        return
      end

      local element11 = table.remove(p43[1][2][p43[1][1]], 1)

      if not element11 then
        p43[3][2][p43[3][1]]()
        return
      end

      if element11.nosprint then
        p43[4][2][p43[4][1]]()
      elseif element11.forcesprint then
        p43[5][2][p43[5][1]](true)
      elseif element11.sprint then
        p43[5][2][p43[5][1]]()
      elseif element11.key then
        p43[6][2][p43[6][1]].pressSkill(element11.key)
      elseif element11.skill then
        p43[7][2][p43[7][1]](element11.skill)
      end

      p43[2][2][p43[2][1]] = os.clock() + (element11.wait or 0)

      if #p43[1][2][p43[1][1]] == 0 then
        p43[3][2][p43[3][1]]()
      end
    end
  end, function(p44, p45)
    return function(p46)
      local val48 = p45[1][2][p45[1][1]]()
      p45[2][2][p45[2][1]]:Flush(val48)
      local val49, val50, val51 = p45[3][2][p45[3][1]].Body()

      if not val49 then
        p45[4][2][p45[4][1]].Threat, p45[4][2][p45[4][1]].Trace, p45[4][2][p45[4][1]].Catch = nil, nil, nil
        return
      end

      p45[5][2][p45[5][1]]:Update(val48, p46, val49, val50, val51)
      p45[6][2][p45[6][1]](val48, val49)
      p45[7][2][p45[7][1]](val49, val50, val48)

      local val52 = p45[3][2][p45[3][1]].Armed(val49, val50) and not p45[3][2][p45[3][1]].Holding(val49)

      if not val52 then
        p45[4][2][p45[4][1]].Threat, p45[4][2][p45[4][1]].Catch = nil, nil

        if not p45[8][2][p45[8][1]].gkTracer then
          p45[4][2][p45[4][1]].Trace = nil
          return
        end
      end

      if val48 < p45[9][2][p45[9][1]] then
        return
      end

      p45[9][2][p45[9][1]] = math.max(
        p45[9][2][p45[9][1]] + 0.016666666666666666, val48 - 0.016666666666666666
      )

      local val53 = p45[3][2][p45[3][1]].Goal(val50, p45[10][2][p45[10][1]]
        or p45[3][2][p45[3][1]].Balls()[1])

      p45[4][2][p45[4][1]].Goal = val53
      local val54 = p45[3][2][p45[3][1]].ShotTunables()
      local diving, boxes, assemblyLinearVelocity2, val55 = p45[11][2][p45[11][1]].Diving, nil, nil, nil

      if p45[8][2][p45[8][1]].autoCatch and val52 then
        if diving then
          boxes, assemblyLinearVelocity2 = p45[5][2][p45[5][1]]:Boxes(val49, val50), val50.AssemblyLinearVelocity
        else
          boxes, assemblyLinearVelocity2, val55 = p45[5][2][p45[5][1]].CatchBox, p45[5][2][p45[5][1]].Velocity, p45[5][2][p45[5][1]]
        end
      end

      local val56, huge2, val57, val58 = nil, math.huge, 0, nil
      local val59, huge3 = nil, math.huge
      local val60, huge4, val61 = nil, math.huge, nil

      for v78, v79 in p45[3][2][p45[3][1]].Balls() do
        local element12 = p45[12][2][p45[12][1]][v79]

        if not element12 or element12.Count == 0 or v79:FindFirstChildOfClass("AlignPosition") then
          continue
        end

        local magnitude6 = (v79.Position - val50.Position).Magnitude

        if magnitude6 < huge3 then
          val59, huge3 = v79, magnitude6
        end

        local val62 = p45[13][2][p45[13][1]](v79, element12, val54, val53)

        if val62 == 0 then
          continue
        end

        local val63 = p45[14][2][p45[14][1]](val62)

        if val63 and p45[15][2][p45[15][1]][1].EndT < huge2 then
          val56, huge2 = v79, p45[15][2][p45[15][1]][1].EndT
        end

        local networkOwner2 = v79:FindFirstChild("NetworkOwner")

        if boxes
          and (val63 or not (networkOwner2 and networkOwner2.Value == p45[16][2][p45[16][1]])) then
          local val64, val65, val66 = p45[17][2][p45[17][1]].BoxContact(
            p45[15][2][p45[15][1]][1], val50.CFrame, assemblyLinearVelocity2, boxes, element12.Surface.Radius, 1.2, val55
          )

          if val64 and val65 >= 0 and val64 < huge4 then
            val60, huge4, val61 = v79, val64, val66
          end
        end
      end

      p45[4][2][p45[4][1]].Idle = val59

      if val60 then
        local val67 = (diving or val61.Y >= 32.285) and "catchhigh" or "catchlow"
        local val68 = p45[3][2][p45[3][1]].CatchReady(val49, val67)

        if val68 or p45[3][2][p45[3][1]].CatchBusy(val49) then
          if val68
            and huge4
              <= p45[2][2][p45[2][1]]:Expect(p45[5][2][p45[5][1]].Frame)
                + p45[5][2][p45[5][1]].Frame
                + math.max(0.016666666666666666, p45[5][2][p45[5][1]].Frame)
            and not p45[2][2][p45[2][1]]:Busy(val48, p45[5][2][p45[5][1]].Frame) then
            p45[18][2][p45[18][1]](val49, val67, val48)
          end
        else
          val60 = nil
        end
      end

      p45[4][2][p45[4][1]].Catch = val60

      if not val56 then
        p45[10][2][p45[10][1]], p45[4][2][p45[4][1]].Threat = nil, nil

        if p45[8][2][p45[8][1]].gkTracer and val59 and p45[12][2][p45[12][1]][val59]
          and p45[13][2][p45[13][1]](val59, p45[12][2][p45[12][1]][val59], val54, val53) > 0 then
          p45[4][2][p45[4][1]].Trace = p45[19][2][p45[19][1]](p45[15][2][p45[15][1]][1], val48)
        else
          p45[4][2][p45[4][1]].Trace = nil
        end

        return
      end

      p45[10][2][p45[10][1]] = val56
      val57, val58 = p45[13][2][p45[13][1]](val56, p45[12][2][p45[12][1]][val56], val54, val53)
      local element13 = p45[15][2][p45[15][1]][1]

      p45[4][2][p45[4][1]].Trace = p45[8][2][p45[8][1]].gkTracer
          and p45[19][2][p45[19][1]](element13, val48)
        or nil

      if not val52 then
        p45[4][2][p45[4][1]].Threat = nil
        return
      end

      local crossT, crossAt = p45[20][2][p45[20][1]].Crossing(element13, val53, val50.Position)

      p45[4][2][p45[4][1]].Threat = {
        Path = { T = table.clone(element13.T), P = table.clone(element13.P), Count = element13.Count }, At = val48, Cross = element13.Cross, Ball = val56, CrossT = crossT, CrossAt = crossAt, Held = val56 == val60, }

      p45[21][2][p45[21][1]](
        val48, diving and "Diving" or val60 and "Catch" or "Watching", val58, val57
      )
    end
  end, function(p47, p48)
    return function(p49, p50, p51)
      local val69 = p51 * p51
      local val70, val71, val72, val73

      for k = 1, #p48[1][2][p48[1][1]] do
        local position = p48[1][2][p48[1][1]][k].Position
        local val74, val75, val76 = position.X - p49.X, position.Y - p49.Y, position.Z - p49.Z
        local val77 = val74 * val74 + val75 * val75 + val76 * val76

        if val77 <= val69 then
          if not val73 or val77 < val73 then
            val72, val73 = p48[1][2][p48[1][1]][k], val77
          end

          local val78 = math.sqrt(val77)

          if val78 < 0.001 or (val74 * p50.X + val75 * p50.Y + val76 * p50.Z) / val78 > 0.25 then
            if not val71 or val77 < val71 then
              val70, val71 = p48[1][2][p48[1][1]][k], val77
            end
          end
        end
      end

      return val70 or val72
    end
  end, function(p52, p53)
    return function(p54, p55)
      if not p54 then
        return nil
      end

      local element14, val79

      for m = 1, #p53[1][2][p53[1][1]] do
        local magnitude7 = (p53[1][2][p53[1][1]][m].Position - p54).Magnitude

        if not val79 or magnitude7 < val79 then
          element14, val79 = p53[1][2][p53[1][1]][m], magnitude7
        end
      end

      if not element14 then
        return nil
      end

      local pointToObjectSpace = element14.CFrame:PointToObjectSpace(p54)
      local val80, val81 = element14.Size.X * 0.5, element14.Size.Y * 0.5
      local safe = p55 or p53[2][2][p53[2][1]].SAFE
      local val82, val83 = val80 - safe, val81 - p53[3][2][p53[3][1]].barSafe

      if val82 <= 0 or val83 <= -val81 then
        return nil
      end

      if math.abs(pointToObjectSpace.X) > val82 or pointToObjectSpace.Y > val83
        or pointToObjectSpace.Y < -val81 then
        return nil
      end

      local val84 = math.clamp((pointToObjectSpace.Y + val81) / (val83 + val81), 0, 1)
      local val85 = math.clamp(math.abs(pointToObjectSpace.X) / val82, 0, 1)
      return val84 * 0.45 + val85 * 0.3 + val84 * val85 * 0.25, pointToObjectSpace.Y
    end
  end, function(p56, p57)
    return function(p58, p59)
      if not (p58 and p58.Parent) then
        return false
      end

      if p59 then
        return true
      end

      for v107, v108 in p58:GetChildren() do
        if v108:IsA("BodyVelocity") then
          v108:Destroy()
        end
      end

      p58.AssemblyAngularVelocity = Vector3.zero

      local bodyVelocity = Instance.new("BodyVelocity")
      bodyVelocity.Name = p57[1][2][p57[1][1]].HOLDN
      bodyVelocity.MaxForce = Vector3.new(1000000, 0, 1000000)
      bodyVelocity.Velocity = Vector3.zero
      bodyVelocity.Parent = p58

      return true
    end
  end, function(p60, p61)
    return function()
      local trace, val86 = p61[1][2][p61[1][1]].Trace, os.clock()

      if not trace or val86 - trace.At > 0.4 or trace.Count < 2 then
        p61[2][2][p61[2][1]].Last = nil
        p61[2][2][p61[2][1]].Hide()
        return
      end

      if trace == p61[2][2][p61[2][1]].Last then
        return
      end

      p61[2][2][p61[2][1]].Last = trace
      local t, p, count, land = trace.T, trace.P, trace.Count, trace.Land
      local val87, val88 = val86 - trace.At, 1

      if land and trace.LandT <= val87 then
        land = nil
      end

      while val88 < count - 1 and t[val88 + 1] <= val87 do
        val88 = val88 + 1
      end

      local val89 = t[val88 + 1] - t[val88]

      p61[3][2][p61[3][1]][1] = p[val88]:Lerp(p[val88 + 1], val89 > 0
          and math.clamp((val87 - t[val88]) / val89, 0, 1)
        or 0)

      local val90 = 1

      for n = val88 + 1, count do
        if land and t[n] >= trace.LandT then
          break
        end

        if (n - val88) % 2 == 0 or n == count then
          val90 = val90 + 1
          p61[3][2][p61[3][1]][val90] = p[n]

          if val90 >= 72 then
            break
          end
        end
      end

      if land then
        val90 = val90 + 1
        p61[3][2][p61[3][1]][val90] = land
      end

      for i6 = val90 + 1, #p61[3][2][p61[3][1]] do
        p61[3][2][p61[3][1]][i6] = nil
      end

      p61[2][2][p61[2][1]].Draw(
        p61[3][2][p61[3][1]], p61[4][2][p61[4][1]].Active, p61[4][2][p61[4][1]].Active
      )
    end
  end, function(p62, p63)
    return function()
      local box = p63[1][2][p63[1][1]].box

      if box then
        return box
      end

      local game = p63[2][2][p63[2][1]]:FindFirstChild("Game")
      game = game and game:FindFirstChild("PitchEngine")
      game = game and game:FindFirstChild("Outs")

      if not game then
        return nil
      end

      local val91, count2 = 0, 0

      for v116, v117 in game:GetChildren() do
        if v117:IsA("BasePart") and v117.Name == "throw in" then
          val91, count2 = val91 + v117.Position.X, count2 + 1
        end
      end

      if count2 == 0 then
        return nil
      end

      val91, box = val91 / count2, {}

      for v118, v119 in game:GetChildren() do
        if v119:IsA("BasePart") then
          local val92 = v119.Size.X * 0.5

          if v119.Name == "throw in" then
            if v119.Position.X < val91 then
              box[1] = math.max(box[1] or -math.huge, v119.Position.X + val92)
            else
              box[2] = math.min(box[2] or math.huge, v119.Position.X - val92)
            end
          elseif v119.Name == "homeout" then
            box[3] = math.max(box[3] or -math.huge, v119.Position.Z)
          elseif v119.Name == "awayout" then
            box[4] = math.min(box[4] or math.huge, v119.Position.Z)
          end
        end
      end

      if not (box[1] and box[2] and box[3] and box[4]) then
        return nil
      end

      p63[1][2][p63[1][1]].box = box
      return box
    end
  end, c = function(...) return { [1] = { ... }, [2] = select("#", ...) } end, function(p64, p65)
    return function()
      p65[1][2][p65[1][1]](os.clock())
      local chargeTarget = p65[2][2][p65[2][1]].chargeTarget

      local passChargeSpd = (chargeTarget == "Both" or chargeTarget == "Pass")
          and p65[2][2][p65[2][1]].passChargeSpd
        or 1

      local powerTarget = p65[2][2][p65[2][1]].powerTarget

      local insaneOn = p65[2][2][p65[2][1]].insaneOn
        and (powerTarget == "Both" or powerTarget == "Pass")

      local passPowerMult = insaneOn and p65[2][2][p65[2][1]].passPowerMult or 1
      local passHeightMult = insaneOn and p65[2][2][p65[2][1]].passHeightMult or 1
      local ballSpeed = p65[2][2][p65[2][1]].ballSpeed
      local val93 = (powerTarget == "Both" or powerTarget == "Pass") and ballSpeed or 1
      local val94 = (powerTarget == "Both" or powerTarget == "Shoot") and ballSpeed or 1
      local curveMult = p65[2][2][p65[2][1]].curveOn and p65[2][2][p65[2][1]].curveMult or 1

      for v123, v124 in type(p65[3][2][p65[3][1]]) == "table" and p65[3][2][p65[3][1]] or {} do
        if type(v124) == "table" then
          local element15 = rawget(v124, "props")

          if type(element15) == "table" then
            if type(rawget(element15, "curveInt")) == "number" then
              local val95 = p65[4][2][p65[4][1]](element15, "curveInt") * curveMult * val93

              if element15.curveInt ~= val95 then
                element15.curveInt = val95
              end
            end

            if type(rawget(element15, "powerMult")) == "number" then
              local val96 = p65[4][2][p65[4][1]](element15, "powerMult") * passPowerMult * val93

              if element15.powerMult ~= val96 then
                element15.powerMult = val96
              end
            end

            if type(rawget(element15, "angleMult")) == "number" then
              local val97 = p65[4][2][p65[4][1]](element15, "angleMult") * passHeightMult * val93

              if element15.angleMult ~= val97 then
                element15.angleMult = val97
              end
            end
          end

          local element16 = rawget(v124, "timing")

          if type(element16) == "table" then
            if type(rawget(element16, "chargeDur")) == "number" then
              local val98 = p65[4][2][p65[4][1]](element16, "chargeDur")
                / math.max(passChargeSpd, 0.05)

              if element16.chargeDur ~= val98 then
                element16.chargeDur = val98
              end
            end

            if type(rawget(element16, "shootDur")) == "number" then
              local val99 = p65[4][2][p65[4][1]](element16, "shootDur") / math.max(val93, 0.05)

              if element16.shootDur ~= val99 then
                element16.shootDur = val99
              end
            end

            if type(rawget(element16, "curveDur")) == "number" then
              local val100 = p65[4][2][p65[4][1]](element16, "curveDur") / math.max(val93, 0.05)

              if element16.curveDur ~= val100 then
                element16.curveDur = val100
              end
            end
          end
        end
      end

      for v133, v134 in { p65[5][2][p65[5][1]], p65[6][2][p65[6][1]] } do
        if type(v134) == "table" then
          pcall(function()
            for v135, v136 in v134 do
              if type(v136) == "table" then
                local element17 = rawget(v136, "modifiers")

                if type(element17) == "table" and type(rawget(element17, "curveIntensity")) == "number" then
                  local val101 = p65[4][2][p65[4][1]](element17, "curveIntensity") * curveMult * val94

                  if element17.curveIntensity ~= val101 then
                    element17.curveIntensity = val101
                  end
                end

                local element18 = rawget(v136, "timing")

                if type(element18) == "table" then
                  if type(rawget(element18, "shootDuration")) == "number" then
                    local val102 = p65[4][2][p65[4][1]](element18, "shootDuration")
                      / math.max(val94, 0.05)

                    if element18.shootDuration ~= val102 then
                      element18.shootDuration = val102
                    end
                  end

                  if type(rawget(element18, "curveDuration")) == "number" then
                    local val103 = p65[4][2][p65[4][1]](element18, "curveDuration")
                      / math.max(val94, 0.05)

                    if element18.curveDuration ~= val103 then
                      element18.curveDuration = val103
                    end
                  end
                end
              end
            end
          end)
        end
      end
    end
  end, function(p66, p67)
    return function()
      if not p67[1][2][p67[1][1]] then
        return false
      end

      local parent2 = rawget(p67[1][2][p67[1][1]], "humanoid")

      if typeof(parent2) ~= "Instance" then
        return false
      end

      local character2 = p67[2][2][p67[2][1]].Character
      return character2 ~= nil and parent2.Parent == character2
    end
  end, function(p68, p69, p70, p71)
    p68.bc[p71] = p68.a(p69, 36483) - p70
    return p68.bc[p71]
  end, function(p72, p73)
    return function()
      if p73[1][2][p73[1][1]].Roullete ~= true then
        return
      end

      local element19 = p73[2][2][p73[2][1]] and rawget(p73[2][2][p73[2][1]], "state")

      if element19 and element19.phase and element19.phase ~= "idle" then
        return
      end

      p73[1][2][p73[1][1]].Roullete = false
    end
  end, function(p74, p75)
    return function(self, p76)
      for i7 = #self.Down, 1, -1 do
        pcall(
          p75[1][2][p75[1][1]].SendKeyEvent, p75[1][2][p75[1][1]], false, self.Down[i7], false, game
        )

        self.Down[i7] = nil
      end

      local queued = self.Queued

      if queued then
        self.Queued = nil
        self:Tap(queued, p76)
      end
    end
  end, function(p77, p78)
    return function(p79)
      local ball2 = p79:FindFirstChild("Ball")
      return ball2 ~= nil and ball2:FindFirstChildOfClass("AlignPosition") ~= nil
    end
  end, function(p80, p81)
    return function()
      local targetName = p81[1][2][p81[1][1]].targetName

      if targetName then
        local findFirstChild = p81[2][2][p81[2][1]]:FindFirstChild(targetName)
        local character3 = findFirstChild and findFirstChild.Character
        return character3 and character3:FindFirstChild("HumanoidRootPart") or nil
      end

      local character4 = p81[3][2][p81[3][1]].Character
      return character4 and character4:FindFirstChild("HumanoidRootPart") or nil
    end
  end, function(p82, p83)
    return function(p84)
      if workspace:FindFirstChild("futsal") then
        return true
      end

      if not p83[1][2][p83[1][1]] then
        return false
      end

      local val104 = os.clock()

      if val104 - p83[2][2][p83[2][1]] > 2 then
        p83[2][2][p83[2][1]] = val104
        table.clear(p83[3][2][p83[3][1]])

        for v145, v146 in p83[1][2][p83[1][1]]:GetChildren() do
          if v146.Name == "box" and v146:IsA("BasePart") then
            p83[3][2][p83[3][1]][#p83[3][2][p83[3][1]] + 1] = v146
          end
        end
      end

      local position2 = p84.Position

      for v147, v148 in p83[3][2][p83[3][1]] do
        local size = v148.Size
        local pointToObjectSpace2 = v148.CFrame:PointToObjectSpace(position2)

        if math.abs(pointToObjectSpace2.X) <= size.X / 2
          and math.abs(pointToObjectSpace2.Y) <= size.Y / 2
          and math.abs(pointToObjectSpace2.Z) <= size.Z / 2 then
          return true
        end
      end

      return false
    end
  end, function(p85, p86)
    return function()
      if p86[1][2][p86[1][1]] then
        if p86[2][2][p86[2][1]] == nil or p86[2][2][p86[2][1]].Parent == nil
          or not p86[3][2][p86[3][1]].passRedirect then
          local val105 = false

          pcall(function()
            if p86[1][2][p86[1][1]].createPhysics == p86[4][2][p86[4][1]] then
              p86[1][2][p86[1][1]].createPhysics = p86[5][2][p86[5][1]]
              val105 = true
            end
          end)

          p86[1][2][p86[1][1]], p86[2][2][p86[2][1]] = nil, nil

          if val105 then
            p86[5][2][p86[5][1]] = nil
          end
        end
      end

      if p86[1][2][p86[1][1]] or not p86[3][2][p86[3][1]].passRedirect then
        return
      end

      local pass = p86[6][2][p86[6][1]]("Pass")

      if not pass then
        return
      end

      local val106, success = pcall(getsenv, pass)

      if not (val106 and type(success) == "table" and type(rawget(success, "createPhysics")) == "function") then
        return
      end

      if success.createPhysics == p86[4][2][p86[4][1]] then
        return
      end

      p86[5][2][p86[5][1]], p86[1][2][p86[1][1]], p86[2][2][p86[2][1]] = success.createPhysics, success, pass
      success.createPhysics = p86[4][2][p86[4][1]]
    end
  end, function(p87, p88)
    return function(p89, p90)
      for v152, v153 in p88[1][2][p88[1][1]].Balls() do
        if not v153.Parent then
          continue
        end

        local element20 = p88[2][2][p88[2][1]][v153]

        if not element20 then
          element20 = p88[3][2][p88[3][1]].new()
          p88[2][2][p88[2][1]][v153] = element20
        end

        element20.Gravity = p88[1][2][p88[1][1]].BallGravity(v153)
        element20:Push(p89, v153.Position, v153.AssemblyLinearVelocity, element20.Gravity)
        element20.Spin = v153.AssemblyAngularVelocity

        if p89 - element20.SurfaceAt > 0.5 then
          element20.SurfaceAt = p89
          element20.HasSurface = p88[1][2][p88[1][1]].Surface(v153, element20.Surface)
        end
      end

      table.clear(p88[4][2][p88[4][1]])

      for v155, v156 in p88[5][2][p88[5][1]]:GetPlayers() do
        if v156 == p88[6][2][p88[6][1]] then
          continue
        end

        local character5 = v156.Character
        local humanoidRootPart2 = character5 and character5:FindFirstChild("HumanoidRootPart")

        if not humanoidRootPart2 then
          continue
        end

        local element21 = p88[7][2][p88[7][1]][v156]

        if not element21 then
          element21 = p88[8][2][p88[8][1]].new()
          p88[7][2][p88[7][1]][v156] = element21
        end

        if element21:Update(p89, character5, humanoidRootPart2) then
          p88[4][2][p88[4][1]][#p88[4][2][p88[4][1]] + 1] = element21.Blocker
        end
      end
    end
  end, function(p91, p92)
    return function(self, p93, p94) return 1.5 * p93 * (self.Quantum or p94) + 0.5 end
  end, function(p95, p96)
    return function()
      local character6 = p96[1][2][p96[1][1]].Character
      local humanoidRootPart3 = character6 and character6:FindFirstChild("HumanoidRootPart")

      if not humanoidRootPart3 then
        p96[2][2][p96[2][1]].Hide()
        return
      end

      local tool = character6:FindFirstChildOfClass("Tool")

      if not (tool and tool.Name == "Pass") then
        p96[2][2][p96[2][1]].Hide()
        return
      end

      if not p96[3][2][p96[3][1]](os.clock()) then
        p96[2][2][p96[2][1]].Hide()
        return
      end

      local val107 = p96[4][2][p96[4][1]]()

      if not (val107 and rawget(val107, "phase") == "charging") then
        p96[2][2][p96[2][1]].Hide()
        return
      end

      local val108 = rawget(val107, "move")
      local val109 = type(val108) == "table" and rawget(val108, "props") or nil
      local val110 = type(val108) == "table" and rawget(val108, "timing") or nil

      if not (type(val109) == "table" and type(val110) == "table") then
        p96[2][2][p96[2][1]].Hide()
        return
      end

      local val111 = p96[5][2][p96[5][1]](
        humanoidRootPart3.Position, humanoidRootPart3.CFrame.LookVector, p96[6][2][p96[6][1]].aimRange
      )

      if not val111 then
        p96[2][2][p96[2][1]].Hide()
        return
      end

      local val112 = math.clamp(rawget(val107, "charge") or 0, 0, 1)
      local maxCharge = val110.maxCharge or 0

      local val113 = (val112 * maxCharge + (val109.basePower or 0) * (val109.chargeRate or 1))
        * (val109.powerMult or 1)

      local val114 = val112 * (maxCharge / 5) * (val109.angleMult or 0)

      if val112 > 0.5 then
        val114 = val114 + (val112 - 0.5) * 2 * (val109.baseAngle or 0) * (val109.angleMult or 0)
      end

      if val113 <= 0 then
        p96[2][2][p96[2][1]].Hide()
        return
      end

      local cframe = humanoidRootPart3.CFrame
      local lookVector, rightVector2, upVector = cframe.LookVector, cframe.RightVector, cframe.UpVector
      local val115 = p96[7][2][p96[7][1]](character6)
      local val116, val117 = lookVector, rawget(val108, "direction")

      if val115 then
        if val117 == "right" then
          val117 = "left"
        elseif val117 == "left" then
          val117 = "right"
        end
      end

      if val117 == "right" then
        val116 = (rightVector2 + lookVector / 5) * val113 / 105
      elseif val117 == "left" then
        val116 = (-rightVector2 + lookVector / 5) * val113 / 105
      elseif val117 == "back" then
        val116 = -lookVector
      end

      local val118 = val114

      if val109.baseAngle == 5 then
        val118 = math.min(val114, 15)
      elseif val109.baseAngle == 80 then
        val118 = math.min(val114, 45)
      end

      local zero2 = rawget(val108, "fake") and Vector3.zero or val116 * val113 + upVector * val118
      local val119 = 2.932
      local val120, success2 = pcall(val111.GetMass, val111)

      if val120 and type(success2) == "number" and success2 > 0 then
        val119 = success2
      end

      local curveInt = val109.curveInt or 0

      if curveInt ~= 0 then
        curveInt = val115 and -math.abs(curveInt) or math.abs(curveInt)
      end

      if rawget(val108, "useRealisticCurve") then
        local val121 = 0

        if p96[8][2][p96[8][1]] then
          local val122, success3 = pcall(p96[8][2][p96[8][1]], val111)

          if val122 and type(success3) == "number" then
            val121 = success3
          end
        end

        if (Vector3.new(val111.Position.X, 0, val111.Position.Z)
            - Vector3.new(humanoidRootPart3.Position.X, 0, humanoidRootPart3.Position.Z)).Magnitude
          > 5 then
          val121 = 0
        end

        local val123 = os.clock()

        if val121 ~= p96[9][2][p96[9][1]] then
          p96[9][2][p96[9][1]], p96[10][2][p96[10][1]] = val121, val123
        end

        if val123 - p96[10][2][p96[10][1]] >= 0.15 then
          p96[11][2][p96[11][1]] = val121
        end

        curveInt = p96[11][2][p96[11][1]]
      end

      local vector3 = Vector3.new(0, -p96[12][2][p96[12][1]](val111), 0)
      local zero3 = curveInt ~= 0 and rightVector2 * (val113 * curveInt / val119) or Vector3.zero

      local val124, element22, val125, val126, val127, val128, val129, val130 = p96[13][2][p96[13][1]](
        val111, character6, val110, zero2, vector3, zero3
      )

      if not val125 and val126 > -math.huge then
        local element23 = val129(val127)
        local vector4 = Vector3.new(element23.X, 0, element23.Z)

        if vector4.Magnitude > 2 then
          local vector5 = Vector3.new(element22.X, val126 + 0.15, element22.Z)
          val124[#val124] = vector5
          element22 = vector5
          local decel = p96[14][2][p96[14][1]].DECEL

          if p96[15][2][p96[15][1]] and val108 == rawget(p96[15][2][p96[15][1]], "Pass") then
            decel = p96[14][2][p96[14][1]].DECEL_ICE
          end

          local val131 = p96[14][2][p96[14][1]].ROLL * 4
          local val132 = vector4.Magnitude / decel / val131
          local val133, total, val134, val135 = val127, 0, vector5, vector5

          for i8 = 1, val131 do
            local magnitude8 = vector4.Magnitude

            if magnitude8 < 2 or total > p96[14][2][p96[14][1]].ROLL_MAX then
              break
            end

            local val136 = -(vector4 / magnitude8) * decel

            if val133 < val130 then
              val136 = val136 + zero3
            end

            local vector6 = val134 + vector4 * val132 + val136 * (0.5 * val132 * val132)
            vector6 = Vector3.new(vector6.X, vector5.Y, vector6.Z)

            total = total + (vector6 - val134).Magnitude
            vector4, val133, val134 = vector4 + val136 * val132, val133 + val132, vector6

            if i8 % 4 == 0 or i8 == val131 then
              local element24 = val134 - val135
              local magnitude9 = element24.Magnitude

              if magnitude9 > 0.001 then
                local spherecast = p96[16][2][p96[16][1]]:Spherecast(
                  val135, val128, element24, p96[17][2][p96[17][1]]
                )

                if spherecast then
                  val124[#val124 + 1] = val135 + element24 * (spherecast.Distance / magnitude9)
                  break
                end
              end

              val124[#val124 + 1] = val134
              val135 = val134
            end
          end
        end
      end

      if #val124 < 2 then
        p96[2][2][p96[2][1]].Hide()
        return
      end

      local bend = curveInt ~= 0 and p96[14][2][p96[14][1]].BEND or p96[14][2][p96[14][1]].FLAT
      p96[2][2][p96[2][1]].Draw(val124, bend, bend)
    end
  end, function(p97)
    local element25 = string
    local byte, char
    element25, char, byte = bit32, element25.char, element25.byte
    local bxor = element25.bxor

    char = { [1] = 3, [3] = char }
    char[2] = char

    byte = { [1] = 3, [3] = byte }
    byte[2] = byte

    bxor = { [1] = 3, [3] = bxor }
    bxor[2] = bxor

    element25 = p97:Bb({ byte, char, bxor })
    return element25
  end, function(p98, p99)
    return function()
      local val137 = p99[1][2][p99[1][1]] and rawget(p99[1][2][p99[1][1]], "state")
      local val138 = type(val137) == "table" and rawget(val137, "activeMove") or nil

      if type(val138) ~= "table" then
        val138 = p99[2][2][p99[2][1]]()
      end

      if type(val138) ~= "table" then
        return nil, false
      end

      local val139 = rawget(val138, "limbs")

      if type(val139) ~= "table" or #val139 == 0 then
        return val138, false
      end

      for v197, v198 in val139 do
        if v198 ~= "Head" then
          return val138, false
        end
      end

      return val138, true
    end
  end, function(p100, p101)
    return function()
      local val140 = os.clock()

      if p101[1][2][p101[1][1]]
        and (p101[1][2][p101[1][1]].Live or val140 - p101[2][2][p101[2][1]] < 5) then
        return p101[1][2][p101[1][1]]
      end

      p101[2][2][p101[2][1]] = val140

      local val141 = {
        PinMin = p101[3][2][p101[3][1]].PinMin, PinMax = p101[3][2][p101[3][1]].PinMax, CurveDuration = p101[3][2][p101[3][1]].CurveDuration, CurveIntensity = p101[3][2][p101[3][1]].CurveIntensity, Live = false, }

      if filtergc then
        local val142, success4 = pcall(filtergc, "table", { Keys = { "Finesse", "Header" } }, false)

        if val142 and type(success4) == "table" then
          local huge5, val143, val144, val145 = math.huge, 0, 0, 0

          for v206, v207 in success4 do
            if type(v207) ~= "table" then
              continue
            end

            for v208, v209 in v207 do
              if type(v209) ~= "table" then
                continue
              end

              local timing, modifiers = v209.timing, v209.modifiers

              if type(timing) == "table" and p101[4][2][p101[4][1]](timing.shootDuration) then
                huge5 = math.min(huge5, timing.shootDuration)
                val143 = math.max(val143, timing.shootDuration)

                if p101[4][2][p101[4][1]](timing.curveDuration) then
                  val145 = math.max(val145, timing.curveDuration)
                end
              end

              if type(modifiers) == "table" and p101[4][2][p101[4][1]](modifiers.curveIntensity) then
                val144 = math.max(val144, math.abs(modifiers.curveIntensity))
              end
            end
          end

          if val143 > 0 then
            val141.PinMin, val141.PinMax, val141.Live = huge5, val143, true

            if val145 > 0 then
              val141.CurveDuration = val145
            end

            if val144 > 0 then
              val141.CurveIntensity = val144
            end
          end
        end

        local val146, success5 = pcall(
          filtergc, "table", { Keys = { "RealisticCurve", "Cooldown" } }, true
        )

        local intensityMultiplier = val146 and type(success5) == "table"
          and type(success5.RealisticCurve) == "table" and success5.RealisticCurve.intensityMultiplier

        if p101[4][2][p101[4][1]](intensityMultiplier) then
          val141.CurveIntensity = math.max(val141.CurveIntensity, math.abs(intensityMultiplier))
        end
      end

      p101[1][2][p101[1][1]] = val141
      p101[5][2][p101[5][1]].Tunables = val141

      return val141
    end
  end, function(p102, p103)
    return function(p104)
      local element26 = p103[1][2][p103[1][1]].DIVES[p104]

      if not element26 then
        return p103[1][2][p103[1][1]].DIVE_FORCE
      end

      local dataFolder = p103[2][2][p103[2][1]]:FindFirstChild("DataFolder")
      dataFolder = dataFolder and dataFolder:FindFirstChild("Customization")
      dataFolder = dataFolder and dataFolder:FindFirstChild("DNA")

      return dataFolder and dataFolder.Value == "Sweeper" and element26.sweeper or element26.force
    end
  end, function(p105, p106)
    return function(p107)
      local character7 = p106[1][2][p106[1][1]].Character

      for v213, v214 in p106[2][2][p106[2][1]]:GetPlayers() do
        local character8 = v214.Character

        local playerEngine = character8 and character8 ~= character7
          and character8:FindFirstChild("Player Engine")

        playerEngine = playerEngine and playerEngine:FindFirstChild("Parts")
        playerEngine = playerEngine and playerEngine:FindFirstChild("shielding")

        if playerEngine and playerEngine.CanTouch ~= p107 then
          playerEngine.CanTouch = p107
        end
      end
    end
  end, function(p108, p109)
    return function(self, p110, p111, p112, p113, p114)
      if p109[1][2][p109[1][1]](p111) and p111 > 0 and p111 < 0.5 then
        self.Frame = self.Frame * 0.9 + p111 * 0.1
      end

      local position3 = p113.Position
      local assemblyLinearVelocity3 = p113.AssemblyLinearVelocity
      local position4 = self.Position

      if position4
        and ((position3 - position4) * Vector3.new(1, 0, 1)).Magnitude
          > math.max(5, 60 * (p111 or 0)) then
        self.Velocity = Vector3.zero
      else
        local val147 = 1 - math.exp(-(p111 or self.Frame) / 0.08)

        self.Velocity = self.Velocity:Lerp(Vector3.new(
          assemblyLinearVelocity3.X, 0, assemblyLinearVelocity3.Z
        ), val147)
      end

      self.Position = position3
      local getState = p114:GetState()

      self.Airborne = p114.FloorMaterial == Enum.Material.Air
        or getState == Enum.HumanoidStateType.Jumping
        or getState == Enum.HumanoidStateType.Freefall

      if not self.Airborne then
        self.StandY = position3.Y
      end

      self.Height = self.StandY and math.max(0, position3.Y - self.StandY) or 0
      self.VerticalSpeed = assemblyLinearVelocity3.Y

      if not self.Airborne and not p109[2][2][p109[2][1]].Diving and p110 - self.BoxAt > 0.5 then
        self.BoxAt = p110
        self.CatchBox, self.BodyBox = self:Boxes(p112, p113)
      end
    end
  end, function(p115, p116)
    return function(p117)
      local val148 = p116[1][2][p116[1][1]].pitch()

      if not val148 then
        return false
      end

      local assemblyLinearVelocity4 = p117.AssemblyLinearVelocity
      local vector7 = Vector3.new(assemblyLinearVelocity4.X, 0, assemblyLinearVelocity4.Z)
      local magnitude10 = vector7.Magnitude
      local position5 = p117.Position

      if magnitude10 > 1 then
        position5 = position5 + vector7 / magnitude10 * math.min(
          magnitude10 * magnitude10 / (2 * p116[1][2][p116[1][1]].DECEL), p116[1][2][p116[1][1]].OUT_MAX
        )
      end

      return position5.X < val148[1] or position5.X > val148[2] or position5.Z < val148[3]
        or position5.Z > val148[4]
    end
  end, function(p118, p119)
    return function(p120)
      for i9 = 1, p120 do
        if p119[1][2][p119[1][1]][i9].EndKind == "Goal" then
          return true
        end
      end

      return false
    end
  end, function(p121, p122)
    return function(self, p123, p124)
      return #self.Down > 0 or self.Queued ~= nil
        or p123 - self.PressedAt < self:Expect(p124) * 3
    end
  end, function(p125, p126)
    return function(p127, p128)
      if p126[1][2][p126[1][1]].CatchBusy(p127) then
        return false
      end

      local element27 = p126[1][2][p126[1][1]].ModuleOf(p127, p128)
      local state = element27 and element27.State

      if not state then
        return true
      end

      if state.globalCooldown or state.catchCooldown or state.dropCooldown or state.dropDelay then
        return false
      end

      if state.lastActionTime and tick() - state.lastActionTime < 0.3 then
        return false
      end

      local catchingWhileDive = state.catchingWhileDive

      if typeof(catchingWhileDive) == "Instance" and catchingWhileDive.IsPlaying then
        return false
      end

      return true
    end
  end, function(p129, p130)
    return function()
      local ec = p129.bc[-28743] or p129:ec(33190, 3836, -28743)

      local val149, val150, val151, val152, val153, val154, val155, val156, val157, val158, val159, val160, val161, val162, val163, val164, val165, val166, val167, cc, val168, val169, val170, val171, cc2, val172, val173, val174, val175, val176, val177, val178, val179, val180, val181, val182, val183, val184, val185, val186, val187, val188, val189, jc, val190, val191, val192, val193, val194, val195, val196, val197, val198, val199, val200, val201, val202, val203, val204, val205, val206, val207, val208, val209, val210, val211, val212, val213, val214, val215, val216, val217, val218, val219, val220, val221, val222, val223, val224, val225, val226, val227, val228, val229, val230, val231, val232, val233, val234

      while true do
        if ec >= 723 then
          if ec > 1565 then
            if ec > 2663 then
              if ec <= 3264 then
                if ec <= 2982 then
                  if ec > 2830 then
                    if ec < 2925 then
                      if ec <= 2866 then
                        if ec <= 2864 then
                          if ec >= 2858 then
                            if ec <= 2858 then
                              val224 = val224(cc2, jc, val158)

                              cc2, jc = val158, 1
                              cc2 = cc2 + jc

                              ec, val186, p130[1][2][p130[1][1]] = p129.gc[-6918]
                                or p129:hc(1557, 48288, -6918), val224, cc2
                            else
                              ec = val234 > val182 and ec + -2795 or p129.bc[32218]
                                or p129:ec(56214, 20263, 32218)
                            end
                          else
                            ec = val198 < cc and (p129.gc[9234] or p129:hc(10091, 39132, 9234))
                              or p129.bc[-16447] or p129:ec(49936, 18712, -16447)
                          end
                        else
                          ec = cc2 ~= cc2
                              and (p129.bc[-28432] or p129:dc(15177375, 8802, -28432))
                            or p129.bc[-12197]
                            or p129:ec(50571, 16378, -12197)
                        end
                      elseif ec > 2887 then
                        ec, val201 = p129.bc[-22925] or p129:dc(219217, 90, -22925), val201(val221, val163)
                        val221 = 7
                        val221 = val158 * val221
                      else
                        val198 = val198(cc, val186)
                        val183 = not val198

                        ec = val183 and (p129.bc[-23145] or p129:ec(42679, 10181, -23145))
                          or ec + -2657
                      end
                    elseif ec <= 2960 then
                      if ec <= 2950 then
                        if ec < 2938 then
                          val224 = val224(cc2, jc, val158)
                          jc, cc2 = 1, val158
                          cc2 = cc2 + jc
                          p130[1][2][p130[1][1]], val186 = cc2, val224
                          ec = val195 < jc and 1494675 / ec or 3796 - ec
                        elseif ec > 2938 then
                          val224 = val224(cc2, jc, val158)
                          ec, jc, cc2 = p129.bc[24099] or p129:dc(18187335, 24796, 24099), 1, val158
                          cc2 = cc2 + jc
                          val186, p130[1][2][p130[1][1]] = val224, cc2
                        else
                          val224 = val224(cc2, jc, val158)
                          ec, cc2, jc = ec + -2479, val158, 1
                          cc2 = cc2 + jc
                          val186, p130[1][2][p130[1][1]] = val224, cc2
                        end
                      else
                        ec = val159 <= 0 and ec + -595 or 5964400 / ec
                      end
                    elseif ec <= 2969 then
                      val224 = val224(cc2, jc, val158)
                      cc2, jc = val158, 1
                      ec, cc2 = p129.gc[14182] or p129:ic(2064582, 4786, 14182), cc2 + jc
                      val186, p130[1][2][p130[1][1]] = val224, cc2
                    else
                      ec = val158 > val162 and 4004 - ec or p129.bc[1116]
                        or p129:dc(797837, 722, 1116)
                    end
                  elseif ec < 2728 then
                    if ec >= 2719 then
                      if ec > 2723 then
                        ec, val183 = p129.bc[-7490] or p129:dc(48796434, 16895, -7490), val183(val198, p129.d(cc))
                        val198, cc, val186, val182 = p130[9][2][p130[9][1]], val196, 128, val183
                      elseif ec > 2719 then
                        val224 = val224(cc2, jc, val158)
                        jc, cc2 = 1, val158
                        cc2 = cc2 + jc
                        p130[1][2][p130[1][1]], ec, val186 = cc2, 743379 / ec, val224
                      else
                        ec = val196 < val183 and 2909 - ec or ec + -2618
                      end
                    elseif ec >= 2704 then
                      if ec <= 2704 then
                        val172 = val172(val211, val187, val171)

                        val211, val187 = val171, 1
                        val211 = val211 + val187

                        val228, p130[1][2][p130[1][1]] = val172, val211

                        ec = val223 >= val187 and (p129.gc[5972] or p129:hc(21182, 61282, 5972))
                          or 2724 - ec
                      else
                        ec = val198 > cc and ec + -2573 or p129.bc[16715]
                          or p129:ec(62753, 30052, 16715)
                      end
                    else
                      cc2 = cc2(jc, val158, val162)

                      jc, val158 = val162, 1
                      jc = jc + val158

                      ec, p130[1][2][p130[1][1]], val224 = p129.bc[3419]
                        or p129:dc(951706, 2037, 3419), jc, cc2
                    end
                  elseif ec < 2750 then
                    if ec > 2734 then
                      ec = val186 > val224 and ec + -2009 or 4433435 / ec
                    elseif ec <= 2728 then
                      ec = val228 ~= val228 and (p129.bc[26366] or p129:dc(2301883, 2296, 26366))
                        or 1852312 / ec
                    else
                      val224 = val224(cc2, jc, val158)

                      cc2, jc = val158, 1
                      cc2 = cc2 + jc

                      val186, ec, p130[1][2][p130[1][1]] = val224, ec + 814, cc2
                    end
                  elseif ec >= 2773 then
                    if ec <= 2773 then
                      val159 = val159 + val196
                      ec = val196 > 0 and ec + 1201 or 5956 - ec
                    else
                      ec = cc2 <= 0 and 4873260 / ec or ec + -2477
                    end
                  elseif ec > 2750 then
                    ec, val224 = p129.bc[-32595] or p129:dc(1205977, 2310, -32595), val224(cc2, jc, val158)

                    cc2, jc = val158, 1
                    cc2 = cc2 + jc

                    val186, p130[1][2][p130[1][1]] = val224, cc2
                  else
                    val224 = val224(cc2, jc, val158)
                    cc2, jc = val158, 1
                    ec, cc2 = p129.gc[31199] or p129:hc(4061, 45116, 31199), cc2 + jc
                    val186, p130[1][2][p130[1][1]] = val224, cc2
                  end
                elseif ec > 3126 then
                  if ec < 3190 then
                    if ec > 3168 then
                      if ec > 3175 then
                        ec = val196 <= 0 and 3898 - ec or p129.bc[13632]
                          or p129:dc(48454181, 19662, 13632)
                      else
                        ec = val198 > cc and (p129.bc[2575] or p129:ec(53137, 16517, 2575))
                          or ec + 678
                      end
                    elseif ec <= 3144 then
                      if ec <= 3133 then
                        ec = val198 < cc and ec + -2433 or 4490 - ec
                      else
                        ec = val186 > val224 and (p129.bc[19816] or p129:dc(19859883, 22224, 19816))
                          or p129.gc[-27915] or p129:hc(7649, 43092, -27915)
                      end
                    else
                      val224 = val224(cc2, jc, val158)

                      cc2, jc = val158, 2
                      cc2 = cc2 + jc

                      p130[1][2][p130[1][1]], ec, val186 = cc2, 2084544 / ec, val224
                    end
                  elseif ec >= 3207 then
                    if ec < 3236 then
                      ec = jc > val158 and (p129.bc[-18962] or p129:ec(61338, 24547, -18962))
                        or ec + -1924
                    elseif ec > 3236 then
                      ec = val186 ~= val186 and ec + 314 or 5516160 / ec
                    else
                      ec = val198 > 0 and (p129.bc[-6186] or p129:ec(51651, 16851, -6186))
                        or p129.bc[-8931] or p129:dc(2754696, 1827, -8931)
                    end
                  elseif ec > 3192 then
                    ec = val186 < val224 and 2320296 / ec or p129.gc[-12056]
                      or p129:hc(27889, 55137, -12056)
                  elseif ec > 3190 then
                    ec = val160 <= 0 and (p129.bc[-9252] or p129:ec(43541, 5689, -9252))
                      or 3380 - ec
                  else
                    val224 = val224(cc2, jc, val158)

                    cc2, ec, jc = val158, 1786400 / ec, 1
                    cc2 = cc2 + jc

                    p130[1][2][p130[1][1]], val186 = cc2, val224
                  end
                elseif ec < 3080 then
                  if ec <= 3055 then
                    if ec <= 3031 then
                      if ec < 3020 then
                        jc = jc(val158, val162, val228)

                        val158 = val228
                        val158 = val158 + val224

                        ec, p130[1][2][p130[1][1]], val186 = p129.gc[16920]
                          or p129:hc(10126, 40415, 16920), val158, jc
                      elseif ec > 3020 then
                        ec = val196 <= 0 and 6928866 / ec or 3091 - ec
                      else
                        ec = jc < val158 and (p129.bc[-18962] or p129:ec(49433, 20068, -18962))
                          or p129.gc[-15250] or p129:hc(12954, 38876, -15250)
                      end
                    else
                      val186 = val186(val224, cc2, jc)
                      val224, cc2 = jc, 1
                      ec, val224 = p129.bc[9928] or p129:dc(3417131, 14960, 9928), val224 + cc2
                      cc, p130[1][2][p130[1][1]] = val186, val224
                    end
                  elseif ec <= 3056 then
                    jc = jc(val158, val162, val228)

                    val158 = val228
                    val158 = val158 + val224

                    p130[1][2][p130[1][1]], val186 = val158, jc

                    ec = val233 < val206 and (p129.gc[6602] or p129:hc(6426, 43449, 6602))
                      or p129.bc[15531] or p129:dc(3985793, 4058, 15531)
                  else
                    val224 = val224(cc2, jc, val158)

                    cc2, jc = val158, 2
                    cc2 = cc2 + jc

                    val186, p130[1][2][p130[1][1]] = val224, cc2
                    ec = val179 < jc and 3180 - ec or ec + -2670
                  end
                elseif ec <= 3097 then
                  if ec < 3092 then
                    if ec > 3080 then
                      ec = val162 <= 0 and (p129.bc[-20830] or p129:dc(1584246, 483, -20830))
                        or p129.gc[-21982] or p129:ic(3692448, 12077, -21982)
                    else
                      ec, val198 = 4370520 / ec, p129.c(val198(cc, val186))
                    end
                  elseif ec <= 3092 then
                    ec = val198 <= 0 and (p129.bc[10334] or p129:ec(40626, 67, 10334))
                      or 309200 / ec
                  else
                    val224 = val224(cc2, jc, val158)

                    cc2, jc = val158, 2
                    cc2 = cc2 + jc

                    val186, ec, p130[1][2][p130[1][1]] = val224, p129.bc[10456]
                      or p129:dc(26593339, 30376, 10456), cc2
                  end
                elseif ec <= 3106 then
                  ec = cc2 ~= cc2 and 6302 - ec or 4813 - ec
                else
                  val224 = val224(cc2, jc, val158)

                  cc2, ec, jc = val158, p129.bc[14375] or p129:ec(39292, 5520, 14375), 1
                  cc2 = cc2 + jc

                  val186, p130[1][2][p130[1][1]] = val224, cc2
                end
              elseif ec < 3655 then
                if ec > 3489 then
                  if ec > 3595 then
                    if ec <= 3601 then
                      if ec >= 3600 then
                        if ec > 3600 then
                          cc = cc(val186, val224)
                          ec, val186 = 6681 - ec, 7
                          val186 = val182 * val186
                        else
                          ec = val159 < val160 and ec + -3407 or p129.bc[-6972]
                            or p129:ec(53014, 16561, -6972)
                        end
                      else
                        cc = cc(val186)
                        val224, val186 = val198, 1
                        cc2 = val186

                        ec = val224 ~= val224 and 3224704 / ec or p129.gc[-30197]
                          or p129:hc(24008, 61863, -30197)
                      end
                    elseif ec > 3617 then
                      jc = jc()
                      ec, cc[val186] = 4050 - ec, jc
                    else
                      val224 = val224(cc2, jc, val158)
                      cc2, jc = val158, 1
                      ec, cc2 = p129.gc[21993] or p129:ic(7524986, 27718, 21993), cc2 + jc
                      val186, p130[1][2][p130[1][1]] = val224, cc2
                    end
                  elseif ec <= 3572 then
                    if ec > 3552 then
                      ec = val231 > val159 and (p129.bc[-23145] or p129:dc(392705, 3062, -23145))
                        or 5815216 / ec
                    elseif ec > 3548 then
                      ec = val231 < val159 and (p129.bc[-23145] or p129:dc(2543581, 22506, -23145))
                        or p129.bc[25779] or p129:ec(60337, 23308, 25779)
                    elseif ec <= 3490 then
                      ec, val224 = p129.bc[26654] or p129:ec(40668, 3885, 26654), val224(cc2, jc, val158)
                      jc, cc2 = 2, val158
                      cc2 = cc2 + jc
                      p130[1][2][p130[1][1]], val186 = cc2, val224
                    else
                      cc[6284] = val186
                      ec = val153 < val154 and 2341680 / ec or ec + -775
                    end
                  elseif ec > 3578 then
                    ec = cc2 > 0 and ec + -1390 or 6461 - ec
                  else
                    ec = val198 < cc and 4278 - ec or 2382948 / ec
                  end
                elseif ec <= 3391 then
                  if ec <= 3348 then
                    if ec <= 3341 then
                      if ec <= 3273 then
                        if ec <= 3271 then
                          val231 = val231(val159)
                          val159, val160 = 1, val182
                          val196 = val159

                          ec = val160 ~= val160 and 3433 - ec or p129.bc[-18351]
                            or p129:ec(65043, 27404, -18351)
                        else
                          jc = jc(val158, val162)
                          cc2 = not jc

                          ec = cc2 and (p129.bc[19296] or p129:ec(47842, 13244, 19296))
                            or 958989 / ec
                        end
                      else
                        ec = val198 > cc and (p129.bc[19296] or p129:ec(56604, 21242, 19296))
                          or p129.bc[290] or p129:ec(64545, 25386, 290)
                      end
                    else
                      ec = val186 <= 0 and (p129.gc[12661] or p129:ic(36136022, 12342, 12661))
                        or p129.bc[-22565] or p129:ec(48151, 11591, -22565)
                    end
                  elseif ec > 3368 then
                    ec = jc < val158 and 3701 - ec or ec + -3103
                  elseif ec <= 3361 then
                    val224 = val224(cc2, jc, val158)
                    jc, cc2 = 1, val158
                    cc2 = cc2 + jc
                    val186, p130[1][2][p130[1][1]] = val224, cc2
                    ec = val225 > jc and 2349339 / ec or 3710 - ec
                  else
                    val183 = val183(val198, cc)
                    val196 = not val183

                    ec = val196 and (p129.bc[-29261] or p129:ec(42956, 10392, -29261))
                      or ec + -3228
                  end
                elseif ec <= 3482 then
                  if ec >= 3480 then
                    if ec <= 3480 then
                      val211 = val211(val187, val171)
                      val172 = not val211

                      ec = val172 and (p129.gc[-7806] or p129:ic(9583030, 26105, -7806))
                        or 3973 - ec
                    else
                      val224 = val224(cc2, jc, val158)
                      ec, cc2, jc = p129.gc[-19740] or p129:ic(14247900, 31273, -19740), val158, 2
                      cc2 = cc2 + jc
                      p130[1][2][p130[1][1]], val186 = cc2, val224
                    end
                  else
                    val224 = val224(cc2, jc, val158)
                    ec, jc, cc2 = ec + -2485, 1, val158
                    cc2 = cc2 + jc
                    p130[1][2][p130[1][1]], val186 = cc2, val224
                  end
                elseif ec <= 3485 then
                  ec = val196 > 0 and 5632 - ec or p129.bc[-19863]
                    or p129:dc(31060392, 16879, -19863)
                else
                  val191 = val191(val170, val234, val182)
                  val234, val170 = 1, val182
                  ec, val170 = p129.bc[-20545] or p129:dc(4008329, 20006, -20545), val170 + val234
                  val176, p130[1][2][p130[1][1]] = val191, val170
                end
              elseif ec <= 3861 then
                if ec < 3768 then
                  if ec < 3730 then
                    if ec > 3677 then
                      val186 = val186(val224, cc2)
                      ec, val224 = p129.bc[13090] or p129:ec(33724, 819, 13090), 7
                      val224 = val231 * val224
                    elseif ec > 3655 then
                      ec = val231 < val159 and ec + -3566 or ec + -3489
                    else
                      ec = val231 > val159 and (p129.bc[-23145] or p129:ec(50832, 18340, -23145))
                        or 6208 - ec
                    end
                  elseif ec > 3744 then
                    ec = val231 > 0 and (p129.bc[9849] or p129:dc(25571207, 10628, 9849))
                      or p129.bc[-1002] or p129:ec(45522, 14265, -1002)
                  elseif ec > 3730 then
                    ec = val186 <= 0 and (p129.bc[-24813] or p129:ec(54324, 20608, -24813))
                      or p129.bc[5124] or p129:dc(2091723, 9936, 5124)
                  else
                    val224 = val224(cc2, jc, val158)
                    jc, cc2 = 1, val158
                    cc2 = cc2 + jc
                    p130[1][2][p130[1][1]], val186 = cc2, val224

                    ec = val190 > jc and 2148480 / ec or p129.bc[-6281]
                      or p129:dc(7095870, 8907, -6281)
                  end
                elseif ec >= 3838 then
                  if ec < 3853 then
                    val224 = val224(cc2, jc, val158)
                    cc2, jc = val158, 1
                    ec, cc2 = 4787 - ec, cc2 + jc
                    p130[1][2][p130[1][1]], val186 = cc2, val224
                  elseif ec <= 3853 then
                    ec = val186 ~= val186 and (p129.bc[-24813] or p129:fc(12034, 3964, -24813))
                      or ec + -109
                  else
                    ec = val162 ~= val162 and 7252 - ec or p129.bc[7926]
                      or p129:dc(38713529, 12518, 7926)
                  end
                elseif ec <= 3786 then
                  if ec > 3768 then
                    jc = jc(val158, val162)
                    ec, val158 = 7386486 / ec, 7
                    val158 = val196 * val158
                  else
                    val198 = val198(cc, p129.d(val186))
                    val224, val186, cc, ec, val231 = 128, val183, p130[9][2][p130[9][1]], 5916 - ec, val198
                  end
                else
                  ec, val182 = p129.bc[-14463] or p129:ec(64488, 29886, -14463), val182(val231, val159, val160)

                  val231 = val160
                  val231 = val231 + val170

                  val191, p130[1][2][p130[1][1]] = val182, val231
                end
              elseif ec >= 3965 then
                if ec <= 4064 then
                  if ec >= 3975 then
                    if ec <= 3975 then
                      val224 = val224(cc2, jc, val158)
                      cc2, jc = val158, 2
                      ec, cc2 = ec + -17, cc2 + jc
                      p130[1][2][p130[1][1]], val186 = cc2, val224
                    else
                      ec = val196 < val183 and (p129.gc[-25991] or p129:hc(26282, 56310, -25991))
                        or 5615 - ec
                    end
                  elseif ec > 3965 then
                    ec = val159 > val160 and ec + -3812 or ec + -791
                  else
                    ec, cc2 = 7238 - ec, cc2(jc, p129.d(val158))
                    val183, val158, jc, val162 = cc2, val224, p130[9][2][p130[9][1]], 128
                  end
                elseif ec > 4078 then
                  ec = val198 < cc and (p129.gc[24882] or p129:ic(1011393, 317, 24882))
                    or p129.gc[-2192] or p129:ic(15276675, 30865, -2192)
                else
                  ec = val196 < val183 and 4239 - ec or 407800 / ec
                end
              elseif ec >= 3957 then
                if ec > 3958 then
                  ec = val186 ~= val186 and ec + -2803 or p129.bc[30546]
                    or p129:dc(8972839, 7465, 30546)
                elseif ec <= 3957 then
                  val224 = val224(cc2, jc)
                  ec, cc2 = 8958648 / ec, 7
                  cc2 = val159 * cc2
                else
                  ec, cc[29601] = p129.gc[-11995] or p129:ic(76523708, 30452, -11995), val186
                end
              elseif ec > 3946 then
                ec, val172 = p129.bc[29666] or p129:dc(55224235, 23296, 29666), val172(val211, val187)
                val211 = 7
                val211 = val186 * val211
              else
                ec = val198 ~= val198 and 16091788 / ec or 7038 - ec
              end
            elseif ec < 2148 then
              if ec > 1907 then
                if ec <= 2029 then
                  if ec > 1970 then
                    if ec >= 1992 then
                      if ec >= 2015 then
                        if ec > 2015 then
                          ec = val186 <= 0 and (p129.gc[11673] or p129:ic(55968748, 20500, 11673))
                            or 3176 - ec
                        else
                          ec = val159 ~= val159
                              and (p129.bc[-29261] or p129:dc(2861607, 15572, -29261))
                            or p129.bc[16823]
                            or p129:ec(58288, 27880, 16823)
                        end
                      else
                        ec = val158 < val162 and (p129.bc[26366] or p129:ec(44350, 8127, 26366))
                          or 2671 - ec
                      end
                    elseif ec <= 1980 then
                      val224 = val224(cc2, jc, val158)
                      cc2, jc = val158, 1
                      ec, cc2 = ec + -1098, cc2 + jc
                      val186, p130[1][2][p130[1][1]] = val224, cc2
                    else
                      ec, val224 = p129.bc[15531] or p129:ec(46733, 13381, 15531), val224(cc2, jc, val158)
                      jc, cc2 = 8, val158
                      cc2 = cc2 + jc
                      p130[1][2][p130[1][1]], val186 = cc2, val224
                    end
                  elseif ec >= 1951 then
                    if ec > 1968 then
                      ec = val198 ~= val198 and (p129.bc[15609] or p129:ec(49874, 19376, 15609))
                        or p129.bc[-11191] or p129:ec(53912, 23479, -11191)
                    elseif ec > 1953 then
                      val183 = val183(val198)
                      val198, cc = 1, val196
                      val186 = val198
                      ec = cc ~= cc and ec + -1827 or 3595 - ec
                    elseif ec > 1951 then
                      val160 = val160(val196, val183, val198)
                      val183, ec, val196 = 1, 429660 / ec, val198
                      val196 = val196 + val183
                      val159, p130[1][2][p130[1][1]] = val160, val196
                    else
                      ec, cc2 = p129.bc[-19786] or p129:ec(57584, 26907, -19786), p129.c(cc2(jc, val158))
                    end
                  elseif ec > 1939 then
                    ec = val231 ~= val231 and (p129.bc[-20500] or p129:ec(62233, 30693, -20500))
                      or p129.bc[22907] or p129:dc(16563403, 24472, 22907)
                  elseif ec > 1924 then
                    ec = cc2 <= 0 and 3067498 / ec or p129.bc[-28301]
                      or p129:dc(15218729, 21590, -28301)
                  else
                    ec = val198 > 0 and (p129.bc[-25955] or p129:dc(80889204, 31155, -25955))
                      or p129.bc[24921] or p129:dc(220357, 59, 24921)
                  end
                elseif ec <= 2092 then
                  if ec < 2065 then
                    if ec < 2052 then
                      ec, val211 = p129.gc[-31517] or p129:hc(13814, 37753, -31517), val211(val187, p129.d(val171))
                      val201, val187, jc, val171 = 128, p130[9][2][p130[9][1]], val211, val172
                    elseif ec <= 2052 then
                      ec = val186 < val224 and (p129.gc[20912] or p129:hc(18150, 64010, 20912))
                        or 2166912 / ec
                    else
                      ec = val186 > 0 and (p129.bc[-29479] or p129:ec(59144, 23678, -29479))
                        or ec + 1896
                    end
                  elseif ec >= 2091 then
                    if ec <= 2091 then
                      ec = val182 > val231 and 382653 / ec or p129.bc[10924]
                        or p129:ec(63885, 27518, 10924)
                    else
                      ec = jc > val158 and 2402 - ec or p129.bc[-13825]
                        or p129:ec(60455, 21391, -13825)
                    end
                  else
                    val224 = val224(cc2, jc, val158)
                    jc, cc2 = 1, val158
                    ec, cc2 = p129.gc[12297] or p129:hc(17675, 64577, 12297), cc2 + jc
                    val186, p130[1][2][p130[1][1]] = val224, cc2
                  end
                elseif ec < 2111 then
                  if ec <= 2107 then
                    ec = val160 > 0 and ec + 1465 or p129.bc[-22904]
                      or p129:ec(48053, 11994, -22904)
                  else
                    ec = val198 > cc and 2810 - ec or ec + 1154
                  end
                elseif ec <= 2142 then
                  if ec > 2111 then
                    ec, val224 = p129.gc[13914] or p129:hc(6384, 43179, 13914), val224(cc2, jc, val158)
                    jc, cc2 = 1, val158
                    cc2 = cc2 + jc
                    p130[1][2][p130[1][1]], val186 = cc2, val224
                  else
                    val198 = val198(cc, val186, val224)
                    val186, cc = 1, val224
                    cc = cc + val186

                    val183, ec, p130[1][2][p130[1][1]] = val198, p129.bc[-22214]
                      or p129:ec(42989, 10457, -22214), cc
                  end
                else
                  ec = val159 > val160 and (p129.bc[-20760] or p129:dc(4641265, 23770, -20760))
                    or 3944039 / ec
                end
              elseif ec < 1722 then
                if ec >= 1628 then
                  if ec > 1698 then
                    if ec > 1700 then
                      ec = cc2 <= 0 and (p129.gc[15400] or p129:ic(17881620, 2275, 15400))
                        or p129.bc[15251] or p129:ec(50647, 18398, 15251)
                    else
                      ec = val159 > val160 and (p129.bc[-4525] or p129:ec(60712, 25353, -4525))
                        or p129.bc[4520] or p129:dc(43430192, 16301, 4520)
                    end
                  elseif ec >= 1692 then
                    if ec <= 1692 then
                      ec = val158 > val162 and ec + -670 or p129.bc[9568]
                        or p129:dc(59939175, 23815, 9568)
                    else
                      ec, cc[14733] = p129.gc[-11995] or p129:ic(6497139, 5151, -11995), val186
                    end
                  elseif ec > 1628 then
                    ec = val186 <= 0 and 5268 - ec or 1125540 / ec
                  else
                    ec = val160 ~= val160 and 5305 - ec or ec + 1564
                  end
                elseif ec < 1608 then
                  if ec < 1582 then
                    ec = val198 <= 0 and (p129.bc[-2809] or p129:ec(2459, 31865, -2809))
                      or 159378 / ec
                  elseif ec <= 1582 then
                    ec = val186 < val224 and (p129.bc[19816] or p129:dc(22066219, 24605, 19816))
                      or ec + -875
                  else
                    ec = val186 <= 0 and ec + 2489 or 2185 - ec
                  end
                elseif ec < 1621 then
                  val186 = val186(val224, cc2, jc)

                  val224, cc2 = jc, 1
                  val224 = val224 + cc2

                  cc, p130[1][2][p130[1][1]] = val186, val224

                  ec = val208 > cc2 and ec + -1577 or p129.bc[-5469]
                    or p129:ec(42192, 10416, -5469)
                elseif ec <= 1621 then
                  ec = cc2 <= 0 and 3326292 / ec or ec + -565
                else
                  ec = val186 > 0 and (p129.bc[30142] or p129:dc(76539904, 24093, 30142))
                    or 6268831 / ec
                end
              elseif ec <= 1771 then
                if ec <= 1749 then
                  if ec < 1736 then
                    if ec > 1722 then
                      ec = val159 ~= val159 and 3894 - ec or p129.bc[24131]
                        or p129:dc(42903729, 29499, 24131)
                    else
                      ec = val186 < val224 and (p129.bc[19816] or p129:dc(20273579, 22640, 19816))
                        or p129.bc[-29201] or p129:dc(8540113, 24250, -29201)
                    end
                  elseif ec <= 1736 then
                    ec = val234 < val182 and 119784 / ec or 4125 - ec
                  else
                    val224 = val224(cc2, jc, val158)

                    cc2, ec, jc = val158, p129.bc[-19554] or p129:ec(47727, 12985, -19554), 1
                    cc2 = cc2 + jc

                    p130[1][2][p130[1][1]], val186 = cc2, val224
                  end
                elseif ec < 1766 then
                  val158 = val158(val162, val228, val172)
                  ec, val162 = 356530 / ec, val172
                  val162 = val162 + cc2
                  p130[1][2][p130[1][1]], val224 = val162, val158
                elseif ec > 1766 then
                  val224 = val224(cc2, jc, val158)

                  cc2, jc = val158, 1
                  cc2 = cc2 + jc

                  p130[1][2][p130[1][1]], ec, val186 = cc2, p129.bc[-21279]
                    or p129:dc(2339907, 5672, -21279), val224
                else
                  val198 = val198(cc, val186, val224)
                  ec, val186, cc = p129.bc[19498] or p129:ec(35920, 581, 19498), 2, val224
                  cc = cc + val186
                  p130[1][2][p130[1][1]], val183 = cc, val198
                end
              elseif ec >= 1813 then
                if ec < 1837 then
                  ec = val158 < val162 and (p129.gc[-31884] or p129:hc(22555, 59911, -31884))
                    or p129.gc[1437] or p129:hc(16793, 35051, 1437)
                elseif ec > 1837 then
                  ec, cc[6284] = ec + 317, val186
                  jc, val224, cc2, val158 = p130[3][2][p130[3][1]], p130[8][2][p130[8][1]], "B", p130[1][2][p130[1][1]]
                else
                  ec = val196 ~= val196 and (p129.bc[-13544] or p129:dc(9819707, 2713, -13544))
                    or p129.bc[-28370] or p129:ec(50447, 17057, -28370)
                end
              elseif ec > 1798 then
                val158 = val158(val162, p129.d(val228))
                cc, ec, val162, val172, val228 = val158, 4301374 / ec, p130[9][2][p130[9][1]], 128, jc
              else
                ec = val228 > 0 and (p129.bc[871] or p129:ec(64052, 26897, 871)) or p129.bc[1116]
                  or p129:dc(5842520, 5001, 1116)
              end
            elseif ec < 2427 then
              if ec > 2283 then
                if ec <= 2387 then
                  if ec > 2365 then
                    if ec <= 2370 then
                      ec, val228 = p129.gc[25476] or p129:hc(31344, 52604, 25476), p129.c(val228(val172, val211))
                    else
                      val162 = val162(val228, val172)
                      val158 = not val162

                      ec = val158 and (p129.gc[20912] or p129:hc(29891, 53239, 20912))
                        or 790097 / ec
                    end
                  elseif ec < 2356 then
                    if ec <= 2286 then
                      ec = val159 < val160 and (p129.bc[-4525] or p129:ec(49965, 19724, -4525))
                        or 2346 - ec
                    else
                      ec = val198 > cc and (p129.gc[-5510] or p129:hc(14702, 34984, -5510))
                        or p129.gc[9410] or p129:hc(3873, 48151, 9410)
                    end
                  elseif ec <= 2356 then
                    ec = val196 > val183 and (p129.bc[15609] or p129:dc(2468465, 15258, 15609))
                      or p129.bc[19940] or p129:dc(1883237, 1714, 19940)
                  else
                    ec = val182 < val231 and (p129.bc[-29261] or p129:dc(5737722, 31287, -29261))
                      or 4380 - ec
                  end
                elseif ec > 2396 then
                  if ec <= 2410 then
                    ec, cc[49287] = p129.gc[-11995] or p129:ic(44623116, 9188, -11995), val186
                  else
                    ec = val234 > val182 and (p129.bc[-1334] or p129:ec(50322, 18892, -1334))
                      or p129.bc[-1002] or p129:dc(31189715, 16021, -1002)
                  end
                elseif ec <= 2390 then
                  if ec <= 2389 then
                    ec = val231 ~= val231 and 2458 - ec or ec + -2252
                  else
                    ec, val158 = 6355 - ec, p129.c(val158(val162, val228))
                  end
                else
                  val224 = val224(cc2, jc, val158)
                  jc, cc2 = 1, val158
                  cc2 = cc2 + jc
                  ec, val186, p130[1][2][p130[1][1]] = 2907 - ec, val224, cc2
                end
              elseif ec >= 2205 then
                if ec > 2260 then
                  if ec >= 2264 then
                    if ec <= 2264 then
                      ec, val186 = 8530752 / ec, p129.c(val186(val224, cc2))
                    else
                      ec = val196 <= 0 and 5883 - ec or ec + -2055
                    end
                  else
                    val224 = val224(cc2, jc, val158)

                    cc2, jc = val158, 1
                    cc2 = cc2 + jc

                    p130[1][2][p130[1][1]], ec, val186 = cc2, 3168 - ec, val224
                  end
                elseif ec > 2224 then
                  ec = val162 ~= val162 and ec + -1950 or p129.bc[20083]
                    or p129:ec(61993, 31626, 20083)
                elseif ec > 2206 then
                  val224 = val224(cc2, jc, val158)

                  cc2, ec, jc = val158, p129.bc[-17465] or p129:ec(38580, 4501, -17465), 1
                  cc2 = cc2 + jc

                  p130[1][2][p130[1][1]], val186 = cc2, val224
                elseif ec > 2205 then
                  ec = val159 > 0 and 4641 - ec or ec + -480
                else
                  ec = val186 > val224 and (p129.gc[21629] or p129:ic(25655168, 29409, 21629))
                    or p129.bc[-28253] or p129:dc(31827585, 11101, -28253)
                end
              elseif ec < 2168 then
                if ec <= 2149 then
                  if ec > 2148 then
                    ec, val224 = 2099573 / ec, val224(cc2, jc, val158)

                    cc2, jc = val158, 1
                    cc2 = cc2 + jc

                    p130[1][2][p130[1][1]], val186 = cc2, val224
                  else
                    cc = cc(val186, val224)
                    val198 = not cc

                    ec = val198 and 414564 / ec or p129.bc[-18426]
                      or p129:dc(5927139, 24956, -18426)
                  end
                else
                  val224 = val224(cc2, jc, val158)

                  cc2, jc = val158, 1
                  cc2 = cc2 + jc

                  p130[1][2][p130[1][1]], val186 = cc2, val224

                  ec = val151 < jc and (p129.gc[-4653] or p129:hc(10309, 39491, -4653))
                    or 2391 - ec
                end
              elseif ec > 2188 then
                val187 = val187(val171, val201)
                val211 = not val187
                ec = val211 and ec + -1173 or p129.bc[13288] or p129:dc(2757049, 9126, 13288)
              elseif ec <= 2168 then
                ec = val182 < val231 and 2351 - ec or p129.bc[16823] or p129:ec(64037, 29787, 16823)
              else
                ec = val196 < val183 and 352268 / ec or 4310360 / ec
              end
            elseif ec <= 2583 then
              if ec <= 2516 then
                if ec < 2465 then
                  if ec >= 2435 then
                    if ec > 2435 then
                      val224 = val224(cc2, jc, val158)
                      jc, cc2 = 1, val158
                      cc2 = cc2 + jc
                      val186, ec, p130[1][2][p130[1][1]] = val224, 2177100 / ec, cc2
                    else
                      ec = val182 > val231 and ec + -2252 or 4161 - ec
                    end
                  else
                    val183 = val183(val198, cc, val186)

                    val198, cc = val186, 1
                    val198 = val198 + cc

                    ec, p130[1][2][p130[1][1]], val196 = 203868 / ec, val198, val183
                  end
                elseif ec < 2513 then
                  if ec <= 2465 then
                    ec = val196 ~= val196 and (p129.bc[-4525] or p129:ec(48718, 12331, -4525))
                      or p129.bc[17420] or p129:ec(36815, 272, 17420)
                  else
                    ec = val196 > val183 and (p129.bc[2619] or p129:ec(52869, 16200, 2619))
                      or 2463485 / ec
                  end
                elseif ec > 2513 then
                  ec = val228 <= 0 and 4561508 / ec or ec + 212
                else
                  val198 = val198(cc, val186)
                  cc = 7
                  ec, cc = 1816899 / ec, val234 * cc
                end
              elseif ec > 2572 then
                if ec <= 2577 then
                  ec, val171 = 4627 - ec, p129.c(val171(val201, val221))
                else
                  ec = val196 ~= val196 and (p129.bc[-20760] or p129:dc(2992314, 15441, -20760))
                    or 2811 - ec
                end
              elseif ec <= 2553 then
                if ec >= 2532 then
                  if ec > 2532 then
                    ec = val160 <= 0 and 9068256 / ec or p129.bc[25779]
                      or p129:dc(3477731, 1356, 25779)
                  else
                    ec, val172 = 6012 - ec, val172(val211, p129.d(val187))
                    val171, val211, val187, cc2 = 128, p130[9][2][p130[9][1]], val228, val172
                  end
                else
                  val224 = val224(cc2, jc, val158)
                  cc2, jc = val158, 1
                  ec, cc2 = p129.gc[2353] or p129:ic(26826624, 28116, 2353), cc2 + jc
                  val186, p130[1][2][p130[1][1]] = val224, cc2
                end
              else
                ec, cc = p129.bc[-31348] or p129:ec(45720, 12661, -31348), p129.c(cc(val186, val224))
              end
            elseif ec >= 2620 then
              if ec <= 2645 then
                if ec <= 2635 then
                  if ec > 2622 then
                    val224 = val224(cc2, jc)
                    val186 = not val224

                    ec = val186 and (p129.bc[15609] or p129:dc(4318235, 26544, 15609))
                      or p129.bc[-18562] or p129:ec(43178, 9545, -18562)
                  elseif ec <= 2620 then
                    ec = val162 > 0 and (p129.gc[-9174] or p129:hc(3758, 47256, -9174))
                      or p129.bc[-13825] or p129:dc(37170294, 9641, -13825)
                  else
                    ec = val196 <= 0 and (p129.bc[12275] or p129:ec(38494, 5101, 12275))
                      or p129.bc[-24092] or p129:ec(62087, 29165, -24092)
                  end
                else
                  ec = val228 <= 0 and ec + -653 or p129.bc[-10816]
                    or p129:ec(38232, 6452, -10816)
                end
              elseif ec > 2655 then
                ec = val196 ~= val196 and (p129.bc[-31422] or p129:ec(46611, 12194, -31422))
                  or 5694 - ec
              else
                ec = cc2 > 0 and (p129.bc[29063] or p129:ec(35557, 5, 29063)) or p129.gc[5591]
                  or p129:hc(16717, 35633, 5591)
              end
            elseif ec > 2598 then
              if ec <= 2615 then
                ec = val198 < cc and ec + -2474 or p129.bc[5124] or p129:dc(3264423, 15626, 5124)
              else
                val224 = val224(cc2, jc, val158)

                cc2, jc = val158, 1
                cc2 = cc2 + jc

                p130[1][2][p130[1][1]], val186 = cc2, val224

                ec = val204 <= jc and 3342 - ec or p129.gc[11670]
                  or p129:ic(6174000, 20272, 11670)
              end
            elseif ec < 2597 then
              val224 = val224(cc2, jc, val158)
              jc, cc2 = 1, val158
              ec, cc2 = 2147210 / ec, cc2 + jc
              p130[1][2][p130[1][1]], val186 = cc2, val224
            elseif ec > 2597 then
              ec = val160 ~= val160 and ec + -2487 or p129.bc[-4179] or p129:dc(766891, 3968, -4179)
            else
              ec = val196 > val183 and ec + -2436 or p129.bc[24921] or p129:ec(47114, 10015, 24921)
            end
          elseif ec > 920 then
            if ec < 1008 then
              if ec > 961 then
                if ec >= 983 then
                  if ec < 996 then
                    if ec >= 988 then
                      if ec > 990 then
                        ec, val198 = 1004950 / ec, 75
                      elseif ec <= 988 then
                        ec, val198 = 1998 - ec, 197
                      else
                        ec, val198 = p129.bc[20699] or p129:ec(61662, 31339, 20699), 37
                      end
                    elseif ec > 985 then
                      ec, val198 = p129.gc[-1090] or p129:hc(5194, 44610, -1090), 12
                    elseif ec <= 983 then
                      ec, val198 = p129.gc[-1090] or p129:hc(30231, 52287, -1090), 45
                    else
                      ec = val198 <= 0 and 5049 - ec or ec + 566
                    end
                  elseif ec >= 1004 then
                    if ec < 1005 then
                      ec, val198 = 1014040 / ec, 197
                    elseif ec > 1005 then
                      val224, val158, jc, ec, cc2 = p130[8][2][p130[8][1]], p130[1][2][p130[1][1]], p130[3][2][p130[3][1]], p129.gc[18045] or p129:hc(26708, 55325, 18045), p129.bc[-28414]
                        or p129:cc(p129.Eb("NghQ"), p129.Eb("cK"), -28414)
                    else
                      cc = 14

                      ec = val183 <= cc and 1815 - ec or p129.gc[-15772]
                        or p129:ic(5696768, 9912, -15772)
                    end
                  elseif ec <= 997 then
                    if ec > 996 then
                      cc = 93

                      ec = val183 <= cc and (p129.gc[-7547] or p129:hc(2083, 47473, -7547))
                        or 1625 - ec
                    else
                      val198 = 12

                      ec = val215 < val198 and (p129.gc[20272] or p129:hc(24951, 57363, 20272))
                        or ec + 14
                    end
                  else
                    cc = 181

                    ec = val183 > cc and 965965 / ec or p129.gc[-30925]
                      or p129:ic(7124110, 9838, -30925)
                  end
                elseif ec <= 975 then
                  if ec < 969 then
                    if ec > 965 then
                      ec, val198 = 1977 - ec, 162
                    elseif ec <= 964 then
                      cc = 183

                      ec = val183 > cc and (p129.gc[-32108] or p129:hc(11894, 37426, -32108))
                        or p129.bc[-18406] or p129:ec(50967, 18220, -18406)
                    else
                      ec, val198 = 1975 - ec, 197
                    end
                  elseif ec < 974 then
                    ec, val160[val196] = 1756 - ec, val186
                  elseif ec <= 974 then
                    ec, val198 = 983740 / ec, 45
                  else
                    ec, val158, cc2, val224, jc = 4457 - ec, p130[1][2][p130[1][1]], p129.gc[-2650]
                      or p129:jc(p129.Eb(";Fs("), p129.Eb("-T"), -2650), p130[8][2][p130[8][1]], p130[3][2][p130[3][1]]
                  end
                elseif ec > 978 then
                  if ec > 980 then
                    ec, val198 = p129.gc[-1090] or p129:hc(22137, 60573, -1090), 37
                  else
                    cc = 26

                    ec = val183 > cc and 1873 - ec or p129.gc[-16922]
                      or p129:ic(16997128, 27420, -16922)
                  end
                elseif ec < 977 then
                  val171, ec, val211, val201, val221, val187, val163 = p130[6][2][p130[6][1]], p129.gc[27443]
                    or p129:ic(82099602, 29242, 27443), p130[10][2][p130[10][1]], p130[7][2][p130[7][1]], val172, jc, 127
                elseif ec <= 977 then
                  cc[49932] = val186
                  val224, jc, val158, ec, cc2 = p130[8][2][p130[8][1]], p130[3][2][p130[3][1]], p130[1][2][p130[1][1]], p129.bc[-14291] or p129:ec(64733, 27799, -14291), "B"
                else
                  ec, val198 = ec + 32, 1
                end
              elseif ec >= 942 then
                if ec <= 952 then
                  if ec > 948 then
                    if ec > 950 then
                      cc = 121
                      ec = val183 > cc and ec + -29 or ec + -654
                    elseif ec <= 949 then
                      cc[6284] = val186

                      jc, val224, ec, cc2, val158 = p130[3][2][p130[3][1]], p130[8][2][p130[8][1]], p129.gc[-15647] or p129:kc(49768, 2932, -15647), p129.gc[26096]
                        or p129:jc(p129.Eb("pU9H"), p129.Eb("p#"), 26096), p130[1][2][p130[1][1]]
                    else
                      cc2, val164, val181 = 0, 109, 153

                      ec = val224 == cc2 and 1322 - ec or p129.gc[13657]
                        or p129:hc(10572, 38620, 13657)
                    end
                  elseif ec >= 946 then
                    if ec > 946 then
                      cc = 65

                      ec = val183 > cc and 1267 - ec or p129.bc[27788]
                        or p129:dc(16126858, 26381, 27788)
                    else
                      val198 = 197

                      ec = val166 <= val198 and (p129.gc[-1090] or p129:hc(22554, 59954, -1090))
                        or ec + -946
                    end
                  elseif ec > 942 then
                    ec, val198 = 1953 - ec, 75
                  else
                    cc = 236
                    ec = val183 < cc and 629256 / ec or ec + -694
                  end
                elseif ec <= 959 then
                  if ec <= 957 then
                    if ec <= 953 then
                      cc = 3

                      ec = val183 <= cc and (p129.gc[-27808] or p129:hc(20540, 61657, -27808))
                        or p129.bc[-4819] or p129:ec(64594, 28740, -4819)
                    else
                      cc = 209

                      ec = val183 >= cc and (p129.gc[18025] or p129:ic(10876873, 12443, 18025))
                        or p129.bc[31119] or p129:dc(7681355, 11636, 31119)
                    end
                  else
                    ec, val198 = ec + 51, 142
                  end
                elseif ec > 960 then
                  cc = 166

                  ec = val183 > cc and (p129.gc[31428] or p129:hc(2756, 46930, 31428))
                    or p129.gc[-22862] or p129:hc(18498, 64492, -22862)
                else
                  ec, val198 = p129.bc[20699] or p129:dc(15960535, 15790, 20699), 45
                end
              elseif ec <= 932 then
                if ec >= 928 then
                  if ec >= 931 then
                    if ec > 931 then
                      cc = 56
                      ec = val183 > cc and 806180 / ec or 685020 / ec
                    else
                      cc = 209

                      ec = val183 <= cc and (p129.bc[3710] or p129:ec(40163, 3854, 3710))
                        or 1832 - ec
                    end
                  elseif ec > 928 then
                    ec, val198 = 1940 - ec, 37
                  else
                    ec, cc[6284] = p129.gc[-11995] or p129:ic(19616202, 1690, -11995), val186
                  end
                elseif ec > 926 then
                  cc = 58

                  ec = val183 > cc and (p129.bc[23555] or p129:ec(44380, 8602, 23555))
                    or p129.gc[-28592] or p129:hc(33083, 50061, -28592)
                elseif ec <= 923 then
                  ec, val198 = 1933 - ec, 1
                else
                  ec, val198 = p129.gc[-1090] or p129:hc(14207, 36247, -1090), 197
                end
              elseif ec <= 936 then
                if ec < 935 then
                  ec, cc[14733] = ec + -157, val186

                  val224, jc, val158, cc2 = p130[8][2][p130[8][1]], p130[3][2][p130[3][1]], p130[1][2][p130[1][1]], p129.gc[-2650]
                    or p129:jc(p129.Eb("o$8S"), p129.Eb("qW"), -2650)
                elseif ec <= 935 then
                  ec, val198 = p129.gc[-1090] or p129:hc(11505, 38629, -1090), 37
                else
                  ec, val198 = ec + 74, 75
                end
              elseif ec <= 937 then
                ec, val198 = p129.bc[20699] or p129:ec(50164, 18821, 20699), 37
              else
                cc = 515
                ec = val183 <= cc and 744331 / ec or 364167 / ec
              end
            elseif ec > 1219 then
              if ec >= 1419 then
                if ec < 1518 then
                  if ec <= 1455 then
                    if ec > 1454 then
                      val224 = val224(cc2, jc, val158)

                      cc2, jc = val158, 2
                      cc2 = cc2 + jc

                      ec, val186, p130[1][2][p130[1][1]] = ec + -1072, val224, cc2
                    elseif ec > 1431 then
                      ec = val159 <= 0 and ec + 714 or 1529 - ec
                    elseif ec <= 1419 then
                      val196 = val196(val183, p129.d(val198))
                      val183, val198, cc, ec, val234 = p130[9][2][p130[9][1]], val160, 128, ec + 1949, val196
                    else
                      val224 = val224(cc2, jc, val158)
                      jc, cc2 = 1, val158
                      cc2 = cc2 + jc
                      p130[1][2][p130[1][1]], ec, val186 = cc2, 2365 - ec, val224
                    end
                  elseif ec <= 1461 then
                    ec = val234 < val182 and 100809 / ec or p129.bc[22560]
                      or p129:ec(37894, 6652, 22560)
                  else
                    ec, val224 = 3386 - ec, val224(cc2, jc, val158)
                    jc, cc2 = 1, val158
                    cc2 = cc2 + jc
                    val186, p130[1][2][p130[1][1]] = val224, cc2
                  end
                elseif ec < 1549 then
                  if ec >= 1537 then
                    if ec > 1537 then
                      ec = val198 > cc and (p129.bc[19296] or p129:ec(53369, 24149, 19296))
                        or p129.gc[-16294] or p129:ic(63367699, 25799, -16294)
                    else
                      ec = val198 ~= val198 and (p129.bc[-2809] or p129:ec(1246, 32702, -2809))
                        or p129.bc[9663] or p129:ec(43102, 8371, 9663)
                    end
                  else
                    ec = val231 <= 0 and 3254 - ec or 3907 - ec
                  end
                elseif ec <= 1551 then
                  if ec <= 1549 then
                    val224 = val224(cc2, jc, val158)

                    cc2, ec, jc = val158, 571581 / ec, 2
                    cc2 = cc2 + jc

                    val186, p130[1][2][p130[1][1]] = val224, cc2
                  else
                    ec = val198 ~= val198 and 294690 / ec or p129.gc[-20889]
                      or p129:hc(12847, 36816, -20889)
                  end
                else
                  val162 = val162(val228, val172)
                  val228 = 7
                  ec, val228 = ec + 825, val198 * val228
                end
              elseif ec < 1361 then
                if ec >= 1283 then
                  if ec < 1344 then
                    ec = val162 <= 0 and 3874660 / ec or p129.gc[-15250]
                      or p129:hc(35008, 49654, -15250)
                  elseif ec <= 1344 then
                    val182 = val182(val231, val159, val160)

                    val231, val159 = val160, 1
                    val231 = val231 + val159

                    p130[1][2][p130[1][1]], val234 = val231, val182

                    ec = val175 > val159 and (p129.bc[11431] or p129:dc(5635152, 22419, 11431))
                      or p129.bc[-19777] or p129:dc(5222584, 22137, -19777)
                  else
                    ec = val186 ~= val186 and 949900 / ec or p129.gc[-27390]
                      or p129:hc(24122, 58810, -27390)
                  end
                elseif ec <= 1264 then
                  ec = val159 < val160 and 1457 - ec or p129.bc[-24092]
                    or p129:ec(45702, 12782, -24092)
                else
                  ec = val159 > val160 and (p129.bc[-20760] or p129:dc(2584891, 13456, -20760))
                    or 3893 - ec
                end
              elseif ec < 1389 then
                if ec <= 1368 then
                  if ec <= 1361 then
                    val160 = val160(val196, p129.d(val183))
                    val196, val198, val183, ec, val170 = p130[9][2][p130[9][1]], 128, val159, 2764 - ec, val160
                  else
                    ec, val186 = ec + 1267, val186(val224, p129.d(cc2))
                    jc, val224, val160, cc2 = 128, p130[9][2][p130[9][1]], val186, cc
                  end
                else
                  val158 = val158(val162, val228, val172)
                  ec, val228, val162 = ec + -648, 1, val172
                  val162 = val162 + val228
                  p130[1][2][p130[1][1]], jc = val162, val158
                end
              elseif ec < 1403 then
                ec = val196 > val183 and ec + -1199 or 2926 - ec
              elseif ec <= 1403 then
                val196 = val196(val183, val198)
                val160 = not val196
                ec = val160 and (p129.bc[-1334] or p129:dc(1053875, 15928, -1334)) or 350750 / ec
              else
                ec = val196 > 0 and (p129.bc[2503] or p129:ec(34491, 404, 2503)) or 4075 - ec
              end
            elseif ec >= 1076 then
              if ec > 1136 then
                if ec > 1179 then
                  if ec > 1196 then
                    val160 = val160(val196)
                    val183, val196 = val159, 1
                    val198 = val196

                    ec = val183 ~= val183 and 231610 / ec or p129.bc[-18927]
                      or p129:ec(39425, 2014, -18927)
                  else
                    ec = val186 <= 0 and (p129.bc[27439] or p129:ec(64782, 28424, 27439))
                      or p129.bc[17464] or p129:dc(263811, 8348, 17464)
                  end
                elseif ec <= 1157 then
                  if ec <= 1147 then
                    ec = val186 ~= val186 and ec + -982 or p129.bc[17464]
                      or p129:dc(995365, 27389, 17464)
                  else
                    ec = val198 < cc and 190905 / ec or p129.bc[17464]
                      or p129:ec(48876, 12361, 17464)
                  end
                else
                  ec = val228 ~= val228 and ec + 813 or p129.bc[3830]
                    or p129:dc(50646972, 19131, 3830)
                end
              elseif ec >= 1100 then
                if ec > 1129 then
                  val224 = val224(cc2, jc, val158)

                  cc2, jc = val158, 2
                  cc2 = cc2 + jc

                  val186, p130[1][2][p130[1][1]] = val224, cc2

                  ec = val150 < jc and (p129.gc[-11995] or p129:ic(87804272, 26248, -11995))
                    or p129.bc[-20860] or p129:ec(60181, 25714, -20860)
                elseif ec > 1121 then
                  val224 = val224(cc2, jc, val158)

                  cc2, jc = val158, 2
                  cc2 = cc2 + jc

                  ec, val186, p130[1][2][p130[1][1]] = 1980 - ec, val224, cc2
                elseif ec > 1100 then
                  ec = val186 > val224 and ec + -395 or p129.gc[5591] or p129:hc(14166, 38190, 5591)
                else
                  ec, val196 = p129.bc[-11404] or p129:dc(2165815, 26740, -11404), val196(val183, val198, cc)

                  val183, val198 = cc, 1
                  val183 = val183 + val198

                  p130[1][2][p130[1][1]], val160 = val183, val196
                end
              elseif ec <= 1087 then
                if ec > 1076 then
                  ec = val198 <= 0 and (p129.bc[-1347] or p129:ec(60856, 23215, -1347))
                    or p129.bc[-22437] or p129:ec(56804, 19381, -22437)
                else
                  val224 = val224(cc2, jc, val158)
                  jc, ec, cc2 = 1, p129.bc[8871] or p129:dc(8269082, 14995, 8871), val158
                  cc2 = cc2 + jc
                  p130[1][2][p130[1][1]], val186 = cc2, val224
                end
              else
                ec = val186 > 0 and (p129.gc[-5507] or p129:hc(13021, 38021, -5507))
                  or p129.bc[10481] or p129:ec(49713, 16370, 10481)
              end
            elseif ec >= 1021 then
              if ec >= 1050 then
                if ec <= 1053 then
                  if ec <= 1050 then
                    ec, val187 = 2658600 / ec, p129.c(val187(val171, val201))
                  else
                    ec, val224 = p129.gc[-20592] or p129:ic(12210510, 26485, -20592), val224(cc2, jc, val158)

                    cc2, jc = val158, 2
                    cc2 = cc2 + jc

                    p130[1][2][p130[1][1]], val186 = cc2, val224
                  end
                else
                  ec = cc2 ~= cc2 and (p129.bc[-16644] or p129:fc(10981, 2552, -16644))
                    or 935616 / ec
                end
              elseif ec <= 1022 then
                if ec > 1021 then
                  cc2 = jc

                  ec = val178 < val174 and 1477 - ec or p129.bc[-8300]
                    or p129:ec(40023, 3991, -8300)
                else
                  cc = 205
                  ec = val183 > cc and 2016 - ec or ec + -890
                end
              else
                val224 = val224(cc2, jc, val158)

                cc2, jc = val158, 1
                cc2 = cc2 + jc

                p130[1][2][p130[1][1]], ec, val186 = cc2, 498465 / ec, val224
              end
            elseif ec >= 1015 then
              if ec < 1017 then
                val198 = 45
                ec = val157 <= val198 and ec + -5 or p129.bc[2774] or p129:ec(42048, 10164, 2774)
              elseif ec <= 1017 then
                cc = 7

                ec = val183 <= cc and 173907 / ec or p129.gc[23513]
                  or p129:hc(18519, 64154, 23513)
              else
                val224, cc2, val158, ec, jc = p130[8][2][p130[8][1]], "B", p130[1][2][p130[1][1]], p129.bc[-28798] or p129:dc(5640996, 2259, -28798), p130[3][2][p130[3][1]]
              end
            elseif ec >= 1010 then
              if ec > 1010 then
                cc = 62

                ec = val183 > cc and (p129.gc[-16617] or p129:hc(16459, 32931, -16617))
                  or p129.gc[2191] or p129:ic(5690432, 25460, 2191)
              else
                val186 = {}
                val186[15562] = val183

                val224 = 0
                val186[6284] = val224
                ec, val186[14733] = p129.gc[4316] or p129:hc(10084, 39679, 4316), val224

                val186[49287] = val224
                val186[49932] = val224
                val186[24799] = val224
                val186[29601] = val224
                val186[44007] = val224
                val186[23485] = val224
                val186[40758] = val224
                val186[8652] = val224
                val186[6863] = val224
                val186[13110] = val224

                val224, cc, val186 = val231, val186, p130[5][2][p130[5][1]]
                cc2 = cc
              end
            else
              ec, val198 = ec + 2, 1
            end
          elseif ec < 814 then
            if ec > 766 then
              if ec >= 790 then
                if ec > 799 then
                  if ec > 808 then
                    if ec <= 810 then
                      ec, val198 = ec + 200, 233
                    else
                      cc = 113

                      ec = val183 < cc and ec + -461 or p129.bc[-5290]
                        or p129:dc(15493485, 20253, -5290)
                    end
                  elseif ec >= 806 then
                    if ec <= 806 then
                      ec, val198 = ec + 204, 12
                    else
                      val198 = val198 + val186

                      ec = val186 > 0 and (p129.gc[30747] or p129:hc(14554, 36954, 30747))
                        or ec + 790
                    end
                  else
                    ec, val198 = 1815 - ec, 197
                  end
                elseif ec >= 794 then
                  if ec > 797 then
                    val198 = 45
                    ec = val156 > val198 and 806990 / ec or ec + -595
                  elseif ec < 796 then
                    val198 = 69

                    ec = val229 < val198 and (p129.gc[25240] or p129:ic(19129544, 17216, 25240))
                      or 1804 - ec
                  elseif ec > 796 then
                    val198 = 1

                    ec = val194 <= val198 and (p129.bc[12488] or p129:dc(21266545, 25094, 12488))
                      or 804970 / ec
                  else
                    cc2, ec, val158, val224, jc = "B", p129.gc[2563] or p129:ic(16374150, 2278, 2563), p130[1][2][p130[1][1]], p130[8][2][p130[8][1]], p130[3][2][p130[3][1]]
                  end
                elseif ec >= 791 then
                  if ec <= 791 then
                    val198 = 45

                    ec = val152 < val198 and 317982 / ec or p129.bc[20699]
                      or p129:ec(3267, 32334, 20699)
                  else
                    ec, val198 = p129.bc[20699] or p129:dc(26344901, 26031, 20699), 45
                  end
                else
                  ec, val198 = p129.bc[20699] or p129:dc(7017529, 6993, 20699), 142
                end
              elseif ec > 777 then
                if ec < 783 then
                  if ec <= 779 then
                    ec, val198 = p129.bc[20699] or p129:ec(64695, 28226, 20699), 12
                  else
                    val198 = 197

                    ec = val161 <= val198 and (p129.gc[-30917] or p129:ic(299943, 13917, -30917))
                      or 788810 / ec
                  end
                elseif ec >= 785 then
                  if ec > 785 then
                    val196 = val196 + val198

                    ec = val198 > 0 and (p129.gc[29246] or p129:hc(8992, 42817, 29246))
                      or ec + 198
                  else
                    cc = 222
                    ec = val183 <= cc and ec + -641 or 1075 - ec
                  end
                else
                  ec, val198 = 790830 / ec, 75
                end
              elseif ec < 773 then
                if ec < 770 then
                  val198 = 12

                  ec = val202 <= val198 and 357120 / ec or p129.bc[20699]
                    or p129:ec(53229, 15740, 20699)
                elseif ec > 770 then
                  ec, val198 = 1781 - ec, 37
                else
                  ec, val198 = 1780 - ec, 197
                end
              elseif ec < 775 then
                ec, val198 = p129.bc[20699] or p129:ec(65139, 27902, 20699), 45
              elseif ec > 775 then
                ec, val224 = p129.bc[-27824] or p129:dc(7465131, 10540, -27824), val224(cc2, jc, val158)

                cc2, jc = val158, 2
                cc2 = cc2 + jc

                p130[1][2][p130[1][1]], val186 = cc2, val224
              else
                cc = 96
                ec = val183 >= cc and 1340 - ec or p129.gc[-21102] or p129:hc(2413, 48018, -21102)
              end
            elseif ec >= 744 then
              if ec >= 753 then
                if ec > 760 then
                  if ec <= 762 then
                    if ec > 761 then
                      ec, cc2, val224, val158, jc = 1723644 / ec, "B", p130[8][2][p130[8][1]], p130[1][2][p130[1][1]], p130[3][2][p130[3][1]]
                    else
                      ec, val158 = p129.bc[21829] or p129:ec(4019, 31307, 21829), "c"
                      jc, val158 = val158 .. cc2, p130[8][2][p130[8][1]]
                      val162, val172, val228 = jc, p130[1][2][p130[1][1]], p130[3][2][p130[3][1]]
                    end
                  else
                    cc = 113
                    ec = val183 <= cc and ec + 222 or ec + -7
                  end
                elseif ec <= 759 then
                  if ec < 756 then
                    val198 = 37

                    ec = val209 > val198 and 760530 / ec or p129.bc[-21935]
                      or p129:dc(19861733, 22673, -21935)
                  elseif ec <= 756 then
                    ec, val198 = ec + 254, 104
                  else
                    ec, val198 = ec + 251, 197
                  end
                else
                  cc = 161
                  ec = val183 < cc and 341240 / ec or 1311 - ec
                end
              elseif ec > 750 then
                if ec > 751 then
                  ec, val198 = p129.gc[-1090] or p129:hc(23552, 58900, -1090), 35
                else
                  ec, val198 = p129.bc[20699] or p129:ec(40696, 3209, 20699), 45
                end
              elseif ec > 746 then
                ec, val198 = ec + 260, 45
              elseif ec >= 745 then
                if ec > 745 then
                  ec, val198 = ec + 264, 104
                else
                  cc = 43

                  ec = val183 <= cc and ec + 69 or p129.gc[27951]
                    or p129:ic(12147840, 11350, 27951)
                end
              else
                ec, val198 = 1754 - ec, 197
              end
            elseif ec < 734 then
              if ec >= 728 then
                if ec >= 731 then
                  if ec > 731 then
                    cc[14733] = val186
                    cc2, jc, ec, val158, val224 = "B", p130[3][2][p130[3][1]], ec + 1038, p130[1][2][p130[1][1]], p130[8][2][p130[8][1]]
                  else
                    val162, val158, ec, val228, val172, val187, val211 = cc, p130[10][2][p130[10][1]], p129.gc[-16733]
                      or p129:ic(127152198, 24734, -16733), p130[6][2][p130[6][1]], p130[7][2][p130[7][1]], 127, jc
                  end
                else
                  ec, val224[44007] = p129.gc[22952] or p129:hc(1392, 48372, 22952), cc2
                end
              elseif ec < 724 then
                ec, val183 = p129.bc[-29644] or p129:ec(54531, 22063, -29644), p129.c(val183(val198, cc))
              elseif ec <= 724 then
                cc = 218

                ec = val183 <= cc and (p129.gc[-10624] or p129:ic(5348448, 10776, -10624))
                  or 182448 / ec
              else
                ec, val198 = ec + -293, cc
              end
            elseif ec >= 738 then
              if ec > 740 then
                val198 = 1
                ec = val168 < val198 and 199124 / ec or 750430 / ec
              elseif ec > 738 then
                cc = 67
                ec = val183 <= cc and (p129.gc[23934] or p129:hc(3880, 45096, 23934)) or 1454 - ec
              else
                cc = 915

                ec = val183 <= cc and (p129.gc[-788] or p129:ic(4304575, 1779, -788))
                  or p129.bc[-1185] or p129:dc(10439350, 13393, -1185)
              end
            elseif ec > 735 then
              val186, val197, val199 = 104, 5, 100
              ec = val198 > val186 and 1756 - ec or p129.bc[-4487] or p129:ec(49767, 18709, -4487)
            elseif ec > 734 then
              ec, val198 = 742350 / ec, 45
            else
              ec, val198 = 741340 / ec, 1
            end
          elseif ec > 874 then
            if ec < 896 then
              if ec > 885 then
                if ec <= 892 then
                  if ec > 890 then
                    ec, val198 = 1902 - ec, 233
                  elseif ec <= 886 then
                    ec, val162, val158, val172, val228 = ec + 493, "B", p130[8][2][p130[8][1]], p130[1][2][p130[1][1]], p130[3][2][p130[3][1]]
                  else
                    cc = 138

                    ec = val183 <= cc and ec + -357 or p129.bc[-22206]
                      or p129:dc(9142915, 17974, -22206)
                  end
                elseif ec > 893 then
                  cc2 = 0
                  val158, val162, jc = 4, 1, cc2

                  ec = val158 ~= val158 and (p129.bc[-18962] or p129:dc(9694149, 31125, -18962))
                    or 2342280 / ec
                else
                  ec, val198 = p129.bc[20699] or p129:ec(53997, 22652, 20699), 1
                end
              elseif ec <= 882 then
                if ec <= 879 then
                  if ec > 878 then
                    cc = 74

                    ec = val183 > cc and (p129.gc[4058] or p129:hc(22968, 59529, 4058))
                      or p129.bc[-3028] or p129:ec(50762, 18225, -3028)
                  elseif ec <= 875 then
                    ec, val198 = p129.gc[-1090] or p129:ic(27559870, 30639, -1090), 45
                  else
                    cc = 432

                    ec = val183 > cc and 1318 - ec or p129.bc[-4198]
                      or p129:ec(62869, 30835, -4198)
                  end
                else
                  ec, cc[49287] = 4008 - ec, val186
                  val158, val224, cc2, jc = p130[1][2][p130[1][1]], p130[8][2][p130[8][1]], "B", p130[3][2][p130[3][1]]
                end
              elseif ec <= 884 then
                ec, val198 = p129.bc[20699] or p129:ec(34753, 1360, 20699), 37
              else
                ec, cc[14733] = p129.gc[-11995] or p129:ic(55570920, 21360, -11995), val186
              end
            elseif ec >= 913 then
              if ec < 918 then
                if ec >= 914 then
                  if ec <= 914 then
                    cc[14733] = val186
                    val158, val224, ec, jc, cc2 = p130[1][2][p130[1][1]], p130[8][2][p130[8][1]], p129.gc[-27541] or p129:hc(29602, 54780, -27541), p130[3][2][p130[3][1]], "B"
                  else
                    ec, val198 = p129.gc[-1090] or p129:ic(11253420, 14014, -1090), 12
                  end
                else
                  val224 = 3
                  ec = cc == val224 and 594363 / ec or 607145 / ec
                end
              elseif ec < 919 then
                ec, val198 = 927180 / ec, 197
              elseif ec <= 919 then
                cc = 178

                ec = val183 <= cc and 1819 - ec or p129.gc[-32024]
                  or p129:hc(29792, 52337, -32024)
              else
                cc = 163

                ec = val183 <= cc and (p129.bc[28937] or p129:ec(63470, 30400, 28937))
                  or p129.bc[-11998] or p129:ec(47198, 13906, -11998)
              end
            elseif ec <= 903 then
              if ec >= 901 then
                if ec <= 901 then
                  ec, val198 = p129.gc[-1090] or p129:ic(4889410, 4049, -1090), 197
                else
                  val186 = 12

                  ec = val198 <= val186 and (p129.gc[28786] or p129:ic(4961125, 9881, 28786))
                    or p129.gc[-21252] or p129:hc(15274, 33940, -21252)
                end
              elseif ec > 896 then
                ec, val198 = p129.gc[-1090] or p129:ic(26243840, 30904, -1090), 37
              else
                val224 = {}
                val224[50602] = val191
                val224[35016] = val234
                val224[40559] = val170
                val224[40274] = val231
                val224[44371] = cc
                val224[45868] = val183

                cc2 = 0

                val224[4625] = cc2
                val224[8164] = cc2

                val186 = val224
                return val186
              end
            elseif ec <= 905 then
              ec, val198 = 914050 / ec, 37
            else
              cc[14733] = val186
              ec, cc2, val158, jc, val224 = 1951 - ec, "B", p130[1][2][p130[1][1]], p130[3][2][p130[3][1]], p130[8][2][p130[8][1]]
            end
          elseif ec < 842 then
            if ec <= 829 then
              if ec > 820 then
                if ec <= 828 then
                  if ec <= 827 then
                    ec, val198 = ec + 183, 37
                  else
                    cc = 16

                    ec = val183 > cc and 1625 - ec or p129.gc[-20496]
                      or p129:ic(5057775, 19191, -20496)
                  end
                else
                  ec, val198 = ec + 181, 197
                end
              elseif ec > 817 then
                jc, val158, cc2, ec, val224 = p130[3][2][p130[3][1]], p130[1][2][p130[1][1]], "B", p129.bc[7474] or p129:dc(84604837, 28478, 7474), p130[8][2][p130[8][1]]
              elseif ec <= 816 then
                if ec <= 814 then
                  ec, val198 = p129.gc[-1090] or p129:ic(5826690, 2993, -1090), 37
                else
                  cc2 = cc2(jc, val158, val162)

                  jc, val158 = val162, 1
                  jc = jc + val158

                  ec, val224, p130[1][2][p130[1][1]] = p129.bc[14814]
                    or p129:ec(63236, 30941, 14814), cc2, jc
                end
              else
                val234 = val234(val182, val231, val159)

                val182, val231 = val159, 1
                val182 = val182 + val231

                ec, p130[1][2][p130[1][1]], val170 = p129.bc[318] or p129:ec(51437, 17887, 318), val182, val234
              end
            elseif ec <= 832 then
              if ec > 831 then
                cc = 81

                ec = val183 <= cc and (p129.gc[20185] or p129:hc(30511, 51715, 20185))
                  or ec + -302
              elseif ec <= 830 then
                ec, cc[6284] = p129.gc[-25322] or p129:hc(26314, 57129, -25322), val186
                jc, val224, val158, cc2 = p130[3][2][p130[3][1]], p130[8][2][p130[8][1]], p130[1][2][p130[1][1]], "B"
              else
                cc = 239

                ec = val183 <= cc and ec + -63 or p129.bc[-11202]
                  or p129:dc(9785931, 22682, -11202)
              end
            elseif ec <= 833 then
              val198 = 197
              ec = val218 >= val198 and ec + -587 or p129.bc[20699] or p129:ec(65246, 27755, 20699)
            else
              cc = 123

              ec = val183 > cc and (p129.gc[-20580] or p129:hc(14261, 34995, -20580))
                or p129.bc[8375] or p129:ec(3591, 32383, 8375)
            end
          elseif ec < 857 then
            if ec >= 849 then
              if ec <= 850 then
                if ec <= 849 then
                  ec, val198 = 1859 - ec, 206
                else
                  ec, val198 = p129.gc[-1090] or p129:ic(29031440, 28016, -1090), 197
                end
              else
                ec, cc[23485] = ec + -179, val186
                jc, val224, val158, cc2 = p130[3][2][p130[3][1]], p130[8][2][p130[8][1]], p130[1][2][p130[1][1]], "B"
              end
            elseif ec <= 846 then
              if ec <= 842 then
                ec, val198 = 850420 / ec, 45
              else
                cc = 202

                ec = val183 <= cc and 1104 - ec or p129.bc[23748]
                  or p129:dc(10693873, 14906, 23748)
              end
            else
              ec, val198 = p129.gc[-1090] or p129:ic(20792870, 19795, -1090), 1
            end
          elseif ec < 865 then
            if ec > 859 then
              cc = 17

              ec = val183 > cc and (p129.gc[-15796] or p129:ic(5155620, 28294, -15796))
                or 713736 / ec
            elseif ec > 857 then
              cc[6284] = val186
              jc, val158, val224, ec, cc2 = p130[3][2][p130[3][1]], p130[1][2][p130[1][1]], p130[8][2][p130[8][1]], p129.bc[-31207] or p129:dc(20224103, 8213, -31207), "B"
            else
              val171 = val171(val201, val221)
              val201 = 7
              ec, val201 = p129.bc[-2991] or p129:ec(38108, 5701, -2991), jc * val201
            end
          elseif ec > 872 then
            ec, cc[13110] = 2423602 / ec, val186
          elseif ec > 871 then
            ec, val198 = p129.gc[-1090] or p129:ic(19431390, 22047, -1090), 37
          elseif ec <= 865 then
            ec, val198 = p129.bc[20699] or p129:ec(62959, 30586, 20699), 69
          else
            cc[6284], val190 = val186, 133
            ec, val158, jc, val224, cc2 = 2395250 / ec, p130[1][2][p130[1][1]], p130[3][2][p130[3][1]], p130[8][2][p130[8][1]], "B"
          end
        elseif ec <= 325 then
          if ec > 167 then
            if ec >= 235 then
              if ec <= 279 then
                if ec < 252 then
                  if ec < 246 then
                    if ec <= 239 then
                      if ec <= 238 then
                        if ec <= 236 then
                          if ec <= 235 then
                            val174, val193, val153, val231, val208, ec, val178, val215, val207, val154, val219, val159 = 73, 129, 216, p130[4][2][p130[4][1]], 93, ec
                              + 3036, 38, 196, 255, 206, 222, val182
                          else
                            ec, val198 = 1246 - ec, 37
                          end
                        else
                          val159 = val159 + val196
                          ec = val196 > 0 and 1509 - ec or 2860 - ec
                        end
                      else
                        cc = 216
                        ec = val183 < cc and 1196 - ec or 173036 / ec
                      end
                    elseif ec > 241 then
                      cc = 576

                      ec = val183 <= cc and 42525 / ec or p129.bc[-3363]
                        or p129:ec(65159, 28494, -3363)
                    else
                      val186 = 142

                      ec = val198 < val186 and (p129.gc[30100] or p129:ic(11960773, 8797, 30100))
                        or p129.bc[16057] or p129:ec(63122, 30290, 16057)
                    end
                  elseif ec >= 249 then
                    if ec <= 250 then
                      if ec <= 249 then
                        val194, val225, val231, val227 = 115, 191, 0, 182
                        val196, val160, val159 = 1, 4, val231
                        ec = val160 ~= val160 and 442 - ec or 867765 / ec
                      else
                        val234 = val234 + val231

                        ec = val231 > 0 and (p129.bc[475] or p129:ec(55909, 18870, 475))
                          or p129.bc[32218] or p129:ec(45218, 14387, 32218)
                      end
                    else
                      val159, ec, val182, val216, val223, val234, val195, val184, val231, val166, val165 = p130[1][2][p130[1][1]], 205067
                        / ec, "B", 182, 201, p130[8][2][p130[8][1]], 164, 120, p130[3][2][p130[3][1]], 23, 191
                    end
                  elseif ec < 247 then
                    val198 = 142

                    ec = val155 > val198 and (p129.bc[20699] or p129:ec(44570, 7335, 20699))
                      or 49692 / ec
                  elseif ec <= 247 then
                    cc = 455

                    ec = val183 <= cc and (p129.bc[-14303] or p129:ec(33132, 3615, -14303))
                      or p129.bc[-22207] or p129:ec(59234, 26159, -22207)
                  else
                    cc = 236
                    ec = val183 > cc and ec + 319 or 782 - ec
                  end
                elseif ec > 263 then
                  if ec < 271 then
                    if ec <= 265 then
                      ec, cc[23485] = p129.bc[32106] or p129:dc(33569849, 11395, 32106), val186
                      jc, val224, cc2, val158 = p130[3][2][p130[3][1]], p130[8][2][p130[8][1]], "B", p130[1][2][p130[1][1]]
                    else
                      ec, val198 = p129.bc[20699] or p129:ec(3374, 32699, 20699), 197
                    end
                  elseif ec <= 273 then
                    if ec > 271 then
                      ec, cc[6284] = p129.gc[-11995] or p129:hc(7902, 43539, -11995), val186
                    else
                      val198 = 197

                      ec = val203 < val198 and ec + -264 or p129.gc[-1090]
                        or p129:hc(25638, 56878, -1090)
                    end
                  else
                    cc = 0
                    ec = val183 > cc and 837 - ec or 210924 / ec
                  end
                elseif ec > 257 then
                  if ec >= 259 then
                    if ec > 259 then
                      cc = 41

                      ec = val183 > cc and (p129.bc[-9656] or p129:ec(50955, 18119, -9656))
                        or p129.gc[-31953] or p129:hc(1577, 48597, -31953)
                    else
                      ec, cc[6284] = ec + 1196, val186

                      val158, cc2, val224, jc = p130[1][2][p130[1][1]], p129.bc[-28414]
                        or p129:cc(p129.Eb("<g@4"), p129.Eb("+5"), -28414), p130[8][2][p130[8][1]], p130[3][2][p130[3][1]]
                    end
                  else
                    cc = 200

                    ec = val183 <= cc and 168732 / ec or p129.gc[30280]
                      or p129:ic(9810572, 11948, 30280)
                  end
                elseif ec <= 255 then
                  if ec > 253 then
                    cc = 38
                    ec = val183 > cc and 859 - ec or 161670 / ec
                  elseif ec <= 252 then
                    ec, val198 = 254520 / ec, 197
                  else
                    cc = 194
                    ec = val183 > cc and 147499 / ec or 658 - ec
                  end
                else
                  ec, val198 = 1267 - ec, 197
                end
              elseif ec < 302 then
                if ec >= 292 then
                  if ec <= 296 then
                    if ec >= 294 then
                      if ec > 294 then
                        val186 = 197

                        ec = val198 > val186 and 242720 / ec or p129.gc[-26631]
                          or p129:ic(5282870, 13181, -26631)
                      else
                        cc[8652] = val186
                        jc, ec, cc2, val224, val158 = p130[3][2][p130[3][1]], 1128372 / ec, "B", p130[8][2][p130[8][1]], p130[1][2][p130[1][1]]
                      end
                    elseif ec > 292 then
                      val198 = val198 + val186

                      ec = val186 > 0 and (p129.bc[27641] or p129:fc(10298, 2052, 27641))
                        or p129.bc[25172] or p129:ec(3059, 32131, 25172)
                    else
                      cc[44007] = val186

                      ec, val224, val158, cc2, jc = 307476 / ec, p130[8][2][p130[8][1]], p130[1][2][p130[1][1]], p129.gc[-2650]
                        or p129:jc(p129.Eb("sNbX"), p129.Eb("mH"), -2650), p130[3][2][p130[3][1]]
                    end
                  elseif ec > 298 then
                    val186 = 37
                    ec = val198 > val186 and ec + 272 or ec + 496
                  else
                    cc = 119
                    ec = val183 > cc and ec + 452 or 76586 / ec
                  end
                elseif ec <= 287 then
                  if ec >= 284 then
                    if ec <= 284 then
                      cc2, val224, ec, val158, jc = p129.bc[-28414]
                        or p129:cc(p129.Eb("iQa_"), p129.Eb("w*"), -28414), p130[8][2][p130[8][1]], 3381 - ec, p130[1][2][p130[1][1]], p130[3][2][p130[3][1]]
                    else
                      val224 = 5

                      ec = cc == val224 and (p129.bc[22141] or p129:dc(13598158, 29269, 22141))
                        or p129.bc[23294] or p129:ec(55421, 21357, 23294)
                    end
                  else
                    val198 = 142
                    ec = val167 < val198 and 1292 - ec or 227010 / ec
                  end
                elseif ec > 288 then
                  ec, val198 = p129.bc[20699] or p129:dc(5642661, 5631, 20699), 45
                else
                  val172, ec, val211, val187, val171 = p130[8][2][p130[8][1]], p129.bc[431] or p129:ec(50583, 16516, 431), "B", p130[3][2][p130[3][1]], p130[1][2][p130[1][1]]
                end
              elseif ec > 313 then
                if ec > 319 then
                  if ec > 321 then
                    ec, val224, jc, val158, cc2 = 840775 / ec, p130[8][2][p130[8][1]], p130[3][2][p130[3][1]], p130[1][2][p130[1][1]], "B"
                  else
                    ec, val198 = p129.gc[-1090] or p129:ic(12110910, 13295, -1090), 37
                  end
                elseif ec > 317 then
                  ec, val198 = p129.bc[20699] or p129:ec(52766, 15531, 20699), 75
                elseif ec <= 314 then
                  ec, val198 = ec + 696, 37
                else
                  ec, val198 = p129.gc[-1090] or p129:ic(21702880, 20168, -1090), 45
                end
              elseif ec > 308 then
                if ec > 310 then
                  ec, val198 = 316130 / ec, 197
                elseif ec > 309 then
                  val224 = cc2

                  ec = val193 > val207 and (p129.gc[12460] or p129:hc(1711, 47124, 12460))
                    or ec + 640
                else
                  val198 = 1

                  ec = val220 <= val198 and (p129.gc[17375] or p129:ic(25928550, 30397, 17375))
                    or p129.gc[-1090] or p129:ic(2975460, 5818, -1090)
                end
              elseif ec >= 307 then
                if ec <= 307 then
                  val158 = val158 + val228

                  ec = val228 > 0 and (p129.gc[-31326] or p129:kc(49152, 1622, -31326))
                    or ec + 2209
                else
                  val186 = 12
                  ec = val198 < val186 and 707 - ec or 1211 - ec
                end
              elseif ec <= 302 then
                cc = 229
                ec = val183 <= cc and 294148 / ec or 44092 / ec
              else
                ec, cc[6863] = p129.gc[-11995] or p129:hc(31424, 53745, -11995), val186
              end
            elseif ec > 201 then
              if ec <= 217 then
                if ec > 210 then
                  if ec <= 213 then
                    if ec >= 212 then
                      if ec > 212 then
                        val234, val230, val180 = 0, 153, 96
                        val159, val231, val182 = 1, 4, val234

                        ec = val231 ~= val231 and (p129.bc[-29261] or p129:dc(142869, 1074, -29261))
                          or p129.bc[11667] or p129:ec(51573, 16216, 11667)
                      else
                        cc = 876

                        ec = val183 <= cc and 194192 / ec or p129.gc[18851]
                          or p129:hc(9518, 40249, 18851)
                      end
                    else
                      cc = 56

                      ec = val183 < cc and (p129.bc[-12773] or p129:ec(42528, 10258, -12773))
                        or 195597 / ec
                    end
                  elseif ec <= 214 then
                    cc = 322

                    ec = val183 <= cc and (p129.bc[8928] or p129:dc(3141403, 27645, 8928))
                      or p129.bc[-20015] or p129:dc(348465, 4873, -20015)
                  else
                    cc, val161 = 769, 252

                    ec = val183 >= cc and (p129.bc[-2500] or p129:dc(1144355, 22250, -2500))
                      or p129.bc[-17725] or p129:dc(142979, 9352, -17725)
                  end
                elseif ec > 206 then
                  if ec < 209 then
                    cc = 254
                    ec = val183 <= cc and 564 - ec or 825 - ec
                  elseif ec > 209 then
                    cc = 742

                    ec = val183 < cc and (p129.bc[-24363] or p129:ec(46829, 14288, -24363))
                      or ec + -30
                  else
                    cc = 432

                    ec = val183 < cc and (p129.bc[-23452] or p129:ec(33780, 2727, -23452))
                      or p129.bc[-21935] or p129:ec(52463, 16126, -21935)
                  end
                elseif ec <= 204 then
                  if ec >= 203 then
                    if ec <= 203 then
                      val202, val177, val175, val191 = 207, 128, 144, 226

                      ec = val176 ~= val191 and (p129.bc[-21151] or p129:dc(873322, 4157, -21151))
                        or p129.bc[14200] or p129:dc(204107, 1448, 14200)
                    else
                      cc = 776

                      ec = val183 >= cc and 647 - ec or p129.bc[-24646]
                        or p129:dc(21108077, 27154, -24646)
                    end
                  else
                    jc = p130[11][2][p130[11][1]]
                    cc2 = jc[val224]
                    ec, val183[val198] = p129.bc[-26172] or p129:ec(38394, 6225, -26172), cc2
                  end
                else
                  jc = 0
                  val162, val158, val228 = 4, jc, 1

                  ec = val162 ~= val162 and 210532 / ec or p129.bc[-2616]
                    or p129:dc(410635, 240, -2616)
                end
              elseif ec < 226 then
                if ec <= 222 then
                  if ec >= 220 then
                    if ec <= 220 then
                      ec, cc, val183, val160, val186, val196, val198 = 2733 - ec, val159, p130[6][2][p130[6][1]], p130[10][2][p130[10][1]], 127, val170, p130[7][2][p130[7][1]]
                    else
                      ec, val198 = p129.gc[-1090] or p129:hc(4932, 45384, -1090), 37
                    end
                  else
                    cc = 114

                    ec = val183 <= cc and (p129.bc[-8879] or p129:dc(20708183, 25437, -8879))
                      or p129.bc[-1225] or p129:dc(13519301, 32391, -1225)
                  end
                elseif ec <= 224 then
                  val196 = val196 + val198

                  ec = val198 > 0 and (p129.bc[-11548] or p129:ec(55562, 20053, -11548))
                    or 243488 / ec
                else
                  ec, val198 = p129.bc[20699] or p129:dc(32205501, 31907, 20699), 233
                end
              elseif ec < 230 then
                if ec <= 228 then
                  if ec <= 226 then
                    cc = 220

                    ec = val183 <= cc and (p129.bc[14695] or p129:ec(44014, 9342, 14695))
                      or 299 - ec
                  else
                    ec, val224, val186, cc, val198 = 2339 - ec, p130[1][2][p130[1][1]], p130[3][2][p130[3][1]], "B", p130[8][2][p130[8][1]]
                  end
                else
                  cc = 467

                  ec = val183 <= cc and 199688 / ec or p129.bc[15034]
                    or p129:dc(15816509, 20530, 15034)
                end
              elseif ec < 231 then
                val231 = val231 + val160

                ec = val160 > 0 and (p129.bc[9578] or p129:dc(102374929, 28022, 9578))
                  or ec + 2323
              elseif ec > 231 then
                ec, jc, cc2, val224, val162, val186, val158 = p129.bc[6184]
                  or p129:dc(106016969, 27997, 6184), p130[7][2][p130[7][1]], p130[6][2][p130[6][1]], val160, 127, p130[10][2][p130[10][1]], cc
              else
                cc[14733] = val186
                ec, jc, val224, val158, cc2 = 604758 / ec, p130[3][2][p130[3][1]], p130[8][2][p130[8][1]], p130[1][2][p130[1][1]], "b"
              end
            elseif ec >= 184 then
              if ec >= 192 then
                if ec > 197 then
                  if ec <= 200 then
                    cc = 498
                    ec = val183 < cc and 45800 / ec or 31000 / ec
                  else
                    cc, val188 = 208, 83
                    ec = val183 < cc and 30753 / ec or ec + -201
                  end
                elseif ec >= 194 then
                  if ec <= 194 then
                    cc = 994
                    ec = val183 > cc and 251 - ec or 245 - ec
                  else
                    cc = 48
                    ec = val183 <= cc and ec + 440 or 511 - ec
                  end
                elseif ec <= 192 then
                  cc = 87

                  ec = val183 < cc and 802 - ec or p129.bc[-26935]
                    or p129:dc(4826371, 11016, -26935)
                else
                  ec, val182 = p129.bc[-19777] or p129:dc(2978646, 12727, -19777), val231
                end
              elseif ec < 188 then
                if ec > 186 then
                  ec, val198 = ec + 823, 1
                elseif ec <= 184 then
                  ec, val198 = p129.gc[-1090] or p129:hc(7384, 42748, -1090), 1
                else
                  cc = 147
                  ec = val183 > cc and ec + 172 or 119598 / ec
                end
              elseif ec <= 189 then
                if ec > 188 then
                  cc = 40
                  ec = val183 <= cc and ec + 66 or p129.bc[-3575] or p129:ec(50600, 19141, -3575)
                else
                  ec, cc, val186, val198, val183 = 456276 / ec, p130[3][2][p130[3][1]], p130[1][2][p130[1][1]], "B", p130[8][2][p130[8][1]]
                end
              else
                val183 = 0
                val198, cc, val186 = val183, 4, 1

                ec = cc ~= cc and (p129.bc[19296] or p129:dc(556056, 3447, 19296))
                  or p129.bc[-20322] or p129:fc(10314, 3695, -20322)
              end
            elseif ec >= 176 then
              if ec > 180 then
                if ec > 182 then
                  ec, val170 = p129.bc[101] or p129:dc(442247, 21071, 101), val234
                else
                  cc = 594
                  ec = val183 > cc and ec + 303 or 142506 / ec
                end
              elseif ec > 179 then
                val156, cc = 113, 742

                ec = val183 <= cc and (p129.gc[12420] or p129:hc(32852, 49847, 12420))
                  or 143820 / ec
              elseif ec > 178 then
                cc, val210 = 71, 186

                ec = val183 > cc and (p129.bc[-6834] or p129:dc(2434310, 22013, -6834))
                  or 190 - ec
              elseif ec > 176 then
                cc = 109
                ec = val183 > cc and 38982 / ec or ec + -124
              else
                val198 = 75
                ec = val210 >= val198 and ec + 834 or ec + 289
              end
            elseif ec < 173 then
              if ec >= 171 then
                if ec <= 171 then
                  cc = 6

                  ec = val183 > cc and (p129.gc[25537] or p129:hc(11564, 37926, 25537))
                    or p129.gc[16521] or p129:hc(10285, 39468, 16521)
                else
                  val189, val170, val217, val185, val218 = 188, 0, 66, 208, 31
                  val234, val182, val231 = val170, 4, 1

                  ec = val182 ~= val182 and (p129.bc[-1334] or p129:ec(43220, 9746, -1334))
                    or p129.bc[29447] or p129:fc(10767, 1423, 29447)
                end
              else
                ec, cc2, val158, val228, val172, val162, jc = 1735 - ec, p130[10][2][p130[10][1]], p130[6][2][p130[6][1]], val224, 127, p130[7][2][p130[7][1]], val183
              end
            elseif ec <= 174 then
              if ec <= 173 then
                val182 = 0
                val160, val231, val159 = 1, val182, 4

                ec = val159 ~= val159 and (p129.bc[-23145] or p129:ec(39373, 5855, -23145))
                  or 364511 / ec
              else
                val198 = 37

                ec = val217 < val198 and (p129.bc[-22696] or p129:dc(18947857, 27486, -22696))
                  or 175740 / ec
              end
            else
              cc = 560
              ec = val183 <= cc and 117250 / ec or 59850 / ec
            end
          elseif ec > 103 then
            if ec <= 139 then
              if ec > 126 then
                if ec >= 133 then
                  if ec > 136 then
                    if ec > 137 then
                      ec, val198 = p129.gc[-1090] or p129:ic(23486540, 18414, -1090), 37
                    else
                      val196, ec, val160, val198, val183 = "B", ec + 1816, p130[8][2][p130[8][1]], p130[1][2][p130[1][1]], p130[3][2][p130[3][1]]
                    end
                  elseif ec >= 135 then
                    if ec > 135 then
                      cc = 81

                      ec = val183 < cc and (p129.bc[10708] or p129:dc(9753890, 18407, 10708))
                        or p129.gc[-11988] or p129:hc(12255, 37509, -11988)
                    else
                      cc = 217

                      ec = val183 <= cc and 721 - ec or p129.gc[-26429]
                        or p129:ic(12575784, 10922, -26429)
                    end
                  elseif ec > 133 then
                    jc = "c"
                    jc, cc2 = p130[8][2][p130[8][1]], jc .. val224
                    val158, val228, ec, val162 = cc2, p130[1][2][p130[1][1]], p129.bc[15242] or p129:dc(6959467, 2292, 15242), p130[3][2][p130[3][1]]
                  else
                    cc = 153

                    ec = val183 < cc and (p129.bc[-25440] or p129:dc(6165365, 13770, -25440))
                      or 845 - ec
                  end
                elseif ec >= 130 then
                  if ec < 131 then
                    cc = 79

                    ec = val183 < cc and (p129.bc[-12962] or p129:dc(6360453, 12381, -12962))
                      or ec + 6
                  elseif ec > 131 then
                    cc = 157

                    ec = val183 < cc and (p129.bc[26316] or p129:dc(254507, 26224, 26316))
                      or 16896 / ec
                  else
                    ec, val198 = ec + 879, 45
                  end
                elseif ec <= 128 then
                  cc = 165

                  ec = val183 > cc and (p129.bc[-9037] or p129:dc(448155, 24691, -9037))
                    or ec + 23
                else
                  cc, val173, val226 = 247, 201, 49
                  ec = val183 > cc and 175 - ec or p129.bc[29179] or p129:ec(49579, 20063, 29179)
                end
              elseif ec < 114 then
                if ec > 111 then
                  if ec > 112 then
                    cc = 82

                    ec = val183 <= cc and (p129.bc[-26724] or p129:ec(64713, 29128, -26724))
                      or p129.bc[9681] or p129:dc(4066731, 21456, 9681)
                  else
                    cc = 312

                    ec = val183 <= cc and (p129.gc[20636] or p129:hc(6677, 43353, 20636))
                      or 53648 / ec
                  end
                elseif ec <= 109 then
                  if ec > 106 then
                    cc = 238

                    ec = val183 <= cc and (p129.bc[25535] or p129:ec(62711, 30406, 25535))
                      or 940 - ec
                  elseif ec <= 104 then
                    cc = 870

                    ec = val183 <= cc and (p129.bc[29099] or p129:ec(60211, 25036, 29099))
                      or p129.gc[-830] or p129:hc(16242, 33455, -830)
                  else
                    val224 = 2

                    ec = cc == val224 and (p129.bc[31447] or p129:ec(41902, 10950, 31447))
                      or 393 - ec
                  end
                else
                  ec, val234 = 173 - ec, val182
                end
              elseif ec <= 121 then
                if ec <= 118 then
                  if ec > 116 then
                    cc = 48

                    ec = val183 >= cc and (p129.bc[9621] or p129:dc(4940658, 27715, 9621))
                      or p129.bc[26274] or p129:ec(40604, 4060, 26274)
                  elseif ec > 114 then
                    cc = 253
                    ec = val183 < cc and ec + -23 or ec + 91
                  else
                    cc = 137

                    ec = val183 >= cc and 101460 / ec or p129.bc[-20547]
                      or p129:ec(45404, 15958, -20547)
                  end
                else
                  cc = 123

                  ec = val183 >= cc and 78529 / ec or p129.bc[5338]
                    or p129:dc(1470011, 1566, 5338)
                end
              elseif ec < 125 then
                cc = 182

                ec = val183 > cc and (p129.bc[-13116] or p129:ec(41458, 11181, -13116))
                  or p129.bc[-941] or p129:ec(52221, 16789, -941)
              elseif ec <= 125 then
                cc = 188
                ec = val183 >= cc and 85000 / ec or p129.bc[23087] or p129:ec(61303, 24485, 23087)
              else
                ec, val186 = p129.bc[15531] or p129:dc(29815009, 30714, 15531), math.huge
              end
            elseif ec > 153 then
              if ec < 161 then
                if ec < 157 then
                  if ec > 154 then
                    cc = 515
                    ec = val183 >= cc and ec + 786 or ec + 672
                  else
                    cc = 404

                    ec = val183 < cc and (p129.bc[-13830] or p129:dc(470159, 23798, -13830))
                      or p129.bc[-20775] or p129:dc(588897, 6306, -20775)
                  end
                elseif ec <= 158 then
                  if ec > 157 then
                    cc = 711

                    ec = val183 > cc and (p129.bc[-1033] or p129:dc(14694377, 15730, -1033))
                      or p129.gc[-26835] or p129:hc(23052, 59518, -26835)
                  else
                    cc = 185
                    ec = val183 > cc and 282 - ec or 281 - ec
                  end
                else
                  cc = 243

                  ec = val183 <= cc and (p129.gc[21988] or p129:hc(32349, 49931, 21988))
                    or p129.bc[29742] or p129:dc(9898126, 16025, 29742)
                end
              elseif ec < 165 then
                if ec < 162 then
                  ec, val159, val200 = 243 - ec, val160, 147
                elseif ec <= 162 then
                  val160 = 0
                  val183, val198, val196 = 4, 1, val160

                  ec = val183 ~= val183 and (p129.bc[15609] or p129:ec(60580, 24966, 15609))
                    or p129.bc[-27627] or p129:dc(32471015, 16883, -27627)
                else
                  cc = 196

                  ec = val183 > cc and (p129.bc[20054] or p129:dc(116175, 10108, 20054))
                    or 41239 / ec
                end
              elseif ec >= 166 then
                if ec > 166 then
                  cc = 5
                  ec = val183 <= cc and 84001 / ec or ec + 850
                else
                  ec, val224 = p129.bc[-13082] or p129:dc(5261183, 26146, -13082), ""
                end
              else
                ec, val196 = 253 - ec, val183
              end
            elseif ec < 146 then
              if ec <= 143 then
                if ec >= 142 then
                  if ec > 142 then
                    val232, val231, val168, val205, val182, ec, val159, val160 = 38, "B", 187, 170, p130[8][2][p130[8][1]], p129.bc[-31634]
                      or p129:ec(44076, 7535, -31634), p130[3][2][p130[3][1]], p130[1][2][p130[1][1]]
                  else
                    val222, cc, val157 = 115, 175, 5
                    ec = val183 > cc and 18318 / ec or 2130 / ec
                  end
                elseif ec <= 140 then
                  val182 = val182 + val159

                  ec = val159 > 0 and (p129.bc[-8803] or p129:dc(27031036, 12933, -8803))
                    or 414400 / ec
                else
                  cc, val198 = val182, 1
                  val186 = val198
                  ec = cc ~= cc and ec + 559 or 1232 - ec
                end
              elseif ec > 144 then
                cc = 51
                ec = val183 <= cc and ec + 52 or ec + 785
              else
                cc = 221

                ec = val183 > cc and (p129.bc[29604] or p129:ec(59324, 26197, 29604))
                  or p129.bc[9695] or p129:ec(55575, 21940, 9695)
              end
            elseif ec >= 150 then
              if ec > 151 then
                cc, val220 = 191, 74
                ec = val183 >= cc and ec + 10 or ec + 4
              elseif ec <= 150 then
                ec, jc = 89700 / ec, val224[29601]
                cc2 = val160[jc]
              else
                cc = 162
                ec = val183 > cc and 138920 / ec or 911 - ec
              end
            elseif ec >= 147 then
              if ec <= 147 then
                val158, val169, jc, val214, ec, cc2, val224 = p130[1][2][p130[1][1]], 35, p130[3][2][p130[3][1]], 153, p129.bc[-18425]
                  or p129:dc(1597174, 445, -18425), "B", p130[8][2][p130[8][1]]
              else
                val198, cc, jc, cc2, val186, ec, val224 = p130[10][2][p130[10][1]], val231, 127, val183, p130[6][2][p130[6][1]], 4106 - ec, p130[7][2][p130[7][1]]
              end
            else
              ec, val198 = p129.bc[20699] or p129:ec(50128, 18785, 20699), 45
            end
          elseif ec < 57 then
            if ec < 28 then
              if ec <= 16 then
                if ec >= 10 then
                  if ec < 15 then
                    if ec > 10 then
                      cc = 62

                      ec = val183 < cc and (p129.bc[-162] or p129:dc(4593151, 21980, -162))
                        or p129.bc[-4959] or p129:dc(1272518, 12555, -4959)
                    else
                      cc = 16
                      ec = val183 < cc and 10050 / ec or 872 - ec
                    end
                  elseif ec > 15 then
                    cc = 172

                    ec = val183 >= cc and (p129.bc[-8787] or p129:ec(4043, 32414, -8787))
                      or 15376 / ec
                  else
                    val229, cc, val155 = 242, 89, 229

                    ec = val183 > cc and (p129.bc[-31019] or p129:ec(58882, 26706, -31019))
                      or ec + 103
                  end
                elseif ec < 7 then
                  cc = 230
                  ec = val183 > cc and ec + 28 or ec + 226
                elseif ec <= 7 then
                  cc = 204

                  ec = val183 > cc and 1028 - ec or p129.bc[-21888]
                    or p129:dc(11198635, 13184, -21888)
                else
                  cc = 148
                  ec = val183 > cc and ec + 125 or 640 / ec
                end
              elseif ec < 22 then
                if ec <= 20 then
                  val234 = 0

                  ec = val170 == val234 and ec + 28 or p129.bc[-17493]
                    or p129:ec(43909, 9391, -17493)
                else
                  cc = 624
                  ec = val183 > cc and (p129.bc[7920] or p129:dc(878517, 4279, 7920)) or 264 - ec
                end
              elseif ec > 25 then
                cc = 244

                ec = val183 > cc and (p129.bc[7261] or p129:dc(11278587, 18147, 7261))
                  or p129.bc[-24116] or p129:dc(4913203, 30568, -24116)
              elseif ec > 22 then
                cc = 10

                ec = val183 <= cc and (p129.bc[-23021] or p129:ec(42629, 10079, -23021))
                  or ec + -15
              else
                cc = 284
                ec = val183 < cc and 2552 / ec or 4708 / ec
              end
            elseif ec > 47 then
              if ec > 51 then
                if ec > 52 then
                  cc = 97

                  ec = val183 > cc and (p129.bc[-22121] or p129:ec(63870, 30125, -22121))
                    or ec + 721
                else
                  cc = 876
                  ec = val183 >= cc and ec + 142 or ec + 26
                end
              elseif ec < 49 then
                ec, val191 = p129.bc[-14463] or p129:ec(58824, 27294, -14463), ""
              elseif ec <= 49 then
                val231 = "c"
                val182, ec, val231 = val231 .. val234, 30919 / ec, p130[8][2][p130[8][1]]
                val196, val160, val159 = p130[1][2][p130[1][1]], p130[3][2][p130[3][1]], val182
              else
                cc = 915
                ec = val183 < cc and 263 - ec or p129.bc[8836] or p129:ec(47174, 13283, 8836)
              end
            elseif ec >= 40 then
              if ec <= 46 then
                if ec < 41 then
                  val167, cc = 26, 132
                  ec = val183 > cc and 154 - ec or 4840 / ec
                elseif ec > 41 then
                  cc = 534
                  ec = val183 >= cc and (p129.bc[9026] or p129:ec(35726, 1076, 9026)) or ec + 108
                else
                  val170, ec, val203, val182, val191, val234, val179 = "B", p129.bc[-6175]
                    or p129:dc(88795094, 25437, -6175), 233, p130[1][2][p130[1][1]], p130[8][2][p130[8][1]], p130[3][2][p130[3][1]], 13
                end
              else
                cc = 139

                ec = val183 <= cc and (p129.bc[10892] or p129:ec(51954, 17435, 10892))
                  or p129.bc[-1319] or p129:ec(56573, 20986, -1319)
              end
            elseif ec <= 31 then
              if ec > 28 then
                val224, val186 = 1, nil
                ec = cc == val224 and ec + 95 or ec + 75
              else
                cc = 241
                ec = val183 > cc and (p129.bc[2021] or p129:ec(62165, 31803, 2021)) or 137 - ec
              end
            else
              val158, jc, val162, ec, cc2 = p130[3][2][p130[3][1]], "B", p130[1][2][p130[1][1]], ec + 778, p130[8][2][p130[8][1]]
            end
          elseif ec > 82 then
            if ec < 91 then
              if ec >= 86 then
                if ec > 87 then
                  ec, val183, val198 = ec + 1880, p130[4][2][p130[4][1]], val196
                elseif ec <= 86 then
                  cc = 119
                  ec = val183 >= cc and 3440 / ec or 264 - ec
                else
                  ec, val182 = ec + 3748, "c"
                  val182, val234 = p130[8][2][p130[8][1]], val182 .. val170
                  val231, val159, val160 = val234, p130[3][2][p130[3][1]], p130[1][2][p130[1][1]]
                end
              elseif ec < 84 then
                val196, val186, val198, cc, val224, ec, val183 = p130[10][2][p130[10][1]], val160, p130[6][2][p130[6][1]], p130[7][2][p130[7][1]], 127, 298883 / ec, val234
              elseif ec > 84 then
                cc = 458
                ec = val183 <= cc and (p129.bc[-18667] or p129:ec(35458, 957, -18667)) or ec + 115
              else
                val186, val198, ec, cc, cc2, val183, val224 = p130[7][2][p130[7][1]], val182, p129.bc[-2502]
                  or p129:ec(36912, 4150, -2502), p130[6][2][p130[6][1]], 127, p130[10][2][p130[10][1]], val196
              end
            elseif ec >= 101 then
              if ec > 102 then
                cc = 66
                ec = val183 <= cc and 97644 / ec or 76220 / ec
              elseif ec > 101 then
                cc = 43
                ec = val183 >= cc and 75990 / ec or p129.bc[-4752] or p129:ec(46422, 15054, -4752)
              else
                ec, jc, cc2, val224, val186 = p129.bc[28714] or p129:ec(65229, 27142, 28714), p130[1][2][p130[1][1]], p130[3][2][p130[3][1]], "B", p130[8][2][p130[8][1]]
              end
            elseif ec <= 93 then
              if ec > 91 then
                cc = 248
                ec = val183 > cc and ec + 756 or 64728 / ec
              else
                val170 = ""

                ec = val180 <= val230 and 162 - ec or p129.bc[3710]
                  or p129:dc(13345735, 15686, 3710)
              end
            else
              ec, jc, val224, cc2, val186 = p129.bc[-23619] or p129:ec(54814, 19630, -23619), p130[1][2][p130[1][1]], "B", p130[3][2][p130[3][1]], p130[8][2][p130[8][1]]
            end
          elseif ec > 71 then
            if ec > 78 then
              if ec <= 80 then
                cc = 146
                ec = val183 < cc and ec + 556 or 14880 / ec
              else
                val233, val160, ec, val206, val196 = 76, p130[4][2][p130[4][1]], ec + 1137, 51, val159
              end
            elseif ec < 75 then
              if ec > 73 then
                cc = 334

                ec = val183 <= cc and 74592 / ec or p129.bc[23829]
                  or p129:dc(1066889, 3062, 23829)
              else
                cc = 225
                ec = val183 <= cc and (p129.bc[31415] or p129:ec(65016, 28778, 31415)) or 375 - ec
              end
            elseif ec <= 75 then
              ec, cc, val196, val183, val198 = p129.bc[-19483] or p129:ec(42978, 9493, -19483), p130[1][2][p130[1][1]], p130[8][2][p130[8][1]], "B", p130[3][2][p130[3][1]]
            else
              cc = 840
              ec = val183 > cc and 182 - ec or 282 - ec
            end
          elseif ec > 67 then
            if ec > 69 then
              val231, val182 = 0, {}

              val182[50602] = val231
              val182[35016] = val231
              val182[40559] = val231

              val159 = {}
              val231 = val159
              val182[40274] = val231
              val159 = {}
              val231 = val159
              val182[44371] = val231
              val159 = {}
              val231 = val159

              val182[45868] = val231
              val182[4625] = val191
              val182[8164] = val170

              val234 = val182
              return val234
            elseif ec <= 68 then
              cc = 434
              ec = val183 > cc and (p129.bc[-25331] or p129:ec(49995, 19665, -25331)) or 277 - ec
            else
              val151, ec, val191, val204 = 72, 320 - ec, val170, 136
            end
          elseif ec > 62 then
            cc, val192 = 19, 6

            ec = val183 <= cc and (p129.bc[23617] or p129:ec(61959, 31851, 23617))
              or p129.bc[12623] or p129:ec(55221, 22649, 12623)
          elseif ec > 60 then
            val182 = 0

            ec = val234 == val182 and (p129.bc[19118] or p129:dc(598852, 7165, 19118))
              or p129.bc[-9756] or p129:dc(795662, 17333, -9756)
          elseif ec <= 57 then
            cc = 997

            ec = val183 > cc and (p129.gc[9535] or p129:ic(3541416, 10150, 9535))
              or p129.bc[25069] or p129:dc(97973, 278, 25069)
          else
            ec, val198, val152, val186, val224, cc, val209 = p129.bc[-411] or p129:ec(58563, 25434, -411), p130[8][2][p130[8][1]], 149, p130[3][2][p130[3][1]], p130[1][2][p130[1][1]], p129.bc[-30582] or p129:cc(
              p129.Eb("Lo`n"), p129.Eb("eE"), -30582
            ), 210
          end
        elseif ec <= 531 then
          if ec < 429 then
            if ec < 373 then
              if ec >= 351 then
                if ec > 359 then
                  if ec < 368 then
                    if ec > 361 then
                      cc2 = 0
                      ec = val149 > cc2 and ec + 84 or ec + 52
                    else
                      val158, ec, cc2, jc, val224 = p130[1][2][p130[1][1]], p129.bc[23443]
                        or p129:dc(93526019, 30539, 23443), p129.gc[26096]
                        or p129:jc(p129.Eb("(T3d"), p129.Eb("?*"), 26096), p130[3][2][p130[3][1]], p130[8][2][p130[8][1]]
                    end
                  elseif ec >= 369 then
                    if ec > 369 then
                      val186 = ""
                      ec = val181 >= val164 and ec + 597 or 226920 / ec
                    else
                      cc[40758] = val186

                      ec = val205 <= val232 and ec + -197 or p129.bc[15789]
                        or p129:dc(37828169, 13658, 15789)
                    end
                  else
                    ec, val198 = p129.bc[20699] or p129:dc(9813099, 9696, 20699), 45
                  end
                elseif ec > 356 then
                  if ec <= 358 then
                    if ec > 357 then
                      ec, val198 = 1368 - ec, 197
                    else
                      cc = 253

                      ec = val183 <= cc and (p129.bc[-25323] or p129:dc(15756851, 22348, -25323))
                        or 1338 - ec
                    end
                  else
                    jc = val224[44007]
                    ec, cc2 = 715 - ec, val160[jc]
                  end
                elseif ec > 355 then
                  ec = cc2 and 1084 - ec or p129.bc[5733] or p129:ec(50505, 18761, 5733)
                elseif ec >= 353 then
                  if ec <= 353 then
                    ec, jc = p129.gc[1982] or p129:ic(20867357, 2891, 1982), p130[2][2][p130[2][1]]
                  else
                    ec, val198 = 358550 / ec, 46
                  end
                else
                  ec, val198 = p129.gc[-1090] or p129:hc(31382, 51390, -1090), 142
                end
              elseif ec >= 332 then
                if ec <= 341 then
                  if ec < 338 then
                    if ec <= 332 then
                      cc = 242

                      ec = val183 > cc and (p129.bc[16754] or p129:ec(43675, 8631, 16754))
                        or p129.bc[-3797] or p129:dc(5068913, 7506, -3797)
                    else
                      val186 = 46

                      ec = val198 <= val186
                          and (p129.gc[-32530] or p129:ic(26909054, 30042, -32530))
                        or ec + 138
                    end
                  elseif ec > 338 then
                    ec, val198 = 1351 - ec, 45
                  else
                    ec, val198 = p129.gc[-1090] or p129:ic(2233110, 5531, -1090), 197
                  end
                elseif ec > 342 then
                  ec, val198 = p129.gc[-1090] or p129:ic(11007990, 14251, -1090), 197
                else
                  ec, val198 = 345420 / ec, 37
                end
              elseif ec < 328 then
                if ec > 326 then
                  ec, val198 = p129.bc[20699] or p129:dc(1304165, 1247, 20699), 233
                else
                  val221, val187, ec, val201, val172, val171, val211 = 127, p130[6][2][p130[6][1]], p129.bc[-18099]
                    or p129:ec(38406, 5420, -18099), val228, p130[10][2][p130[10][1]], p130[7][2][p130[7][1]], cc2
                end
              elseif ec > 329 then
                val186 = val186 + cc2

                ec = cc2 > 0 and (p129.gc[-26162] or p129:hc(15050, 36353, -26162))
                  or p129.gc[19323] or p129:ic(6389982, 4702, 19323)
              elseif ec > 328 then
                val186 = 75
                ec = val198 <= val186 and 924 - ec or 690 - ec
              else
                cc = 193
                ec = val183 > cc and ec + 45 or p129.bc[-15296] or p129:ec(46143, 14058, -15296)
              end
            elseif ec < 397 then
              if ec >= 383 then
                if ec > 390 then
                  if ec > 393 then
                    ec, cc[6863] = 3332 - ec, val186
                    val158, jc, val224, cc2 = p130[1][2][p130[1][1]], p130[3][2][p130[3][1]], p130[8][2][p130[8][1]], "b"
                  else
                    cc = 133
                    ec = val183 <= cc and 1187 - ec or 144624 / ec
                  end
                elseif ec < 387 then
                  if ec > 383 then
                    val224, val158, cc2, ec, jc = p130[8][2][p130[8][1]], p130[1][2][p130[1][1]], "B", p129.bc[-3576] or p129:dc(8742747, 4057, -3576), p130[3][2][p130[3][1]]
                  else
                    cc[23485] = val186

                    ec = val214 >= val169 and (p129.bc[15789] or p129:dc(26069814, 9385, 15789))
                      or p129.gc[1512] or p129:ic(624900, 13719, 1512)
                  end
                elseif ec <= 387 then
                  ec, val198 = 390870 / ec, 45
                else
                  cc[29601] = val186
                  cc2, ec, jc, val158, val224 = "B", p129.bc[2853] or p129:dc(5529105, 2027, 2853), p130[3][2][p130[3][1]], p130[1][2][p130[1][1]], p130[8][2][p130[8][1]]
                end
              elseif ec <= 377 then
                if ec < 375 then
                  if ec <= 373 then
                    ec, val198 = p129.bc[20699] or p129:dc(5889629, 5779, 20699), 123
                  else
                    ec, val198 = p129.gc[-1090] or p129:ic(10053540, 15322, -1090), 75
                  end
                elseif ec <= 375 then
                  ec, val198 = 1385 - ec, 45
                else
                  ec, val198 = p129.gc[-1090] or p129:hc(15864, 33820, -1090), 37
                end
              elseif ec > 379 then
                ec, val198 = ec + 630, 75
              else
                cc = 217
                ec = val183 >= cc and 514 - ec or p129.gc[9127] or p129:ic(1317720, 5405, 9127)
              end
            elseif ec <= 410 then
              if ec <= 405 then
                if ec > 402 then
                  cc = 193

                  ec = val183 >= cc and ec + -77 or p129.bc[-32214]
                    or p129:dc(2357108, 4933, -32214)
                elseif ec <= 399 then
                  if ec > 397 then
                    val224, val158, ec, jc, cc2 = p130[8][2][p130[8][1]], p130[1][2][p130[1][1]], ec + 3000, p130[3][2][p130[3][1]], "B"
                  else
                    ec, val198 = 400970 / ec, 1
                  end
                else
                  ec, val198 = p129.bc[20699] or p129:dc(19810287, 19634, 20699), 233
                end
              elseif ec > 409 then
                val186 = 35
                ec = val198 > val186 and 123000 / ec or ec + -102
              elseif ec > 408 then
                cc[6284] = val186

                ec = val212 <= val213 and (p129.bc[13625] or p129:dc(20185051, 25008, 13625))
                  or 1134157 / ec
              else
                val198 = 45

                ec = val227 <= val198 and ec + -14 or p129.bc[20699]
                  or p129:dc(10618759, 10566, 20699)
              end
            elseif ec < 418 then
              if ec > 416 then
                cc[49932] = val186
                val224, ec, val158, cc2, jc = p130[8][2][p130[8][1]], p129.bc[-11335] or p129:ec(3718, 29412, -11335), p130[1][2][p130[1][1]], "B", p130[3][2][p130[3][1]]
              else
                ec, val198 = p129.bc[20699] or p129:dc(31639791, 31282, 20699), 197
              end
            elseif ec < 419 then
              cc = 116

              ec = val183 > cc and (p129.gc[-15835] or p129:hc(5091, 44220, -15835))
                or p129.bc[-29396] or p129:ec(62912, 30785, -29396)
            elseif ec <= 419 then
              val186 = val186 + cc2

              ec = cc2 > 0 and (p129.bc[-15736] or p129:ec(59603, 23048, -15736))
                or p129.bc[9591] or p129:dc(62826362, 32395, 9591)
            else
              ec, val198 = p129.bc[20699] or p129:dc(6692485, 6671, 20699), 37
            end
          elseif ec > 477 then
            if ec < 508 then
              if ec <= 493 then
                if ec < 485 then
                  if ec >= 480 then
                    if ec <= 480 then
                      ec, val198 = p129.gc[-1090] or p129:ic(10091920, 14896, -1090), 37
                    else
                      ec, val198 = 1494 - ec, 197
                    end
                  else
                    ec, val198 = ec + 531, 37
                  end
                elseif ec <= 489 then
                  if ec <= 485 then
                    ec, val198 = ec + 525, 197
                  else
                    ec, val198 = p129.gc[-1090] or p129:hc(14144, 36180, -1090), 1
                  end
                else
                  jc = jc + val162

                  ec = val162 > 0 and 3700 - ec or p129.bc[-12088]
                    or p129:dc(26163919, 20428, -12088)
                end
              elseif ec < 503 then
                if ec <= 498 then
                  ec, val198 = p129.gc[-1090] or p129:hc(16208, 34116, -1090), 45
                else
                  ec, val198 = ec + 509, 197
                end
              elseif ec <= 504 then
                if ec <= 503 then
                  cc = 3

                  ec = val183 >= cc and (p129.bc[-11809] or p129:dc(3073841, 3178, -11809))
                    or p129.gc[-11791] or p129:ic(704196, 5348, -11791)
                else
                  ec, val198 = 1514 - ec, 197
                end
              else
                ec, val198 = p129.bc[20699] or p129:ec(65155, 27662, 20699), 1
              end
            elseif ec >= 520 then
              if ec > 527 then
                if ec <= 530 then
                  ec, val198 = 1540 - ec, 37
                else
                  cc[14733] = val186
                  jc, val158, val224, ec, cc2 = p130[3][2][p130[3][1]], p130[1][2][p130[1][1]], p130[8][2][p130[8][1]], p129.gc[2306] or p129:ic(44668015, 18759, 2306), "B"
                end
              elseif ec <= 525 then
                if ec > 523 then
                  val224, ec, val158, jc, cc2 = p130[8][2][p130[8][1]], p129.bc[8269] or p129:ec(57326, 17987, 8269), p130[1][2][p130[1][1]], p130[3][2][p130[3][1]], "B"
                elseif ec > 520 then
                  ec, val198 = ec + 487, 75
                else
                  val224 = val224(cc2, jc, val158)
                  jc, cc2 = 1, val158
                  cc2 = cc2 + jc
                  ec, p130[1][2][p130[1][1]], val186 = 216840 / ec, cc2, val224
                end
              else
                ec, val198 = p129.gc[-1090] or p129:hc(30254, 52262, -1090), 101
              end
            elseif ec > 517 then
              if ec > 518 then
                cc[14733] = val186
                jc, cc2, val224, ec, val158 = p130[3][2][p130[3][1]], "B", p130[8][2][p130[8][1]], p129.gc[16374] or p129:hc(17418, 34230, 16374), p130[1][2][p130[1][1]]
              else
                cc = 77

                ec = val183 > cc and (p129.bc[-28540] or p129:ec(57656, 28282, -28540))
                  or 1397 - ec
              end
            elseif ec > 515 then
              ec, val198 = 1527 - ec, 46
            elseif ec >= 511 then
              if ec <= 511 then
                ec, cc[24799] = 2260 - ec, val186
                val158, cc2, val224, jc = p130[1][2][p130[1][1]], "B", p130[8][2][p130[8][1]], p130[3][2][p130[3][1]]
              else
                val211 = val211(val187, val171, val201)

                val187, val171 = val201, 1
                val187 = val187 + val171

                p130[1][2][p130[1][1]], val172 = val187, val211
                ec = val200 < val171 and ec + 80 or 502640 / ec
              end
            else
              ec, val198 = 513080 / ec, 45
            end
          elseif ec > 451 then
            if ec < 467 then
              if ec > 461 then
                if ec <= 464 then
                  ec, val198 = p129.bc[20699] or p129:dc(8045433, 7921, 20699), 45
                else
                  ec, cc2, val224, jc, val158 = 2449 - ec, p129.bc[-1386]
                    or p129:cc(p129.Eb("Lm2"), p129.Eb("eE"), -1386), p130[8][2][p130[8][1]], p130[3][2][p130[3][1]], p130[1][2][p130[1][1]]
                end
              elseif ec >= 459 then
                if ec > 459 then
                  jc = p129.gc[6554] or p129:jc(p129.Eb("pU4"), p129.Eb("p#"), 6554)
                  cc2, ec, jc = jc .. val224, 3476 - ec, p130[8][2][p130[8][1]]
                  val158, val162, val228 = cc2, p130[3][2][p130[3][1]], p130[1][2][p130[1][1]]
                else
                  cc[8652] = val186
                  ec, cc2, jc, val158, val224 = p129.gc[19026] or p129:kc(49169, 2636, 19026), "B", p130[3][2][p130[3][1]], p130[1][2][p130[1][1]], p130[8][2][p130[8][1]]
                end
              elseif ec <= 455 then
                jc = 0

                ec = cc2 == jc and (p129.bc[735] or p129:dc(2705633, 16423, 735))
                  or p129.bc[21720] or p129:ec(38126, 6004, 21720)
              else
                cc = 141

                ec = val183 <= cc and (p129.bc[-13716] or p129:dc(16353979, 22264, -13716))
                  or 831 - ec
              end
            elseif ec > 473 then
              if ec > 474 then
                cc[6284] = val186

                val158, val224, cc2, ec, jc = p130[1][2][p130[1][1]], p130[8][2][p130[8][1]], p129.bc[-28414]
                  or p129:cc(p129.Eb("^`iL"), p129.Eb("%K"), -28414), 538533 / ec, p130[3][2][p130[3][1]]
              else
                ec, val198 = 478740 / ec, 1
              end
            elseif ec < 472 then
              if ec <= 467 then
                cc = 191
                ec = val183 > cc and 1211 - ec or p129.gc[-9942] or p129:hc(23841, 58487, -9942)
              else
                cc = 178
                ec = val183 < cc and ec + 68 or p129.gc[-1421] or p129:ic(10823063, 13113, -1421)
              end
            elseif ec > 472 then
              jc, val224, ec, val158, cc2 = p130[3][2][p130[3][1]], p130[8][2][p130[8][1]], 508948 / ec, p130[1][2][p130[1][1]], "B"
            else
              ec, val198 = 1482 - ec, 197
            end
          elseif ec <= 440 then
            if ec <= 435 then
              if ec <= 433 then
                if ec <= 432 then
                  if ec > 429 then
                    ec, val198 = 1442 - ec, 37
                  else
                    ec, val198 = p129.gc[-1090] or p129:ic(27726520, 30212, -1090), 46
                  end
                else
                  val186, ec, cc = val198, p129.bc[8257] or p129:dc(23245232, 6453, 8257), p130[4][2][p130[4][1]]
                end
              else
                val198 = 142

                ec = val216 <= val198 and (p129.bc[26654] or p129:dc(9745059, 31780, 26654))
                  or p129.bc[20699] or p129:ec(47931, 12742, 20699)
              end
            elseif ec <= 439 then
              if ec > 437 then
                ec, cc[49287] = ec + 3291, val186
                jc, val224, val158, cc2 = p130[3][2][p130[3][1]], p130[8][2][p130[8][1]], p130[1][2][p130[1][1]], "B"
              else
                cc = 87

                ec = val183 <= cc and (p129.bc[15744] or p129:ec(38856, 5669, 15744))
                  or p129.bc[2599] or p129:ec(39324, 5365, 2599)
              end
            else
              ec, val198 = p129.gc[-1090] or p129:ic(2442180, 5194, -1090), 69
            end
          elseif ec < 449 then
            if ec < 446 then
              cc = 776
              ec = val183 > cc and 192705 / ec or p129.bc[-30154] or p129:ec(59269, 25960, -30154)
            elseif ec > 446 then
              val186 = 142

              ec = val198 > val186 and (p129.bc[-9294] or p129:ec(41416, 11960, -9294))
                or 340614 / ec
            else
              val224, jc, ec, val158, cc2 = p130[8][2][p130[8][1]], p130[3][2][p130[3][1]], ec + 1950, p130[1][2][p130[1][1]], "B"
            end
          elseif ec < 450 then
            cc = 157
            ec = val183 > cc and (p129.gc[-214] or p129:ic(3377247, 3241, -214)) or 1367 - ec
          elseif ec <= 450 then
            val224[29601] = cc2
            val158, jc = 0, val224[44007]
            cc2 = jc ~= val158

            ec = cc2 and (p129.gc[-23528] or p129:ic(5873958, 8914, -23528)) or p129.gc[7414]
              or p129:ic(1009260, 5675, 7414)
          else
            cc = 151

            ec = val183 <= cc and (p129.gc[-11466] or p129:ic(5135130, 13306, -11466))
              or p129.bc[-23527] or p129:ec(34148, 2385, -23527)
          end
        elseif ec > 632 then
          if ec > 679 then
            if ec <= 704 then
              if ec <= 693 then
                if ec >= 688 then
                  if ec > 692 then
                    ec, val198 = 1703 - ec, 233
                  elseif ec > 691 then
                    ec, val198 = 1702 - ec, 37
                  elseif ec > 688 then
                    ec, val198 = p129.bc[20699] or p129:ec(59713, 25552, 20699), 37
                  else
                    ec, cc[6284] = 1907824 / ec, val186
                  end
                elseif ec >= 682 then
                  if ec <= 682 then
                    cc = 172

                    ec = val183 > cc and (p129.gc[-1908] or p129:ic(3236090, 14378, -1908))
                      or p129.gc[-21023] or p129:hc(20205, 61461, -21023)
                  else
                    ec, val198 = p129.gc[-1090] or p129:ic(13884470, 10379, -1090), 123
                  end
                else
                  cc = 188

                  ec = val183 > cc and (p129.bc[-12021] or p129:ec(50360, 18676, -12021))
                    or ec + 306
                end
              elseif ec > 700 then
                if ec <= 701 then
                  ec, val198 = p129.bc[20699] or p129:ec(44522, 8055, 20699), 12
                else
                  ec, cc[29601] = p129.bc[15789] or p129:fc(11011, 731, 15789), val186
                end
              elseif ec >= 699 then
                if ec > 699 then
                  cc = 0
                  val186, cc2, val224 = cc, 1, 4

                  ec = val224 ~= val224 and (p129.bc[-16644] or p129:ec(51639, 17502, -16644))
                    or 3355 - ec
                else
                  cc[49287] = val186
                  val224, jc, ec, val158, cc2 = p130[8][2][p130[8][1]], p130[3][2][p130[3][1]], p129.gc[14812] or p129:hc(30767, 54133, 14812), p130[1][2][p130[1][1]], "B"
                end
              else
                ec, val198 = p129.gc[-1090] or p129:hc(18995, 63579, -1090), 142
              end
            elseif ec > 714 then
              if ec > 721 then
                cc = 284
                ec = val183 <= cc and 631750 / ec or 558106 / ec
              elseif ec >= 720 then
                if ec <= 720 then
                  cc = 404

                  ec = val183 > cc and (p129.bc[-3791] or p129:ec(54757, 22408, -3791))
                    or p129.bc[-10267] or p129:ec(34454, 1585, -10267)
                else
                  ec, val198 = p129.gc[-1090] or p129:ic(24877310, 32015, -1090), 75
                end
              else
                ec = val159 < val160 and ec + -553 or 1762475 / ec
              end
            elseif ec < 709 then
              if ec < 706 then
                val198 = 1
                ec = val184 < val198 and ec + -373 or 712050 / ec
              elseif ec <= 706 then
                ec, val198 = ec + 304, 12
              else
                ec = cc2 ~= cc2 and (p129.gc[21629] or p129:ic(20902784, 17945, 21629))
                  or 1060 - ec
              end
            elseif ec >= 712 then
              if ec > 712 then
                ec, val198 = 721140 / ec, 37
              else
                cc = 153
                ec = val183 > cc and 1559 - ec or 899 - ec
              end
            else
              val224 = 4
              ec = cc == val224 and 1603 - ec or p129.bc[15531] or p129:dc(24348097, 25114, 15531)
            end
          elseif ec > 660 then
            if ec >= 670 then
              if ec > 676 then
                if ec > 677 then
                  val211, ec, val187, val201, val171 = p130[8][2][p130[8][1]], 1194 - ec, "B", p130[1][2][p130[1][1]], p130[3][2][p130[3][1]]
                else
                  ec, val198 = p129.gc[-1090] or p129:hc(10725, 39913, -1090), 142
                end
              elseif ec < 675 then
                if ec <= 670 then
                  cc = 540

                  ec = val183 < cc and (p129.gc[5894] or p129:hc(15394, 33872, 5894))
                    or p129.gc[31076] or p129:hc(14483, 34823, 31076)
                else
                  val224 = val224(cc2, jc, val158)
                  ec, jc, cc2 = p129.bc[-31247] or p129:ec(63481, 28688, -31247), 1, val158
                  cc2 = cc2 + jc
                  val186, p130[1][2][p130[1][1]] = val224, cc2
                end
              elseif ec <= 675 then
                ec, val198 = p129.bc[20699] or p129:dc(14858557, 14691, 20699), 197
              else
                ec = val231 <= 0 and (p129.bc[-20500] or p129:dc(1788133, 1238, -20500))
                  or ec + -539
              end
            elseif ec <= 665 then
              if ec > 664 then
                val224 = 6

                ec = cc == val224 and (p129.gc[19916] or p129:hc(23564, 59234, 19916))
                  or p129.gc[-27693] or p129:hc(32943, 50160, -27693)
              elseif ec <= 662 then
                ec, val198 = p129.bc[20699] or p129:dc(13795333, 13647, 20699), 1
              else
                val198 = 197

                ec = val188 <= val198 and ec + 346 or p129.gc[3974]
                  or p129:ic(19463178, 20613, 3974)
              end
            elseif ec > 666 then
              cc = 232

              ec = val183 > cc and (p129.gc[13294] or p129:ic(1262016, 4856, 13294))
                or p129.bc[-22696] or p129:ec(35690, 822, -22696)
            else
              val224, val149 = val231[val198], 93
              jc, val158 = val224[29601], 0
              cc2 = jc ~= val158
              ec = cc2 and ec + -516 or 1264 - ec
            end
          elseif ec <= 643 then
            if ec < 639 then
              if ec <= 636 then
                if ec > 634 then
                  cc = 142
                  ec = val183 <= cc and 290016 / ec or ec + 117
                else
                  cc = 28

                  ec = val183 <= cc and (p129.gc[24352] or p129:hc(8393, 41110, 24352))
                    or 384838 / ec
                end
              else
                ec, val198 = ec + 373, 75
              end
            elseif ec < 642 then
              if ec > 639 then
                cc2 = 0
                ec = val219 > cc2 and 1369 - ec or 1535 - ec
              else
                val186(val224, cc2)
                val186 = 101
                ec = val198 > val186 and ec + -83 or ec + -89
              end
            elseif ec > 642 then
              cc = 146

              ec = val183 > cc and (p129.bc[-8300] or p129:ec(38244, 6314, -8300))
                or p129.bc[18218] or p129:dc(21584723, 23864, 18218)
            else
              val198 = val198 + val186

              ec = val186 > 0 and (p129.bc[-18303] or p129:dc(49012531, 20887, -18303))
                or 3990 - ec
            end
          elseif ec < 654 then
            if ec <= 651 then
              if ec > 649 then
                ec, val186 = 1620 - ec, -math.huge
              else
                cc = 125

                ec = val183 <= cc and 1486 - ec or p129.gc[-12739]
                  or p129:ic(13434120, 29991, -12739)
              end
            else
              val198 = 101
              ec = val165 < val198 and (p129.gc[10339] or p129:ic(37634, 8039, 10339)) or 1663 - ec
            end
          elseif ec < 658 then
            ec, val198 = 1664 - ec, 101
          elseif ec <= 658 then
            ec, cc[23485] = 2207 - ec, val186

            val224, val158, jc, cc2 = p130[8][2][p130[8][1]], p130[1][2][p130[1][1]], p130[3][2][p130[3][1]], p129.bc[-28414]
              or p129:cc(p129.Eb("wBxt"), p129.Eb("iU"), -28414)
          else
            ec, val186 = p129.bc[15531] or p129:ec(47417, 13297, 15531), (0 / 0)
          end
        elseif ec >= 589 then
          if ec >= 613 then
            if ec <= 624 then
              if ec > 618 then
                if ec >= 623 then
                  if ec <= 623 then
                    cc[6284] = val186

                    jc, val158, ec, cc2, val224 = p130[3][2][p130[3][1]], p130[1][2][p130[1][1]], ec + 3352, p129.gc[-2650]
                      or p129:jc(p129.Eb("2!8|"), p129.Eb("HU"), -2650), p130[8][2][p130[8][1]]
                  else
                    ec, val198 = p129.gc[-1090] or p129:ic(18503200, 23208, -1090), 233
                  end
                else
                  ec, val198 = 627210 / ec, 197
                end
              elseif ec > 616 then
                ec, val198 = 1628 - ec, 45
              elseif ec <= 615 then
                if ec <= 613 then
                  cc = 63
                  ec = val183 > cc and 884 - ec or 1625 - ec
                else
                  cc2, val158, ec, jc, val162 = p130[8][2][p130[8][1]], p130[3][2][p130[3][1]], ec + 2060, "B", p130[1][2][p130[1][1]]
                end
              else
                val198 = 123
                ec = val189 >= val198 and (p129.gc[-1090] or p129:hc(7870, 42198, -1090)) or ec + 54
              end
            elseif ec <= 630 then
              if ec <= 628 then
                if ec <= 625 then
                  val186 = 206

                  ec = val198 > val186 and 240000 / ec or p129.bc[-13579]
                    or p129:ec(55387, 21936, -13579)
                else
                  ec, val198 = p129.bc[20699] or p129:dc(6075789, 5995, 20699), 37
                end
              else
                cc = 540
                ec = val183 <= cc and 594090 / ec or ec + -207
              end
            elseif ec <= 631 then
              ec, val231 = 44801 / ec, val231(val159, val160, val196)

              val159 = val196
              val159 = val159 + val234

              p130[1][2][p130[1][1]], val170 = val159, val231
            else
              val198 = 233
              ec = val177 < val198 and (p129.gc[-1090] or p129:hc(21620, 61080, -1090)) or 699 - ec
            end
          elseif ec > 602 then
            if ec > 607 then
              if ec > 609 then
                cc = 83

                ec = val183 <= cc and (p129.gc[-32601] or p129:ic(7627368, 9964, -32601))
                  or 1443 - ec
              else
                ec, val198 = p129.gc[-1090] or p129:hc(24086, 58430, -1090), 69
              end
            elseif ec < 605 then
              cc = 39
              ec = val183 > cc and 210796 / ec or 1397 - ec
            elseif ec <= 605 then
              val198 = 37
              ec = val173 >= val198 and ec + 405 or 114950 / ec
            else
              ec, val198 = 1617 - ec, 45
            end
          elseif ec <= 592 then
            if ec > 591 then
              cc = 106
              ec = val183 <= cc and (p129.bc[30328] or p129:ec(58977, 26361, 30328)) or ec + 412
            elseif ec >= 590 then
              if ec > 590 then
                cc = 186

                ec = val183 <= cc and (p129.gc[-6432] or p129:ic(10568304, 18976, -6432))
                  or p129.bc[-2490] or p129:dc(3212056, 10567, -2490)
              else
                ec, val198 = ec + 420, 1
              end
            else
              val224 = val224(cc2, jc, val158)
              cc2, jc = val158, 2
              ec, cc2 = p129.gc[-3958] or p129:ic(5517035, 19563, -3958), cc2 + jc
              val186, p130[1][2][p130[1][1]] = val224, cc2
            end
          elseif ec >= 598 then
            if ec <= 598 then
              ec = cc2 and 1048 - ec or p129.bc[23084] or p129:ec(40803, 4210, 23084)
            else
              ec, val198 = 1612 - ec, 197
            end
          else
            val150, val186 = 178, 69
            ec = val198 > val186 and (p129.gc[30866] or p129:ic(12722325, 17297, 30866)) or 930 - ec
          end
        elseif ec < 563 then
          if ec < 554 then
            if ec < 540 then
              if ec >= 534 then
                if ec <= 534 then
                  val198 = 37

                  ec = val226 < val198 and (p129.bc[32627] or p129:dc(26546435, 28050, 32627))
                    or 539340 / ec
                else
                  ec, val198 = p129.bc[20699] or p129:dc(6006469, 5935, 20699), 37
                end
              else
                cc = 137

                ec = val183 <= cc and (p129.bc[26391] or p129:dc(4075339, 14640, 26391))
                  or ec + -117
              end
            elseif ec >= 550 then
              if ec <= 550 then
                val212, val186, val213 = 223, 45, 119
                ec = val198 > val186 and 180950 / ec or ec + -140
              else
                cc = 161

                ec = val183 <= cc and 491492 / ec or p129.gc[2006]
                  or p129:ic(27337090, 29526, 2006)
              end
            else
              ec, cc[29601] = 1722600 / ec, val186
              val224, val158, cc2, jc = p130[8][2][p130[8][1]], p130[1][2][p130[1][1]], "B", p130[3][2][p130[3][1]]
            end
          elseif ec <= 558 then
            if ec < 556 then
              if ec > 554 then
                ec, cc[14733] = 630480 / ec, val186

                val158, cc2, jc, val224 = p130[1][2][p130[1][1]], p129.gc[-2650]
                  or p129:jc(p129.Eb("Vij%"), p129.Eb("Tm"), -2650), p130[3][2][p130[3][1]], p130[8][2][p130[8][1]]
              else
                ec, val198 = 559540 / ec, 142
              end
            elseif ec <= 556 then
              val186 = 162

              ec = val198 > val186 and (p129.bc[17376] or p129:ec(49236, 19558, 17376))
                or 133996 / ec
            else
              val198 = 12

              ec = val222 <= val198 and (p129.gc[30086] or p129:ic(4261884, 31090, 30086))
                or p129.bc[20699] or p129:ec(43056, 8897, 20699)
            end
          elseif ec > 560 then
            val198 = 1

            ec = val192 >= val198 and (p129.bc[20699] or p129:dc(1411561, 1385, 20699))
              or p129.bc[-16872] or p129:ec(49507, 20107, -16872)
          else
            cc[6284] = val186

            ec = val199 >= val197 and (p129.gc[-11995] or p129:ic(54051316, 20764, -11995))
              or p129.bc[-20860] or p129:ec(57752, 28151, -20860)
          end
        elseif ec < 576 then
          if ec <= 572 then
            if ec > 567 then
              ec, val158, cc2, val224, jc = p129.bc[-30293] or p129:ec(64898, 28921, -30293), p130[1][2][p130[1][1]], "B", p130[8][2][p130[8][1]], p130[3][2][p130[3][1]]
            elseif ec >= 565 then
              if ec <= 565 then
                cc = 96

                ec = val183 > cc and (p129.bc[4329] or p129:dc(16466768, 23791, 4329))
                  or p129.gc[-7058] or p129:ic(10751949, 20463, -7058)
              else
                ec, val198 = p129.bc[20699] or p129:dc(17880861, 17651, 20699), 45
              end
            else
              cc[49287] = val186
              jc, ec, val158, val224, cc2 = p130[3][2][p130[3][1]], p129.bc[12519] or p129:ec(38642, 4108, 12519), p130[1][2][p130[1][1]], p130[8][2][p130[8][1]], "B"
            end
          elseif ec <= 573 then
            cc = 26
            ec = val183 < cc and 549507 / ec or ec + 407
          else
            ec, cc[6284] = 3743 - ec, val186

            jc, val158, val224, cc2 = p130[3][2][p130[3][1]], p130[1][2][p130[1][1]], p130[8][2][p130[8][1]], p129.bc[-28414]
              or p129:cc(p129.Eb(">%8X"), p129.Eb(")c"), -28414)
          end
        elseif ec > 586 then
          if ec <= 587 then
            ec = val186 ~= val186 and ec + -446 or ec + -381
          else
            val198 = 37
            ec = val185 > val198 and ec + 422 or 8820 / ec
          end
        elseif ec <= 583 then
          if ec >= 581 then
            if ec > 581 then
              cc = 195
              ec = val183 > cc and 1425 - ec or 197054 / ec
            else
              ec, val198 = 586810 / ec, 75
            end
          else
            ec, cc[14733] = p129.gc[-11995] or p129:hc(13922, 38295, -11995), val186
          end
        else
          ec, val198 = p129.gc[-1090] or p129:hc(11984, 38084, -1090), 45
        end
      end
    end
  end, function(p131)
    local element28 = string
    local char2, byte2
    element28, byte2, char2 = bit32, element28.byte, element28.char
    local bxor2 = element28.bxor

    char2 = { [1] = 3, [3] = char2 }
    char2[2] = char2

    byte2 = { [1] = 3, [3] = byte2 }
    byte2[2] = byte2

    bxor2 = { [1] = 3, [3] = bxor2 }
    bxor2[2] = bxor2

    element28 = p131:Db({ byte2, char2, bxor2 })
    return element28
  end, function(p132, p133)
    return function(p134)
      local val235 = p133[1][2][p133[1][1]](p133[2][2][p133[2][1]].Team)
      local val236 = val235 == "Home" and "hgoal" or val235 == "Away" and "agoal" or nil

      for i10 = 1, #p133[3][2][p133[3][1]] do
        local parent3 = p133[3][2][p133[3][1]][i10]

        if parent3 and parent3.Parent and parent3.Name == val236 then
          return parent3
        end
      end

      local val237, val238

      if val235 then
        for v310, v311 in p133[4][2][p133[4][1]]:GetPlayers() do
          local team = v311.Team

          local character9 = team and team.Name:find("GK")
            and p133[1][2][p133[1][1]](team) == val235 and v311.Character

          local humanoidRootPart4 = character9 and character9:FindFirstChild("HumanoidRootPart")

          if humanoidRootPart4 then
            for i11 = 1, #p133[3][2][p133[3][1]] do
              local parent4 = p133[3][2][p133[3][1]][i11]

              if parent4 and parent4.Parent then
                local magnitude11 = (parent4.Position - humanoidRootPart4.Position).Magnitude

                if not val238 or magnitude11 > val238 then
                  val237, val238 = parent4, magnitude11
                end
              end
            end

            break
          end
        end

        if val237 then
          return val237
        end
      end

      local lookVector2 = p134.CFrame.LookVector
      local val239, val240

      for i12 = 1, #p133[3][2][p133[3][1]] do
        local parent5 = p133[3][2][p133[3][1]][i12]

        if parent5 and parent5.Parent then
          local element29 = parent5.Position - p134.Position
          local vector8 = Vector3.new(element29.X, 0, element29.Z)

          if vector8.Magnitude > 0.001 then
            local dot = lookVector2:Dot(vector8.Unit)

            if not val240 or dot > val240 then
              val239, val240 = parent5, dot
            end
          end
        end
      end

      return val240 and val240 > 0.3 and val239 or nil
    end
  end, function(p135, p136)
    return function(self, p137, p138, p139)
      local position6 = p139.Position

      if not p136[1][2][p136[1][1]](position6) then
        return false
      end

      local position7, at2 = self.Position, self.At

      if position7 and at2 then
        local val241 = p137 - at2

        if val241 > 0 then
          local element30 = (position6 - position7) * Vector3.new(1, 0, 1)

          if element30.Magnitude > math.max(8, 80 * val241) then
            self.Velocity = Vector3.zero
          else
            local val242 = 1 - math.exp(-val241 / 0.15)
            self.Velocity = self.Velocity:Lerp(element30 / val241, val242)
          end
        end
      end

      self.Position, self.At = position6, p137

      if p137 - self.BoxAt > 0.5 then
        self.BoxAt = p137
        local val243, val244, val245 = 0, 0, 0
        local cframe2 = p139.CFrame

        for v323, v324 in p138:GetChildren() do
          if v324:IsA("BasePart") and (v324.CanCollide or v324.CanTouch) then
            local element31 = v324.Size * 0.5
            local pointToObjectSpace3 = cframe2:PointToObjectSpace(v324.Position)

            local val246 = Vector3.new(pointToObjectSpace3.X, 0, pointToObjectSpace3.Z).Magnitude
              + Vector3.new(element31.X, 0, element31.Z).Magnitude

            if val246 > val243 then
              val243 = val246
            end

            local magnitude12 = element31.Magnitude

            if pointToObjectSpace3.Y - magnitude12 < val244 then
              val244 = pointToObjectSpace3.Y - magnitude12
            end

            if pointToObjectSpace3.Y + magnitude12 > val245 then
              val245 = pointToObjectSpace3.Y + magnitude12
            end
          end
        end

        self.Blocker.Radius, self.Blocker.Bottom, self.Blocker.Top = val243, val244, val245
      end

      self.Blocker.Position, self.Blocker.Velocity = position6, self.Velocity
      return true
    end
  end, function(p140, p141)
    return function(p142, p143, p144, p145, p146, p147)
      local position8 = p142.Position
      local shootDur = p144.shootDur or 0.3
      local val247 = math.max(p144.curveDur or 0, shootDur)
      local val248 = p146 + p147
      local val249 = position8 + p145 * shootDur
      local val250 = val247 - shootDur
      local val251 = val249 + p145 * val250 + val248 * (0.5 * val250 * val250)
      local val252 = p145 + val248 * val250

      local function helper3(val253)
        if val253 <= shootDur then
          return position8 + p145 * val253
        end

        if val253 <= val247 then
          local val254 = val253 - shootDur
          return val249 + p145 * val254 + val248 * (0.5 * val254 * val254)
        end

        local val255 = val253 - val247
        return val251 + val252 * val255 + p146 * (0.5 * val255 * val255)
      end

      p141[1][2][p141[1][1]].FilterDescendantsInstances = {
        p141[2][2][p141[2][1]], p141[3][2][p141[3][1]], p143, p141[4][2][p141[4][1]], }

      local val256 = p142.Size.X * 0.5

      local spherecast2 = p141[5][2][p141[5][1]]:Spherecast(
        position8, val256, Vector3.new(0, -300, 0), p141[1][2][p141[1][1]]
      )

      local val257 = spherecast2 and position8.Y - spherecast2.Distance or -math.huge
      local maxt, val258 = p141[6][2][p141[6][1]].MAXT, 0.05

      while val258 <= p141[6][2][p141[6][1]].MAXT do
        if helper3(val258).Y <= val257 then
          local val259, val260 = val258 - 0.05, val258

          for i13 = 1, 8 do
            local val261 = (val259 + val260) * 0.5

            if helper3(val261).Y <= val257 then
              val260 = val261
            else
              val259 = val261
            end
          end

          maxt = val260
          break
        end

        val258 = val258 + 0.05
      end

      local val262, val263, val264 = { position8 }, position8, false

      for i14 = 1, p141[6][2][p141[6][1]].AIR do
        local val265 = helper3(maxt * (i14 / p141[6][2][p141[6][1]].AIR))
        local element32 = val265 - val263
        local magnitude13 = element32.Magnitude

        if magnitude13 > 0.001 then
          local spherecast3 = p141[5][2][p141[5][1]]:Spherecast(
            val263, val256, element32, p141[1][2][p141[1][1]]
          )

          if spherecast3 then
            val263 = val263 + element32 * (spherecast3.Distance / magnitude13)
            val262[#val262 + 1] = val263
            val264 = spherecast3.Normal.Y <= 0.7
            break
          end
        end

        val262[#val262 + 1] = val265
        val263 = val265
      end

      return val262, val263, val264, val257, maxt, val256, function(p149)
        if p149 <= shootDur then
          return p145
        end

        if p149 <= val247 then
          return p145 + val248 * (p149 - shootDur)
        end

        return val252 + p146 * (p149 - val247)
      end, val247
    end
  end, function(p150, p151)
    return function(p152, p153)
      local gk = p152:FindFirstChild("GK")
      local client = gk and gk:FindFirstChild("Client")
      return p151[1][2][p151[1][1]].Module(client and client:FindFirstChild(p153))
    end
  end, function(p154, p155)
    return function(...)
      local val266 = 124
      local val267, val268, val269, val270, val271, val272, val273, val274, element33, val275, val276, val277, val278

      while true do
        if val266 <= 164 then
          if val266 > 86 then
            if val266 <= 160 then
              if val266 <= 124 then
                element33, val269, val266, val272, val267 = p155[8][2][p155[8][1]], p154.c(...), 86, 44, 224
              else
                val275(val271, val273, val276, val274, val277)
                val271 = p155[1][2][p155[1][1]]
                val275, val271 = val271[35016], element33.n
                val266 = val275 < val271 and 29120 / val266 or 75
              end
            else
              val274, val277, val276, val266, val273 = 2, val271, val275, val266 + 85, p155[4][2][p155[4][1]]
            end
          elseif val266 > 75 then
            val266, element33 = 103 - val266, element33(p154.d(val269))
            val269, val268 = p155[3][2][p155[3][1]], p155[1][2][p155[1][1]]
            val268 = val268[50602]
          elseif val266 <= 47 then
            if val266 <= 17 then
              val269 = val269(val268)
              val273, val275 = {}, {}
              val271 = val273
              val275[24830] = val271
              val266, val271 = 160, 0
              val275[44908] = val271
              val271, val268, val273, val275, val274 = element33, val275, 1, p155[2][2][p155[2][1]], p155[1][2][p155[1][1]]
              val277, val274, val276 = val269, val273, val274[35016]
            else
              val276, val266, val273 = p155[5][2][p155[5][1]], 167, val275[2]
              val274, val277 = val273, 0
            end
          else
            val271, val274, val266, val276, val273, val275 = p155[7][2][p155[7][1]], val268, 184, val269, p155[9][2][p155[9][1]], p155[6][2][p155[6][1]]
          end
        elseif val266 < 210 then
          if val266 >= 182 then
            if val266 <= 182 then
              val273 = p155[1][2][p155[1][1]]
              val271, val273 = val273[35016], 1
              val275, val274, val273 = val271 + val273, p155[1][2][p155[1][1]], element33.n
              val276 = val274[35016]
              val271 = val273 - val276
              val266, val268[44908] = 45500 / val266, val271
              val274, val276, val273, val270, val278 = val275, element33, p155[2][2][p155[2][1]], 1, val275 + val271
              val277, val270, val278 = val278 - val270, val268[24830], val270
            else
              val266, val271 = 210, p154.c(val271(val273, val276, val274))
            end
          else
            val276 = p154.c(val276(val274, val277))
            return p154.d(val276)
          end
        elseif val266 <= 249 then
          if val266 > 210 then
            val273 = p154.c(val273(val276, val274, val277))
            return p154.d(val273)
          end

          val275, val271 = val275(p154.d(val271))
          val273 = val275[1]
          val266 = val273 and 164 or val266 + -163
        else
          val273(val276, val274, val277, val278, val270)
          val266 = val267 < val272 and val266 + -86 or 75
        end
      end
    end
  end, function(p156, p157)
    return function(p158, p159, p160, p161, p162, p163, p164)
      local val279, val280, eps = p158.T, p158.P, p158.Eps
      local verticalSpeed, height, val281 = 0, 0, 0

      if p164 and p164.Airborne then
        verticalSpeed, height, val281 = p164.VerticalSpeed, p164.Height, workspace.Gravity * 0.5
      end

      local val282, val283, val284 = nil, -p157[1][2][p157[1][1]], nil

      for i15 = 1, p158.Count do
        local val285 = val279[i15]

        if not val282 and val285 > p163 then
          break
        end

        local val286 = verticalSpeed * val285 - val281 * val285 * val285

        if val286 < -height then
          val286 = -height
        end

        local pointToObjectSpace4 = p159:PointToObjectSpace(val280[i15] - p160 * val285
          - p157[2][2][p157[2][1]] * val286)

        local val287 = -p157[1][2][p157[1][1]]

        for v365, v366 in p161 do
          local min, max = v366.Min, v366.Max
          local val288 = pointToObjectSpace4.X - (min.X - p162)
          local val289 = max.X + p162 - pointToObjectSpace4.X

          if val289 < val288 then
            val288 = val289
          end

          val289 = pointToObjectSpace4.Y - (min.Y - p162)

          if val289 < val288 then
            val288 = val289
          end

          val289 = max.Y + p162 - pointToObjectSpace4.Y

          if val289 < val288 then
            val288 = val289
          end

          val289 = pointToObjectSpace4.Z - (min.Z - p162)

          if val289 < val288 then
            val288 = val289
          end

          val289 = max.Z + p162 - pointToObjectSpace4.Z

          if val289 < val288 then
            val288 = val289
          end

          if val288 > val287 then
            val287 = val288
          end
        end

        if val287 >= 0 then
          if i15 == 1 then
            return nil
          end

          val282, val284 = val282 or val285, val284 or val280[i15]

          if val287 - eps[i15] > val283 then
            val283 = val287 - eps[i15]
          end
        elseif val282 then
          break
        end
      end

      return val282, val283, val284
    end
  end, function(p166, p167)
    return function()
      if p167[1][2][p167[1][1]] == nil then
        local playerScripts = p167[2][2][p167[2][1]]:FindFirstChild("PlayerScripts")
        local playerModule = playerScripts and playerScripts:FindFirstChild("PlayerModule")
        local val290, element34 = false, nil

        if playerModule then
          val290, element34 = p167[3][2][p167[3][1]](require, playerModule)
        end

        p167[1][2][p167[1][1]] = false

        if val290 and type(element34) == "table" then
          local val291, val292 = p167[3][2][p167[3][1]](element34.GetControls, element34)
          p167[1][2][p167[1][1]] = val291 and val292 or false
        end
      end

      if not p167[1][2][p167[1][1]] then
        return false
      end

      local val293, success6 = pcall(p167[1][2][p167[1][1]].GetMoveVector, p167[1][2][p167[1][1]])
      return val293 and typeof(success6) == "Vector3" and success6.Magnitude > 0.1
    end
  end, function(p168, p169)
    return function(p170, p171, p172)
      local val294 = os.clock()

      if val294 < p169[1][2][p169[1][1]].nxt then
        return
      end

      p169[1][2][p169[1][1]].nxt = val294
        + (p171 and p169[1][2][p169[1][1]].rtt() or p169[1][2][p169[1][1]].cd)

      if not p169[1][2][p169[1][1]].ev then
        local events = replicatedStorage:FindFirstChild("Events")
        events = events and events:FindFirstChild("Remotes")
        p169[1][2][p169[1][1]].ev = events and events:FindFirstChild("Event")
      end

      if p169[1][2][p169[1][1]].ev then
        if p172 then
          p169[1][2][p169[1][1]].ev:FireServer("SetOwner", p170)
        else
          p169[1][2][p169[1][1]].ev:FireServer("SetOwner", p170, p170.CFrame)
        end

        if not p169[1][2][p169[1][1]].pending then
          p169[1][2][p169[1][1]].pending = { ball = p170, t = val294, minD = math.huge }
        end
      end
    end
  end, function(p173, p174)
    return function(self, p175, p176, p177, p178)
      if not (p174[1][2][p174[1][1]](p176) and p174[1][2][p174[1][1]](p177))
        or p177.Magnitude > 1000 then
        return
      end

      local count3 = self.Count

      if count3 > 0 then
        local val295 = p175 - self.T[count3]

        if val295 <= 0 then
          return
        end

        local val296, element35 = self.P[count3], self.V[count3]
        local val297 = p178 * (self.Quantum or val295) * 2 + 2
        local magnitude14 = (p177 - element35).Magnitude
        local magnitude15 = (p176 - (val296 + element35 * val295)).Magnitude

        if magnitude14 > val297 then
          self:Reset(p177.Magnitude > element35.Magnitude + val297 and p175 - val295 * 0.5 or nil)
        elseif magnitude15 > math.max(4, element35.Magnitude * val295 * 0.5 + 2) then
          self:Reset(nil)
        end

        if p177 ~= element35 then
          if self.Changed then
            local val298 = p175 - self.Changed

            if val298 > 0 and val298 < 0.25 then
              self.Quantum = self.Quantum and self.Quantum * 0.8 + val298 * 0.2 or val298
            end
          end

          self.Changed = p175
        end

        count3 = self.Count
      end

      count3 = count3 + 1

      self.T[count3], self.P[count3], self.V[count3] = p175, p176, p177
      self.Count = count3

      local val299 = p175 - 0.3 - 0.1

      if self.T[1] < val299 and count3 > 8 then
        local count4 = 0

        while count4 < count3 - 1 and self.T[count4 + 1] < val299 do
          count4 = count4 + 1
        end

        table.move(self.T, count4 + 1, count3, 1)
        table.move(self.P, count4 + 1, count3, 1)
        table.move(self.V, count4 + 1, count3, 1)

        for i16 = count3 - count4 + 1, count3 do
          self.T[i16], self.P[i16], self.V[i16] = nil, nil, nil
        end

        self.Count = count3 - count4
      end
    end
  end, function(p179, p180, p181, p182)
    p179.gc[p182] = p180 / p179.a(p181, 7480)
    return p179.gc[p182]
  end, function(p183, p184)
    return function(p185, p186, p187)
      local val300 = math.min(#p185 - 1, p184[1][2][p184[1][1]])

      if val300 < 1 then
        p184[2][2][p184[2][1]]()
        return
      end

      p184[3][2][p184[3][1]] = true

      if p187 and p187 ~= p184[4][2][p184[4][1]] then
        p184[4][2][p184[4][1]] = p187

        for i17 = 1, p184[1][2][p184[1][1]] do
          p184[5][2][p184[5][1]][i17].Color = p187
        end
      end

      for i18 = 1, p184[1][2][p184[1][1]] do
        local element36 = p184[5][2][p184[5][1]][i18]

        if i18 <= val300 then
          local val301, val302 = p185[i18], p185[i18 + 1]
          local magnitude16 = (val302 - val301).Magnitude
          element36.Size = Vector3.new(0.18, 0.18, math.max(magnitude16, 0.05))

          if magnitude16 > 0.001 then
            element36.CFrame = CFrame.lookAt((val301 + val302) * 0.5, val302)
          end

          element36.Transparency = 0.25
        elseif element36.Transparency ~= 1 then
          element36.Transparency = 1
        end
      end

      p184[6][2][p184[6][1]].CFrame = CFrame.new(p185[#p185])
      p184[6][2][p184[6][1]].Color = p186 or p184[7][2][p184[7][1]]
      p184[6][2][p184[6][1]].Transparency = 0.15
    end
  end, function(p188, p189)
    return function()
      local character10 = p189[1][2][p189[1][1]].Character
      local humanoid = character10 and character10:FindFirstChildOfClass("Humanoid")

      if not (humanoid and humanoid.Health > 0) then
        p189[2][2][p189[2][1]] = false
        return
      end

      if character10:GetAttribute("CantSprint") == true or p189[3][2][p189[3][1]].Diving
        or p189[3][2][p189[3][1]].Catching or os.clock() < p189[4][2][p189[4][1]] then
        if p189[2][2][p189[2][1]] then
          p189[5][2][p189[5][1]](character10, humanoid, false)
        end

        return
      end

      if os.clock() < (p189[6][2][p189[6][1]].sprintForce or 0) then
        if not p189[2][2][p189[2][1]] then
          p189[5][2][p189[5][1]](character10, humanoid, true)
        end

        return
      end

      if not p189[6][2][p189[6][1]].autoSprint then
        if p189[2][2][p189[2][1]] then
          p189[5][2][p189[5][1]](character10, humanoid, false)
        end

        return
      end

      if humanoid.MoveDirection.Magnitude > 0.1 then
        if not p189[2][2][p189[2][1]] then
          p189[5][2][p189[5][1]](character10, humanoid, true)
        end

        if not p189[6][2][p189[6][1]].wsOn then
          local element37 = p189[7][2][p189[7][1]] and rawget(p189[7][2][p189[7][1]], "state")

          if not (element37 and element37.phase and element37.phase ~= "idle")
            and humanoid.WalkSpeed + 0.05 < 22 then
            humanoid.WalkSpeed = 22
          end
        end
      elseif p189[2][2][p189[2][1]] then
        p189[5][2][p189[5][1]](character10, humanoid, false)
      end
    end
  end, function(p190, p191)
    return function(p192)
      if not p192 then
        return false
      end

      if p191[1][2][p191[1][1]]:FindFirstChild("futsal") then
        return true
      end

      local game2 = p191[1][2][p191[1][1]]:FindFirstChild("Game")

      if not game2 then
        return false
      end

      for index, value in ipairs(game2:GetChildren()) do
        if value.Name == "box" and value:IsA("BasePart") then
          local pointToObjectSpace5 = value.CFrame:PointToObjectSpace(p192.Position)
          local element38 = value.Size * 0.5

          if math.abs(pointToObjectSpace5.X) <= element38.X
            and math.abs(pointToObjectSpace5.Y) <= element38.Y
            and math.abs(pointToObjectSpace5.Z) <= element38.Z then
            return true
          end
        end
      end

      return false
    end
  end, function(p193, p194)
    return function(p195)
      local assemblyMass = p195.AssemblyMass

      if assemblyMass and assemblyMass > 0 then
        for v389, v390 in p195:GetChildren() do
          if v390:IsA("VectorForce") and v390.Enabled
            and v390.RelativeTo == Enum.ActuatorRelativeTo.World then
            return workspace.Gravity - v390.Force.Y / assemblyMass
          end
        end
      end

      return 76.83
    end
  end, function(p196, p197)
    return function(p198)
      if p197[1][2][p197[1][1]] and p197[2][2][p197[2][1]] and p198 < p197[3][2][p197[3][1]] then
        return true
      end

      if p198 < p197[3][2][p197[3][1]] then
        return false
      end

      p197[3][2][p197[3][1]] = p198 + 0.5
      local pass2 = p197[4][2][p197[4][1]]("Pass")

      if p197[1][2][p197[1][1]] and p197[2][2][p197[2][1]] and pass2 == p197[5][2][p197[5][1]]
        and pass2 and pass2.Parent then
        return true
      end

      p197[1][2][p197[1][1]], p197[6][2][p197[6][1]], p197[5][2][p197[5][1]] = nil, nil, nil

      if not (pass2 and type(getsenv) == "function") then
        return false
      end

      local val303, success7 = pcall(getsenv, pass2)

      if not (val303 and type(success7) == "table") then
        return false
      end

      local val304 = rawget(success7, "execute")

      if type(val304) ~= "function" then
        return false
      end

      local val305, success8 = pcall(debug.getupvalues, val304)

      if not (val305 and type(success8) == "table") then
        return false
      end

      for v396, v397 in success8 do
        if type(v397) == "table" and type(rawget(v397, "Pass")) == "table"
          and type(rawget(rawget(v397, "Pass"), "props")) == "table" then
          p197[2][2][p197[2][1]] = v397
        end
      end

      for v398, v399 in success8 do
        if type(v399) == "table" and rawget(v399, "phase") ~= nil
          and rawget(v399, "charge") ~= nil and rawget(v399, "power") ~= nil then
          p197[1][2][p197[1][1]], p197[6][2][p197[6][1]], p197[5][2][p197[5][1]] = val304, v398, pass2
          p197[7][2][p197[7][1]] = nil

          local val306 = p197[8][2][p197[8][1]] or rawget(success7, "createPhysics")

          if type(val306) == "function" then
            local val307, success9 = pcall(debug.getupvalues, val306)

            if val307 and type(success9) == "table" and type(success9[3]) == "table"
              and type(rawget(success9[3], "Pass")) == "table" and type(success9[5]) == "function" then
              p197[7][2][p197[7][1]] = success9[5]
            end
          end

          return true
        end
      end

      return false
    end
  end, function(p199, p200)
    return function(p201, p202, p203, p204, p205, p206)
      local val308, val309, eps2, ignored = p206.T, p206.P, p206.Eps, p206.Ignored
      local gravity, floor, restitution, radius = p202.Gravity, p202.Floor, p202.Restitution, p202.Radius
      local friction, tolerance = p202.Friction, p202.Tolerance or 0
      local goal, blockers = p202.Goal, p202.Blockers
      local val310 = #blockers
      local position9, velocity, spin = p201.Position, p201.Velocity, p201.Spin
      local val311 = false

      if p201.Phase == "Rolling" then
        local vector9 = Vector3.new(velocity.X, 0, velocity.Z)
        local magnitude17 = vector9.Magnitude

        val311 = magnitude17 < 0.001
          or magnitude17 + radius * (spin.Z * vector9.X - spin.X * vector9.Z) / magnitude17 <= 1
          or -p201.Roll:Dot(vector9) / magnitude17 < friction * gravity * 0.5
      end

      local val312 = math.exp(-1.06 * p205)
      local curve, curveLeft = p201.Curve, p201.CurveLeft
      local velSigma, accSigma = p201.VelSigma, p201.AccSigma

      for i19 = 1, val310 do
        local element39 = blockers[i19]
        local element40 = position9 - element39.Position

        ignored[i19] = Vector3.new(element40.X, 0, element40.Z).Magnitude <= element39.Radius + radius
          and element40.Y >= element39.Bottom - radius and element40.Y <= element39.Top + radius
      end

      local dot2 = goal and (position9 - goal.Origin):Dot(goal.Normal)
      local count5, val313, val314, val315, vector10, val316 = 0, 0, 0, nil, nil, nil
      local endKind, val317, val318 = "Horizon", p204, nil

      while true do
        count5 = count5 + 1
        val308[count5], val309[count5] = val313, position9
        local val319 = val313 - p203

        if val319 < 0 then
          val319 = 0
        end

        eps2[count5] = velSigma * val313 + 0.5 * accSigma * val319 * val319

        if val313 >= p204 then
          break
        end

        local val320 = val313 + p205 * 0.5
        local vector11 = p200[1][2][p200[1][1]]

        if val311 then
          vector11 = Vector3.new(velocity.X, 0, velocity.Z) * -0.3028571428571429
        elseif val320 >= p203 then
          local val321, val322 = 0, 0

          if val320 < curveLeft then
            val321, val322 = curve.X, curve.Z
          end

          vector11 = Vector3.new(val321, -gravity, val322)

          if position9.Y <= floor + 0.25 and p200[2][2][p200[2][1]](velocity.Y) < 1 then
            if not val315 then
              local vector12 = Vector3.new(velocity.X, 0, velocity.Z)
              local magnitude18 = vector12.Magnitude
              val315, val314 = p200[1][2][p200[1][1]], 0

              if magnitude18 > 0.001 then
                local val323 = magnitude18
                  + radius * (spin.Z * vector12.X - spin.X * vector12.Z) / magnitude18

                val315, val314 = vector12 / -magnitude18, val323 > 0 and val323 * 0.2857142857142857 or 0
              end
            end

            if val314 > 0 then
              vector11 = val315 * (friction * gravity)
              val314 = val314 - friction * gravity * p205
            else
              val311, vector11 = true, p200[1][2][p200[1][1]]
            end
          else
            spin = spin * val312
          end
        end

        local vector13 = position9 + velocity * p205 + vector11 * (0.5 * p205 * p205)
        local vector14 = velocity + vector11 * p205
        local val324 = val313 + p205

        if vector13.Y < floor and val320 >= p203 then
          if vector14.Y < 0 and not val311 then
            local val325, val326 = position9.Y - floor, 0

            if val325 > 0 then
              local val327 = 0.5 * vector11.Y

              if val327 < -0.000001 then
                val326 = (velocity.Y
                    + p200[3][2][p200[3][1]](velocity.Y * velocity.Y - 4 * val327 * val325))
                  / (-2 * val327)
              elseif velocity.Y < 0 then
                val326 = -val325 / velocity.Y
              end

              if val326 > p205 then
                val326 = p205
              end
            end

            local val328, element41 = position9 + velocity * val326 + vector11 * (0.5 * val326 * val326), velocity + vector11 * val326
            local val329 = -element41.Y
            local val330 = val329 * restitution
            local vector15 = Vector3.new(element41.X, 0, element41.Z)
            local element42 = vector15 + Vector3.new(radius * spin.Z, 0, -radius * spin.X)
            local magnitude19 = element42.Magnitude

            if magnitude19 > 0.000001 and val329 > tolerance then
              local val331 = friction * (1 + restitution) * val329

              if val331 > magnitude19 * 0.2857142857142857 then
                val331 = magnitude19 * 0.2857142857142857
              end

              local val332 = element42 / magnitude19
              vector15 = vector15 - val332 * val331
              spin = spin + Vector3.yAxis:Cross(val332) * (2.5 * val331 / radius)
            end

            local val333 = p205 - val326

            if val330 < gravity * p205 * 2 or val329 <= tolerance then
              val311, vector14 = true, vector15

              vector13 = Vector3.new(
                val328.X + vector15.X * val333, floor, val328.Z + vector15.Z * val333
              )
            else
              vector10, val316 = vector10 or Vector3.new(val328.X, floor, val328.Z), val316 or val313 + val326
              vector14 = Vector3.new(vector15.X, val330 - gravity * val333, vector15.Z)

              vector13 = Vector3.new(
                val328.X + vector15.X * val333, floor + val330 * val333 - 0.5 * gravity * val333 * val333, val328.Z + vector15.Z * val333
              )
            end
          end

          if vector13.Y < floor then
            vector13 = Vector3.new(vector13.X, floor, vector13.Z)
          end
        end

        if goal then
          local val334 = false

          if vector13.Y <= goal.Top + radius then
            for i20 = -1, 1, 2 do
              local val335 = goal.Origin + goal.Right * (i20 * (goal.HalfWidth + goal.PostRadius))

              if p200[4][2][p200[4][1]](position9, vector13, val335) <= goal.PostRadius + radius then
                val334 = true
              end
            end
          end

          if val334 then
            endKind, val317 = "Post", val324
            break
          end

          local dot3 = (vector13 - goal.Origin):Dot(goal.Normal)

          if dot2 > 0 and dot3 <= 0 then
            local val336 = dot2 / (dot2 - dot3)
            local lerp = position9:Lerp(vector13, val336)
            local dot4 = (lerp - goal.Origin):Dot(goal.Right)
            local val337 = eps2[count5]

            local val338 = p200[2][2][p200[2][1]](dot4) <= goal.HalfWidth + val337
              and lerp.Y <= goal.Top + val337

            local val339 = p200[2][2][p200[2][1]](dot4) <= goal.HalfWidth
              and p200[2][2][p200[2][1]](lerp.Y - goal.Top - goal.PostRadius)
                <= goal.PostRadius + radius

            val318 = {
              T = val313 + p205 * val336, Position = lerp, Lateral = dot4, Height = lerp.Y, InMouth = val338, }

            endKind = val339 and "Post" or val338 and "Goal" or "Wide"
            val317 = val318.T
            count5 = count5 + 1
            val308[count5], val309[count5], eps2[count5] = val318.T, lerp, val337
            break
          end

          dot2 = dot3
        end

        local val340 = false

        for i21 = 1, val310 do
          local element43 = blockers[i21]
          local element44 = vector13 - (element43.Position + element43.Velocity * val324)

          local val341 = Vector3.new(element44.X, 0, element44.Z).Magnitude <= element43.Radius + radius
            and element44.Y >= element43.Bottom - radius and element44.Y <= element43.Top + radius

          if ignored[i21] then
            if not val341 then
              ignored[i21] = false
            end
          elseif val341 then
            val340 = true
          end
        end

        if val340 then
          endKind, val317 = "Blocked", val324
          break
        end

        position9, velocity, val313 = vector13, vector14, val324

        if val311 and velocity.Magnitude < 0.5 then
          endKind, val317 = "Stopped", val313
          break
        end
      end

      p206.Count, p206.Step, p206.EndKind, p206.EndT, p206.Cross, p206.Land, p206.LandT = count5, p205, endKind, val317, val318, vector10, val316
      return p206
    end
  end, function(p208, p209, p210, p211)
    p208.bc[p211] = p208.Cb(p209, p210)
    return p208.bc[p211]
  end, function(p212, p213, p214, p215)
    p212.bc[p215] = p212.a(p213, 53675) / p214
    return p212.bc[p215]
  end, d = helper(), function(p216, p217)
    return function(p218, p219, p220, goal2)
      local surface = p219.Surface

      if not p219.HasSurface then
        return 0
      end

      p217[1][2][p217[1][1]].Gravity = p219.Gravity
      p217[1][2][p217[1][1]].Floor = surface.Floor

      p217[1][2][p217[1][1]].Tolerance = p219:Tolerance(
        p219.Gravity, p217[2][2][p217[2][1]].Frame
      )

      p217[1][2][p217[1][1]].PinMin, p217[1][2][p217[1][1]].PinMax = p220.PinMin, p220.PinMax
      p217[1][2][p217[1][1]].CurveDuration = p220.CurveDuration

      p217[1][2][p217[1][1]].CurveBound = p220.CurveIntensity
        / math.max(p218.AssemblyMass, 0.001)

      local element45 = p217[3][2][p217[3][1]].Fit(p219, p217[1][2][p217[1][1]], p219.State)

      if not element45 or element45.Velocity.Magnitude < 1 then
        return 0
      end

      p217[4][2][p217[4][1]].Gravity, p217[4][2][p217[4][1]].Floor, p217[4][2][p217[4][1]].Restitution, p217[4][2][p217[4][1]].Friction, p217[4][2][p217[4][1]].Radius, p217[4][2][p217[4][1]].Tolerance = p219.Gravity, surface.Floor, surface.Restitution, surface.Friction, surface.Radius, p217[1][2][p217[1][1]].Tolerance
      p217[4][2][p217[4][1]].Goal = goal2

      table.clear(p217[5][2][p217[5][1]])

      if element45.Phase == "Pinned" then
        p217[5][2][p217[5][1]][1], p217[5][2][p217[5][1]][2], p217[5][2][p217[5][1]][3] = (element45.PinLo
            + element45.PinHi)
          * 0.5, element45.PinLo, element45.PinHi
      else
        p217[5][2][p217[5][1]][1] = 0
      end

      for v439, v440 in p217[5][2][p217[5][1]] do
        p217[3][2][p217[3][1]].Predict(
          element45, p217[4][2][p217[4][1]], v440, 4, 0.016666666666666666, p217[6][2][p217[6][1]][v439]
        )
      end

      return #p217[5][2][p217[5][1]], element45
    end
  end, function(p221, p222)
    return function(p223, p224)
      local val342, val343

      local function helper4(val344)
        local element46, element47, element48, val345, val346, val347, val348 = p222[1][2][p222[1][1]](
          p223, p224, val344
        )

        local val349 = val344 == nil
        local val350, val351 = (val347 - val346) * 0.5, (val346 + val347) * 0.5

        for i22 = 1, #p222[2][2][p222[2][1]] do
          local position10 = p222[2][2][p222[2][1]][i22].Position
          local val352, val353, val354 = position10.X - element46.X, position10.Y - element46.Y, position10.Z - element46.Z
          local val355 = val352 * element48.X + val354 * element48.Z
          local val356 = val352 * element47.X + val354 * element47.Z
          local val357

          if val349 then
            local val358 = (val353 - val350) / val351
            val357 = (val355 / val345) ^ 2 + val358 * val358 + (val356 / val348) ^ 2 <= 1
          else
            val357 = val353 >= -val346 and val353 <= val347 and val355 >= -val345 and val355 <= val345
              and val356 >= -val348 and val356 <= val348
          end

          if val357 then
            local val359 = val355 * val355 + val353 * val353 + val356 * val356

            if not val343 or val359 < val343 then
              val342, val343 = p222[2][2][p222[2][1]][i22], val359
            end
          end
        end
      end

      if not (p222[3][2][p222[3][1]].feetBox or p222[3][2][p222[3][1]].headBox) then
        helper4(nil)
        return val342
      end

      local val360, val361 = p222[4][2][p222[4][1]]()

      if val360 then
        if val361 then
          if p222[3][2][p222[3][1]].headBox then
            helper4("head")
          end
        elseif p222[3][2][p222[3][1]].feetBox then
          helper4("feet")
        end

        return val342
      end

      if p222[3][2][p222[3][1]].feetBox then
        helper4("feet")
      end

      if p222[3][2][p222[3][1]].headBox then
        helper4("head")
      end

      return val342
    end
  end, function(p226, p227)
    return function(p228, ...)
      p227[1][2][p227[1][1]]()
      return p228, ...
    end
  end, function(p229, p230)
    return function(p231, p232, p233, p234)
      local val362 = p231 * p231
      local val363 = val362 * val362 - p232 * (p232 * p233 * p233 + 2 * p234 * val362)

      if val363 < 0 then
        return nil
      end

      return math.atan((val362 - math.sqrt(val363)) / (p232 * p233))
    end
  end, function(p235)
    local element49 = string
    local gsub, char3 = element49.gsub, element49.char

    char3 = { [1] = 3, [3] = char3 }
    char3[2] = char3

    gsub = { [1] = 3, [3] = gsub }
    gsub[2] = gsub

    local element50 = bit32
    local band

    element49, band = element50.rshift, element50.band
    element49 = { [1] = 3, [3] = element49 }
    element49[2] = element49

    band = { [1] = 3, [3] = band }
    band[2] = band

    element50 = p235:Fb({ char3, element49, band, gsub })
    return element50
  end, function(p236, p237)
    return function()
      local guideBall = p237[1][2][p237[1][1]].guideBall

      if not (guideBall and guideBall.Parent) or os.clock() >= p237[1][2][p237[1][1]].guideUntil then
        if guideBall and guideBall.Parent then
          local summitGuide = guideBall:FindFirstChild("SummitGuide")

          if summitGuide then
            summitGuide:Destroy()
          end
        end

        p237[1][2][p237[1][1]].guideBall = nil
        return
      end

      local guideTarget = p237[1][2][p237[1][1]].guideTarget
      local position11, assemblyLinearVelocity5 = guideBall.Position, guideBall.AssemblyLinearVelocity
      local element51 = guideTarget - position11
      local vector16 = Vector3.new(element51.X, 0, element51.Z)
      local magnitude20 = Vector3.new(assemblyLinearVelocity5.X, 0, assemblyLinearVelocity5.Z).Magnitude

      if vector16.Magnitude <= p237[1][2][p237[1][1]].ARRIVE
        or magnitude20 < 1
        or p237[1][2][p237[1][1]].nrm
          and (position11 - guideTarget):Dot(p237[1][2][p237[1][1]].nrm) <= 0 then
        local summitGuide2 = guideBall:FindFirstChild("SummitGuide")

        if summitGuide2 then
          summitGuide2:Destroy()
        end

        p237[1][2][p237[1][1]].guideBall = nil
        return
      end

      local val364 = math.max(0.05, vector16.Magnitude / magnitude20)
      local vector17 = Vector3.new(0, -p237[2][2][p237[2][1]](guideBall), 0)
      local getMass2 = guideBall:GetMass()

      for v469, v470 in guideBall:GetChildren() do
        if v470:IsA("BodyForce") and v470.Name ~= "SummitGuide" and getMass2 > 0 then
          vector17 = vector17 + v470.Force / getMass2
        end
      end

      local element52 = guideTarget
        - (position11 + assemblyLinearVelocity5 * val364 + vector17 * (0.5 * val364 * val364))

      local vector18 = Vector3.new(assemblyLinearVelocity5.X, 0, assemblyLinearVelocity5.Z)
      local zero4 = Vector3.zero

      if vector18.Magnitude > 0.001 then
        local unit2 = vector18.Unit
        local vector19 = Vector3.new(element52.X, 0, element52.Z)
        zero4 = (vector19 - unit2 * vector19:Dot(unit2)) * (2 / (val364 * val364))
      end

      if zero4.Magnitude > p237[1][2][p237[1][1]].GUIDE_MAX then
        zero4 = zero4.Unit * p237[1][2][p237[1][1]].GUIDE_MAX
      end

      local summitGuide3 = guideBall:FindFirstChild("SummitGuide")

      if not summitGuide3 then
        summitGuide3 = Instance.new("BodyForce")
        summitGuide3.Name = "SummitGuide"
        summitGuide3.Parent = guideBall
      end

      summitGuide3.Force = zero4 * getMass2
    end
  end, function(p238, p239)
    return function(p240, p241, p242)
      local val365, val366, origin, normal = p240.T, p240.P, p241.Origin, p241.Normal
      local dot5 = (p242 - origin):Dot(normal)
      local dot6 = (val366[1] - origin):Dot(normal)

      if dot6 > dot5 then
        for i23 = 2, p240.Count do
          local dot7 = (val366[i23] - origin):Dot(normal)

          if dot7 <= dot5 then
            local val367 = (dot6 - dot5) / (dot6 - dot7)
            return val365[i23 - 1] + (val365[i23] - val365[i23 - 1]) * val367, val366[i23 - 1]:Lerp(val366[i23], val367)
          end

          dot6 = dot7
        end
      end

      local cross = p240.Cross

      if cross then
        return cross.T, cross.Position
      end

      return nil
    end
  end, function(p244, p245)
    return function()
      if p245[1][2][p245[1][1]].aimK then
        p245[1][2][p245[1][1]].aimK = nil
        p245[2][2][p245[2][1]]()
      end
    end
  end, function(p246, p247)
    return function(p248, p249)
      local element53 = p247[1][2][p247[1][1]].goalFor(p248)

      if not element53 then
        return nil
      end

      local val368 = p247[1][2][p247[1][1]].normal(element53)
      local vector20 = Vector3.new(element53.Position.X - p249.X, 0, element53.Position.Z - p249.Z)

      if vector20.Magnitude < 0.001 then
        return nil
      end

      local rightVector3 = element53.CFrame.RightVector

      local val369 = rightVector3:Dot((vector20.Unit:Cross(Vector3.new(0, 1, 0)))) >= 0 and 1
        or -1

      local agCorner = p247[2][2][p247[2][1]].agCorner

      local roll = agCorner == "Random Corner" and p247[1][2][p247[1][1]].ROLL
        or agCorner == "Random Top Corner" and p247[1][2][p247[1][1]].ROLL_TOP

      if roll then
        agCorner = roll[math.random(1, #roll)]
      end

      agCorner = p247[1][2][p247[1][1]].CORNERS[agCorner]
        or p247[1][2][p247[1][1]].CORNERS["Top Left"]

      local element54 = element53.Size * 0.5
      local val370 = math.min(4.5, element54.X - 2)
      local val371 = math.min(p247[1][2][p247[1][1]].INSET_Y, element54.Y - 1)

      return element53.Position + val368 * p247[1][2][p247[1][1]].mouth(element53, val368)
        + rightVector3 * (val369 * agCorner[1] * (element54.X - val370))
        + Vector3.new(0, agCorner[2] * (element54.Y - val371), 0), element53, val368
    end
  end, function(p250, p251)
    return function(p252)
      if p252:FindFirstChild("Left") then
        return true
      end

      local dataFolder2 = p251[1][2][p251[1][1]]:FindFirstChild("DataFolder")
      local leg = dataFolder2 and dataFolder2:FindFirstChild("leg")
      return leg ~= nil and leg.Value == "L"
    end
  end, function(p253, p254)
    return function()
      if p254[1][2][p254[1][1]] then
        for v479, v480 in p254[1][2][p254[1][1]] do
          if typeof(v479) == "EnumItem" and v479.EnumType == Enum.KeyCode
            and type(v480) == "table" and rawget(v480, "timing") then
            local val372, success10 = pcall(
              p254[2][2][p254[2][1]].IsKeyDown, p254[2][2][p254[2][1]], v479
            )

            if val372 and success10 then
              return v480
            end
          end
        end
      end

      local val373 = p254[3][2][p254[3][1]] and rawget(p254[3][2][p254[3][1]], "LowShoot")

      if type(val373) == "table" and p254[2][2][p254[2][1]]:IsKeyDown(Enum.KeyCode.R) then
        return val373
      end

      return p254[4][2][p254[4][1]]
    end
  end, function(p255, p256)
    return function(p257, p258)
      if not p256[1][2][p256[1][1]] then
        return nil
      end

      local val374, val375, huge6, val376 = nil, nil, math.huge, -1

      for v487, v488 in p256[1][2][p256[1][1]]:GetChildren() do
        if v488:IsA("BasePart") then
          local magnitude21 = (v488.Position - p257.Position).Magnitude

          if magnitude21 < huge6 then
            val374, huge6 = v488, magnitude21
          end

          if magnitude21 > val376 then
            val375, val376 = v488, magnitude21
          end
        end
      end

      if not val374 then
        return nil
      end

      local val377 = p256[2][2][p256[2][1]][val374]

      if val377 then
        return val377
      end

      val377 = p256[3][2][p256[3][1]](val374, val375 ~= val374 and val375 or nil, p258)

      if not val377 then
        return nil
      end

      p256[2][2][p256[2][1]][val374] = val377

      p256[4][2][p256[4][1]].Goal = {
        Name = val374.Name, HalfWidth = val377.HalfWidth, Top = val377.Top, PostRadius = val377.PostRadius, Origin = val377.Origin, Normal = val377.Normal, Right = val377.Right, }

      return val377
    end
  end, function(p259, p260)
    return function(p261, p262, p263, p264)
      local val378, val379, v492, val380, val381, val382, val383 = p260[1][2][p260[1][1]](p262, p263, p264)
      local val384 = val378 + Vector3.new(0, (val382 - val381) * 0.5, 0)
      local ball3 = p264 == nil and Enum.PartType.Ball or Enum.PartType.Block

      if p261.Shape ~= ball3 then
        p261.Shape = ball3
      end

      p261.Size = Vector3.new(val380 * 2, val381 + val382, val383 * 2)
      p261.CFrame = CFrame.lookAt(val384, val384 + val379)
      p261.Transparency = 0.86
    end
  end, function(p265, p266)
    return function(p267, p268)
      if not p267:FindFirstChild("GK") or p266[1][2][p266[1][1]].InFK then
        return false
      end

      return p266[2][2][p266[2][1]].InsideBox(p268)
    end
  end, bit32.bxor, function(p269, p270)
    return function()
      if p270[1][2][p270[1][1]] == nil then
        local playerScripts2 = p270[2][2][p270[2][1]]:FindFirstChild("PlayerScripts")

        local findFirstChild2 = playerScripts2
          and playerScripts2:FindFirstChild("KeybindMenu", true)

        local val385, val386 = false, nil

        if findFirstChild2 and findFirstChild2:IsA("ModuleScript") then
          val385, val386 = p270[3][2][p270[3][1]](require, findFirstChild2)
        end

        p270[1][2][p270[1][1]] = val385 and type(val386) == "table" and val386 or false
      end

      return p270[1][2][p270[1][1]] or nil
    end
  end, {}, function(p271, p272)
    return function(p273)
      if not p273 then
        return 0
      end

      local jumpPower = p273.UseJumpPower and p273.JumpPower
        or math.sqrt(2 * p272[1][2][p272[1][1]].Gravity * p273.JumpHeight)

      return jumpPower * jumpPower / (2 * p272[1][2][p272[1][1]].Gravity)
    end
  end, function(p274, p275)
    return function(p276, diveFORCE)
      if p276 <= 0 then
        return 0
      end

      diveFORCE = diveFORCE or p275[1][2][p275[1][1]].DIVE_FORCE
      local val387 = diveFORCE * 0.5

      if p276 <= p275[1][2][p275[1][1]].DIVE_TWEEN then
        return val387 * p276
          + (diveFORCE - val387) * p276 * p276 / (2 * p275[1][2][p275[1][1]].DIVE_TWEEN)
      end

      return (val387 + diveFORCE) * 0.5 * p275[1][2][p275[1][1]].DIVE_TWEEN
        + diveFORCE * (p276 - p275[1][2][p275[1][1]].DIVE_TWEEN)
    end
  end, function(p277, p278)
    return function(p279, p280, p281)
      local element55, element56 = p278[1][2][p278[1][1]].ModuleOf(p279, "catchhigh"), p278[1][2][p278[1][1]].ModuleOf(p279, "catchlow")

      if not (p278[2][2][p278[2][1]].magnetCatch
        and (element55 and element55.State and element55.State.attemptingCatch
          or element56 and element56.State and element56.State.attemptingCatch)) then
        p278[3][2][p278[3][1]].Ball, p278[3][2][p278[3][1]].Done = nil, nil
        return
      end

      if p278[3][2][p278[3][1]].Done then
        return
      end

      if not p278[3][2][p278[3][1]].Ball then
        if not (p278[4][2][p278[4][1]](element55) or p278[4][2][p278[4][1]](element56)) then
          return
        end

        local parent6 = p278[1][2][p278[1][1]].BallIn(p279, p280, "gk")

        if not (parent6 and parent6.Parent == p278[5][2][p278[5][1]] and p278[6][2][p278[6][1]](parent6)) then
          return
        end

        p278[3][2][p278[3][1]].Ball, p278[3][2][p278[3][1]].At = parent6, p281
      end

      local ball4, ball5 = p278[3][2][p278[3][1]].Ball, p279:FindFirstChild("Ball")
      local attachment = ball5 and ball5:FindFirstChild("Attachment")

      if not (ball4.Parent == p278[5][2][p278[5][1]] and attachment)
        or ball4:FindFirstChildOfClass("AlignPosition")
        or p281 - p278[3][2][p278[3][1]].At > 0.5 then
        p278[3][2][p278[3][1]].Ball, p278[3][2][p278[3][1]].Done = nil, true
        return
      end

      local networkOwner3 = ball4:FindFirstChild("NetworkOwner")

      if networkOwner3 and networkOwner3.Value ~= p278[7][2][p278[7][1]] then
        p278[8][2][p278[8][1]](ball4, true)
        return
      end

      for v504, v505 in ball4:GetChildren() do
        if v505:IsA("BodyMover") and not v505:IsA("BodyGyro") then
          v505:Destroy()
        end
      end

      for v506, v507 in p279:GetDescendants() do
        if v507:IsA("BasePart") then
          local noCollisionConstraint = Instance.new("NoCollisionConstraint")
          noCollisionConstraint.Part0, noCollisionConstraint.Part1, noCollisionConstraint.Parent = v507, ball4, ball4
          debris:AddItem(noCollisionConstraint, 1)
        end
      end

      local worldPosition = attachment.WorldPosition

      local unit3 = ball4.Position - worldPosition
      unit3 = unit3.Magnitude > 0.001 and unit3.Unit or p280.CFrame.LookVector

      ball4.CFrame = CFrame.new(worldPosition + unit3 * 2.5)
      ball4.AssemblyLinearVelocity, ball4.AssemblyAngularVelocity = unit3 * -15, Vector3.zero

      p278[3][2][p278[3][1]].Ball, p278[3][2][p278[3][1]].Done = nil, true
    end
  end, function(p282, p283)
    return function(p284, diveFORCE2)
      if p284 <= 0 then
        return 0
      end

      diveFORCE2 = diveFORCE2 or p283[1][2][p283[1][1]].DIVE_FORCE

      if diveFORCE2 <= 0 then
        return p283[1][2][p283[1][1]].REACT
      end

      local val388 = diveFORCE2 * 0.5
      local val389 = (val388 + diveFORCE2) * 0.5 * p283[1][2][p283[1][1]].DIVE_TWEEN

      if p284 <= val389 then
        local val390 = (diveFORCE2 - val388) / (2 * p283[1][2][p283[1][1]].DIVE_TWEEN)
        return (-val388 + math.sqrt(val388 * val388 + 4 * val390 * p284)) / (2 * val390)
      end

      return p283[1][2][p283[1][1]].DIVE_TWEEN + (p284 - val389) / diveFORCE2
    end
  end, function(p285, p286)
    return function(p287)
      return type(p287) == "number" and p287 == p287 and p287 ~= math.huge
        and p287 ~= -math.huge
    end
  end, function(p288, p289)
    return function()
      local character11 = p289[1][2][p289[1][1]].Character
      local humanoidRootPart5 = character11 and character11:FindFirstChild("HumanoidRootPart")

      if p289[2][2][p289[2][1]].steerBV
        and not (p289[3][2][p289[3][1]].autoRedirect and p289[4][2][p289[4][1]].Diving
          and humanoidRootPart5 and p289[2][2][p289[2][1]].steerBV.Parent == humanoidRootPart5) then
        pcall(p289[2][2][p289[2][1]].steerBV.Destroy, p289[2][2][p289[2][1]].steerBV)
        p289[2][2][p289[2][1]].steerBV = nil
      end

      local threat = p289[2][2][p289[2][1]].Live.Threat
      local ball6 = threat and threat.Ball

      if not (humanoidRootPart5 and ball6 and threat.CrossT) then
        return
      end

      local val391 = os.clock()
      local val392 = threat.CrossT - (val391 - threat.At)

      if val392 <= 0 or val392 > 1.5 then
        return
      end

      local networkOwner4 = ball6:FindFirstChild("NetworkOwner")

      if networkOwner4 and networkOwner4.Value == p289[1][2][p289[1][1]]
        and (ball6.Position - humanoidRootPart5.Position).Magnitude < 6 then
        return
      end

      local crossAt2 = threat.CrossAt

      local lookVector3 = humanoidRootPart5.CFrame.LookVector
      lookVector3 = Vector3.new(lookVector3.X, 0, lookVector3.Z)

      local val393 = (lookVector3.Magnitude > 0.001 and CFrame.new(
        humanoidRootPart5.Position, humanoidRootPart5.Position + lookVector3.Unit
      ) or humanoidRootPart5.CFrame):PointToObjectSpace(crossAt2).X

      local val394 = crossAt2.Y - humanoidRootPart5.Position.Y
      local dot8, val395 = val393, val393 < 0 and -1 or 1
      local goal3 = p289[2][2][p289[2][1]].Live.Goal

      do
        local rightVector4 = humanoidRootPart5.CFrame.RightVector
        rightVector4 = Vector3.new(rightVector4.X, 0, rightVector4.Z)

        if rightVector4.Magnitude > 0.001 then
          dot8 = (crossAt2 - humanoidRootPart5.Position):Dot(goal3.Right)
          local dot9 = rightVector4.Unit:Dot(goal3.Right)

          if math.abs(dot9) > 0.2 and math.abs(dot8) > 0.001 then
            val395 = dot9 * dot8 >= 0 and 1 or -1
          end
        end
      end

      local lastLat = ball6 == p289[2][2][p289[2][1]].latBall and p289[2][2][p289[2][1]].lastLat
        or nil

      local val396 = false

      do
        local assemblyLinearVelocity6 = ball6.AssemblyLinearVelocity
        local magnitude22 = assemblyLinearVelocity6.Magnitude

        assemblyLinearVelocity6 = magnitude22 > 0.001 and assemblyLinearVelocity6 / magnitude22
          or nil

        if assemblyLinearVelocity6 and lastLat and p289[2][2][p289[2][1]].lastDir then
          val396 = assemblyLinearVelocity6:Dot(p289[2][2][p289[2][1]].lastDir) < 0.985
        end

        p289[2][2][p289[2][1]].lastDir = assemblyLinearVelocity6
      end

      p289[2][2][p289[2][1]].latBall, p289[2][2][p289[2][1]].lastLat = ball6, dot8
      local element57 = p289[5][2][p289[5][1]] and rawget(p289[5][2][p289[5][1]], "state")

      if element57 and (element57.chargeProgress or 0) > 0 then
        return
      end

      if p289[3][2][p289[3][1]].autoRedirect and p289[4][2][p289[4][1]].Diving
        and p289[2][2][p289[2][1]].fired
        and string.sub(p289[2][2][p289[2][1]].fired, 1, 5) ~= "catch" then
        local val397 = os.clock() - (p289[2][2][p289[2][1]].firedAt or 0)

        if val397 > p289[2][2][p289[2][1]].REACT then
          if p289[2][2][p289[2][1]].steerBV then
            pcall(p289[2][2][p289[2][1]].steerBV.Destroy, p289[2][2][p289[2][1]].steerBV)
            p289[2][2][p289[2][1]].steerBV = nil
          end
        else
          local steerBV = p289[2][2][p289[2][1]].steerBV

          if not (steerBV and steerBV.Parent) then
            for index2, value2 in ipairs(humanoidRootPart5:GetChildren()) do
              if value2:IsA("BodyVelocity") then
                value2:Destroy()
              end
            end

            steerBV = p289[6][2][p289[6][1]]("BodyVelocity", humanoidRootPart5, {
              MaxForce = Vector3.new(1, 1, 1) * 50000, })

            debris:AddItem(steerBV, p289[2][2][p289[2][1]].REACT)
            p289[2][2][p289[2][1]].steerBV = steerBV
          end

          if val397 <= p289[2][2][p289[2][1]].DIVE_TWEEN then
            local top = goal3.Top

            local element58 = (crossAt2.Y > top and Vector3.new(crossAt2.X, top, crossAt2.Z) or crossAt2) - Vector3.new(
              0, p289[2][2][p289[2][1]].leap and 0 or p289[2][2][p289[2][1]].CHEST, 0
            ) - humanoidRootPart5.Position

            if p289[2][2][p289[2][1]].dir ~= 0 and p289[2][2][p289[2][1]].axis then
              local dot10 = element58:Dot(p289[2][2][p289[2][1]].axis)

              if dot10 * p289[2][2][p289[2][1]].dir < 0 then
                element58 = element58 - p289[2][2][p289[2][1]].axis * dot10
              end
            end

            local magnitude23 = element58.Magnitude

            if magnitude23 > 0.2 then
              local vector21 = element58.Unit * math.min(
                magnitude23 / math.max(val392, 0.03), p289[2][2][p289[2][1]].steerForce or p289[2][2][p289[2][1]].DIVE_FORCE
              )

              if humanoidRootPart5.Position.Y >= top and vector21.Y > 0 then
                vector21 = Vector3.new(vector21.X, 0, vector21.Z)
              end

              steerBV.Velocity = vector21
            end
          end
        end
      end

      if not p289[3][2][p289[3][1]].oldDive or threat.Held then
        return
      end

      local humanoid2 = character11:FindFirstChildOfClass("Humanoid")

      local autoJump = p289[3][2][p289[3][1]].autoJump and humanoid2
          and humanoid2.FloorMaterial ~= Enum.Material.Air
          and p289[2][2][p289[2][1]].JumpGain(humanoid2)
        or 0

      local val398, val399 = p289[7][2][p289[7][1]](val394, val395)

      if not p289[2][2][p289[2][1]].Ready(val398, character11, false) then
        local val400 = p289[2][2][p289[2][1]].ALT[val398]

        if not (val400 and p289[2][2][p289[2][1]].Ready(val400, character11, false)) then
          return
        end

        val398 = val400
      end

      local val401 = p289[2][2][p289[2][1]].ForceOf(val398)

      local magnitude24 = p289[3][2][p289[3][1]].autoRedirect
          and (crossAt2 - Vector3.new(0, p289[2][2][p289[2][1]].CHEST, 0)
            - humanoidRootPart5.Position).Magnitude
        or math.abs(val393)

      local val402 = math.clamp(ball6.ReceiveAge or 0, 0, 0.2)
      local dot11, val403 = 0, val393

      do
        local rightVector5 = humanoidRootPart5.CFrame.RightVector
        rightVector5 = Vector3.new(rightVector5.X, 0, rightVector5.Z)

        if rightVector5.Magnitude > 0.001 then
          dot11 = humanoidRootPart5.AssemblyLinearVelocity:Dot(rightVector5.Unit)
          val403 = val393 - dot11 * math.min(val392, p289[2][2][p289[2][1]].REACT)
        end
      end

      if p289[3][2][p289[3][1]].runHold and math.abs(dot11) >= p289[2][2][p289[2][1]].RUN_MIN
        and dot11 * val393 > 0
        and math.abs(val403) <= humanoidRootPart5.Size.X * 0.5 + ball6.Size.X * 0.5
        and val394 <= p289[2][2][p289[2][1]].CATCH_REACH then
        return
      end

      local val404 = math.clamp(p289[8][2][p289[8][1]](
        math.max(magnitude24, math.abs(val403)) - p289[2][2][p289[2][1]].ARM_REACH, val401
      ) + p289[3][2][p289[3][1]].gkMargin + val402, p289[2][2][p289[2][1]].MIN_LEAD, p289[2][2][p289[2][1]].REACT)

      local val405 = p289[2][2][p289[2][1]].DIVE_UP
        + 4 * math.min(val392, p289[2][2][p289[2][1]].REACT) + 1

      if val399 and p289[3][2][p289[3][1]].autoJump then
        val405 = val405 + autoJump
      end

      local autoRedirect = not (p289[4][2][p289[4][1]].Diving or p289[4][2][p289[4][1]].Catching) and val391 >= p289[9][2][p289[9][1]] and (val404 >= p289[2][2][p289[2][1]].REACT or val396 or not (lastLat and math.abs(dot8 - lastLat) > p289[2][2][p289[2][1]].STABLE)) and magnitude24 <= p289[10][2][p289[10][1]](
        math.min(val392, p289[2][2][p289[2][1]].REACT), val401
      ) + p289[2][2][p289[2][1]].TOUCH + p289[2][2][p289[2][1]].STRETCH and (p289[3][2][p289[3][1]].autoRedirect or val394 <= val405)

      if val399 and autoRedirect and p289[3][2][p289[3][1]].autoJump
        and val392 <= val404 + p289[2][2][p289[2][1]].JUMP_LEAD and val391 >= p289[11][2][p289[11][1]] then
        if humanoid2 and humanoid2.FloorMaterial ~= Enum.Material.Air then
          local jumpPower2 = humanoid2.UseJumpPower and humanoid2.JumpPower
            or math.sqrt(2 * p289[12][2][p289[12][1]].Gravity * humanoid2.JumpHeight)

          local assemblyLinearVelocity7 = humanoidRootPart5.AssemblyLinearVelocity

          humanoidRootPart5.AssemblyLinearVelocity = Vector3.new(
            assemblyLinearVelocity7.X, jumpPower2, assemblyLinearVelocity7.Z
          )

          p289[11][2][p289[11][1]] = val391 + math.max(0.35, val392 + 0.15)
        end
      end

      if not autoRedirect or val392 > val404 then
        return
      end

      p289[2][2][p289[2][1]].steerForce = val401

      p289[2][2][p289[2][1]].dir = p289[2][2][p289[2][1]].DIVES[val398]
          and p289[2][2][p289[2][1]].DIVES[val398].sign
        or 0

      local rightVector6 = humanoidRootPart5.CFrame.RightVector
      rightVector6 = Vector3.new(rightVector6.X, 0, rightVector6.Z)

      p289[2][2][p289[2][1]].axis = rightVector6.Magnitude > 0.001 and rightVector6.Unit or nil
      p289[2][2][p289[2][1]].leap = val399

      if p289[13][2][p289[13][1]](val398) then
        p289[9][2][p289[9][1]] = val391 + p289[2][2][p289[2][1]].READY_CD
      end
    end
  end, function(p290, p291)
    return function(p292, p293)
      local val406 = p293 < 0

      if p292 <= p291[1][2][p291[1][1]].TIER_LOW then
        return val406 and "lowdiveL" or "lowdiveR", false
      end

      return val406 and "highdiveL" or "highdiveR", p292 > p291[1][2][p291[1][1]].TIER_HIGH
    end
  end, function(p294, p295)
    return function(p296, p297)
      local val407 = p295[1][2][p295[1][1]][p296]

      if not val407 then
        val407 = {}
        p295[1][2][p295[1][1]][p296] = val407
      end

      if val407[p297] == nil then
        val407[p297] = p296[p297]
      end

      return val407[p297]
    end
  end, function(p298, p299)
    return function(p300, p301, p302)
      if not p301 then
        return nil
      end

      local gk2 = p301:FindFirstChild("GK")
        or p299[1][2][p299[1][1]]:FindFirstChild("Backpack")
          and p299[1][2][p299[1][1]].Backpack:FindFirstChild("GK")

      local client2 = gk2 and gk2:FindFirstChild("Client")
      local findFirstChild3 = client2 and client2:FindFirstChild(p300)

      if not findFirstChild3 then
        return nil
      end

      if not p302 then
        local head = p301:FindFirstChild("Head")

        if head and p299[2][2][p299[2][1]].CurrentCamera.CameraSubject == head then
          return nil
        end
      end

      if p299[3][2][p299[3][1]].InFK then
        return nil
      end

      if not p299[4][2][p299[4][1]].InBox(p301:FindFirstChild("HumanoidRootPart")) then
        return nil
      end

      local element59 = p299[4][2][p299[4][1]].State(findFirstChild3)

      if element59 and (element59.cooldown or element59.animating) then
        return nil
      end

      return findFirstChild3
    end
  end, function(p303, p304)
    return function()
      local val408, val409 = p304[1][2][p304[1][1]].Body()

      if not val408 or p304[1][2][p304[1][1]].Holding(val408) then
        return
      end

      local element60 = p304[1][2][p304[1][1]].BallIn(val408, val409, "deflect", p304[2][2][p304[2][1]].autoCatch
        and p304[3][2][p304[3][1]].Catch)

      if not element60 then
        return
      end

      local val410, huge7 = nil, math.huge

      for v534, v535 in val408:GetDescendants() do
        if v535:IsA("BasePart") and v535.CanTouch and not v535.Anchored then
          local magnitude25 = (v535.Position - element60.Position).Magnitude

          if magnitude25 < huge7 then
            val410, huge7 = v535, magnitude25
          end
        end
      end

      if val410 then
        p304[4][2][p304[4][1]](val410, element60)
      end
    end
  end, function(p305, p306)
    return function(p307, p308)
      p307 = { [1] = 3, [3] = p307 }
      p307[2] = p307

      p308 = { [1] = 3, [3] = p308 }
      p308[2] = p308

      local xb = p305:Xb({ p306[12] })
      xb = { [1] = 3, [3] = xb }
      xb[2] = xb

      local val411 = { [1] = 3, [3] = val411 }
      val411[2] = val411
      val411[2][val411[1]] = p305:_c({ val411 })

      local val412 = { [1] = 3, [3] = val412 }
      val412[2] = val412

      val412[2][val412[1]] = p305:ac({
        p307, p306[17], xb, val411, p306[1], p306[10], p306[15], p306[7], p306[9], p308, p306[4], p306[5], p306[11], p306[2], p306[16], p306[13], p306[3], p306[6], })

      return (p305:Yb({ p307, p306[10], p306[15], val411, p306[18], xb, p306[14], p306[8], val412 }))
    end
  end, function(p309, p310)
    return function(p311, p312, p313)
      if not p313 then
        return p312.Position
      end

      local leftFoot, rightFoot = p311:FindFirstChild("LeftFoot"), p311:FindFirstChild("RightFoot")

      if leftFoot and rightFoot then
        return (leftFoot.Position + rightFoot.Position) * 0.5
      end

      return p312.Position - Vector3.new(0, 3.56, 0)
    end
  end, function(p314, p315)
    return function()
      local val413, val414 = math.min(p315[1][2][p315[1][1]].Low, p315[1][2][p315[1][1]].High), math.max(p315[1][2][p315[1][1]].Low, p315[1][2][p315[1][1]].High)
      local val415 = os.clock()

      if val415 >= p315[1][2][p315[1][1]].Retarget or not p315[1][2][p315[1][1]].Target then
        p315[1][2][p315[1][1]].Target, p315[1][2][p315[1][1]].Retarget = val413
          + math.random() * (val414 - val413), val415 + 3
          + math.random() * 5
      end

      local current = p315[1][2][p315[1][1]].Current or p315[1][2][p315[1][1]].Target

      current = math.clamp(current + (p315[1][2][p315[1][1]].Target - current) * 0.35
        + (math.random() - 0.5) * 4, val413, val414)

      p315[1][2][p315[1][1]].Current = current
      return math.floor(current + 0.5)
    end
  end, function(p316, p317)
    return function()
      local character12 = p317[1][2][p317[1][1]].Character
      local humanoidRootPart6 = character12 and character12:FindFirstChild("HumanoidRootPart")

      if not humanoidRootPart6 then
        return
      end

      local pending = p317[2][2][p317[2][1]].pending

      if pending then
        local networkOwner5 = pending.ball and pending.ball.Parent
          and pending.ball:FindFirstChild("NetworkOwner")

        if pending.ball and pending.ball.Parent then
          local magnitude26 = (pending.ball.Position - humanoidRootPart6.Position).Magnitude

          if magnitude26 < pending.minD then
            pending.minD = magnitude26
          end
        end

        if not networkOwner5 or os.clock() - pending.t > 2 then
          p317[2][2][p317[2][1]].pending = nil
        elseif networkOwner5.Value == p317[1][2][p317[1][1]] then
          p317[2][2][p317[2][1]].pending = nil
        end
      end

      local object = p317[3][2][p317[3][1]](p317[4][2][p317[4][1]](
        character12, humanoidRootPart6, false
      ), humanoidRootPart6.CFrame.LookVector, 10)

      if not object then
        return
      end

      local networkOwner6 = object:FindFirstChild("NetworkOwner")

      if not networkOwner6 then
        return
      end

      local value3 = networkOwner6.Value

      if value3 == p317[1][2][p317[1][1]] then
        p317[2][2][p317[2][1]].had = object
        return
      end

      local val416 = os.clock()

      if p317[2][2][p317[2][1]].had == object then
        p317[2][2][p317[2][1]].nxt, p317[2][2][p317[2][1]].recover, p317[2][2][p317[2][1]].recoverUntil = 0, object, val416
          + 1.2
      end

      p317[2][2][p317[2][1]].had = nil

      if value3
        and not (p317[2][2][p317[2][1]].recover == object
          and val416 < p317[2][2][p317[2][1]].recoverUntil) then
        return
      end

      if p317[2][2][p317[2][1]].outSoon(object) then
        return
      end

      p317[5][2][p317[5][1]](object, value3 == nil)
    end
  end, function(p318, p319)
    return function(p320)
      if p320 and p320.Parent then
        local findFirstChild4 = p320:FindFirstChild(p319[1][2][p319[1][1]].HOLDN)

        if findFirstChild4 then
          findFirstChild4:Destroy()
        end
      end

      p319[1][2][p319[1][1]].holdBall, p319[1][2][p319[1][1]].holdUntil = nil, 0
    end
  end, function(p321, p322) return function(self, p323) return (self.Share or 1) * p323 end end, function(p324, p325)
    return function()
      p325[1][2][p325[1][1]].Hide()

      if p325[2][2][p325[2][1]].top then
        p325[2][2][p325[2][1]].top.Transparency = 1
      end

      if p325[3][2][p325[3][1]].Transparency ~= 1 then
        p325[3][2][p325[3][1]].Transparency = 1
      end

      if p325[4][2][p325[4][1]].Transparency ~= 1 then
        p325[4][2][p325[4][1]].Transparency = 1
      end
    end
  end, function(p326, p327)
    return function(p328)
      local val417 = p327[1][2][p327[1][1]].u3[p328]

      if val417 then
        return val417
      end

      local val418, success11 = pcall(require, p328)

      if not (val418 and type(success11) == "table") then
        return nil
      end

      local val419 = p327[2][2][p327[2][1]](success11)

      if not val419 then
        return nil
      end

      for i24 = 1, 8 do
        local val420, success12 = pcall(debug.getupvalue, val419, i24)

        if val420 and type(success12) == "function" then
          for i25 = 1, 32 do
            local val421, success13 = pcall(debug.getupvalue, success12, i25)

            if val421 and type(success13) == "table" and success13.cooldown ~= nil and success13.animating ~= nil then
              p327[1][2][p327[1][1]].u3[p328] = success13
              return success13
            end
          end
        end
      end

      return nil
    end
  end, function(p329, p330)
    return function(p331)
      local lookVector4 = p331.CFrame.LookVector
      lookVector4 = Vector3.new(lookVector4.X, 0, lookVector4.Z)
      lookVector4 = lookVector4.Magnitude > 0.001 and lookVector4.Unit or Vector3.new(0, 0, 1)

      local zero5 = p330[1][2][p330[1][1]] and p330[2][2][p330[2][1]]
          and (p330[1][2][p330[1][1]] + p330[2][2][p330[2][1]]) * 0.5
        or Vector3.zero

      if lookVector4:Dot(Vector3.new(zero5.X - p331.Position.X, 0, zero5.Z - p331.Position.Z))
        < 0 then
        lookVector4 = -lookVector4
      end

      return lookVector4
    end
  end, function(p332, p333)
    return function()
      local character13 = p333[1][2][p333[1][1]].Character
      local humanoidRootPart7 = character13 and character13:FindFirstChild("HumanoidRootPart")

      if humanoidRootPart7 and p333[2][2][p333[2][1]].magnetCatch then
        p333[3][2][p333[3][1]].DrawBox(
          p333[4][2][p333[4][1]], character13, humanoidRootPart7, "gk"
        )
      else
        p333[4][2][p333[4][1]].Transparency = 1
      end
    end
  end, function(p334, p335)
    return function()
      local character14 = p335[1][2][p335[1][1]].Character
      local humanoidRootPart8 = character14 and character14:FindFirstChild("HumanoidRootPart")

      if humanoidRootPart8 and p335[2][2][p335[2][1]].gkDeflect then
        p335[3][2][p335[3][1]].DrawBox(
          p335[3][2][p335[3][1]].DeflectBubble, character14, humanoidRootPart8, "deflect"
        )
      else
        p335[3][2][p335[3][1]].DeflectBubble.Transparency = 1
      end
    end
  end, function(p336, p337, p338, p339)
    p336.bc[p339] = p336.a(p337, 10864) + p336.a(p338, 3001)
    return p336.bc[p339]
  end, function(p340, p341, p342, p343)
    p340.gc[p343] = p341 - p340.a(p342, 48666)
    return p340.gc[p343]
  end, function(p344, p345)
    return function()
      local character15 = p345[1][2][p345[1][1]].Character

      if not (character15 and character15:FindFirstChild("Tackle")) then
        return
      end

      local upperTorso = character15:FindFirstChild("UpperTorso")
        or character15:FindFirstChild("HumanoidRootPart")

      if not upperTorso then
        return
      end

      local val422 = os.clock()

      if val422 < p345[2][2][p345[2][1]] then
        return
      end

      if not p345[3][2][p345[3][1]](upperTorso.Position, upperTorso.AssemblyLinearVelocity) then
        return
      end

      p345[2][2][p345[2][1]] = val422 + 0.75
      p345[4][2][p345[4][1]]("chest", "Tackle")
    end
  end, function(p346, p347)
    return function(p348)
      local zero6 = Vector3.zero

      for v552, v553 in p348:GetChildren() do
        if v553:IsA("BodyVelocity") then
          if v553.Name == "ShootVelocity" then
            return Vector3.zero
          end
        elseif v553:IsA("BodyForce") then
          zero6 = zero6 + v553.Force
        end
      end

      local assemblyMass2 = p348.AssemblyMass

      local zero7 = assemblyMass2 and assemblyMass2 > 0 and zero6 / assemblyMass2
        or Vector3.zero

      return Vector3.new(0, -p347[1][2][p347[1][1]](p348), 0) + zero7
    end
  end, function(p349, p350)
    return function()
      if not p350[1][2][p350[1][1]].antiShield then
        if p350[2][2][p350[2][1]].realShield then
          p350[3][2][p350[3][1]].WatchBallTouchShielded = p350[2][2][p350[2][1]].realShield
          p350[2][2][p350[2][1]].realShield = nil
        end

        if p350[2][2][p350[2][1]].realSwept then
          p350[3][2][p350[3][1]].WatchBallTouchSwept = p350[2][2][p350[2][1]].realSwept
          p350[2][2][p350[2][1]].realSwept = nil
        end

        p350[2][2][p350[2][1]].shieldTouch(true)
        return
      end

      if type(p350[3][2][p350[3][1]].WatchBallTouch) == "function" then
        if type(p350[3][2][p350[3][1]].WatchBallTouchShielded) == "function"
          and p350[3][2][p350[3][1]].WatchBallTouchShielded
            ~= p350[3][2][p350[3][1]].WatchBallTouch then
          p350[2][2][p350[2][1]].realShield = p350[3][2][p350[3][1]].WatchBallTouchShielded
          p350[3][2][p350[3][1]].WatchBallTouchShielded = p350[3][2][p350[3][1]].WatchBallTouch
        end

        if type(p350[3][2][p350[3][1]].WatchBallTouchSwept) == "function"
          and p350[3][2][p350[3][1]].WatchBallTouchSwept
            ~= p350[3][2][p350[3][1]].WatchBallTouch then
          p350[2][2][p350[2][1]].realSwept = p350[3][2][p350[3][1]].WatchBallTouchSwept
          p350[3][2][p350[3][1]].WatchBallTouchSwept = p350[3][2][p350[3][1]].WatchBallTouch
        end
      end

      p350[2][2][p350[2][1]].shieldTouch(false)
    end
  end, function(p351, p352)
    return function(p353)
      local dribKeys = p352[1][2][p352[1][1]].dribKeys

      if not dribKeys then
        dribKeys = {}

        local assets = replicatedStorage:FindFirstChild("Assets")
        assets = assets and assets:FindFirstChild("Player")
        assets = assets and assets:FindFirstChild("Keybinds")
        assets = assets and assets:FindFirstChild("Dribble")
        assets = assets and assets:FindFirstChild("KBM")

        for v554, v555 in assets and assets:GetChildren() or {} do
          local key = v555:FindFirstChild("Key")

          if key and type(key.Value) == "string" then
            dribKeys[v555.Name] = key.Value
          end
        end

        p352[1][2][p352[1][1]].dribKeys = dribKeys
      end

      local val423, success14 = pcall(function() return Enum.KeyCode[dribKeys[p353] or ""] end)

      if not (val423 and success14) then
        return
      end

      pcall(function()
        virtualInputManager:SendKeyEvent(true, success14, false, game)

        task.delay(0.04, function()
          pcall(virtualInputManager.SendKeyEvent, virtualInputManager, false, success14, false, game)
        end)
      end)
    end
  end, function(p354, p355)
    return function(p356)
      if not p355[1][2][p355[1][1]] then
        return false
      end

      if p355[2][2][p355[2][1]]:GetFocusedTextBox() then
        return false
      end

      local element61 = p355[3][2][p355[3][1]].Keybinds()

      if not element61 then
        return false
      end

      local val424, val425 = p355[4][2][p355[4][1]](element61.IsOpen, element61)

      if not val424 or val425 then
        return false
      end

      local head2 = p356:FindFirstChild("Head")
      local bar = head2 and head2:FindFirstChild("bar")
      local power = bar and bar:FindFirstChild("Power")
      return not (power and power:IsA("GuiObject") and power.Visible)
    end
  end, function(p357, p358)
    return function(p359)
      local assemblyMass3 = p359.AssemblyMass

      if not (assemblyMass3 > 0) then
        return workspace.Gravity
      end

      local total2 = 0

      for v561, v562 in p359:GetChildren() do
        if v562:IsA("VectorForce") and v562.Enabled
          and v562.RelativeTo == Enum.ActuatorRelativeTo.World then
          total2 = total2 + v562.Force.Y
        end
      end

      return workspace.Gravity - total2 / assemblyMass3
    end
  end, function(p360, p361)
    return function()
      p361[1][2][p361[1][1]]()
      p361[2][2][p361[2][1]]()

      if p361[3][2][p361[3][1]] == 0 or os.clock() < p361[3][2][p361[3][1]] then
        return
      end

      p361[3][2][p361[3][1]] = 0

      if p361[4][2][p361[4][1]].Diving or p361[4][2][p361[4][1]].Catching then
        return
      end

      if type(p361[4][2][p361[4][1]].Backpack) == "function" then
        p361[4][2][p361[4][1]].Backpack(false)
      end

      local character16 = p361[5][2][p361[5][1]].Character
      local humanoid3 = character16 and character16:FindFirstChildOfClass("Humanoid")

      if not (humanoid3 and humanoid3.Health > 0 and humanoid3.WalkSpeed == 0) then
        return
      end

      pcall(function()
        humanoid3.WalkSpeed = 16
        humanoid3.AutoRotate = true
        humanoid3:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)

        local humanoidRootPart9 = character16:FindFirstChild("HumanoidRootPart")

        local bodyVelocity2 = humanoidRootPart9
          and humanoidRootPart9:FindFirstChildOfClass("BodyVelocity")

        if bodyVelocity2 then
          bodyVelocity2:Destroy()
        end

        local collision = character16:FindFirstChild("Collision")

        if collision then
          collision.CanCollide = true
        end

        p361[6][2][p361[6][1]].CurrentCamera.CameraSubject = humanoid3
        guiService.TouchControlsEnabled = true
      end)
    end
  end, function(p362, p363)
    return function(p364)
      return p363[1][2][p363[1][1]](p364.X) and p363[1][2][p363[1][1]](p364.Y)
        and p363[1][2][p363[1][1]](p364.Z)
    end
  end, function(p365, p366)
    return function(p367)
      local val426, val427, val428, val429

      for i26 = 1, #p366[1][2][p366[1][1]] do
        local parent7 = p366[1][2][p366[1][1]][i26]

        if parent7 and parent7.Parent then
          local magnitude27 = (parent7.Position - p367.Position).Magnitude

          if not val429 or magnitude27 < val429 then
            val428, val429 = parent7, magnitude27
          end

          local networkOwner7 = parent7:FindFirstChild("NetworkOwner")

          if networkOwner7 and networkOwner7.Value and (not val427 or magnitude27 < val427) then
            val426, val427 = parent7, magnitude27
          end
        end
      end

      return val426 or val428
    end
  end, function(p368, p369)
    return function(p370, p371)
      local val430, val431, count6 = p370.T, p370.P, p370.Count

      if p371 <= 0 then
        return val431[1]
      end

      local val432 = p371 / p370.Step // 1 + 1

      if val432 >= count6 then
        return val431[count6], true
      end

      local val433, val434 = val430[val432], val430[val432 + 1]
      local val435 = val434 > val433 and (p371 - val433) / (val434 - val433) or 0

      if val435 > 1 then
        val435 = 1
      end

      return val431[val432]:Lerp(val431[val432 + 1], val435)
    end
  end, function(p373, p374)
    return function()
      local val436, val437, val438 = p374[1][2][p374[1][1]].Body()

      if not val436 then
        return
      end

      if not p374[2][2][p374[2][1]].autoPos then
        return
      end

      if not p374[1][2][p374[1][1]].Armed(val436, val437) or p374[1][2][p374[1][1]].Holding(val436)
        or p374[1][2][p374[1][1]].PlayerSteering() then
        return
      end

      if p374[3][2][p374[3][1]].Diving or p374[3][2][p374[3][1]].Catching then
        return
      end

      local goal4 = p374[4][2][p374[4][1]].Goal

      if not goal4 then
        return
      end

      local normal2, right, origin2 = goal4.Normal, goal4.Right, goal4.Origin
      local position12 = val437.Position
      local dot12 = (position12 - origin2):Dot(normal2)
      local dot13 = (position12 - origin2):Dot(right)

      local diveReach = p374[5][2][p374[5][1]].DiveReach and p374[5][2][p374[5][1]].DiveReach()
        or 14

      local threat2 = p374[4][2][p374[4][1]].Threat
      local dot14, val439

      if threat2 and os.clock() - threat2.At < 0.25 then
        local path = threat2.Path
        dot14 = threat2.Cross and (threat2.Cross.Position - origin2):Dot(right)

        for i27 = 1, path.Count do
          if (path.P[i27] - origin2):Dot(normal2) <= dot12 then
            dot14 = (path.P[i27] - origin2):Dot(right)
            break
          end
        end

        val439 = val438.WalkSpeed * p374[6][2][p374[6][1]].Frame
      elseif p374[4][2][p374[4][1]].Idle then
        local val440 = math.max(goal4.HalfWidth - diveReach, 0)

        dot14 = math.clamp(
          (p374[4][2][p374[4][1]].Idle.Position - origin2):Dot(right), -val440, val440
        )

        val439 = val437.Size.X * 0.5
      end

      if not dot14 then
        return
      end

      dot14 = math.clamp(
        dot14, -goal4.HalfWidth + val437.Size.X * 0.5, goal4.HalfWidth - val437.Size.X * 0.5
      )

      if math.abs(dot14 - dot13) <= val439 then
        return
      end

      val438:Move(right * (dot14 > dot13 and 1 or -1), false)
    end
  end, function(p375, p376)
    return function(p377, p378)
      local val441 = 134
      local val442, val443, val444, val445, val446

      repeat
        if val441 >= 134 then
          if val441 > 139 then
            val441, val443 = 1, val443()
            p377 = val443
          elseif val441 > 134 then
            val445[2][val445[1]] = val445[2][val445[1]](val444[2][val444[1]], val443)
            return val445[2][val445[1]]
          else
            val442 = p377
            val441, val446 = 213, val442

            val446 = { [1] = 3, [3] = val446 }
            val446[2] = val446

            val445 = 1
            val445 = { [1] = 3, [3] = val445 }
            val445[2] = val445

            val444 = nil
            val444 = { [1] = 3, [3] = val444 }
            val444[2] = val444

            val444[2][val444[1]] = p375:Vb({
              val445, val444, val446, p376[21], p376[17], p376[1], p376[10], p376[15], p376[7], p376[9], p376[22], })

            val443 = val444[2][val444[1]]
          end
        elseif val441 > 1 then
          val442 = val442()
          val441, val442 = 139, { [1] = 3, [3] = val442 }
          val442[2] = val442

          val446[2][val446[1]] = { [1] = 3, [3] = val446[2][val446[1]] }
          val446[2][val446[1]][2] = val446[2][val446[1]]

          val446[2][val446[1]] = p375:Wb({
            p376[11], p376[2], p376[16], p376[13], p376[3], p376[22], p376[6], p376[18], val446, p376[14], p376[8], p376[20], p376[19], p376[12], p376[21], val442, p376[10], p376[4], })

          val445[2][val445[1]], val444[2][val444[1]], val443 = val446[2][val446[1]], p377, p378
        else
          val441, val442 = 119, p376[5][2][p376[5][1]]
        end
      until false
    end
  end, zb = function(p379, p380, p381, ...)
    local val447 = 142
    local val448, val449, val450, val451, val452, val453

    while true do
      if val447 < 142 then
        if val447 >= 94 then
          if val447 < 124 then
            if val447 <= 94 then
              val447 = val450 > 0 and val447 + -24 or 245
            else
              val447 = val450 ~= val450 and 289 - val447 or 20928 / val447
            end
          elseif val447 > 124 then
            val447 = val448 > val452 and 193 or 146
          else
            val447 = val450 <= 0 and 124 / val447 or 218
          end
        elseif val447 > 6 then
          val447 = val448 > val452 and val447 + 123 or 245
        elseif val447 > 1 then
          val448 = p379.c(val448(val452, p379.d(val450)))
          return p379.d(val448)
        else
          val447 = val448 < val452 and 193 / val447 or val447 + 217
        end
      elseif val447 <= 193 then
        if val447 >= 189 then
          if val447 > 189 then
            val447, val452, val450, val448 = 1158 / val447, val453, p379.c(...), val453[p381]
          else
            val447 = val448 < val452 and 36477 / val447 or 96
          end
        elseif val447 <= 142 then
          val449, val451, val453, val448 = #p380, 1, p379, 0
          val450, val452 = val451, val449 - val451
          val447 = val452 ~= val452 and 193 or 94
        else
          val447 = val450 <= 0 and 335 - val447 or 96
        end
      elseif val447 >= 218 then
        if val447 > 218 then
          val447 = val450 ~= val450 and 245 / val447 or 30380 / val447
        else
          local val454 = 100169

          local val455
          val455, val454 = val454 * val448, 32801

          local val456
          val447, val456 = 194, val455 + val454

          local val457
          val457, val456 = val456 % val449, 1

          local val458 = val457 + val456
          val457, val451 = val448 + val456, p380[val458]
          val458 = val453[val457]
          val453[val451] = val458
        end
      else
        val448 = val448 + val450
        val447 = val450 > 0 and 129 or 146
      end
    end
  end, function(p382, p383)
    return function(p384)
      local val459 = 19
      local val460, val461, val462, val463, val464, val465, val466, val467, val468, val469, val470, val471, val472

      while true do
        if val459 < 123 then
          if val459 >= 23 then
            if val459 <= 66 then
              if val459 < 43 then
                val466 = val466 + val470

                val459 = (val470 > 0 and val466 > val472 or val470 <= 0 and val466 < val472 or val470 ~= val470)
                    and 5474 / val459
                  or 11
              elseif val459 > 43 then
                val467, val466 = p383[5][2][p383[5][1]], val462
                val467 = val467(val466)

                val466 = p383[4][2][p383[4][1]]
                val466[p384] = val467

                return val467
              else
                val468, val471 = 1, #val462
                val463 = val471 + val468
                val462[val463] = val464
                val463, val468, val471 = p383[2][2][p383[2][1]], -2048, val460 .. val464
                val459, val463 = 23, val463(val471, val468)
                val460 = val463
              end
            else
              return val465
            end
          elseif val459 < 11 then
            val472, val466, val467 = val461, p384, p383[3][2][p383[3][1]]
            val467 = val467(val466, val472)
            val466 = 1
            val472, val461, val470 = 8, val461 + val466, val466

            val459 = (val472 ~= val472 or val470 > 0 and val466 > val472
                  or (val470 <= 0 or val470 ~= val470) and val466 < val472)
                and 238
              or 11
          elseif val459 <= 11 then
            val464, val463, val471, val468 = nil, p383[1][2][p383[1][1]], val467, 1
            val463 = val463(val471, val468)
            val471 = 0
            val459 = val463 ~= val471 and 208 or 248
          else
            val461 = p383[4][2][p383[4][1]]
            val465 = val461[p384]
            val459 = val465 and 110 or 148
          end
        elseif val459 < 208 then
          if val459 <= 148 then
            if val459 > 123 then
              val459, val460, val461 = 238, {}, 1
              val460, val462 = "", val460
            else
              val469, val471, val468, val463 = val461, p384, val461, p383[2][2][p383[2][1]]
              val459, val463 = val459 + 120, val463(val471, val468, val469)
              val463, val464 = 1, val463
              val461 = val461 + val463
            end
          else
            val469, val468, val463, val471 = val461, p384, p383[6][2][p383[6][1]], ">I2"
            val463 = val463(val471, val468, val469)
            val471 = 2
            local val473, val474
            val474, val468, val473, val459, val461, val469 = 5, #val460, val463, 445 - val459, val461 + val471, p383[7][2][p383[7][1]]
            val469 = val469(val473, val474)
            val474, val469, val473, val471 = 31, p383[1][2][p383[1][1]], val463, val468 - val469
            val469 = val469(val473, val474)

            val473 = 3
            val473, val474, val468, val469 = val460, val471, val469 + val473, p383[2][2][p383[2][1]]

            local val475 = val471 + val468
            val475 = val475 - 1

            val469 = val469(val473, val474, val475)
            val464 = val469
          end
        elseif val459 > 243 then
          val471 = 1
          val471, val463 = #p384, val461 + val471
          val459 = val463 <= val471 and val459 + -46 or 243
        elseif val459 > 238 then
          val463, val471, val468 = p383[7][2][p383[7][1]], val467, 1
          val463 = val463(val471, val468)

          val467 = val463
          val459 = val464 and val459 + -200 or 23
        elseif val459 <= 208 then
          val463 = #p384
          val459 = val461 <= val463 and 123 or val459 + 35
        else
          val467 = #p384
          val459 = val461 <= val467 and 5 or 66
        end
      end
    end
  end, function(p385, p386)
    return function()
      local sprintController = p386[1][2][p386[1][1]].SprintController

      if type(sprintController) ~= "table" then
        return
      end

      if not p386[2][2][p386[2][1]].stamState then
        local val476, success15 = pcall(debug.getupvalues, sprintController.AddStamina)

        if val476 and type(success15) == "table" then
          for v614, v615 in success15 do
            if type(v615) == "table" and rawget(v615, "Stamina") ~= nil then
              p386[2][2][p386[2][1]].stamState = v615
              break
            end
          end
        end
      end

      if not p386[2][2][p386[2][1]].infStam then
        return
      end

      if p386[2][2][p386[2][1]].stamState then
        p386[2][2][p386[2][1]].stamState.Stamina = 100
        p386[2][2][p386[2][1]].stamState.CanSprint = true
      elseif type(sprintController.SetStamina) == "function" then
        pcall(sprintController.SetStamina, 100)
      end

      local character17 = p386[3][2][p386[3][1]].Character

      if character17 and character17:GetAttribute("CantSprint") == true then
        pcall(character17.SetAttribute, character17, "CantSprint", false)
      end
    end
  end, function(p387, p388, ...)
    local val477 = { ... }

    for i28 = 1, select("#", ...) do
      p387[p388 + i28 - 1] = val477[i28]
    end
  end, function(p389, p390)
    return function(p391, p392)
      local val478 = false

      for v618, v619 in p390[1][2][p390[1][1]] do
        local findFirstChild5 = (not (p390[2][2][p390[2][1]].feetBox or p390[2][2][p390[2][1]].headBox)
              or v619 == "feet" and p390[2][2][p390[2][1]].feetBox
              or v619 == "head" and p390[2][2][p390[2][1]].headBox)
            and p391:FindFirstChild(v618)
          or nil

        if findFirstChild5 and findFirstChild5:FindFirstChildOfClass("TouchTransmitter") then
          val478 = true

          if not p390[3][2][p390[3][1]] then
            local val479 = p390[4][2][p390[4][1]](p391, p392)

            if val479 and p390[5][2][p390[5][1]](val479)
              and p390[6][2][p390[6][1]](findFirstChild5, val479) then
              p390[3][2][p390[3][1]] = true
            end
          end
        end
      end

      if not val478 then
        p390[3][2][p390[3][1]] = false
      end
    end
  end, function(p393, p394)
    return function(p395)
      local state2 = p395 and p395.State

      if not (state2 and state2.attemptingCatch and type(state2.preloadedAnims) == "table") then
        return false
      end

      for v621, v622 in state2.preloadedAnims do
        if v621 ~= "catchloop" and typeof(v622) == "Instance" and v622.IsPlaying then
          return true
        end
      end

      return false
    end
  end, function(p396, p397)
    return function(p398)
      local longKeys = p397[1][2][p397[1][1]].longKeys

      if not longKeys then
        longKeys = {}

        local assets2 = replicatedStorage:FindFirstChild("Assets")
        assets2 = assets2 and assets2:FindFirstChild("Player")
        assets2 = assets2 and assets2:FindFirstChild("Keybinds")
        assets2 = assets2 and assets2:FindFirstChild("Long")
        assets2 = assets2 and assets2:FindFirstChild("KBM")

        for v623, v624 in assets2 and assets2:GetChildren() or {} do
          local key2 = v624:FindFirstChild("Key")

          if key2 and type(key2.Value) == "string" then
            longKeys[v624.Name] = key2.Value
          end
        end

        p397[1][2][p397[1][1]].longKeys = longKeys
      end

      for v625, v626 in longKeys do
        local val480 = p398[v625]

        if val480 then
          local val481, success16 = pcall(function() return Enum.KeyCode[v626] end)

          if val481 and success16 then
            local val482, success17 = pcall(
              p397[2][2][p397[2][1]].IsKeyDown, p397[2][2][p397[2][1]], success16
            )

            if val482 and success17 then
              return val480
            end
          end
        end
      end

      return p398.LongPass
    end
  end, function(p399, p400)
    return function(p401)
      local character18 = p400[1][2][p400[1][1]].Character
      local humanoidRootPart10 = character18 and character18:FindFirstChild("HumanoidRootPart")

      if not p400[2][2][p400[2][1]]() and os.clock() - p400[3][2][p400[3][1]] > 0.5 then
        p400[3][2][p400[3][1]] = os.clock()
        pcall(p400[4][2][p400[4][1]])
      end

      local val483 = p400[5][2][p400[5][1]] and rawget(p400[5][2][p400[5][1]], "state")

      if not (humanoidRootPart10 and val483) then
        p400[6][2][p400[6][1]]()
        p400[7][2][p400[7][1]]()
        p400[8][2][p400[8][1]] = false

        return
      end

      local tool2 = character18 and character18:FindFirstChildOfClass("Tool")

      if not (tool2 and p400[9][2][p400[9][1]][tool2.Name]) then
        p400[6][2][p400[6][1]]()
        p400[7][2][p400[7][1]]()
        p400[8][2][p400[8][1]] = false

        return
      end

      local chargeProgress = val483.chargeProgress and val483.chargeProgress > 0
        or val483.phase and val483.phase ~= "idle"

      local val484 = (val483.chargeProgress or 0) > 0

      if not chargeProgress and p400[10][2][p400[10][1]].aimOnlyCharging then
        p400[6][2][p400[6][1]]()
        p400[7][2][p400[7][1]]()
        p400[8][2][p400[8][1]] = false

        return
      end

      if not chargeProgress then
        if p400[8][2][p400[8][1]] then
          p400[11][2][p400[11][1]] = os.clock() + 1
        end

        p400[7][2][p400[7][1]]()
        p400[8][2][p400[8][1]] = false
      elseif not p400[8][2][p400[8][1]] then
        p400[8][2][p400[8][1]] = true
        p400[12][2][p400[12][1]] = 0
        p400[7][2][p400[7][1]]()
      end

      local val485 = p400[13][2][p400[13][1]](
        humanoidRootPart10.Position, humanoidRootPart10.CFrame.LookVector, p400[10][2][p400[10][1]].aimRange
      )

      local val486 = chargeProgress and rawget(val483, "activeMove")

      local val487 = type(val486) == "table" and rawget(val486, "timing") and val486
        or p400[14][2][p400[14][1]]()

      if not (val485 and val487) then
        p400[6][2][p400[6][1]]()
        return
      end

      local element62 = rawget(val487, "modifiers") or {}
      local element63 = rawget(val487, "properties") or {}
      local element64 = rawget(val487, "timing") or {}
      local val488, val489, val490 = 1, 1, 1
      local maxChargeValue = element64.maxChargeValue or 0

      local function helper5(val491)
        return (val491 * maxChargeValue + (element63.basePower or 0) * (element63.chargeRate or 1))
          * (element62.powerMultiplier or 1)
      end

      local function helper6(val492)
        return (val492 * maxChargeValue / 5 + (element63.baseAngle or 0)) * (element62.angleMultiplier or 1)
      end

      local calculatedPower = chargeProgress and val483.calculatedPower or helper5(1)
      local calculatedAngle = chargeProgress and (val483.calculatedAngle or 0) or helper6(1)

      if type(calculatedPower) ~= "number" or calculatedPower <= 0 then
        p400[6][2][p400[6][1]]()
        return
      end

      if type(rawget(p400[5][2][p400[5][1]], "applyWeakFoot")) == "function" then
        local val493, val494, val495, success18 = pcall(
          p400[5][2][p400[5][1]].applyWeakFoot, p400[5][2][p400[5][1]], val487, val483.movementState, 100, 100
        )

        if val493 and type(val494) == "number" and type(val495) == "number" and val494 > 0 then
          val488, val490 = val494 / 100, val495 / 100
          local curveIntensity = element62.curveIntensity

          if type(success18) == "table" and type(success18.curveIntensity) == "number"
            and type(curveIntensity) == "number" and curveIntensity ~= 0 then
            val489 = success18.curveIntensity / curveIntensity
          end
        end
      end

      local cframe3 = humanoidRootPart10.CFrame
      local movementState = val483.movementState

      if type(rawget(p400[5][2][p400[5][1]], "getMovementState")) == "function" then
        local val496, success19 = pcall(
          p400[5][2][p400[5][1]].getMovementState, p400[5][2][p400[5][1]]
        )

        if val496 and type(success19) == "string" then
          movementState = success19
        end
      end

      local findResult = val483.isLeftAnim == true

      if type(rawget(p400[5][2][p400[5][1]], "getLegAnimation")) == "function" then
        local val497, success20 = pcall(
          p400[5][2][p400[5][1]].getLegAnimation, p400[5][2][p400[5][1]], val487, movementState
        )

        if val497 and success20 then
          local name
          pcall(function() name = success20.Animation and success20.Animation.Name end)

          if type(name) == "string" then
            findResult = string.find(name, "_Left") ~= nil
          end
        end
      end

      local curveIntensity2 = element62.curveIntensity or 0

      if curveIntensity2 ~= 0 and findResult then
        curveIntensity2 = -curveIntensity2
      end

      if rawget(val487, "useRealisticCurve")
        and type(rawget(p400[5][2][p400[5][1]], "calculateRealisticCurve")) == "function" then
        local val498, success21 = pcall(
          p400[5][2][p400[5][1]].calculateRealisticCurve, p400[5][2][p400[5][1]], val485
        )

        if val498 and type(success21) == "number" then
          curveIntensity2 = success21
        end
      end

      curveIntensity2 = curveIntensity2 * val489
      local val499 = 2.932
      local val500, success22 = pcall(val485.GetMass, val485)

      if val500 and type(success22) == "number" and success22 > 0 then
        val499 = success22
      end

      local vector22 = Vector3.new(0, -p400[15][2][p400[15][1]](val485), 0)
      local shootDuration = element64.shootDuration or 0.1
      local val501 = math.max(element64.curveDuration or 1, shootDuration)
      local val502 = rawget(val487, "Knuckle")
      local val503 = rawget(val487, "direction") == "left"
      local val504 = rawget(val487, "low")
      local val505, val506

      for i29 = 1, #p400[16][2][p400[16][1]] do
        local element65 = p400[16][2][p400[16][1]][i29]
        local element66 = element65.Position - val485.Position
        local magnitude28 = element66.Magnitude

        if magnitude28 > 1 then
          local dot15 = cframe3.LookVector:Dot(element66 / magnitude28)

          if not val506 or dot15 > val506 then
            val505, val506 = element65, dot15
          end
        end
      end

      if val506 and val506 <= 0 then
        val505 = nil
      end

      local val507 = {
        p400[17][2][p400[17][1]], p400[18][2][p400[18][1]], character18, p400[19][2][p400[19][1]], }

      for i30 = 1, #p400[20][2][p400[20][1]] do
        val507[#val507 + 1] = p400[20][2][p400[20][1]][i30]
      end

      p400[21][2][p400[21][1]].FilterDescendantsInstances = val507
      local val508 = val485.Size.X * 0.5

      local spherecast4 = p400[22][2][p400[22][1]]:Spherecast(
        val485.Position, val508, Vector3.new(0, -300, 0), p400[21][2][p400[21][1]]
      )

      local val509 = spherecast4 and val485.Position.Y - spherecast4.Distance or -math.huge

      if #p400[16][2][p400[16][1]] == 0 or not p400[16][2][p400[16][1]][1].Parent then
        p400[23][2][p400[23][1]]()
        p400[24][2][p400[24][1]]()
      end

      local function helper7(val513, val510, val511, val512, val514)
        local element67 = val512 or cframe3
        local val515 = val513 * val488
        local val516 = val504 and 10 or val510 * val490
        local val517

        if val503 then
          val517 = element67.RightVector * ((findResult and -1 or 1) * val515) + element67.UpVector * val516
        else
          val517 = element67.LookVector * val515 + element67.UpVector * val516
        end

        local zero8 = val502 and Vector3.zero
          or element67.RightVector * (val515 * curveIntensity2 / val499)

        local val518 = val485.Position + val517 * shootDuration
        local val519 = val501 - shootDuration
        local val520 = vector22 + zero8
        local val521 = val518 + val517 * val519 + val520 * (0.5 * val519 * val519)
        local val522 = val517 + val520 * val519

        local function helper8(val523)
          if val523 <= shootDuration then
            return val485.Position + val517 * val523
          end

          if val523 <= val501 then
            local val524 = val523 - shootDuration
            return val518 + val517 * val524 + val520 * (0.5 * val524 * val524)
          end

          local val525 = val523 - val501
          return val521 + val522 * val525 + vector22 * (0.5 * val525 * val525)
        end

        local val526 = val514 and 0.1 or 0.05
        local maxt2, val527 = p400[25][2][p400[25][1]].MAXT, val526

        while val527 <= p400[25][2][p400[25][1]].MAXT do
          if helper8(val527).Y <= val509 then
            local val528, val529 = val527 - val526, val527

            for i31 = 1, 8 do
              local val530 = (val528 + val529) * 0.5

              if helper8(val530).Y <= val509 then
                val529 = val530
              else
                val528 = val530
              end
            end

            maxt2 = val529
            break
          end

          val527 = val527 + val526
        end

        local val531 = p400[26][2][p400[26][1]]
        local position13 = val485.Position
        val531[1] = position13
        local val532, y, val533 = position13.X, position13.Y, position13.Z
        local val534, val535, val536 = val532, y, val533

        for i32 = 1, val511 do
          local element68 = helper8(maxt2 * (i32 / val511))
          val531[i32 + 1] = element68

          if element68.X < val532 then
            val532 = element68.X
          elseif element68.X > val534 then
            val534 = element68.X
          end

          if element68.Y < y then
            y = element68.Y
          elseif element68.Y > val535 then
            val535 = element68.Y
          end

          if element68.Z < val533 then
            val533 = element68.Z
          elseif element68.Z > val536 then
            val536 = element68.Z
          end
        end

        local val537

        if val505 then
          local cframe4 = val505.CFrame
          local pointToObjectSpace6 = cframe4:PointToObjectSpace(position13)

          for i33 = 1, val511 do
            local pointToObjectSpace7 = cframe4:PointToObjectSpace(val531[i33 + 1])

            if pointToObjectSpace7.Z <= 0 ~= (pointToObjectSpace6.Z <= 0) then
              local val538 = pointToObjectSpace6.Z - pointToObjectSpace7.Z
              local val539 = val538 ~= 0 and pointToObjectSpace6.Z / val538 or 0

              val537 = pointToObjectSpace6.Y
                + (pointToObjectSpace7.Y - pointToObjectSpace6.Y) * math.clamp(val539, 0, 1)

              break
            end

            pointToObjectSpace6 = pointToObjectSpace7
          end
        end

        if val514
          and p400[27][2][p400[27][1]]
          and not (val532 - val508 <= p400[28][2][p400[28][1]].X
            and val534 + val508 >= p400[27][2][p400[27][1]].X
            and y - val508 <= p400[28][2][p400[28][1]].Y
            and val535 + val508 >= p400[27][2][p400[27][1]].Y
            and val533 - val508 <= p400[28][2][p400[28][1]].Z
            and val536 + val508 >= p400[27][2][p400[27][1]].Z) then
          return nil, false, val531[val511 + 1], val537
        end

        local val540 = not val514 and { position13 } or nil
        local element69, val541, val542 = position13, false, position13

        for i34 = 1, val511 do
          local val543 = val531[i34 + 1]
          local element70 = val543 - element69
          local magnitude29 = element70.Magnitude

          if magnitude29 > 0.001 then
            local val544 = false

            if p400[27][2][p400[27][1]] then
              local element71 = element69 + element70
              local val545, val546 = math.min(element69.X, element71.X) - val508, math.max(element69.X, element71.X) + val508
              local val547, val548 = math.min(element69.Y, element71.Y) - val508, math.max(element69.Y, element71.Y) + val508
              local val549, val550 = math.min(element69.Z, element71.Z) - val508, math.max(element69.Z, element71.Z) + val508

              val544 = val545 <= p400[28][2][p400[28][1]].X and val546 >= p400[27][2][p400[27][1]].X
                and val547 <= p400[28][2][p400[28][1]].Y and val548 >= p400[27][2][p400[27][1]].Y
                and val549 <= p400[28][2][p400[28][1]].Z and val550 >= p400[27][2][p400[27][1]].Z
            end

            local spherecast5 = val544 and #p400[16][2][p400[16][1]] > 0 and p400[22][2][p400[22][1]]:Spherecast(
              element69, val508, element70, p400[29][2][p400[29][1]]
            ) or nil

            local spherecast6 = p400[22][2][p400[22][1]]:Spherecast(
              element69, val508, element70, p400[21][2][p400[21][1]]
            )

            local distance = spherecast5 and spherecast5.Distance or math.huge
            local distance2 = spherecast6 and spherecast6.Distance or math.huge

            if distance <= distance2 and spherecast5 then
              val542 = element69 + element70 * (distance / magnitude29)
              val541 = true

              if not val514 then
                val540[#val540 + 1] = val542
              end

              break
            elseif spherecast6 then
              val542 = element69 + element70 * (distance2 / magnitude29)

              if not val514 then
                val540[#val540 + 1] = val542
              end

              break
            end
          end

          val542 = val543

          if not val514 then
            val540[#val540 + 1] = val543
          end

          element69 = val543
        end

        return val540, val541, val542, val537
      end

      local segs = p400[10][2][p400[10][1]].aimOn and p400[25][2][p400[25][1]].SEGS or 12

      local val551, val552, val553 = helper7(
        calculatedPower, calculatedAngle, segs, nil, not p400[10][2][p400[10][1]].aimOn
      )

      local val554 = val552 and p400[30][2][p400[30][1]](val553) or nil

      if p400[10][2][p400[10][1]].noOvershoot then
        local val555 = os.clock()

        if val555 - p400[12][2][p400[12][1]] > (chargeProgress and 0.05 or 0.25) then
          p400[12][2][p400[12][1]] = val555
          local aimK = p400[10][2][p400[10][1]].aimK or 1
          local val556 = helper6(val483.chargeProgress or 1) / aimK
          local val557 = val505 and val505.Size.Y * 0.5 - p400[10][2][p400[10][1]].barSafe or nil

          local function helper9(val558)
            local v710, v711, v712, val559 = helper7(calculatedPower, val556 * val558, 12, nil, true)
            return val559
          end

          local val560, val561

          if val557 then
            for i35 = 0, 10 do
              local val562 = 1 - i35 * 0.09

              if val562 < 0.12 then
                break
              end

              local val563 = helper9(val562)

              if not val563 then
                break
              end

              if val563 <= val557 then
                val560 = val562
                break
              end

              val561 = val562
            end

            if val560 and val561 then
              local val564, val565 = val560, val561

              for i36 = 1, 5 do
                local val566 = (val564 + val565) * 0.5
                local val567 = helper9(val566)

                if val567 and val567 <= val557 then
                  val564 = val566
                else
                  val565 = val566
                end
              end

              val560 = val564
            end
          end

          if val560 then
            local val568 = math.clamp(val560, 0.12, 1)
            local val569 = val568 < aimK and val568 or aimK + math.clamp(val568 - aimK, -0.12, 0.12)

            if math.abs(val569 - aimK) > 0.004 then
              p400[10][2][p400[10][1]].aimK = val569
              p400[31][2][p400[31][1]]()
            end
          elseif p400[10][2][p400[10][1]].aimK then
            local val570 = math.min(1, aimK + 0.12)

            if val570 >= 0.999 then
              p400[10][2][p400[10][1]].aimK = nil
            else
              p400[10][2][p400[10][1]].aimK = val570
            end

            p400[31][2][p400[31][1]]()
          end
        end

        val551, val552, val553 = helper7(
          calculatedPower, calculatedAngle, segs, nil, not p400[10][2][p400[10][1]].aimOn
        )

        val554 = val552 and p400[30][2][p400[30][1]](val553) or nil
      elseif p400[10][2][p400[10][1]].aimK then
        p400[7][2][p400[7][1]]()
      end

      if p400[10][2][p400[10][1]].noOvershoot and val484 then
        local element72 = val505

        if element72 then
          if not p400[32][2][p400[32][1]].top then
            p400[32][2][p400[32][1]].top = p400[33][2][p400[33][1]]("Part", p400[18][2][p400[18][1]], {
              Anchored = true, CanCollide = false, CanQuery = false, CanTouch = false, Massless = true, CastShadow = false, Name = "FUTCeiling", Material = Enum.Material.Neon, Color = Color3.fromRGB(255, 210, 70), Size = Vector3.new(0.25, 0.25, 1), Transparency = 1, })
          end

          local cframe5 = element72.CFrame
          local val571, val572 = element72.Size.X * 0.5, element72.Size.Y * 0.5
          local val573 = val572 - p400[10][2][p400[10][1]].barSafe
          local val574 = val571 * 2.5
          local pointToWorldSpace = cframe5:PointToWorldSpace(Vector3.new(-val571 - val574, val573, 0))
          local pointToWorldSpace2 = cframe5:PointToWorldSpace(Vector3.new(val571 + val574, val573, 0))

          p400[32][2][p400[32][1]].top.Size = Vector3.new(
            0.25, 0.25, (pointToWorldSpace2 - pointToWorldSpace).Magnitude
          )

          p400[32][2][p400[32][1]].top.CFrame = CFrame.lookAt((pointToWorldSpace
              + pointToWorldSpace2)
            * 0.5, pointToWorldSpace2)

          p400[32][2][p400[32][1]].top.Transparency = 0.2
        end
      elseif p400[32][2][p400[32][1]].top then
        p400[32][2][p400[32][1]].top.Transparency = 1
      end

      if not p400[10][2][p400[10][1]].aimOn or #val551 < 2
        or not chargeProgress and os.clock() < p400[11][2][p400[11][1]] then
        p400[6][2][p400[6][1]]()
        return
      end

      local badcol = not val552 and p400[25][2][p400[25][1]].BADCOL
        or val554 and p400[25][2][p400[25][1]].OKCOL or p400[25][2][p400[25][1]].EDGECOL

      p400[34][2][p400[34][1]].Draw(val551, badcol, badcol)

      if not p400[10][2][p400[10][1]].aimRing then
        if p400[35][2][p400[35][1]].Transparency ~= 1 then
          p400[35][2][p400[35][1]].Transparency = 1
        end

        if p400[36][2][p400[36][1]].Transparency ~= 1 then
          p400[36][2][p400[36][1]].Transparency = 1
        end

        return
      end

      local raycast = p400[22][2][p400[22][1]]:Raycast(
        val553 + Vector3.new(0, 3, 0), Vector3.new(0, -400, 0), p400[21][2][p400[21][1]]
      )

      local val575 = raycast and raycast.Position.Y or val509

      if val575 > -math.huge then
        p400[35][2][p400[35][1]].Color, p400[36][2][p400[36][1]].Color = badcol, badcol

        p400[35][2][p400[35][1]].CFrame = CFrame.new(
          val553.X, val575 + 0.08, val553.Z, 0, -1, 0, 1, 0, 0, 0, 0, 1
        )

        p400[35][2][p400[35][1]].Transparency = 0.3

        local val576 = val553.Y - val575

        if val576 > 0.5 then
          p400[36][2][p400[36][1]].Size = Vector3.new(0.12, val576, 0.12)
          p400[36][2][p400[36][1]].CFrame = CFrame.new(val553.X, val575 + val576 * 0.5, val553.Z)
          p400[36][2][p400[36][1]].Transparency = 0.45
        elseif p400[36][2][p400[36][1]].Transparency ~= 1 then
          p400[36][2][p400[36][1]].Transparency = 1
        end
      end
    end
  end, function(p411, p412)
    return function()
      local element73 = p412[1][2][p412[1][1]].who()

      if not element73 then
        return
      end

      local parent8 = p412[1][2][p412[1][1]].pick(element73)

      if not (parent8 and parent8.Parent) then
        return
      end

      local element74 = element73.Position + element73.CFrame.LookVector * p412[1][2][p412[1][1]].AHEAD
      local val577, val578 = element74.X, element74.Z
      local val579 = p412[2][2][p412[2][1]].pitch()

      if val579 then
        val577 = math.clamp(
          val577, val579[1] + p412[1][2][p412[1][1]].INSET, val579[2] - p412[1][2][p412[1][1]].INSET
        )

        val578 = math.clamp(
          val578, val579[3] + p412[1][2][p412[1][1]].INSET, val579[4] - p412[1][2][p412[1][1]].INSET
        )
      end

      local val580 = math.abs(val577 - element74.X) > 0.01 or math.abs(val578 - element74.Z) > 0.01
      local networkOwner8 = parent8:FindFirstChild("NetworkOwner")

      if not (networkOwner8 and networkOwner8.Value == p412[3][2][p412[3][1]]) then
        if val580 then
          p412[4][2][p412[4][1]](parent8, true)
          return
        end

        if p412[2][2][p412[2][1]].outSoon(parent8) then
          return
        end

        p412[4][2][p412[4][1]](parent8)
        return
      end

      if val580 then
        parent8.CFrame = CFrame.new(val577, parent8.Position.Y, val578)
        parent8.AssemblyLinearVelocity = Vector3.new(0, parent8.AssemblyLinearVelocity.Y, 0)
      else
        parent8.CFrame = CFrame.new(val577, element73.Position.Y - p412[1][2][p412[1][1]].DROP, val578)
        parent8.AssemblyLinearVelocity = Vector3.zero
        parent8.AssemblyAngularVelocity = Vector3.zero
      end
    end
  end, function(p413, p414)
    return function()
      if not next(p414[1][2][p414[1][1]]) then
        p414[2][2][p414[2][1]]()
      end

      local chargeTarget2 = p414[3][2][p414[3][1]].chargeTarget

      local passChargeSpd2 = (chargeTarget2 == "Both" or chargeTarget2 == "Shoot")
          and p414[3][2][p414[3][1]].passChargeSpd
        or 1

      local powerTarget2 = p414[3][2][p414[3][1]].powerTarget

      local insaneOn2 = p414[3][2][p414[3][1]].insaneOn
        and (powerTarget2 == "Both" or powerTarget2 == "Shoot")

      local ballSpeed2 = (powerTarget2 == "Both" or powerTarget2 == "Shoot")
          and p414[3][2][p414[3][1]].ballSpeed
        or 1

      for v736, v737 in p414[1][2][p414[1][1]] do
        pcall(function()
          v736.chargeDuration = p414[3][2][p414[3][1]].fullCharge and 0.03
            or v737 / math.max(passChargeSpd2, 0.05)
        end)
      end

      for v738, v739 in p414[4][2][p414[4][1]] do
        pcall(function()
          v738.powerMultiplier = v739.p * (insaneOn2 and p414[3][2][p414[3][1]].powerMult or 1)
            * ballSpeed2

          v738.angleMultiplier = v739.a * (insaneOn2 and p414[3][2][p414[3][1]].heightMult or 1)
            * (p414[3][2][p414[3][1]].aimK or 1) * ballSpeed2
        end)
      end
    end
  end, function(p415, p416)
    return function(p417, p418, p419)
      local count7 = p417.Count

      if count7 < 1 then
        return nil
      end

      local val581, val582, v = p417.T, p417.P, p417.V
      local val583, val584, element75 = val581[count7], val582[count7], v[count7]
      local gravity2, tolerance2, window = p418.Gravity, p418.Tolerance, p418.Window
      local val585, val586 = count7, count7
      local val587, val588 = true, true

      for i37 = count7 - 1, 1, -1 do
        local val589 = val583 - val581[i37]

        if val589 > window then
          break
        end

        local element76 = v[i37]

        if val587 and p416[1][2][p416[1][1]](element76.Y - (element75.Y + gravity2 * val589)) <= tolerance2 then
          val585 = i37
        else
          val587 = false
        end

        if val588 and (element76 - element75).Magnitude <= tolerance2 then
          val586 = i37
        else
          val588 = false
        end

        if not val587 and not val588 then
          break
        end
      end

      local kickT = p417.KickT and val583 - p417.KickT or p416[2][2][p416[2][1]]
      local val590 = val584.Y <= p418.Floor + 0.25 and p416[1][2][p416[1][1]](element75.Y) <= tolerance2
      local val591

      if val585 < val586 and not val590 then
        val591 = "Free"
      elseif kickT < p418.PinMax and val586 <= val585 then
        val591 = "Pinned"
      else
        val591 = val590 and "Rolling" or "Free"
      end

      local val592 = val591 == "Free" and val585 or val586
      local val593 = count7 - val592 + 1
      local total3, total4, val594, val595 = 0, 0, p416[3][2][p416[3][1]], p416[3][2][p416[3][1]]

      for i38 = val592, count7 do
        local val596 = val581[i38] - val583
        local val597 = v[i38]
        total3 = total3 + val596
        total4 = total4 + val596 * val596
        val594 = val594 + val597
        val595 = val595 + val597 * val596
      end

      local val598, val599 = total3 / val593, val594 / val593
      local val600 = total4 - val593 * val598 * val598
      local element77 = p416[3][2][p416[3][1]]

      if val593 >= 3 and val600 > 0.000001 then
        element77 = (val595 - val599 * (val593 * val598)) / val600
      end

      local vector23 = p416[3][2][p416[3][1]]

      if val591 == "Free" then
        vector23 = Vector3.new(element77.X, -gravity2, element77.Z)
      elseif val591 == "Rolling" then
        vector23 = Vector3.new(element77.X, 0, element77.Z)
      end

      local vector24 = val599 - vector23 * val598

      if val591 == "Rolling" then
        vector24 = Vector3.new(vector24.X, 0, vector24.Z)
      end

      local total5 = 0

      for i39 = val592, count7 do
        local object2 = v[i39] - (vector24 + vector23 * (val581[i39] - val583))
        total5 = total5 + object2:Dot(object2)
      end

      local val601 = p416[4][2][p416[4][1]](total5 / val593)
      local val602 = val583 - val581[val592]
      local val603 = Vector3.new(vector24.X, 0, vector24.Z).Magnitude * p418.CurveBound

      local val604 = val591 == "Free" and val593 >= 3 and val602 >= p418.CurveSpan
        and kickT < p418.CurveDuration

      local vector25 = p416[3][2][p416[3][1]]

      if val604 then
        vector25 = Vector3.new(element77.X, 0, element77.Z)
        local magnitude30 = vector25.Magnitude

        if magnitude30 > val603 then
          vector25 = vector25 * (val603 / magnitude30)
        end
      end

      local val605, pinHi = 0, 0

      if val591 == "Pinned" then
        local val606 = kickT == p416[2][2][p416[2][1]] and val602 or kickT
        val605 = p416[5][2][p416[5][1]](0, p418.PinMin - val606)
        pinHi = p416[5][2][p416[5][1]](val605, p418.PinMax - val606)
      end

      p419 = p419 or {}
      p419.Time, p419.Position, p419.Velocity = val583, val584, vector24
      p419.Phase, p419.Samples, p419.Span, p419.KickAge = val591, val593, val602, kickT
      p419.Curve, p419.CurveKnown, p419.Spin = vector25, val604, p417.Spin or p416[3][2][p416[3][1]]

      p419.Roll = val591 == "Rolling" and Vector3.new(vector23.X, 0, vector23.Z)
        or p416[3][2][p416[3][1]]

      p419.CurveLeft = kickT == p416[2][2][p416[2][1]] and p418.CurveDuration
        or p416[5][2][p416[5][1]](0, p418.CurveDuration - kickT)

      p419.PinLo, p419.PinHi = val605, pinHi
      p419.VelSigma = val593 > 1 and val601 / p416[4][2][p416[4][1]](val593) or tolerance2

      p419.AccSigma = val604 and val600 > 0.000001
          and p416[6][2][p416[6][1]](val603, val601 / p416[4][2][p416[4][1]](val600))
        or 0

      return p419
    end
  end, function(p421, p422)
    return function(at3, kind, p423, futures)
      p422[1][2][p422[1][1]].Last = {
        At = at3, Kind = kind, Phase = p423 and p423.Phase, KickAge = p423 and p423.KickAge, Futures = futures, End = p422[2][2][p422[2][1]][1].EndKind, EndT = p422[2][2][p422[2][1]][1].EndT, }
    end
  end, function(p424, p425)
    return function()
      local val607 = os.clock()

      if val607 - p425[1][2][p425[1][1]] < 0.5 then
        return p425[2][2][p425[2][1]]
      end

      p425[1][2][p425[1][1]] = val607
      table.clear(p425[2][2][p425[2][1]])

      if p425[3][2][p425[3][1]] then
        for v769, v770 in p425[3][2][p425[3][1]]:GetChildren() do
          if v770:IsA("BasePart") and v770.Name:find("Ball") then
            p425[2][2][p425[2][1]][#p425[2][2][p425[2][1]] + 1] = v770
          end
        end
      end

      local findFirstChild6 = workspace:FindFirstChild("FreekickBall", true)

      if findFirstChild6 and findFirstChild6:IsA("BasePart") then
        p425[2][2][p425[2][1]][#p425[2][2][p425[2][1]] + 1] = findFirstChild6
      end

      return p425[2][2][p425[2][1]]
    end
  end, function(p426, ...)
    p426.Hb, p426.Cb, p426.Eb, p426.Ab = p426:Hb(), p426:Cb(), p426:Eb(), p426:Ab()
    p426.Tb = p426:Tb()
    return p426:f()(...)
  end, function(p427, p428)
    return function(p429, p430)
      local val608 = 158
      local val609, val610, val611, val612, val613, val614, val615, val616, val617, val618

      while true do
        if val608 <= 148 then
          if val608 > 42 then
            if val608 <= 125 then
              if val608 >= 115 then
                if val608 > 115 then
                  val608 = val614 ~= val614 and 0 or 19625 / val608
                else
                  val608 = val614 <= 0 and 12 or 157
                end
              else
                val608 = val614 <= 0 and 251 - val608 or 125
              end
            else
              val611 = val611(val617, val618)
              local val619

              val609, val608, val619, val617, val618 = #p430, 238, #p430, p428[1][2][p428[1][1]], p430
              val609 = val609 - val610 % val619
            end
          elseif val608 < 17 then
            if val608 <= 0 then
              return val613
            end

            val608 = val610 < val615 and 0 or val608 + 145
          elseif val608 > 20 then
            val608 = val610 > val615 and 0 or 225
          elseif val608 <= 17 then
            val608 = val610 > val615 and 0 or 765 / val608
          else
            val608, val612 = 153, val612(p427.d(val616))
            val613 = val613 .. val612
          end
        elseif val608 > 213 then
          if val608 >= 229 then
            if val608 > 229 then
              val608, val617 = 229, p427.c(val617(val618, val609))
            else
              val608, val616 = 20, p427.c(val616(val611, p427.d(val617)))
            end
          else
            val608 = val614 ~= val614 and 2700 / val608 or 25875 / val608
          end
        elseif val608 >= 158 then
          if val608 >= 206 then
            if val608 > 206 then
              val608 = val614 > 0 and 42 or 225
            else
              val608 = val610 < val615 and 0 or 125
            end
          else
            val612, val613, val616, val610 = #p429, "", 1, 0
            val614, val615 = val616, val612 - val616
            val608 = val615 ~= val615 and 0 or 213
          end
        elseif val608 > 153 then
          val612, val618, val616, val617, val611 = p428[2][2][p428[2][1]], 1, p428[3][2][p428[3][1]], p429, p428[1][2][p428[1][1]]
          val608, val618 = 148, val610 + val618
        else
          val610 = val610 + val614
          val608 = val614 > 0 and 2601 / val608 or 6885 / val608
        end
      end
    end
  end, function(p431, p432)
    return p431.Tb(
      p431.Hb(p431.Eb("|KhFz0058?0RQtI00IC34FLZ-4*&!J11$jm^CSQU00k2O|FA(IDgdxRBL67?<uouC0p<TQE)@U)CKUkx2LP};AS?i||2iTm08<q<G5;(8000Oc09UUH4FCxNKnejv3;qJ23?2ZwAv^~C01IFd01p5TF#iAs1P};6079z_9R<P=1Yi*aWD@EErV|Gs6bB>~0M7pz0RXxqJ_rEy77W262p|s%K>+_k4j%wl3=aUU7Yv{nAOS)d2nHJN6u=Y!8x+7HECBxjClml20K*sm5D6_C08aoq{~SL6kO3ki0N=b0H~<|UVIKhh9xebn5da|o{~#~`IuigR0P7+$7hohHpad2L|2zOf2^s)b2mcBHB>;s704BQt0t=xP04EEeBL6G^g$MvB00Pw;44@VQK|BIM2>|~o00JBU0Vo&x1fe|wK<_sb04o0g-T*5K0Pi{helper4&$d!?>Z6y|1AL8FA*^S+W#<8G5`+&0RX?sD;gO9D<U8+|0V$34--B$2L2VmJse2@o;NV7GbAM-FAiWu3;+jT06754Ed_uu3PArc5dhjW95DdD+z}K(Hw7F3KK~p{0D2Z0769Ke0I*3S3E?v;UjVW#Ofxp%IRoJRKm*|OEdVqCGXER{<vTzg05I18uu3_>Njbm(06GPWI|+dAJ|6^N4uNmo5lAHspd>RD;Qb8%U<?4jJQ^VXIv)X%06`Np{{UAO82~i^qE{CH4go?o0YM4^qE$BmK@tQ4I0Oed1P4_*1P40?!3PO~JPJbfJqY0z3!**%&LdR;4B|fxqCgBsK}kTXLMjkqLkK5C0-!~z0;5I~;zt8#NEQM~susdZ6=6acB1;TrOsX0pO$z`{2t!XAAq=V<;!q91Q39h<4<J*j3}aLUU{wJ_RtUydst5pB0)trzU|Iv?TdE_W1}0)$B>@j7!d<E;f?g>?Unk)WDxzTODMw){p$jcyVgfM#BugCvFeObM{{k>3O&|l}Z_gGaCn_@lZGZt1&j8vwbTuIXgHHheJRC>>0XZH3|6>5KP9!S;VfO_KJ6B-LLOKBd%tSl^6GIzF{W(zJ1pxCo0A#-aGAIDBRY#&_zcv7}IaohSAWVNOSOA_yK0HeR_fsJ&Nx(_~???X`0A>L1NE`tFX8=MUDgXgGzbOD{0I*L<;ZCa|DFf(f1K=wI?g#q-AXs2z9{{ja`ywh-1U?;D0KNAFA{L2&dLkzxUR59f0BSc8!7N+Aw?7_P1|TpWS)eoD0D2=QBLm`VIQIasR&QWW0>dKzS_5V(QvhrN_b@V8U!iR{09WrMCjf2;0|x*v{{VU<CnNxG0RL)8S~~!00Nmdn5>ZG80iatuzW{3huvZ~+;6!aGa^OXJ0DwjobAjI<0NO_r0R%`At^&YGSwAIU7XV-xssP{|0AL~j;2~mS59<LQ0$>^`Vh;frssrF40ALjW;2i;A7GD4ZVkbiegd+ohJr4r{17k@-2c!Z4{{;YQP-8;?aIXN`P&y9b4^V({|3m-*N)!Nc0DrJwAuj;$ST7*|1LZbVGXQe~_hvU=haz-D09XGoGXQk}uwWwpEdVb_FBM$?x6D;d2%t?g5a0*;5nu@s;3fm*S6Tlz0CoV}FB4g-RRsZ~cLAYV0i}3)0ijz1WqAOwWQjm~R~9Zn00U?e7vb_Bfdm=?9DxIAH$i?Jq$&UdY9&A)!v6zn3qJq@Y-qj#p%DNBZCwOmEiN8{18ztNp)XaWAff*&0K7eC0DAymS2#NWd;p?-0b*5t0wR9`B7g$ofpTE^f^)zH0D}O|MF8prf`kS_g$DwL0G|I}Ra;2_194Dx5CC#25yW#QMKQq1F)pO8!7wwxBSA9&*8_As7J)CAz&-#?hXKGIL^wn=ArLsgeJ43UC;-}BZ89VOR~A12hyVk1r6D1q1qx&Y;VGdYKZ^i~13+gwVFO17A&TDsYGHI#J0W3H_6XwvTRMT06&PDTPAmWec6}5<3BlzxMx-}LAQZ#IX`|l-RRE$w^T1a@_e21TAfSv@0GQu*Qda<t0K<*|QUd{x1Y-jNkOCr+2B-0o2m!0$2mq4+&Q7!^U;!YMDgc#L1wxjpD`1xaLzn~RnGT@{iVZ`W3L={j;k^I|z?^6jLF8Zv;GGko111FH{hkqGp8&ObP$K(8Pbp+N09QamzW|^B19@~rK{{^$1A09H1baaOBmY-GMF61y1AEm}Orbgk<U44<JOFQMXnR{HL1<AYLGL;M0b*g{Q&2VUHE96Ou;5okNS^?r0HQ{RKmkFcu0+73SpWi|r2?S~e*l<!R$Bn30wVvX0JUmVBS=%~bKpL7U;<VGS42lY0H^>1eQ;JI0l|f-0l*tx0R*8D#|0s({!qYhS^)2KPXOPl0NQC#IpID4y8&Z#f_Nb=2>?2HVxbs;y+A-m0ILgNU27c0M*yq=z%)$7@*P1gg`i{MI{?~du_|^!xgj89?{lp}bbl5AtpM6;3qzsmhruL^;3bS;Hvj?aW>v3Yd--5fQ#C&@Yyd(?SrcFep%2<=CpM7a1!W!Kj=}#y0Nf`MbZiCx0I+)@DgfGO`C|J4PeBy`1Az+qdF2Hhp<e*nZ7=wUVOk-7!6O4~a&TV&t^fgO9in}bK(_;eM{R(EHXGqYuK?O?IM1Obj$+>b0Iy5{?|E4O@2~){fW08z0I~N@0Pi_~vH<UT|5^aE0GNYbWB&lO0NqW5VE}*3cW(gNatvPKRY|9yN2nl3sGtU^ApJ|Jph^J1JXj$AcwGUJ06S4~?*La+S79KSie;~A0JQ)B!nOipx2FK2Rb>GKz_<j0xqimrx>Nw~fngA!_xg#0&p<u^z&)>8BYk29<GTdHyr%%pVPb#^puGmdzJ3Vfx@(3|0KX1kzdBWR0HRvopa%a05LAl*LRe}40J?36QUFc>??PH@00NA_0C3-qX8;0I0`0*7`=VJ0Pr?BBfmv4oDv1cK!vf+c0_p!(R#^bV076##X8;od#Q-{60RO-MPI>@3T>$UG0Kt3_01{G(q67!V5Fr8tCLzZop$V!Y;>aZd3IRgNCSe#_0;0;SK+9+WLd>n8Rm}lI&IZSmuwc&w169zmz|jR`(z77b0;5&bw1CwF1J*HT*9)Rm*th`M17q5`VA}-4_1wC^-2$WD17=;_hWLSHi(b8eZEG(8S65p2fr$K|K0#IAz(C*#BjG(Eem`TS;tRs#KVw3I<PHMmszIS54`Sv+0TmF!=YIgTVq+v%V)S77Ig|uWAp!tbQ&ztK=l}zZS9ifmd`|)bLFof#T!j*$w`7W45}|4UFyU^e0I-J=p$1^;24Eu624PKB0tR900zeZ#iV7m^0YC)<rS(7zfbFUSphE&h4-Vq)1^_b&My2Ek;S1DYpW)Eq(qZ`#1j3JkX#nqoURIBRcpJ%ta*u+CkAU|80B{4t?Eu<%-44xRO#lG{!hJ}817UR=0HRh{p#LjVXixy!bzA&(VGV%~0KZ6ERbK$wbSp7v0SHUs*Af8lZGco?09RPITLAD^VI=?oLGh?q!J8lgpz;Ah1p=b;3Sx)!1OXocq6XN}pa>v(2FUdW$p8TMYz?PGRR9gP_YJoO$PKRe2Ej!n6o)DsZykXX==mT)I7mPtq9Fr9T4o3$AmZpELmC5hA^LS9R~A>(0Q+v_0YLne0R#Zb0-^n7K>lIC1OWd4vj73Ozy)9d0doWv_g4V|TtOcII$B==1OWqi24Mj$VD}bS0SzD)Spf%H27m|$;sFU^feQp8RSE*23ksv01ON;K162(HKn?*val536+5YN0Ymi>1OO5OqZ0rFjinu4;Sl0O55N=xKz6>?!4Logj$Z);kFhP;0T2Vm0FMj=1HAuUhyeEhS6N(J0Q4H5^lbq`_Z$FK_yI%p9bokWqxc@cmHGig`5++q0;45>S^jGP7Fq!o17=|DiEY7Xj<P@iZEi0BS6W?wfs25F1OQ(b00WR)6-7=Wz}H#<7y>|K69rlUMHvCW5BH(k!N?&D8h}+01tJ<^z*yqJ4jkaR0>cj~pbr5~wt@pcQvd^#Y)pd0Az^gpK?LCy+CmQjQ6u10P$XbeB;ZdaU{utE|55;IfRl3oa4!JbfMjx{dUBy|!0Ty!Zopn{!CP=x&j8weVdOyzW4}m0V_g6Pln0I>38DWG0K0E?Dghh+0EJWlDF6az{{R7VVgM%qu>PO{^KJkF05M$pe}H2GKmY+8YykhTi6bol?}ZZo0UZHOb%9#}`5w{2R^S020Nw%rAXorT06-#<?*nElRF~m1SuDP)p*a9oB`B()R{kmg2mP-APXuRM9+3s$Az0i1HXs1iC_bT765w+`!Bqg~1C@26K^;L>02BX_Z!!SPhkpbA0ePAMA^`7?|8D^!0NR8{II2egT=pbcs^nM#U|aqI;93AvZ#6QA{!!p0cmP*qX94vkQ$QvGLni>DWz-Jf0--2Y04W3mDgghrd~+aYasUJSonug8UI5)?ob`ABfq4}mD{27m|CDzDECBD7cl`k%AeMIlE&%WUmv;d#077nkzX0!;cmXi~0c`&O@0oc4F#rRnrXxiYz`j9d6u@Wd6+mSbz+)CbWB|Kgfr)wnG76z+3ZQj$3ZiuhAl?AFsX*J7b_e03AYlPx0G9)#MM~jh34{m%W$yq3rB1y-W^MuhGXPg+Zviv_@7j)aF#$ku0X0?+AVfb5BQ^{nXAB_ubQ5C@fR%LtHvs1YqC3su6JcWjyZ?QOdjU8A-DdNhdKcjYVgRrJ`v0Am03ZN90Koq}ZX=O(17>pFn`8lcpmXG*fB^SbY;QT?ogyp)cV=^(XJLDxbm#%!fdE%+aOeP2dH*&ukO0bwcXa;&D**4BdI2#10n>(TqyV0k|BjP@0Pmc90sk-pK&E+r07AcXf&lNHegVO#|9gP~9HfT;I{$hBIsrME00#dA5OJsj;#_inB7=qi+Lj8-VZUzx1Ft_qD54Mh0ari(Z~#|md5Zx%0>CeaA;Ulcz&xr1pfCZ!VgsT*27nGy>_KiQq6Psz2;fEpCnY}$zzGV$N#SWq;FlnZ3cx@OpcnIDcHs$QK~fL^J}-a{fI<;q84+PsZ2E*(5n@9WKsYP~3Ian!7N8A-!Fb_#VM5`)14Bgs+Lu1&p;@XK0!AC)Q5)fH3Tj8H9>8Yufofi0YhK`8QeR+Rf`T8xNFtz37r|6a;Z5OKBBDtpfOlx&RWBaqN+;la7sE>rAf<7G0RjnN1_MkHfDilvK}^A00NR*OH2MtSaaROl00Xf#>YRaES)_83qPvWW|9k;W0NrPvd+z{OX=|F`+KOJH8X;o=z=j}A;A%5LQGNlz0Z#zhiXa`~Y5~JgQJ^bXU}<ce;8z2pQvpL#1b|8pLG@K$#8d}jQvmOl{d7}+Q+GBoj{tu{Y<&P%Yi$kTtBg4)A!Px;ZdYL1yNpX=fNO36iU6e5F+!nV10ey5z@%;eKLEOdoo4}7uK+@AeptY62f>X|KQIC709v51Yk+wMWAD0yo@h*9LT-OrT7Yj1;f_=_A!l4-{jhF;Gcf?#j}-g@Vcj5YaRFEW15>A7mjN?D3}HZV2jKVbn|Kysd^RzZe*j>9h?xOd0K@fK0i#U<gIfYHfB&X<0LqPfc>#Q`AYve017>@q(!uwGseEfei2zr1wRqCOrf#8prPd*Y`>K5dL5cuZc6t78p@B9tnE>yj{c(Wcu&N>|0PoeL0Ya+*L8StstRVd=YXA*$sRA&BzpH%$Fomojz<B?70bT+yhOK}8_uyZR09Sc@0rg<{Kw$wxVgfLS|E_=l_@;RPDgUVg9ITH6;(gD0B#Vx4q(Z>9dJ#vH<W|9*0dP~`O5x$*K5n6A00Xygq9I0M%4`8(O9XRS0D6G99Bgrcd!V@_abUV`asX4iVhV-gA$DE>d{qK551ruXBYvQ~7Ve>}!MNtZW1*rzafSh>0K732$U)|zhJd{l$zgQ?D5)g{VG#j%X&`-Rpzgt?bZVe=^u!q<d2FD1R1^aCLt$>9cW)qjZ=n7d0e%3xn3IJ8A7lUns#v|n_r(!m{`tXa0Qh)w0CE4L0Pmp~0c8OBus5Ks05fv{@1Vbc0cHTAb>={@f2SfV00XT+y&?D*VJM-MVFv&Mu2Q}u0aE}%c!xQle0~jJ+;kJ9n+3BV|9v5zeE^=Dm-m^A00Lm9odp25@27kpAh4|opjUeqc?Dos7J30yz<(Bd0a^f876XCrR~B*s&Y+`y0q<!5yNdrHY5|e|08>+R09RI7e*tR%qE`S40YcSm0YL`>qHW0GR{;O-gk%A30HRsH0J;D(XJ7^cZ~6mF2m?oO0x)EY|6KsiWB~wISNB>0aR8!n0G@K&bb8SMgkTMT-U0t}SOD*ZWdU^m0Q!xG0Db`}{{W&~0G9x;jQ=1l0Nf1|gnR!30BU<=ZUJ@w0K8y|0d@dauUlRKb=1JIWFU$EX#sZt?}%st{`bIJUIBRk&S+E(AORqH0U!VcK>?BAssZ490b+dv=6(a_e}e$;2%yox2%y&h2Vj8a9YAwi3c?a#kct5RzX3e}qF(^SUjVR=A}tDng5<&c1VZG%00Dz=0B~QEYyb*a1Sf<Tq4Xy}3E+ho!G(MW0PkviWN#S3VT%FZh5%PwUl_p7X)YrmTwehd;As`$0U!XU-~r$j-~yl(-~;3p-~;6Se;+|z0Pl)w0f6XW7eE$(1wa;pA|ojPkrj&;gJ2eckQRXnpcaDs1VR>qhj9RKlx<@G1Qvh<B^H2P06pO14?u-503CocpjiO#dxmB+p^k_EWg#KIT>yRnu#E$QTJHewhi5lIkBI?y9srI~0AM47=HUNTTmgsxS5;l(0f{Mr2uK8=_W+_-T>wG|Lsta=ieW+G1Vd&Cz(RpQAP4{}XIgGn1fgP}lVI}U`AOa2=K&7@-CB`fZU6(7Rq4S|;GlI@;UH4c0^R_xBZBs=ps<miAl?A6U;hB_jBEh10Pp{cYXOS@S6*S?0JH$kYcAkkVfz7$IRG(T0NQ~4d%A&G08?u<GJk{v;-Ot6Zr&mN2J9eN0KhzEApeGI02URL00n=10JV8@B4?XH{*8eo08wXX00;kb04rp9VF17TNNN}$kr@DH0QcI48N|T@0I-<<Au9l)WdH^MM+2T8>OrBQmEm9apj9LIAQkwaSNSAc`XH%LkmUQJT>Ky|{GckR{UHA#AR!C>peFwyNLmwO56$2Y0Tkg(AYdr+fg~ZE;YuQ4OCsQ?0gC8BBqZbsC156DCF5%Ui=KV}Z~)qi{YBcL4*&s$6afEn0FxCMg?KFY0HSCXz}ks!HB=Hr6+sy-Kw<Mh6#{|y8Q~zoqG1I91EU6!Mlk>!0i=Np_T&VG72g1AkfVbQfsiHW`r)<#seup90F8tIdjX0MA+VnzFWmskaDnQ8I|QXBK@R}e+K>tFAz}q2eMo-;d5s$YqHb0oZ!2qnXfL2}Z3jgwL^Bpd1qQ%helper7$=8O&IZofjVT3z3}OKs|B`KvY5+QN0soHyj*$R5bOG;?0g#jBU=nGdUjP%IeUAO$TK(a5F$O^z#G=}eYa`+HXiz|B#>5W*qH)$IA(9^$A!`vtW&nT8nvww8l};(a(90pwA-o~BV4_B1mmS_vp=|)LsYYM}t_cyz!P&uYTfhjRDj^i%zXkwmo34&F!JGYH8)E<gl8*oZ`IRUkBH)CW8~~#Ic_QI<i*o?lnE56g0pj5g0UVxq|Cwq46RL=s0EYvy5K!S*!ChhUfd$_HYM!x?LE)Y-z6%ADk^lji3j~Mtn+pJZ3jukKb^yoPn|LQ7_n`{_pnLzEY5=uwiXwjfi9mz`09Sf_0iTor1G6r7!Rv(#`U1k0H9?R7@2Z8r0hIvSpCJv!mT!{)0ht)&h@2SU{e2C=dXIMi+MH=-H39SC4?Tc_d=LOx5C*|KV4MgzVNUl#*V>&xKcx(Fz<~gN2aEtKeUf?%p!FCGp?5_fg?|9r2c9%HR3s{4`ayajTj9+N5&#W0{NzuA4*`Bv!5IJpxM4v&q}>%5;DP~{PC=Cbcki!-0YKWMa7|=go>_vkAua|WDfglObO5@Rv33EN?*n;~m|g&xnE?M+g@^%~078ZRmP_Cdf3^TZga4EOx|p+l0h?a}=AZ_=1LB-xVEvs1L!JUKle&z)2SJ(uSB8lPKmhXrp8-PyK$N?U0DI1qnt+Fj0iXte&!L+DR{=l+AeFrRjtGFFoB&sdi*g2nqX9z(fR??F3*f(`od8#fj0xhU+yO%g;FrFT4MCm&msg674ML^?Lk&Qf`@fM8p`QR(i;h+p0gIeu02LSsrx*)Os2B=Dhzx)i;He0JovIh=00FBOqXR*#Y8VWy7zeHx3eJ|fK)val534?uK+@cnsq=Eekn<?0NsMVm?=VKuNHu@5i&4<hL?PR{SYvOSAm29asq!akG6;aqJy^p|5t*A0kQxSwEvQ$1LAOkDwCCz&7gVCAbVWo!2x~B&>(!!pnlOHO(3RL@O*&;fyAK#fqVc1zflOI!33cNp@7z4cnKtaT48noYOKGXv0;0x1W18=00E|=A`QDpfxu~XVSj<a;SV9d2>@!Xz@WEbt-VZ6fqMV}rv>3tuaz}5t~3C%H)FK=HDI+k!?pmTivaxuIwH3K__m1vKPkBY+N)Kpp^YJZ5$J$}00YE$4JGA->Y#<|AQK?5#H3clp|Lkx#H(Avz!M;++N~~SA!tDY@Sr*T0AS{!4*?Ui8@GL^0w9P0+OTT5A^C^{z=J^v00YSyxcT7%1&*M$$*Itxw!KDx!H56>uxG->_8%bczUjfhJeMK=xS9aWxv>EguX!K6u8bs%4j_lVy(EeN1I~LG;f=}=z>dGfj}kxxfpq}yYP-&^rXZI9FW;)m00FfnBBM3`HoO3$nE)OD-&dHM0G$Cq0W$spK>@e}<-fn3{{guGSC^Ury8i$=oB_N6ySrZiqM85+0z$n50QZ{#z5t+{0lxshaLuLw50V99!2SaP0LB3C#i9Y<zyR;Yq5)tlm(#42450@@YX?GX0RP?rbC&?`#H9ZLbO8Fy#sHW90Q>-=n*jv?udvG^Edzm=2w<iD1A)!Q0UiLS0G@aN&H%8?1Ar1?!M+Hh!T<x%Oddg4sxKf5FQ6tcAV@GIk?#OPnq3e<0c!yN@5iD6!2mC{|1TEG0L;R=0N;B62gt_`U@orz&j6mrzr(WtPXpUlM>oJ*L76zfU6-jM4*`}sK$SYcotP-%1Ke?+fdqk-UjPH$GElt)lRp4Ooj-t{Kmb$0sNpOIq*a?jfSf}BnnQp@L;%H-M1YY+01Tl;0ayTUYRcWc*<s2T^yIC?*u=BP`@pEpp{2jNq5#^*WyE2Ve!oDirvL-qIT1m;!GT&JdZ+=z0zeo6OHd#JL2Tg+fx7|bff9+-5QPteR|i1E(LuWa|L@g>0mJ~>%H>}W+&s{!5kPvTC-<fRG;F}dy8y8N*&-|ePXLb|{oOcV##jIc{0sj8dZ#C+0B->QYRlff0mT5Yf7&4}00ZAF!eJkv00ZD<RzW9$CV}cAfuU%i7HJ?C0BX0*;K2NW%}L{h$8W&^0muA=w#wsxU8^IZsJ*2Yzy;%hJ)&WPzeupE8Ng=&$J)wBd*NW=V&RMc|5LR!GR^>CxBtP?0muN|so?*;0J_24rUA)U079$*M9Kk2%L1bRSE{W6%mB`}>i_@&A<Y1y&I97#XQv~$yM92U0ROtc+ob`|0K9Lq+yE|(z|g{}f&Z!C0x-Mcv;coPvjNcnF4B;|`_ja$fDx+U0x-Y4<Fx=fv;yJN_LIQV#RB20;sP+gz2vq4I<*Di)b^IZ)W!ngtm6VO|Gwq706Mk-)%O5%)eAwb<N!kbu?&F|r``ZUt6t?msjLCkAYgVNVXjJ{qX1U|K-VI`EdByZ*Z@&ytpErAxBx4uzNP@$>&t9TVWUc5v8w>@da5U?IRe?g0Q<1rIRexo;R9y>uGau;0x-7R_Q)UrZ4H2^s{n5PJtGJI-vD~6C;h8C!O!Bt0oefmQ@1rV&;X*Xz99fttgivu0YO%O0GQ&v!U5X=!>il?0|DIw0R{m=-hTkKlDi?Vx~HJur2qrvOG6=~09V@18nXeXs$it5;9aH~0I&hy0>E-)q4lK!!r&Qzu>c3W{{Snk!m0q;&;3DY0i*)^;mW`LNm^hezX00JXxh;MJ~YA)0kk0n0Dn5N0pbDS(Zc}$<HG;}$P@wO)*ZkhFa{tU1|eKJs<_}K+h`}c;1IiDKdQUnIJ{tFyx=GZq2^Zs<<T)9y$FjQ4#6R5!hwR}alu<bR|tX+K)2`t=MO*t9S=+)ss^Dl3&C^9z-h@qYU;ZLe|m&K4ngVx=_(fi>j$hL2cbfT;|yR|?E&lru^$X!20{UPZGm1GKmfM^?g{Y~A`zi)FaadmfNG-`VE6C=?+>wXzX0#A*&zXBHh?3TWXQVM0^RpO00Hp>!&<5Xz+(f?00*RF1Hf0bRe_cP4=O<bax&pAw*c?fc_Pbvqu~SoHDN0OvbzAW0sr#i0Powo0rS5A@7lTn^blaVy8-n9U?Bl#G9VWJ0rmiWNCUUalBj^JsDWMs9%11*p%1QJg8%>{FClYHfhoG_L=ZcH_yPAVA^H3?>P4aY07?QTJpaQ0JrEiI-KhWHyZ{IPqWS~>1PW|#VPtc3|8i+=X9NUiVgGGq1WRaiba4N3IxjDBVRtV7XK8e3bz*gM|7CJxZ*FvDZvS*HV{dIQFf{*4Z*pXAFH=?jO-)HuFLGsO?{hC`WeDIeZDIFmZZ8T!WpXZT|8-#m13zCq1osGZZww`LX=7{m1P4eAAV+0%1pfz9b!}~FbXflc2uM{zUrs^)O+^F*b}=q6{{#nCMN(5qPxnp)8WDwLX>()V4qz^4XD<eY2Soo#Q$tTuL<9!^Q*Ufxa$y7n|5#;iZv+cfPXAL?P*6`&R7L+p1Zz`wX>?=%XdrZNAYmYL|8;P1Z*p{HWd9&#cx7XCbZ`H1EFg4fWo{t%a&>M20U&c@a=&SCbRc187@#h{AVG6$AZY^wME(z>AZcbGd2e<1AZ}#{U|}F~W&R<6ZDnp`VRUKVZ*DFG5DzF{PQOo7MFa>(8em`lNkmfw14dO;^8^V2!W`lUMQ&mLVr*q(1O!WEKY4QmH%e~}Oco&TXL4a;4dHSiYx`w+6-01hb980@AZc_UVr6V^|936~1Ws>sW&Z>NOGQ}(2}A#HZf0p`b#i6@1PMWPbZBpK|7mk&1O`xSVfT4uaw<S+b9G_=Y;yz%Q)q8*eRMtH2T);ib3Xxp2}E*fVq$CoLjO%~WNBt;Wpe*>1PVuQVQg!+Wo2*&pae}X-~@jNRAFLIa%2gi{0gH4fn{`4WpZ}^X=7ys3Q~1$_5o!ORYqV*Zg6#e1Evd1Z)0I>5v2bKcW-iQb8una2A~C0Xk|{o1XAu2pacX*P(cPoZvSU#Ze;`lUq|-@1#kwSYy<>!zj<(F1O;>^fdusiQ$S}&-~@AUXg^W}1!iSsNMHcMU0DI6S_B1A;aC8}`~rYep;`n9aBp}2WpYh*Y;*()zi4G?XJ~W*VhQbc9N<%MI)DTTVXJ3G4<K_V00}KXbDvFNbY*h};3WW5e{x}CYXv{}v_Sp<Km-Y6b#iuP`UzqU1tCLdVRC2pWm9lEAVP0+Xx9V`V*&zH0-<yS`3nys0fY%+VQg$v4dVwwP!gsN4q-?WC;tdxX>C$rZfB=u1P1{jHDM0{08i&`Y<UghH-QLLZ~t&0Ol4+t1PDK2XG3ptZaskkApR4<1P4NFVRT{rZf!teXH#@}Z2x5iKxP(ZW@gJ~W(pu@4+0uT2V$RLa#LYu4S-?*NdIqaWCcIL>xKUwxKZo`2xn{kO&j28ZUsOw4FAl`%*@RM31pXPc4ZTT3IRa_;{>k*XKPphfmr~7TK@zHWMyV-Wn*-FVF4sr0%lqS3xJ^iLuhGiWO8M0`veC%Kxbucb_CxDW_503YC!}8A3<bf1PTNq0U%|dwFg{aZVA8y3<knd?`3Uob^^c)Q&^5`;8baCS)u`gSm1O21PpU!bZupH{2)MWU<3hc1O{J^Uu|z>VxXIV17HOI2}osOa&%&4|6z0mKe?Hing5xYngk3|WoP|qY@l*XZ*On}(*{N%0B7I^cmQ8U`B-iMq=5x;Wnp8fXi)$F!7>*>YXSoayJu@21OyF4A0tBDb!$Ln1O!x}1PGcn0Y+UR2~tnt0YVJ=H=#^GflOs*1PvGi0s+PYf>m&EfCGmC#*GB7p#%gNfF!^Kf>hsca&vD428Tg%val23+@1Hu8p2SmFdLcec#1O!2NTYw13QW-%3;R+Td17HJg^>`vc$s$AoV`K!s188An1P7jBcKV6H3;_gHZggpE*8~V?MW8}jpacng0U-i|1V~RzL<2+Ke?V&mKm=z+Oi!0XOJ4(`3b}(#fdush0wGRP;BatkX?{InK|@hhNm9aK`*USOzy(xKRYU(s1O-GzLq$yg1P4!5R9{U&+D$-W6`^u;$)Iv&w`^r$o<Ie2%)$j9K}bbGL=M1J;Z^|u1VmC#Py_`@e@;_HR0Ilia{~QN-XQ~bXm11rm2lHR1goHMj$p=t1p5bXm!NNNZUhd#dx2qNbY*f-q6Pau;29(hQek;x`m!KU&%kYS1OsmWWp@MwMQ(L%y95yfBt~g$2EbH)mw^XKZewh9Pk=oN0*DA<a&0BVf}wi^1`^{01aoNxAn^oupy8ot0B>?L1m^-_cnn}VAO&xCU2ex<2y9_xAZP&~F9mjNZ|filfniGmy95i6pmc9-gCh*|0fYlX3Wgy~X=G$iY-I!u1jGTv2kHR*PVZm@1X52-Oj`s90HI%0Ccp<K!gXJ(;7u<eNCX2f;CBT-)`>!91O@@1KSn`A1wZBj1T(?!M?q9Yi-!h5QrA*RRssO|Y{UgZ|4&a-R0Tic6n}c*N3IkE2RWecMNCCjj)w$HPv1sV1O;=mA_jBTHXw9F3`YbD<I^)cGcy1{1O!A70h^{@1yD~{MZ;ihGobzoK-UUAaHH1>{{#$1NlrymQ}ab%4I%O1RY^oePDsKDXLT+BSV9T`Lh@S!3j)Hpga%VoQhP~DQQ%HRK~jET{^P(#Z*l|%Zg1CeZDC-5ZAIW{PdckW1py)i1af@>2tvP8bY*Y^1GiuV-Uy&ULQF-~0B>@R=70xtckD#<!am?<hi(K2`(UbJFdzXWQV#_{K7eQ9Y(R$~1Ec#1XaPi01PNwx2XAh4u>o<Q1O#P(E<o>71P4R_z+Y8R{`de%MN(f(PgmCkKn!t(R02UrN#93E1wX?nWC&9JX8>7WLqr4zQvX#>Urk9)1wXEVL<K+N1cV9-f=1s@QbR=q0b^8GUqwYu1O*3xLptEz<px1gO<w|GNCf={C;&xNLr4Wc-3thV1wZo%qy<B}NJT-RzPM4&K?Lmx4uD@wci}(GDF5}sk6bAP2}-wBO;7@3KnX~M3*$pU3E&IGF`#2*Pyc2F2ugKra7XuHX>P~>OjHB{Uv)DC1yjJFWq+XcZk-_oo?v8o1PS>>*g?4>6IN+*bpLf>Y)Ni#b#&iNVQyh(oPYyG#?hb#Q~My1!OFmObZ<vX1QE)BbZEWcd1OW)pTKl^1PjdI{sD#rbYXLA1O@iM;AL{krv^}IZpBUK;6GLc0s?vf4MX1bAw+d@VctOnK=lD*<PHMjNp5sy_il4(3}6IpVRRK}NI+tY;BA2c-GGF^|8a731O#YxXa39}dS!BN1OrC>X`w(+a%E&`WAAhX0zsnSPGxufPzPZMLvn9(bN=K(1$jYuX>$bW3cjG~0Cbx`1PNnrVRU0?N#O(t0YcVLKm-Qppml_x1VUwRCBO&)qbvXkLj{44LUnU_^PmAiDdb586+mQVEF#YUCV{&l4k7;tOJ#XtX>Me6q<{e+1OdTwPjLRA?*>d^d92_B4p850VR>b8WZ-3T{uDtBQ)q8=RCT*<VfP?&1O>~1bDIPP0KrLan}E$=NB44Jb|V1?Q+0CNW?^YS1V?fp1PA+HUku=7cmxGT_iS}@CLmN{a0I;s6=DWOcyOse1jhwKY`uX%pgBMU1o=<|!KXlMWpZI|ehA<ORd8fsbVY#d;(+7;22?$PbOZ%!RB{ZWNv7cfZxVp*W3GY-LIA;Ka&z?sJ7-rAKyP;iKlQ1dgb6%?Q*dE!ZgGHRW^53l1XRu;?*>6*bWorK24j3mAP#^AQe|#r>;PK?Oah?<NWj4f0HJ;lq*FylQv?L1VE<GE1XDpqMFjr>aA^bsL`6sc1O`Y!Oh!;ivRy!Ej^X^kX<{dU1g{1|Z*0e*2ZSJP*HTA99sprRfConZRa8u2Ze#=qde@+I)FKE&d2A<P{c;FlVQ^&x2tiM7V`y(lU_8NY2;lu}(xC`LVQx`%?`3j%1OXvbZ*}`)Xm#LWb8~EE<#S4aL*f8tU}SH1bONE~fN7(E1Wsk?0Qm(GLX8ImQ)zl-`veRdKyGtzVRGMPZew`_65&L0?{9DgKY?WhPfNE$PfS06K|}!I2d_m$M@0bxc<KWSn@MM|U}aY}fNm%b|2Q}?HaIaeH}^9&H2`1)4>2+SI5IaeGBr6j|1mK#IWhzeIR7y@GdDCcFg4#ZH8(Oe1OPKK|1>!=I5IObF!%*QcZU843v*~`W%F!g9%BK7L2z(v{dojO3~p~zYiaLnY(!;R00atfd2%9v0s;gCVqx@P^96GQq1E7WVP^#22ySn4a9!YZ1^Yjw;KF+Z1b1OsX#v2k<OBu-<+<kMn+RrCfgp7x086C^|59&tY;0w8W&Z^~@XXB2%*?mV1wY;;4@3;$Agx9QVpDLC0j{h>1M_QT7QpA_2xD?@pK*0%bYUHb*Whf;Y+8p4X4U}_!vqbm3c`v224okd26dt!Y!6=rKoZO3!NSX6^ycikfr|i1PSOHWPfXoR@BsxtIoriVMSnv@OkYVuMb3zG?i3@UfB;WbPR;=P3qk<mUrR+rQ0oK-0fSS$ph;2$?*v9nL1SP-MNWN0=;3Z>O>cHtAg^q1ZfEd<3Ao@@e^gI$X=elwxhAb+=U`=cFreV##ccZQfOG_+0%mvw27Up;a|8%;Xkl9b*1^CAa4tb)_`q;;|4(iN33GH|WcO)xZ2>?Cb8cbdaC4WS-QWU)1O-s}X{&%~z+_@?VRFo%fRkWhXNVxGAZ2XV1O`kEfpg>GK|~)(RZRp669Co#3IYB=0A+MWaB~C=-WK9UVQXc{AZG;g159h+gTQBK1PA=cAZK871O`-LazAHfbOZ=eIN$*y=?5Gj1;PnGKxa~6eQw0yCR1Z&Zg-$xEFf@Yaynpbo`HQJfgm7nWMp#z0_c!Ht$-b1aG&4>Pjvlg;eZQLWoKz~zInh@VPXUlDuHdsWo~o^;^AO`Km>KwbLL<od4OuHfNyduc_4{^WeNjq3&76+-ym~vZ*;&wWqJQ)1SCUjZ*yhcATJ?uZ)_2Oa&O&q2H<ILZVF;!ZyRl5tY8XenP6lh5&(Nabk#s>1Q}3`V2>bVWo)M444@Ywbn+hpbK&5ppacp*X|ru0k>C};1RBOcAir>Ed2?xF8-sFpVRs-|LIe_Xnc+8bb1j@;X?j3Fl>n&;=RmMT2BaWg{s0cX0pn0|X>W4Q0SV_rXko!XAwUELR)1k^b!7w)LcQSgRBs03Orj=4X?Di#AS@val5!XH5t!Dw$2Y-9mp-XL-#qI<xK0@%W$pTPK_Np9MJ0Yv`+X98Ja0&rpf0zzQ{M*&s>|7~FcM_~bR0{?4a0%&3aVPgLRWnlteVFGLaVgg@c0(W8p|43m1Z(#ysVgCY3VF6hIMgsq8VgW+}MqvT}QUOW=O<@9O|6u||VFF@e0{>580&HReb7B7iOkn{<0c!&PWnuzmVF646|7l?XbOB2OWB+0SdIE7_0(t*o0ZjsAVgYLZ0%TzUPXcmc{{mQH0aF5WV*dg|VFE#60(Spl0&`*kX##cMVgYUfNeW<L0pC;sR|0hnAYuXkLIG6)Q36F_{{m)W0e1pRVgCVa0%>9bZesreRbc^W0dfNWZDIm&VggZN{{eUcRAB)@0sl||c>-@@0Z#t{cwqra0dN8TZ322>0%~Ca|40INVFFNL0snOZPGJF90%-qX0doRwVFF>lVFFWO0(2R`VgCYBVFGbt0&?GB0d@jc5};xN|5jlEZ+YSb0sjC305<|MHUPir4KOncDv^NV{|N#B3IOg3JpU>n0G=-=D;xg+78O1K1||Uio-!*g9{^Vee+>Wu09ObO2LS(92@e1R09OkC5C8-KnJ+6X{{RI5iW3|O3I7-c1P5bva(2ySe4q_*-T*-XXJz|SaOi+(ZgXL7{sRFCVqt7-Q*hm7gkS}5V*y|Q0N>&d0s(fR-~k=)00AZx3;<IVHCr<+0ssRZ44@4RpjQ9@1pz|_1i%LZqhAOB&KCd!;t2wP{R#qu3jo?H1~cmb4-}ve72ygE0IduPf(-x)g$@db4;l)b5DJF~G75ko016QO5ef$q9ss%_JpTp&1^_w{02KcK6EFY<1P};cKLA1u9T_4O0U)Xs0|^xX1PW~y6owa~3TGG;k`Y56AsHVh2kI1;8We{c9;KoS0DVFd!W;mi3jrttr5!8)9u!3c00$Q0AF36g1r@CzDn=m{ry}Y!=OZD63n76e03`n~06G%@Cjch@G5|Ui04V?{|1<zP7XT{&DpfWlfEFZ{2_%;+B!{If8fXR@W-vfkHUJ$+8^A!o0YM1?K^kWY8gK4dAqp8Sq<~3HApb#AQ%O@)1POmZWMoKXVPw3({|ruVAWwE>a{kx=Z*&9%PGN2TWdt`%Wo2-4xgeIJ+W{bTZUsOf{=&c@VqtPFAVmFdyufa6bRc7B{LCQ*17T@x1PereWpiV4X>fG9p#BM9PfkSy2TNu1d19rYo+4p&Y;?~A6H{osV5C4gI)6cRbZ;O>Z?M4s1V(IOX9NgC-f3WBVPk6)B2;hBXJ>3>0YC(%C_>EDArlB`ZU_Jp;bU*Pa@=48As}#R2jCdm43HoPp#%y8Aao%2Q*?O?KtMulVf%Dp+M#TBVR>`=AZHr^X>KkcOzhua-C${LAf#`1Zv7x3AuJ$sZy;%Y9{^!)AZ=-L_&|0DBm@NpLIej-AA<LD1Pd%cL~?I%{bUC~1P@MObanr7VQe5qX>MiTb8}?`Q49lbZtrY)E+8PLAZ%rmVRkD(j$&jE0`uT(cW-WG4&q@TW(UL1AZBc7?Ew>lAZQ*D;AwOO86GDMtsX?alwvnXZ+9Ts;AG?u$Os^F8lWD)Z+B%cav*7Q9H3_ZApL^hY;R_CY5f2LP5)_b1OrWBcm@AJW)@~<W@cvp1PDZBV`*(+>uhs1!c*&l1O`L?F+v1CS7>QtX!QNyGX-)Q1ZQs`bZ>7iAX4N2Z*4WAzVzTAZe@2M9RMIRWnl(@PJsjv8V3qQ?+8?Ha5F$=bOb#L0U=FkWMo6(0-^s>X=iA31Pem9Z*+7DfJ|isU=1VzgapJ40mKC(5f8)%VX_tk4FW_L<OM^&Ap}h=CE;y#86YgcVo$;oZ*E~iMj#+XVMt{;f&Typ;sXHz0|3{nA0*3Q3AP|T5I-6L1P5VfP6ER~as$**FChcL0s#jHp#3EWq%brn08aq_I~+d%C^9QGe;XD62LL$$3PR@#Zf|zR3e*W<XN*nc1QZBiZ{Tmi1NLX|A%hn8B!Um%5&-}&{{Y<uJQ)Cm2iEE!0UF;R73zSnJ1ZhA+&~23Ar<Q20pj;h06iKYQ6~%l{RgH12pt6gzX*E{3L9b^3mX&7pqBwB76pMk2Y>~EK>q+yCk+4x7yxf82_6OofDa2H0`HO$5i`;N4GBR1024hME&#U?{{UeH0xAF>0DlugASeL076HKj11|t107o4&{Wd7zLmWx~-T=P`5&-W(9{gaQ|1>l<C;-q15`Qx%2LM7BB`qNTJRMB{y#y-->i`l0045BAPXIpd0)q+w78xK2D**oiG$H^A0I*5?6M!+nPXIF<O#pvA9vcY+1ZStg{}EDUaBOK~VgGbxWK(o+a$)~xWdsUGWpq>jWpZ|DV`T&euTyVzasc2CGk|3OMrm?$bVF!q|7>Ig4Nz=hdG}><Q>X%S1O;&YW1)Zq3{7ujb^B~(0;2>2NpnH|F@OgG0v7=83->-MB157<0Ne*}6E-ac0f0Ro1K{@n0UaaYH2^{j{TLWTJsd#*LJi*-00Af#GoY|N?iWNbH!BDLIvhgZ0FVSCBO_n~3jYA_Hx~c|0NURy1Tz2+SKto;e*^$Z1tvTsPQg6{xS(=rVq&L27p?yUbYXLA1O;>daA9|D00H6!tpd~l^BzG#4dWmxe>WT#0742FEJ6DmKo>zNA^@;F>mn;GL_7k3dI}Gn3T6PXJs|?4T)+bUAf*R#WpQ<Ba&2W%00aROz}^64!1wPo6iq<Y9SJZ03OE4K3O+dq-v$B%0&gckV{G?tV`~Lq3jqNj{{Y<vJsJSoDg6ZfzySgPxj_-#MsmRKI}%jD?>yZSRA2@K5lAf{0B?E^6b~TautF4I{{R35BLEOLJiiVANC59PQ{hkl06-!^0PYb)zbPmH+A#$sMFU>|utFg$Q(!zY;8#8$K?R}*c7QfYpt~mpDgZ(Y8A_x&elkFi0wX2>&Pu?)2LLt)1OuR81pf?ab5CwVZ*Sdf#{vaZZ;wC(1pjn-aAgDtW_9y!W9ve!U~Xn<XYT|BQ*=zA00QFw1pxsS0D1@w^#~{dI~GC$8~~x;B@j9QIECQ=5vL3T3mrfLB07`C1m20_5ex(jb3jfL^$SQLI*ou&06!nuKL%g|;06E!;s*fHH3p^{0g$2x69ffx{b52u3Ped(MPHvrPf|lgz@Zc(2z_H2MF(hMb3$4n{uYD);sgQ#3IPA^3Oy<z0I)lJK7beQ5HLCi07anh3Oy+ypaC}>7xJJ50wQgcK?DE@0N;*22R0RapaBN&0PiyskwDrg1m!eYAOl&WlVFMy9A^m$7zhDYDgy&F;QUJ92IT+%0~-L<{~ib}2{{1OAD#ffH~`fh0Ky0Y7x@DaAP4~jcVTICKLtPYGcz*)KvV$#5C#BZ02~e(Z4tkq0VPyHusWFHS3ev+C}1ZN;sK(7X9FAn1L(UULJ4FchNFQ10H#6*qNqW>;hLuq91*BMUcm;z;Wo=07BXNaexbwws~@!{u3`r%fFvuQAPD~`02~0>5gG@-Jph<K7#<^FrT-x_Jpivh6Aj-j0L(Bbqksk|`v54jpa~)X0V}^5015!GK&}FI|0hHM?>ZL%3;wqt3?cyj5<)Hi0Pj2(01W_N_eC5k0YsD_5GDIHG7o@kBu4-ye?Ji`Bmklcw?O|?0|x~YIsoqf5JV{^08uaz{{ROZ04oh53SR)f4iXPxKxQ+5>kbbI;2dGV-T)B)5CHEz9RLvkf2%4f0Pj8?uOK(?KN$d^utX7H1K_C<0-^)pD+Ay^yFdW{??4#<69BM9&;#SSpaP%+;4A~+Kp^V?6uY1q0HCl&Apa}?O(qIR5eX^|G8GOWC=MnX4lV=WNh<^34kQ{5E(72!1K{coBpMDTB@QA706f0{ix(d=I)8vV-pWAr1OL+i!1x0{|Kt?}1V_ZdzwQ4EP-%2yXhm*6XK8L_1O@WJnIQgaBL!n@Wnppz`3uOP#bR=0ZUh?tMrmwxWpYGi|8rwyZe(F@bpLZnZgX^DZe#yta|8%NVRL2gP+@X(#sUNcQ$J~XWd%Rr@c{8*-w04|b7_d;2UhE4W7Hrsk3$4)VgGb!1OshpZUp}USOfuC1OZz10ia=cu7Cyw0W<#1LOuZUKtKR0^*iH4Nm@XSJRt<?sv$PZL@HZB9sn!u`r%gy3(0`xEIa!bEqr6%00jpC8dxI$Lm}EKr-iWqfS|sofjIy$G$`8wKR*CB0x~uLZUM(&SF0c;2SNzRAQ@hweLz=%9smI+6<2||Jn{srVNU=%-a!lX8WjXT0ifOh3kWX&+A9XNpaFrv!GIRcW~(6%0X_tW#i62Lz61u40wN;|%ZLU4KitgB%*@Qq{{#zjaB^vGbTdY8`eERtWM%n4E(d=JLug@gVPiF*{{#p~b!}m8Z|`Yj1Qq|wPi8~+Y+-Z$#Q+211E~SiKqnzAgrWf;q6z;Q0R#?HWpq>E4r0HfsR8YPmq^tf3D++PI3;2O`{F+UZw?VT7#ZNA2y`I+&42(m0WmfJuthrUM+4_58fxxA0;51X91NNw&K3cdq@kieI{?8tF*%(kqeAZ*0t5*Z18Ht&`veRXz(I6$a%uNsb#(XS0|2Wa?<4>b4$?pY0O|h?Ff$7(0R#!3XLV_0WyB%;fDU~E_W;cl3^5%S<o`z-Gc*8~06PB{H~_05B>(~IC>Px!J)HsqDggZ;PGABg00Au<`bfb-n4&x#MgToO5gP#SI~h=5r~%g6z#K-IAQ>Sb0WR$wm4L8A<zfdU0I#wqMlD)|K?H$5-5I6;?>`czz-<%%7a|QL0R9z4{V)lD8vqFa*fx6=HZDM(H6}4k1OL4Q9|Zsh2?TKtbRcplaSaMXVf$daY-}9>1O!fifd&6;Z+B&K1O#yJZ*z16a|a1cVZUc?X>@gDCLso=0Rb8&BEKO4Ux-3G3>aTx0sydIWnSU;KmbBs;7<TSAiqHX919y0{@?+5Cv$>iAx{7^A!gy@1Rp4%c0_KYJrf%~D}W>b?==;1fD3~@2F3>fC<Fvq2$!vXjzD8;aA9L>|3KetX=QG7;UEeCy8{jJK?wlwgMz^SJr5x;5&#oE_Q-&@64XEfD*zs^0KW?r!r?mD;5_>sKc!$Z1^^iV^H&N7p#7s08v_K%2%CkKLk63G3}XiX-vJQ-^C0~I0S<l_B)~omA}<mkfZT+EdSQAC50JsIKK?y|1s?#iB0(smm?VVDI);EC!MD{RHva_#1#n|wY;6Ao1!QGnb!P<s3uk3?b#QiJdu(;AU<7n|aJ1muv;zL11pxuf;Q<EE0NN=8j3A;Q4*~xH0Ne%?HY^45nSwzw!ubJ^0V5`T0SjaR0pbb*&w#&)0tEmDGV<gC|0n<<0D2A)4*FbyK^CF{A^@@_`$Q}KfIc2X0HXZ~P@r@kHYo}qPXO)@LhT^;Kr6C@>pUC;01dPtD+V9>cOf~?;3xwC5dv)l7Gnl;aiDHzY{CBl104X}2|yga0D&C<0V)*^0YCa`qbzEpCIA619sIL_@!?MZNFzu9+p8r+fIAdwpuj!*6Cy>RI4&3wI`;tYIs!uyA~Y7S06i5P`v4n`U{C)5Jsd~?Q7RPw00$ocD-b0Oc0M2$637DYJsWU<-%kKJ9Z2M0BL`mq3jk3o1n3L|;`1~H-z(d!217=2`sv{aYk*X5bz^Ah1Z>FHVFZJ~s~;!t0Piys)Zju17&6CVKZZdbU?vpLBFAL+Ff}PPf<OR{J--Py7XUpFZ$T#h&7|%MJ}Dvq;V%v`A2Dt~A%+751M{mQ(}3VW1OPBKt~8-N96(;66Ru$ke*hK$rXCO*Gsew8H{lil<AH{t06Fpup#^J+#J&V~b5H+n1PNDRY->}GaAjp=P#@vyPz(w80ss%fAvXZG4!UxoCr_ab5Dh_rKz>i7Apo)@Ln<J_{~bdBc?Lf-KK}sj4nZj;0I=CVYJjVQIvfK*L^S<FP2ej602BfQ{RU)VZ)OAtMQ%TJZAo-xZM#6);`6H?NFXu7JrElK_XG=Y-#}1uWn>#^V}{`Z0eQgGBFW;_82q5(0$>D*VFdt_+9>ma;sh9J2<Ac@oeR|B0VNa&fYIU^{?XxeZEb0EL23VO1Qb<nVrg#wWJYptZBk`!e`IBHQ*>o;65#&_0|74p?g~A-Dj`4ws~{%A1Va2dU^RgO0F65z1YQ$h0009XuOJr6;I6MC000F6;|8%KPwxOe9zZF92LLX1Ji-S6PQySSKiA^wtU(9Oz%val4+2mml^G%Av2Kc>J51_8?53IWAE96u1_2>{!L2xcGx9IRjr3OqApRsoqbD>Bo-Gf1gCGe8v}EfInU+~6_q0IMS;-QY9~1pfq6cVTb@1ZV!y!4XnraBOK~|6z1xWK(o+a^GQRWdsV^KvQM^a&~EBWdsROR{9`CcDtYizwHGA!~X+MY-9uuXm8(dYi(t8+yHcFFK=W75vJg70f4Dt+ycM?K?+}A0wn|s|88Y>V`FS@bMtj_-N8f=2w`<}-)~26VQfeM0s!uYVBP=$s-Zj_K2Ab|usR|qqe<ciwE(YjWo~u_p#k{dtHT~7rvU|k0U<*{0RaCmA}$p;06sqalE82y0R##}X>*@rZ*Fd7P@-a>3;sd?JSrdno-HT;DjNU_L<l)E{{WsbD=r@ZSKS9=p;rhFRUlUhoe!hnR|*h8z*_|c{Qyrw7X<_dZ*0$GL}_*>fEZyzVfA#B00$YtP;YYt{|IMmRB~ZsWq)!62}o&VWdUMdWMB*f0V+c#0Yf79PXIbT;E(|#Biia90?eW^0L&r77LO4NEE|@9*I@(V7XKAJ00t!hCPV)eEhqp&4jcgg$N)GpIskD%|0O{;AOKlJK7Rl<BLD#`7P^7=K_V`l;71-s0Q)dE%Yi%|LIBR&76C&bH2@8T2>|!nECmgN)gK5nzYRG6?>QM?Kv}CnI|(8w2_ilTB0#$xLcTy72@C$<1)mE5?>HDWfP`Qw{;i+~AOLqQ7%B5Z9Qwiwp$7yBVSjFPX+dslZ0SID?PCOHbD#val393@CE?Z24DmNB%lRDfMaX_1wYxDnVFfHznTC7;sgP2K$*8ND=oSJ?=*cO@B1_p8Q_W%8wm-&7y|?dbZ^{)1pf&^ZfR{{bZIYdZUhSfMoFdtkph212|xfPEC517+J&P5Vjy&Hf<X!ae*+ExnKLUe459ls7m|PqK?*uG-vBB&4kagm!x*m+3@#uqB0{2IL%%aZ0Pi;vf?)6cIsl<jE)M_)8vg(*3m^ypzYOaR4Mt!KBVc(3Lw7Vn1^=W33{#L`=SyXIYJ+ft1VnH7ce{Y0;B#|jWI^<zA*PWECqYwaX=VLv8KDUP0uBKB|2#GTAOSr9LVFAvK7u#^^CYQ2`vDR*A_D-PFD!mppu-vw4=^3v!SfwO+yaJSo--^fzaRjxK_M$Mq6OaoBoYY&6r}}Zzhz=|X9Nmrz;)knc42IFbmSKRw7CaV0Y2p6A3g%60<K8nPXIjvXafRp1e65u;~_Qg;2R8Pq2V?021Y=EU}*LWZDD7pZe?@><ZopRZUIu-%iwZ*V+;cBpu{u3E(IL`IuIlwFMR+uVgoS%Iuwh*{{=Gu1_TrbKK}p{I~gnhw-0*ap(x^@nKdjkV_?5hM=%lqu;W7r{~-XODiuEfN#6jOFf1--0Pi)w6aWbTusi1h2>%=ap(PYL06zZ!od+*J2?zlH<t#uKG6260`xFgqU_t<dK{nSGG9a?T2`>VxAp0c%S|JJmdI=8n0zu3GD`$WU9RQ)<CJ{RTLhFDZ1OA#|=nFOv09OmC3B3RSp$&9_F#-S%{{RjELJJ%KS8oXn016GjJQvVF`T=4G5TM=w2L}L`?=};|!8{Zr3j{hwK|)su3IX}y1ttyJVR{fj2oOOKI{+`pp!*2`7vV1s1PD|AWpq<;Wo2Xp{RsgeZf|mJVQl{d2vTKpWpqaWPgVpCP;6m&-&1gMX>I|+2tw~+V{32#U<3zJ|6yljZ)|J?1pjn-aAgDtW_3$$V|1bh&EN+i5C)^4LvL<$as=R{Km|8+VPb^f3PXlq3PXPc2}W;nV`bGq*Kh;~)Zuj3AOHhL;sF45AX=ft!vS-kcRw>eD4^m403v`s$AAU^?=ur)K=Q*KJF7tNG!mi!A0e$n|2+{K0HO#0O#Y!jHUk6+cW-k0YjYPMWdsdFb@_73fJ{JbWpZHz`wK>JAx~yjX=Ock&EN$C029(d3<bZ{9tkc9IJ3e(K4YRk0IMJ-JVIe7+5%u90$?>2nxIbr?>-+u01u(`1S9t}BRmh`0PGkby&AG$FaV+nQ=kVo05t@o2m}gSp&}$>3v(@lBH`b_0|KQ0U*#)07%bL63Yg%(C^9NF8Ww)R0lcq><p2o<04LqSEdL+?;SMhzF92VjFexn^-2e=qpx0Lj4c!6`#$fn0uLl4sHwnT7iXbKXEE(cpDJ&cSo|QA>B?Vdl4rsvRAqRZ`;~@wD?h!nU0QXl13S)qtEhQ~_2B0+Rp`J7;F$}|93Shtu01H<j4pYGELJ91l3QXXhG$zw38d_ih;R{=!R|vlh01p6}FTbD={{Yn<2rdaZ0Pocy2rU4>%r7VYbwMWp9{_p`5kCw75CE`0nj%}H|Gfk<0st8h1pf+Vb!==yXkq(uXHOt$ZgXL7|7A~Z1P5tuX8%)kVQmBnVqwE<Y+8f&ru8WJ@C9@KbZKL21O;Jf>1_!BG3f~fqG)Av-*f~7cXJG&3vT~!Pj+Q;b7*gGZ*&9*lHo^hW<a?G-=atX009U{1KRs31pGtX1{5|dO$D|A96=!9K_NNwp!Xvt0m#Gv0pbPi0Z!oaAHAUt033G<8x;GYJRmHQ0sSfI0UQ9bA3h~+P(VH$K9xW#E(JjQ005u>FC;G(Ij;at5(==PIRp&`dmR7-3_TDV26m+H26AC{!e9guXg^_YWNc+ZCct&!!(val273^AbJKPU~-@Y2CZ;`AZ2o7K>{<tt0^Cx;BY_zVt_#sAOYv%@nHfw;W`1Y;3xoKmlPi{P=X9}B+jJ-s%juV2ZAJd;sm7t1^pcPq6Pr4IwCBz*<yTSJ$zv`64D@|-3q)QrX3F`<4*u7Jb$2lAQogI2j9ZtAm0ZB26uBApl$^J3PfphV{dM5e#bxr1$T2ubwnWOM}Zu`lAs6y;9+iW|7m0d6-H@pWdBBKa&vS;Xleg!WKU*8Y+-YMa|8)jVQgzjqTYkR5d#5FY@j_VeIYr*Kmg7a0qz3Ue!v_+z~TXf1_A(ALJAoiK^_F*0O^2zG8_N{9smI+g&|zSARGfQHY$t)LHVNp%rPkd%rh$h|A`9>00%Jub^iz(D;EIB05<<JJpge-CPFyh9soiUB9TEJN$&tc4;w-uA4LGq?>-y=?m<8SRv_O=05Cf*mB2zIbw&hW9r(iUKpf*Bd+$Nx;a^H5E(SpD9+F`{E}Gy<EK0t|;_ebeDkz8mH~%I#0DAxjK0WUMR}U1`pjQwT?&5$~5f;*5LJ%Q(0-z9mAj&Hm7ttX1?>!yKz}yWJKl?QV3Zf1GD-R^a3<Q7@eE_)OqJc^P&+H>4C85F<0QU}G0G>E1G!P*<KA^u4C;$O59;d+E-w_i)HwI;3JRJW^0PjH_01*JcK}8`*BMK~}JFWu2FhDFN;!A2kE59B~0PG|p3ge#dI4Cq69e^hh1b+x<Z){{tZ+d{$2|Z^JJ!MjNfKXv?a&!a^K5GO90-$?kZePGqZ*ytc;{ORvVP|e>banq^WdsLdaBythY2`ozZg_#fb7kXYZVcmR0lEnXK|_C0RY_7s1PKtK|5a{uX>0@xPP=7v(1A~PZsB28?_q3pWzFCQ00F-p0D1@w2xI`T{X6<10vrILB@q8Q05||g8#6Q<1B2e+00bR@fgeNBVFyAWKLdw>00+Qk0R|x33J%3VussRF1|Hu4vLQexP~jjzItB*^38V)AFjT_lCBD~S5*q-w4(8zp`1_>yB!$HVQ)P5jzi<QtZe@4>2m^gi=mHG_0eS#~q32f!2^wHvA@4L4{+i&hJ0U6ng$I7*Km!^80VWkyz!VlDXCXdl-~eZ$A>d<xzXt%YJR~c@KnmX}04M;fJHYQY)fP~|@9aPZ1mr>uzZ?J&5d;j;;J5V<1w$%_;0hxE0oyDZ(7>=khu}{DS5PiR_8=r~U>0D&-U`GPDF9QnfD8=(0NO7EGXM_(=?4H{jzB@pf=dAX^9?}P01crI0IMN#ogg+}!PQ_g3poyh`wsvPf(|JFE&$uBD4}3H91#GBI)6kqKmf8PMVBL=PXK8#MO&c~Y*ha<MF6860KEjQ9kyZK01)B@5bjax5b_V^VKfln?>QO%W1vwj3jhZe0KafR82|zUgy2lyLpT7dCbNJ#8vYUh?>iU(5&$XxH9kEhGXPf&{SX0w2LMh0t0(prAUhlIz=%0SHUB>V5H?H=08~0Bpc54=Q8Go6f)%3k7X(y*6`%_M+Ad`VCZPuS;JrdL4<f+#69^D>puY|j4Z4lsM;rkM04yAU>bC^{(h^1w01`vLdk+;%K{)`<8b1L369h*9?>ZO&6!v{YL>?rfKMC<cv<%=HWf7miAOMa*5%&O5F~Q&+04olABMTg0JUt~f9Af?m1HA<A1poFF?*s*AaQ5K{b8hotaQ2}1;AdfNW&Z>SOlfCmbZP%?X9NmIWpq>jWpZ|DV`T&l|3_?ZVqt7kXn$d3Z+CM94g)~{L}hbhWo~3)>uz+xU~C3~PjYF0X9NOfcmxWBpzm}=W@gJF14(oBLHWc4W#k28Y-R6Zas&njf^!4~&JH332y+X9h`<L$?`~mYYykiWLSg%JWs%|vLt%4tz7L}S1L6Y$<^b8R5g7+O+hPGRK>@J@2E~V<1Rewe<zTD%AU&XPU;zMeJ{*5IFCGBS6afkX<pMil0um?>$pGR9kpW<U^=175I`v?=!RWsUG!6iT3i+S{-yHw}DHwWSus(ckpmc!+09OeN(Li@X2^toM1q2BvC-DR?|1adD;1dM^T)v6GCjjp=6Qn>e>oh3kLO-Kp*%2C_2t5GrHH+h?pzk|35)z>AH5QD(0b}nG5Cshpz+ECOT?!#U0V^7Sp+Jj*{{k%l9ssK;B;Np`E)qjuz%V)P%HcjAMCqak07Cl|Bg`OAE=mBG{{Su=Jperx96JD_qXFIk30UBMAo&XMVo`w$0Qfi({{SdL0KhvIBi?fWutOp#k)RAD{{S-|7%Tv`B5z0t9Sn{@2@YTY{Tt_C_&E>&DM0%GqF5jRiV_<T?Ga$$01e>59{>(#0I)`vfU-eC6%b+fJ{?Pipce@L{r(DI4=DfvG9LhM5CE`81ceqP;XuDT983U07VIH8y5j&n0if?fALrnry%!$<rYamK=tMmJ10bs|C;;z5BEExQPXIg}P3Zt8Z661q7a4D5B25F}-tqxoOc*c)Kp+6`69A$ZdjO^^9rnp#LnDZwE+zo)>qH#8VM;GxP9X_h69>XDK{tRPC<Wku0b~HIB^5mig#Qv8P5?709WieJ0W}wVps-3DVE^|qEiM1u0G{tTC^{a7zzh@wUkyWba&qusLv*13a$y7nRApgpp9BU&Msjwd^5zQPOmA;%R&OA0a{mQC;MyK12^#%yc|uTZVR>b8{B>ad=LBtGbZ7+c1Yu)uaG+ysVgGG#1wfxwXuSX3947=2NOf)hVQz0}WKwT${d90*4n}EiWJdpKa&vS;XlZP>WCREVB?J`%D^LGsLu_Gla|8x&NM&Jc3;+pm0if?qVRU5=fK6d%|88k?b!24(1J^`vbag=k*Wf5K|0^{c7XUCbDSB9-JZYerFD)(qA^kef0yzLEGAcFu8Ww!x1#n|wY~^eRK>=D|aOXV`8}|VO3X$MxRAFQ1Yiwl%Abh|M0GYclED2%nG!yNiI{yEH0~-JkFFFQ$06w^)919o`@8Ev`00JBUusY+y_7H*dA7dZ|4gkQfJPjf*QQ<j);RYuEg+Xo%fc*#t0s<)@{uAN^2XbX`b!mNa5Wxlq0fzxzp!ETQpeFudQx!Ec{Via?10DcZ3Jt0cLInXs24jE+0YeDq0L~ZxfCJzO0NU3p3^K}q1O>th0Q~_7pbG%7J0UF8X<-Vj4GO0Y3c3IQwGRbD5DWkfHP)a53IJdM*P;(1025&ig%(8>5etVB7F-A6V2fZ0HFXmd#}prs+A9PeL9GWKNEHAl1r{7f7pezx1qXK+BgYvd+#0GQ#|SU>8!zn~FXtUP6Ner;rP?bCIbp&8s5?M8V;ct_H)kLl2O+8lX9)*)B0lFMB9aEG2X`b!XC*2U3J&jz{}UVu3K=B?3;#w*Qd3kQR8Rj^Lr4S(L1bk9e&A$fas&!Nb^mm4AVX+nb9C1P1WuH}HvxikAopP)Vt7CxZ*_G4Aa7<MbZBKD|6yrzE+9^2W%Fcn0m67AAarkU{cHrG1PerEb7OyUX>fFDZ*B=-|4&Xu1P4oHdHrINAOr_QWoBW&b!>D52tx{hV*Gz#5Q0>1XJ>3>{{#w9QcqMxL;qAsPfi32L2mbSX&?(@1V&kJ|8*c_Z*C`aAp2);0RVSyAZBv!Z*3rShk|n;Z~t;2b98lWVr>6qAa`hGZXk32Z*667Ze<{IziVl1Y;z!*V08Z=d2e+D6-09XX<}k*X>Mma`8o^Yg5v~6Y++|!4kS}(X=SDWHx&STWo{!Nb0A}34&kwL0^%RyA>(Fd3PB+6cWHEJBB5z=Apc@-WO)P$Q*>`{a3De^Km;%WLHs0R20~<IVPq~K|3PkfAY^HCbpK&)V`U&|W+0zwbRcPS2|>N!3VbpEB}EBLZ)0l-1HVU1Wnp$@2`F;AZ)_NWEFfYspl*F{4*?)$Y;$E5VY(uKYYPB$Aay7JY`zp?bZ>QIXbk`a-wsZ1AX6e?AVghd%s>PqRR&;TB*Xt8a%pF1bRc1$W^`q8AjzOTAaczhD1ZbRCWr^@21EZ(O+rso1O!CIawq^O0HGb|JHa4f_jh4=HG^RwWMzG3Dq;iyO9T%Ef$tzjY-t>TQ*dd=ZUid=0wJJ6p)4RdW&<Jtz;$peOu;&U_ynL(Kqess0ZIf7{s;m?a&K{UWpu}31WFHs4q{bgVIco(b#7;6EFg25G=O7UKp<x0;2L2dKoWooq$xp204U&FL2n+Rd{m%B!es<AOKvcL{x1k-Z*q5Ga%7(%X>N0LIiO-8Wa1w{XG$PB0S}=73gTk{0oS15$Hc(m0s=w5<t#cEEC6vq2`Lx?hS~xF0;B;N%;Mtz0R;f7A0+@+`v?i_z^fo60PmSJ(*b%y7Xs+RR>TXwRKr1VaBO+*q5<^-2Vf)zWIYfX0dE8eZf`(BLqzhx5E8-=EHf<x)CXx}_dy7;#6m(4Rbh>Qjbi@c1Oa~u0PYJtEFl!6_g4uC|A0>bI~@N$04OpmH5(YO00#g$0Yer5!xx_WfdT{xVO&7_Lkjo-L6IXK;1d7>WdQ%(2R<7B6FnRMDFC+-0AU3Je<}cU0Pj2*C}95p00JZc{uD(2F97d882|$S_W>>x`rxobA}s#^-T(y<0Pj8h9pPZ!00$HR@Bcv|00;o@LL2)42>_rW015!G*GM8O0stBTK>it9Ni+r^2NeVWA_T$zLmL1K0PjO0`UJsA1i?cZ01N>C{u)X(04owFX%7Wq3P}wLO%4DGLXRsECJqYi55NlG3`+p83grq4;}oD44nVad6rn^9!bBquV6gQ{55Yta!W&CA01qn@C=eA*55Njb55OoDNgBxy!wwJM?+?HPz@iV|01v|oNDsvmB_MtO3IrcA8UUgczCU0mLM$6RFk%n?0AEZXFaTE+^A`X#pfZ3D04o&xBM|}u5dd;S1oula90mY80Pi;c6aW$cPXIg}|3Lt~1l$Dx81Dc=3mQn`PXIdq96<m*6B_`x{SN{FHWCB`Q)!=iWd%RrazFq;1n&kzMsnZ*4ODOcPhx6iV{}t+zhPr#1P4|DKyUwYGXw)}Wp@Ps1Z`n-Xaoac-(qtF2Ur6m1Oe|@1P56GWmyCV{aOO$S_BACZ*%Qw;sOIronQk^Vb6F4KkyC%bl?XD{{S}tLkvIwCEqImR|g7wz~w9dIvFegusR_t_C|mL2Yx~W0I)mzA}SO?8~}GM6!#@R7=q&OGZO&!1pq>dKu-WY9DP3+Kn5KE0VXFQx&`1Y9)dy&7$KlLzZ^gSLJAom#6SK4pxyuo2LReCzXdY@4*>!IU;*a<usjYxZQ+?RFs(3Nfj1Uep*>lk0RI3B9ssf-Kqp!WKtKsVnKJ|=7X%=Y?*!mepakO$1mt$%PrCp<1z|EUFKGcb&IzIKHWgGs4JE4}@hB631fdbc1Tp{*{2D+JMvws_BMk)q3v+OCX>N2z`)_hFpaO4m1O@wJY_p&RKl3v){WAbS1PMcEVRHLnW7psW2uO8p{@7q?WCRsPX>R{yMrm?$bVF$WX>4RqW<zXY?Q;iUaAWjA1ax`daAgD#Qwt(PZ~Ja^>mg-w1O;?IVPb4$1PKj-`XRpr2xfI|V>lrI?*ifj0fvC(D?84)fB_{GvVgim83E4(4pU`CpcJ7~blYKcqd^1$PJkQ?dl?b8K+YBb00rUy0sz$=2rUUa9{|BRFgdzF0%O9$u^O6y5rfJg1PlqlLF;sM(SUUcf&~HrRS#4k0XxG2LBT9sf&M;#aXcP6FdqQ-Ff=MVrau5CKfe(xBmklcUf`7f8x0;VD*&Ab|0_EN2mrqe4*3XSg2EsI1PDT5|8r$fVRCc?1NTXDLB_xe2mv<#0C7AWIWHvumoPOcGk`irAjhBpf2$!T0Pi&w(BOAM3>r3oJsd)2K)(VY00Ai$B4DtYKBz#ofiN}`0c`>h#Ts#-6RY5Hpl<;0H>y>k??B)Nal|}vz~val536|Jr^$kusu&?{{R379RLt9I{yX$L;#IDBL=pxK{yyups+t+0t){i04oX~2LM;I3JtCR!=bAo6vIL8NgzKVL1usm3IO--Hy2nS)guWqe+@VQ>>48;fB^k7$3Xzy2tOPE*AqS*!(bA_VJiUD9wLAhf&o5p07L-)B`*MuKngb-{{TKi7ywrb5B#b?AK|?OF9rY=84OKH;N=7kO)Gom0S2c83uaegSi=P50tEJ0@dkC;z-(Ux3IAhnZDMaib#qMlLr!3;AOC=TzyaUjc^mma=;;mu0#e>%{cwW-1OWg-4IBRe$N*6?IRG5@3?3JXVCWG$4!$*^Bmh?s6IdY5`yBxRA_M@=9RMl<Vg&;t1_5FR0-yuqwFm>|36X#b5$2#CRNUd@pbQ4W3jm-Bx#0KS01oGa4*+U3^GYYQV7KD1L?SJo1mY0@q7krQ51|tG0I)y;puY+e3+l3<XcRyjX#waCIDQmC6CnUs4G?UA|K0!!4gl{val8@&MLz&aWL6#~K*M*z+m7a#-x7a$rJAOHnG7a#@z7a#_}7a#-V7a#xw<k#Q`p!0wTpca4&fEIx94Hks(-~zx80B}VA9RLLh0Kh#HCnGi+4MG+m4i+I1fd3KzlNA{$8!Nv6<}4K~C8b~m`la9mreY5P0{{b8Mg~R!ga-qJ2C4x40|bNu02)USCHnvuAm9%G7y&~6JrfrIJs2AR{{{d0&k7g>1io*=2u4*@RG1)T_XGq^&>;vxZe#ywZ*pa11PVj{VQxcjY;0*{_hkeK0bo&eWpe#_0U}gybz^7*n+Q#sfNW)(00kg(zjRY*VPtRAfJNtSb!`J-qCjb3Y`zMhWp8c-1qlFe{c_ps1wY3MJ#e?9*9zf-1Pl<sZvS&|VRB_|V|jZ72NK{-VRCEOz*>Z$RHi`$LZ`t64FKq;;8{Tpphy#-0s?veVgh(#0OAJ$KL8d3W)C<{;BA7xx*$6R00Qu!9CZKzLIVLpR|yP*Abyk}1^}2p8Xwr;Q~<&Oqz45<2nMGK2B!52;@}H>Lkt4PGyE$62|x`1I4%?n|26=M5*rB#8UGCg40C04ZDstiK)Ip;R0IJ~1oHt_AR%l(1O-cJ-(zc31P8{zZfAZhfCo`^VQzFLApHfmq67z1b#i7r|3UqO1ZZ_<!axFq<3V)x;K2fNj0b6Mb!NYyZTi6j05J4ML~;Q1NCLQH`a<+X3-m*|K_dY4LohWfuSfuY00bTY0VfpwU_aak6E-adufny!zW@dw00Ahk!aZ)U#7_V{s(`B_wScCeKnDP^!SQ1|t$_01LP7v4IH2MH0Obe=ffW4!TcRoeq3<UUJOI-`Jup0OuAl)Z6#t?jEyco01;iBv*A)fH#vlsvzk2eh5cb7VZ*O$cBL1q31PnrNWO-KIW&Z$aba|vG1PPAj$VX*#=Emrb@*oTU0Ocz>7%Tu+(+3Koz&GUr+~7VOZ$1F4Agq8i6jgwk@2x;IAUYxHgWv!Ie*_C`Z*FH$a$uinV{`-x0fBZRa`OZPU%@_r4h01s{{YN0D*&q|C+h(3jlcot;6fZl{?b4K3;^0M1U6d$54k`O0fWH;0bsoWhQJ2^utDEs?*9ryDklJ*FE0NpA^@H-FfAnd13@p^!5l*XnKt_`G!p=xGA=42y8x>M;O{;j!r(&v6!C%{N&-?1E`B=#z&sNsIT))zzcm1&697yB0R#603~+>?Qe|XmyK-e0fCX@4cwq_r0)ZG|YXAY_3<aj{Agdo20L-F7Ry-MgCPF~~nKLah{2==Oz$?rE1s?#iBJ)8gMj}{inK3Od`val6+6KnETGuspt1fKLEA96&DNAnQN?1BM6#ga-gL^i+Za1_=WMdJ7K=@D0yigAqauK?)!M!`~SY3ojg3B2NI$Um@=|6xRS_pdCWKDghxu0HO>L;7*qn4F@Gd3lpFY#VG$YEj1k$05CZEaHB(J0`EH&01WQ{?>rL#pkGBF^(i`_4b&qJ0Qy7UJpdp8KF8n`BmXxW0R9p}EdaOgI2b*^q77oe*ylPGGv>fZpa6>(mm4oOZ~+fv$zQ(&?R2kU1$3Fh26AElcV}gE1O#Sb>1&eUI-_a40dR6}|8R2z5p{EAQvYRPY-w|JX=ATLb#ivcKw|*GNqcT|xgc+IX><jl`v+D*fNyd$1OxwWWp@M#O<`xhZfSINWM!A&1=j%q4VT~~jUqn)|LzJtDIov>CT$gFfUrA_L_!Kcfn7Z~pa1{@lmQh{;Cwq`jsZOq8v_J*ZT|{XWq5Q#b#(o7(SQ|3X>MdjKWTDvbVF!?2d7}~2mt^W$K+rZAl)%ufZhND_@FixC`|yxWXfU&YXAfL04)HY1OQhH4tC)IW(5>H0|LPZ1A+(yLdf69*!u`jCr$)<WpZ!(1PGGm0zq^H2LDoFWNCGC1P1#;Zyg|Q1OrrWZ*T+$LYE+GWrd*MZDDk11j<7NLVIs`$-)K#0Vj{Z_ay-DkH7%{dJ4M^3VndEJtAtM1D_rMP81Bjp=Lus`yxP!K?nfvHxux0VFaU(U<9HE05SmokO3ki0JjbR{}3=b1^_?+tL-70;58L*;7<TUW^LfBBAnnUzy<(xgWE(S1Zh_YY(Wz|7aA)7^nnIwq6#9T;(0a>VFL%+DFiZ@z&`;1yBsJSGytVQ_XY$IvO_~}Zgfv_Z)|KHp;ze$w7|aY0|;hyZevk`2ES)>PjYEzkst#90RRC410y{I^#O_?;_U)A0WmiGwq&tD0R#k7cVWG7?7#*A0WbuB0siVk0svDLH8U;T2B0P&R|*Y9zyJX7vOobrk3<5Y2msC(YXATP;Ryvm3LXJMj|%|WD;WX8pafwIu3dl>01XNT4g{kFItySA1_K5FqJ}{V0aXwIK@JGQ5dxtK3xp^H08W4q;1Uaf1|*;hiq#VprW6Z@6$^y`0Cc4Q6{P_cq}nS52(AAO0E!bF2?`ni6$A)GMNCOn|3y++1PMW8WN%1iVPs8!4N$(|{UE$zX>Ml(1Wx~9ZDj;6LS=6MWOE>SZ*_7Y`oKXTG{A2lcW7_#Wp-t90>L0*a=&FDY;SLC24EonVRQrwL}hbh_i|})hN1*cPfmYD1P4oHd180~{{#m_WoBV@Z0B?Y8x27WfI2!s&vkTfAP)l0CIm*mY++{v2t&@mV)tQVYZO9MZ)a!kY-I!y6Qv+ibnkLyZf9eFH%M>)cOYnCa%3QB_jDj)6@e}wG$8wIVHTljbSxk^_aJm~2%vKyVIcQyZ*~-caBN|D{%c?ZO=)ff15Nv3cp;!=V`*(+yKHj}LQ`yMA)yZMRApgpZ@^`9AU{uTY<UDD0HGk`-*0zrAaewOAY=1kZVo^q;$>tYbhmE+15iK#1EGRf!w3nW08k?83Q-^f0el2+>*7sebY*h{8UFAC0OAM&10Vp?t0I6vb07i9Ko22%FcSZQK>({GgCILM7lJ`PA}U+~?F9c%06`x?0PYKaKq(^t0Vo%w09HZ43>gUq1!15D=YY6`VY0#Dqe2WD3m`&UAVLJ_z&#EC6XAgWGXU-lK`A5ve?ku$00Ai&<G{N6pe^ZSBpgEXAqV>e2tWXHPjF>!_XG$+xd2UXWM%&Z0Wt&yLu_gKJKzIDzyt+jVRUn2XrI7!V*&s+D4_Nk05cQFz)t`_9Qi&0=*VCk00AWw>d0X_%qAGn0zd%o^EMK{fNmnD9uOPul0q;vDj0w|96$J-!;^xipalS-BM^r=06M9_o}dB%rvX80A3v)=68%7;3827F5HL#zAOHqM2HQfv2mr7<AuFAttH&QC06l>xp>W^<Cr=ar2>{zdgrGB>!W|FcKmjKf`=A2irh%HJAte!m?=%fzuH_3?0HGxkKsypf3z>qw2dgFv1PMc3;9>h?bXb50NOf&t-)?VdWCY|>1O~c$fNaQM1$T1=Km_*&cXO=(ZUhNe|6y!vQ*dQvWd8&TL}_zlZ*J{w```o^t$<K+Z{Kiba&&nNfNp31Wn@!nXKrC^GXw_)!304GcLyb}!0!bD02a|mFf%EtETTS9K_NCEAS$B*y#Og9vL8MrMq*Dl06-!GsjDGYK+a(60{{d>GDhJ5*%DV820YxN1G)kNNufUj1O#_;PZ%l^NL2v9VFz#m??*&BM?ld%K)^KN0$~EwU^N2Y1O;JfZ3w^%Zu@UfnILm$Z*O$`#DK`)0suDxGB&>e=?yS53unRNdj|(mfE*4P5jdg#PJjXc+yxUfE4u7qJxTxo00YWH1mr?sQHB{&gvx>eCly-nVLVku3mR2IL2cpHA8}w7^CK+hqOU)helper5$>uX;0FUCbfHb(AqqkZ4D$j{0RKH4K>!>J92DaK2zX@v;0EMA6%K(e3giSLkKlZw1SWYSJsxtP000Ugb>Iu3b>RLE<U$t@F90w%<t=@nJ9i-e0Z#xvc^!CS4qzP>01JF#S{&d$ZiGHUenB!)K;2NPf=6{}Q5H>a+hS?BKn_NLAVz8ba&vS;XlZO@-nu|<bz^A%q(*YS&S3~gYfNFzAar*G1V_+e1yE^&Vf_mL!bNUpX>MgN1O-QLwgCnK!~4KH0t4_ss~#m6qDz459wv~aKtJH#00I960NN-7Gyo4WhF}k)U~)mQI(S61qGttgW6mI2fCB?7fcvW-kA<rrCIArsFFFPQKmgehml+2<Q9=QVq6Xp(_hWKpw%|}`d2<tKW4ED5U=vU-m_T9;zXt$L5()%j1U-=-oB@!4o&W<>Azfe_@_=RpXaNQ11Ox|TFLiQuWnjP!@_~Wj|7T@WaAX7sX>V?GVQvEf31S(bJbWS}fDQu!GDrYyqyEL=4k0fS05CRwqJu#Ic?Lo=#~^zlCQ{^?GA%G9fV-j$Ou(=`AyWh1w*UhO1LX4|D8K^W5CHEu6jw<wH$5vygx&xJ3BaUH;s5g@00jU75diz|IR)X|2^2Xm{;eV+L;xr<E;aui769G=1_}VJ@7BNv08$_-ec%oLTtGb&8vsHM9sbGWFdRex6F?sSEdaL^0AU3Jn=Jqk06rY8pxYoE=}8Dc5+OeV0l+;M_aZqQK|)CYLJQp^2mm_(LJ5Ee0RJ@ry#y=>00id=1O`lmKLZ2`X76coWpkaQ5lwIZb#rAxb#!!Zdu}n*qYh_fbfm=pX>V?G1Ojh!w$^}bZ`c3{PzL~Wr)6Y8RsdTdWr*Pbg#tEW2A2S4pqIyw07HLob#8P71xw#xO;lF^1py;qQ~(E^BL4ya)g1{i3OM@!@1f$+3O+dq>jnc2sRjq2X>4EqUO)*00U7`t4Eq@p%fRRiHV^=(R|^SSKs4YCEg%{0jzI4?7%u=<3l6T>;LaEU1ON^xV9u);00ANh0pbY(VhTk71LX?=AOqtFqYXTu_ZR>U1|kgrt0c7L01BWF2qF*wL_i1r34##-iWD6R3V#|A1O!lFa(6)ePIo~BMQ(L%1YHOMAyj#AcECa=BJTxLXkh`M2tjV|V`y)3(1Al?ZvR7XY;0*{WdwZ)0bo&eWpa4|BK=f@!2}3RVRLi;Y-MwE1PVi8J9Bggz+`WC0-@l5U1`(64O4Bn0BDe)|8sO{V+004WAkHWEP)DOZ*l|-|5S2eZgX&9a_?nsV|j&O1_S`@Cd6PT0K{WKI2G4A77B*~KgU7`00lYN;y=*B#{r=Ly+Fu8_W>pqhrll*E*0N706sqyQ$j)s#TaJ-Ke_<HpTUPu0QWl_Kybu79zg*2LJApwL>d4-KHnAq?=}=S0IMU-CB0$?0Kp`Vzy}0P34VcLV;|u7DhT|bpJ8rqX=JeVE?{YQZDDjGpbtTA0U_jBptpi#{AMH|9Rma7r2%!oOF>A10s<Ca5jY4r7!p7he?Y534BO*ELtqn3;W=Fr+yGxf9Ik~w%z%GF5gY&kEEj(u+ps~!;Gz#ufbk;T6O3XWL;%sD2LMko0HO_hz%C;}d;stM5kM({p$-7=J3JeI00Ar+kbwvw_W@2STwntLo-cPTG9bLbKpsa2fqeyopf3QcC?*B~{(oVfG%qY80I=Od)I=~lF*#yJ0B=VkGdl!e832s{|2-K13jzd1L;pt=09O$S01P?+pbp32R}l|gAdz6Ul|Vio#enZX8v*b8KOc=?LKPqY@BKjm;z1w)5dg6FMItQ*;1mE70QLmI695Fm000yxUjY6WM=}Fq6$4_q1Os9^074P~1mHpUApjQtU>7L>{(l)sGyp3RCTqZd5flIz0HP9gApKVXKp6lyE*up9J^;Wy79lqh?*K49GEyQ*06j|?8=W8;6a^4~DxV;|8xNpBAOIW;;vN40x+z2s03HDULKY$b1_Tcf|3?5q6eR#val534=RvPA1gr>;2HoA8Gz{=gkc8Y5D}mtDFD|i6euHLLIR>fA^IFaMjSwT6&Vx&{~-XP7yv>6%KsWZ6Fe>e0W$v~03raeM<Oo&0D2Y~6#yXvzeq$h0CE}w;6Q&AJvsmZGa>`v-`o-tLpjDlI~?y$074k@12953x)~x(86xjRA4dUC{~|L0??NL0Bd-AOMIZtOLjnO`_fjS>6QCq70RI0UPdWhp9!)I&04o<O4gzpJ??@IwO#%Q;IRKA(8y*@IK*)d~AW2;*{Gj?#OC5lEC*c1gBSk3yLLVcq00B5B7J*F`fTH~#K0qrRFcbj(`yo&X;2JIy0DAWwAsiV3I{-W({uuyA8$>|>0XpR=24PPf01JrkN+Vi9;UGcaOd~-dP(dO45FbGxR}dQj6+Y;qQ2_5sB`e_(;MW!aR|B9J*yKVS?^6JxA5MVpPAC2!p;#(B0PjpJ-XEY}RWCU)KqWGt0RAFUJqCh;Avu0Np(O+cLq>9{f&U6jZ*OZ>Wn;d0fdo}<X>_arZ})R)ba@~I14M84bOZ+jgEIsLd3Qm0Y1H6Da&M<Ve+N@_a%N#;u%P!wY;S-722x>U_i1%=wgd)FZ*u)@sXzr%X=iA3{{#bWWp@MtSpNh8S_B49a%ul(X>J4rQ)zn7Wd%RrMSw-%1PT90VQgksX=HToXaoUS0>=YXZ+~zE3Q%uzbPL3v4N_rwW43_6fMMxv4WPn85dwrpX>9zMK*M4ONp53ob?U$X3Id241Or56bN;#jWMOV}b4hOhb97;DV`Xy%dq4ycC3kOfYrEk38$bsQgaipqVP{|?KndUzMige800RM-!2G)*z(YL{8vz6b^2cFo_n`xVAS3`0`wj#5q3I1UGYkJJ0R#wWZ){}mLSbxdq#y_Z1Ahbn?g~IDBa#63D=QzgLID7Z689Sn3<+UDcVTJebPWRs%7P68PXIj296kZ&0>{D+fC2>n33F&~cT#0x-(zS52XX+xPj3FO;0FN!6$54uy*T_J-T(p#uf&-1KN@Di0Kx?TR|&lg`@jGI2OR-I2=f5Wi+}=w2>_xBEQ!Gb;0gc*f(rn{oxth_U=4=g4t?M^7XV)m0>?8K2ci&;;P(^^HW=Xv2^kRo1PpU!bZupHzhQJ?Vr*qg2L%6mWpZx>2v%jr`M_y(^&maqPy+^2dNZJ8LEw=Q5fK1D`ve76g9t%sa$^5)a&Bb=21sSzOd<_dWped^VQk-1aAjp={=sx(|7b#QcmxMRZ|h`v0RaTn0B8gRr)YI&R$v1lK`H?h{{sR%0Eq?%0RIOv0CfWvCKCSu$N)kzH~?{9J|R6bAJ$+OC4jf@Js9+$?>+#b{;w59FaQBT1F)bN{yxC|7Dh1uD-Opa3jhScvtR_k1OUDS!Yd6T3INq0M*jf!G%h3n6aarm95Xcl?>g9_cketIMquwf5&)pTZ50(E3nI=U2HybpH7zB_fbI|fL@6i$utFj$e*pSJJpdp8++e#CArqi8Ge6*f9iIUS0IMw2ptRrz_W+_6&VVx|9W4I<{uoFz0R9_YMv%Z1C<(Cu2m)aL9Y#0+{v1X({sRC?E&wYNC=mJtK_|2!0svo6B&RL_@1vj!05IObM7<>1K&&JcK91l&KO9W}??fLJ0jVJW0|0Fm9VrtkdICTsK_I3p9Vn1w-8ux|Jrx@g;0yr&5DEkqL349u|7~Jyc}!_;Wm92tI_7`@S%6^(JO}?xNlsr?Py__eOhrLNfv9cf1O;DGML|PIXyF9wAn&CgF+9{D0S5s0?=%!LfUr9vD*hax0~`Q%FBB!aKNtgG1O@<Op#^^f;ywl>7aF&~eE|Sq0sx8=98iF-1q1?bm|$Z~Kx@ARKh|buW&l70{{(blb87?zWdCJsVR--n;sgBx$l&EGIv6Yf_g4oBKp-eGDmDKa763gE8UY0V31e?<VsAoqb8~re0d9e-A0-Y#`2n>+ausK5L}h0EY^=Zp21IFgY5Q(xd7ude0w4f?t05-<?==-nz}u@LFTgey8lavp_bDnJ&7cn>G869rFgGi}Ksy{l{{r6|EI$A}6#p9lC^9ZJ9u~g<?hZgJBq5*!wG34N8Q(y#Kp~)4y9)_K09OnTG+>$cG%PX1;O{sX0RIR8?>H9#2>?Ib3lcgn1qK2FLG2hlprQ=}ps+q6^(-qO3wUD;0NO131T!aK1pp5L1pfe&78ofUDFFYF1S2O51PMc*Xkl_;W33=FfMxe#WO*t`1O;Yk^>T0E2LQrBbOZ(aaATZ61Q1hja{p;=bVF}$baMZ1Y;0w61PMmJZ*pU0Q*^uGL$I+x1OqW8ui$rXF(3u)0zQEA9z7rd4FLZrG%7b77XU*03K%T{KmhIwKHn)K0I)n{fCm8GIRb=w3J*3xusxe0E20D%0uaTafN}YC6ac9}77hT!0sjEZE+zoXFev{3iy#;|GXRVK92zb)0GTi_)h>RaHB1C6OarnX`#vS{Vm<)b78$J!?4UFgP$4=Grak(xf+;~_0suZfAO7?~0rD0n0t1tO7!^GLFg7e|g6}~9^C5U(1P}oCt0OEj!Uh1`2(J`0E(RN59Qxuy`wJQV;65Bd0D8v_4-FBZJ3tWPApozkB10<wWIF@kLi-CE0jSI}Dga@31q3Spz}*T#31R&;VnGc6+Ast%{y9Jh0Nf1}Jv03U5a2)_NCW0Z+YlrYKtUo5;1U+)5)9!*jv&9lCIGVcDM&91BtRfY0N<}k6%;NPz(*tBK>$Jv7!F`H0RQe2Ml31-utffpfKLE9CP)CQ`zS9QAW<hs0Q3DKN?-vI02~$`{!XE=KOigsus&NNDUv`39~fXkhh_glAwd8WMI$oT0Jj+zAPN+K0HgjV0UH3>92^NhZvgK%7FM9JJq%<2B|!kq77j5Vb|~ORCKiAg92gdX{Yw^t11tctFHYSxEMQ71P6(mB1pfyG|L_14J{<2W0Jjngzz-_`KM(*M5*rkpU<yV5DnS9QEhjht`>Q6Jpac*JKmdOeJsU0nw-FJ*{|+huDFE&nOy4gs0I*6-rfDa?P5^ok6%Y?0L;epVBmfXNLk|G{9^wlC1Q7thKK~FRG8F(q4jgtSVI@RA0B|ZrE&%-nE&)<6K>#pA{U|}8Q#4Kh%^dp_Jxf7eK1Tqn`zJ9(U|&E-0D9LB5)K<-K^tQt0Qa&bL|P+H0AW3?L^{O=G@Kv}J3<fE${?^pUcy_U0SEwR+A9TkfuI2j0AeX`073{SM#6d*Y9Rdx#Q+Q}0M#W4_dgjryTT0sdK!Nn8UPLeuuUsMe-ADIvN2FM6F~n>E>Hly1n&+1|Goh35=AX3vjDIlL2tuLEEoYKeo^F9%SQn7B|yQy6a(cmI2JEJuw_C(!9hU78Y%zpBtZT?;JpO>1^?mz_d*&eT7*I(PynYsMj>26B;YV`K|=o`M*u!U6#xhS|KtGgMj`+ab`xMtH(;b1Ay5+my)zRD|Mee77J%cw2LG-AK237K|FyRYfD{M-@DaaYdH--_1PN1UZ*TsS;BsXI1$1Fz`D_5dmm>~mWprcrZ*Fe4KxuDobGrl%pQb@%WSt-g-)41gV{`*R1P1qVVRr?91PXIy|8#Y5Np5g;bpHegQ*>c%X>R*r1dk;I2xxU}-(hZVX=JGB26X-qU~gsw2uW^p|8!w)V`T&mQ}bnXreg>obY%nv|4?CaWo~o;19##B0X)E~A0*C1e?1Tz0R#v}5QO}j0H#0&0GTf<El!wV-T(r=;LD%`%wYW##2`%~3O@)8`q=>l73Ks*Zgp+H1PxVlWpWmRRQ@613{7u!b7exmb#!!ZZZW064F3ZFEC4qFF*o-Bw+?jR0w(|=s*^wwlSl%SKqQkuPwxOe9YYKu0D27j5e!m5000Cb0PnCrA}o~TJsd-714jh|N=E}gt0dsS`#KgCfQUCmGd+I*5Hvaq07Iof+T)-(0>SS)0HQh?-rNAc4HOQa!mA|gA^--U1po%6I|~5qJwAXK0_#B|BmwVECpHk{0Pj5(Isl<Otl?J=65`<kCi@8h0wD?jay|z)MlBbrz%B|y#6o25JVgd{X*!^11PT9bZ)9m^X=QTyLf~WKpl4-7b#nb-L81?EZ+B&Ke@%64bZKyG1R(ze0dNElVQyz@Y-IvzVbLG~0L`FxJrEkqz~Tb}_hA3!D>@h~09OZE*ug`Q;3X>of&w<d{{jREVRdwGNB3`GYylv0ZB=e}bZKle;Ryk_2>`zU0UZDVCf5N|?-eyOE!QC)09U&T4Jn`i00jX<27It#0;323&KCd!;#CQSU=02N2>yTr0z#}0zzHA=00|`w2`3Gx2|SLb2{R57XAcQH3aS!e0upu*8>bNoC8Ajimf#*?5&!`}Y8%3(69GXM9V7yv2OfeH@*aQ&&LI@Z6#%e1t062gfEFoD7b!;=-WJrlAv^}vzyJXM86W^val393=aSr?*OYLDFGrI076R)9S))#G$JbJ9W*ED9tz(I#wrTV+A9Z&!GQ@lA`fT)KLI$cACe8HATMP=i3kW+BI3d4J25(cU`&A`08{rCHZ)9uBOd@)>kAG{f+PV$1^}XQ3}^rXp)kM<04@Xqt}wt101O3U2?PNM>IT9TUmzt0!zKXQ<17g>BnkjvASV?7`Z6FqG9bY`F*^XiCjbE_6aWt(7gshkE(YKyEaL<SKp`kDLtDZxqg%ikTfi{j7F)nA3tPbiTf;LzTfqM)761zX)gcJ`F$~_IHWmOW1Ha`kGZ6qP5#THDAOQM74Z%VHqW2I066b+10Kq-mF+8Ba0Voh67&iMfFBc#zAplnm1rQ%%EdfJp0s^CK0D9mI1K|)LE(B}=Gs6Z!YyjIS7Z4*d4esDK7w!-tF*Fh-pa1|bpCJJHLOdP-5Fiou5Fh{m-++n}90~so9xwz5O;1*TMNLIcR0Ijo!2d{PVPs`;1Pk>+gCHQrqXYy_VgGGq1S3IgcVYi|b0BkYa%pb=bRc(WbZBpN|8yW|Z){{~ZvST>b7*O1bOiqkL}hbha%ph>*rEhZPfkSy2mecDd17g9WCY&_L}g}Sn1BQb|3hJHY+_+!YwivrRBvaQAOsLe|88b!ZfSI7ApYFt7*1t&WpW_za&>MX4FPXvApF_@;35fEVQgzt>u_b}U^Ux-b0B%=Z*_7L00ICmAVL3PZ+2xMGBO~4X>%ZNVs>fIfPWx#Zy;}UXbFI?aBN|DtU(Y6CLsSoZEtmMbObPeQ*?D?b0BaIAp3J=^q^!eATc%)2w`^(U>pD}3Pc~n9w6TY15Ige0Dxh5{{#p`Wn*b=VY_T|C_+<gX(&Mj|58OkLr4S)M*m@RbRbe?VPpSv1T{x;VPbP_AQ2!SVjw^uVHYC*AYpKDa&KW{PiQP4Y4%_+03aP;S8r}05TJAh!3i>e|8jI<Wnpv#1p4YC1oUA91Wa#l&u|0^LJ1)Y;b;W^E>mc4Z*(jmzi?r5b1WbSU~B(uWgua0WFTw1Wn~)xEpuTbAZFikZ*3rQ$G~L-^$G>xcN1c01T#eUa$$E9V`yn~VjpjKE+9@OU^_uP!2NR?Kp<&!AY);_ZXjZ1AaWVNXznkd4O4I`pk*LPb_OB@3P=D`Wn({r{{~WFWNCGC1phQhZ+9SOVREbop$5ZqAQmBVE}&$NHvujnHXR^6AUMQgzi(uD1Qk#<0y_CR3<L>;1V(IOXTJmsMrCDm4rM&AQ+Hu-Dr0jIgJ#cfav)(W03P6BboxU>W(EK*AVO?!pJQutAZT1d20(BBZv+HEcx7`0jRXVX1QQNr3&JWQAQJ=&VgU_hB^%%upbKke3BfEN4uJ~<1Ox&>$O*>?A_>G9Dxg}TWN+hlZc@QlA``&?3F7|*0s#d8s~;ur09ObJ_~1hcLAwAZ_kais0QKYtehUFYZ+HX@R5$?tb8umDWo~16-u~bN0s#aEC@3=TD>WMy{9yqE2j^*SW@;e>p#cE{`UIdP3*<cz8UY0H30uKwLI}VF0|5&D2*@xrC;(3YKHnTa07DBANUI;*2q6-I2LL$?fdT{#2SNf*ZW9g)KM3IpFdqqXXm58~qaBVI(DejAU{WCf1_A*Xz99%t06H8#AmIRis~{u*?=%!CAm>j2KN=tb=Kuf$dh?+b&Oop`A}q}y-#Gw63K<_DJsf{P0Pi*v00sYnzXkxN9uOM?qECAOJOd!22>=!~Ao&Xez#!xW1O#_;J|KVzLug@gec-6z{|HERZDDS2Y42nN6-J<7Mrm^Yb96&!X>4Rq7iL3jbf5&8M=#+(9u!#tKokczE;~0MK|~ZJj{yV<VY>jj<3b_;?m{E)GZRiAJrEoD0T^Q`KnDQ;4g>dQ4>$tg-3UJ%p8%LY8XqUX0Kx-r09OeN^kB{w;$Z#(AO!&400s&Geece|2Li`47X^d-@<0P%2>>`Q6b%110E!YD2?-hh2?PvtWpr(2|8!w=VPb4$1p5R;VE_aMQFUd#b-ADgQ*>p|pbGy=b!~80VQzH30zd?9VRUF}Kz09TWdsROa%FS>b7f>fbOZ-X>tS?Xg#j3k3v6$DZf6CcWNBk`9Q2(D3*c!%Zlpj);06Bz01g1|3Op+RAOH$N201YRcUK1sA^=wi3`QW-Q^6zw143XwN#Nc9{{#g9+9(7v0R0apfYlucEeScF0ALgzFA(5CL<IW;2jbvFX?A4<eGD!kQe|Xma-$&k1P5~*AwpIJ1^aMg;Gh5j;sXIZ{s0U`0RRCdRDtt>;|UmR00qV8fOB+m{cnAN2m$~x0L{-63o#s2U|Z#xFZ(PlI3NH30vrH)usT@4dI=2)BH;h9JR&Oq000C(9RRW*KPFm$LV>66G!j;%WC1^93I_gPhyVZw9smI+&lLa&00`h?L<<`FV?sd+pa~xU0VuT=1ED=<1q>T!0z!TRpb8)W0Vx*;VRb$Or41HAJsd*^V806?00Al(3n4%B2V`>rLrDM(3jo@GE(9|G4*>=&0KWnNus|UzZsL%?1|lO21P0XLXa8k%1PE|%cV+)_LSb?Q26TCUaAj|11PDpzz<*(GV`T&eP@_R>bOdoI1hByb4sfft1Os9R-~~_#Aq43I31KqF0w<u^5g7{yJV9UzV}hl?4u(pUcL--|vp{2Ia!!Mga$%0(Yl4ww8?Zu2;Q~U5pf#s}MKV^eLSh$m0P#rifWCr{K;<hs7_!7*2NWSx<pKZ&LjwMNpl)<&Q)p>r-)v+A3v&SCL2!F;Y{o$g0st9yp!_Ug5kn|4DmEJzp8y;S84(`<P@x2TNdujsJ^%qG6b+#Nusb9x0AU3K_b31ys-ge@1|n|&0V^4zz_36-K;EMvL;&wPKA|u<{V%1YJ{&{<?hyY(DkcC?FcAR%2OIz^4I&Bv@4pTb52?bv1S!7*01OBO1%e|5_hW2jI)DU6VQrmdHSP;XWvAocAOznCLSb`dJs@-h{{u;LK?DjzVc%{;Z)|KMqXq=a0d7=40lQ&pAyXCiH8U+%U;`ciSGx)gZa@G41pz|_PXO9022H>MU=KcEsso`1TYv}yqX`3`39x-510g{mAs`C?3B?S$3C9fy#Q*>f0;3N{0L~Yr01dzhp$Z7CzYqYhJ0UD+;1Q}6jS>o{6AHWs6JY{W8e$V;5EEt;6K53&yr~NauM=bz6KxkBCm5;|d<7GC83?Bu2&JOe3jhWg0vqlC1MMmrVjS;bE*ruL@WV6VQ5`lwufiV*9x{d>6h~Dc3!YXBkq9cS9%^F$3K<{-1yoW`e@sjS2|;9Jib3A|fCf}ya*`ngPX1OwFjr`AAarQ=Wgud^;2>vjW&d*^bZ;&oOlALJc4Z)MZXhWCO=T${W^ZyJ|9Nk9a&u*DX8!~WL}hbha%ul?bZKvH1PD-XZ*X;N+kgZF1tGlzzW`=ob!?sBLw?2JVqs%z1Pc#9-$Zh6aAfB}3RAyyX=7_3LIZ#VpEyfpWpE9^4~A^`>VOZR5y5G4AZBH+Wpp5Qf*@=UVIco>b#iVXX>=g}Z)Ro$1Wr#*|3w4`OJ#XtX?t#D8-i4CXJ_;P{|it>QbtcwP5(hoLq!A+Q*{4fWNCG6AW~(QZEtq<ATN<&4kL5y14J7^VIX*dAa-f<Wp@kUA;NHJbYuT$1PMk^Qy@ZrZ*OyS1Ts_*0KIb$!60*JVHtpP{~%#*WFTy5XWwXaX>MmEVsmZNZ*M7J7hrOMz;guu2Tny)S5Hz)_XG@31VK}9Z*P5O5WrYdXm581z<(fSVQXa|a05a7Eg&#~b7OCEWn%AdVRB?LU}1D1-(+%WW^@H0a&P%{4PY=qAaY@DXZd9gzy}~<AaZ44KWrdlZ*Fe&fHA?l3rx(Qb95jL!30YrR4X8C0s{<!WguYxd2eoIAaiA9|8p!LX>K5GbKe95O=)fbfMIz51PDZBV`*(+>uhr>0#lPAas&)jNE`rV3PmLfL1+Rb{t9*g2;u|*0R*=It02jsG!*>+6L&lsC{jcL1PKv=@lqJU#-IfZz&s5h`z{jvK>-8@b7k3d836>K3Igk3ybb*~+W-ax4+J{^-#9N53pKpJ6#)G1AiTo@C;%P+tN$b<0HG-nJ^=kaz91U_Q6~@pe+L@?D-0nCyyCwD0KW(n4!GnluLA%S16Je;wIEPGY+-q2a&t?dxnSZGTM83EON1C{5e@^H3lu;YfFds#gdK_nw*dhP)?gYE7~oF-6bl0YPXId{pFjXY3K-910ijp>2n!m3JrEiIw-^;6?m%lp3UqejcA@Q}y8#39LRSb0{lx|8b8CSrn+6vkMsRbU1b_ww0aeal%i#v<(;x@LV+h1(000WA#{&z}KnK!G4Ddn?l+OmtL<HPm53t7yklHIN1lxfDJ>Ubx!U-)E5V{8u2|NYl!ABtpD+0wt64=exWE5f1WFHpP1e6~E@nQuP))vp_(L@HS!vPK(Vi?3>e&M1Ss>Q)V$0rEnVj3?X8|W;Dyy7Cs9BPCd1PcF9Qbj~bLsUu2Pfopw4~;;9z;b2hWNBlz0=}auM{-YPWo{si!hs-fii7ECqd=L#EQ;V{AZ;IMb8}^Lz00o*y{5Gp48U)o!8$q)4n`krVP^yg!N$=cwS<2TP+@a(AW##7?{9JhETZFgXl2`SWzFIsa0CHmZr@~cAa!sOpl@vbY?h#7Y;|O1WX}W+OmD8h2d6Su;s)nz13}s%*C1?fVqG8zbOb^{<A4j%!QUWMa$#e{U^7JXa$&Q8;zcKOAZCobVi90;Xud)d<IzBOwP_LHY`~xd6Nh6u<vIx|3JSuV0t7HfyKi^Qpl@?!?T2m6b*jK(Wyc~7!E9++ZttSY;BR-b@)Rt`_zP$%A+@6b1>yt(+W`rJ;3WWp<1jRxD2#wT96zy!rQsntDxgA)U;+dSEMYKY^8^Is0f+zv0s#)X2(CN`ss{i$3m`tK3n3xAz%{WU@4bKnIRI<m3+4j^3o&5}<-rO8fh`0LWfngQDgp!-2xn^uL<#xf3BsZw*8%|t7H&HqASg2LD>WMy9wh+;1z%xlZBK5fbO-~0{?la<0|h?-C^G*qH6IrMLJk<}wW34;AQ{L4FgPym0w6jZLo5LwLjeDx4FCoJtQrcnFw4L-*dnqRxc~wELeC%)00RKPKEDzoG!g(pm;g`z06rW>0D2G<{}2EK0I)+MEB<`I1tb8nCq^yW!2~=5;Gz%;0H!2+6(7TfMgT$$0i*vM4Imi+1_ChmAVv<efhGV~68{wd2msyy2@<~m?>`>^3IYNP{{T}QHZ(K<SML!C01N=23IGkZ0bmXQkDw6|mO$SB01y!X?>-&?{SgE}6aW$c`bTd-03!elz!w}Hp#Mi4O#uEGNi^>OD-k9JK@<QJ{{a3NJShM(BC8WG1|k#=AQcWH7XJXSMj|Qzq7?iMAO+?Z0mm3YHr+=dp#Y*5Bj5)B|0x#*KnHZZYX5%u+XMx0V_~msYy=1IfK7ow1pfqdd2nR}25$FtZDMgC2|{mV|9M7la${u#3ZFxDa&~0_W0)fc|5jyVbZ>Gq1b+m2WpZx>1p{PueqjU#<s$?HZ3=<&1!f3B0f2O91O)$Rb!TM+2W@HpZbWHwbOZ!v|6yrv1OsDXaQ_4XZ*val6%V{HF#V`~HmWMyHwWO1QNp#%UM?BFNw0Piys?BGuTJ*yl(?%*Z?;sWp@q2DAFIRHumj1VvXKL!9y0GTf>-7P<0?=%zoV6Zy=Jt71f01z)d2LAv=0ND~52t4lqR|g9I00#g-ZVKo=J{3VC*%1UO{W&QC1Oy3TZgl@?L2heoWdsF00K+E(2xfI|yrOs@%>?Kns~>Y97U-EU^D8Y<Ky<^<1_d$G7zPZY1my&UVm<)o1n30-1n7nU1q2B{b97;3X?18oH|5_7b7gc>0)qqve`auVPi_PT0zmghaB~p=836||Zvea&Kqr7Y7hu5u0yY2!1Q88H{{Ry~A2I;975@NX1p+PrECBz!8btsE0p&mcH6j346&L^o@<rhX0Yc^g762{)@475V5h7roF*m<0D*!?q9SFe`|4Rc15Gp@9QQ`(-2nJ#200+Pc07Cm08lNE^O#)IA$u4oi3t$u~f(zja1OI6~9{>vgIv{>xU<^J0LLVMpBEMAu<wZd#?!XT1Fbn|}O$-1mK|J+S6CgViBM$)DHa`S301p8S{(vl?`vC$Ef)D@!F%({D0I)_OEDWGK_aOTcF%7^e0HY%S|GfkZ2><{R1pfh81OZtD0b2hA22y2VV`w1l1X+UvO;DjtVR-!n>Lv(8Wn*b=Utw%>1O(^;6UYHCW?^val578&fszfVZ}hd1P*LvW^~eGa^Cjg1PgU=)FNbW?{{tl5MJPSVRG$c)?#8|THp&rW&d+ya%pgMX>a*%@+`;W1ONa5;{OH%0RsTp6C3{rJpr&33luN^9RZXr9102>{u%({2m}Kt0GhWE9TH(c+AAQU0{kH$AfW>Q)gK5j-3-EkKO8}kAOQ$p0NN`BGbI26jX<u#z&#-=O`{^k;5OYBqhL<}It4(G0ly+60IMM-)dE4^0GTo@Fht-00KWtu0I)qGDS<i90748KufnN-Hx;ZyfX|~n9IJph0pS4u00tlcP8JRbvZv%a10V|G-T>j?+Vd<15aAU;0{}__*Csq9k|73<<pg(pRzm*ZXJvE*1zX_#bZa1RXkl|@1pfqSWNc*s1LAuG14lp{3>gt0Ab+bNCIA5?6uW@m)g1^e2|Ymp9R30%iW3|O2^s>w1PN1ca%ptHZvSTl3{z!vL3Dp~a%p09bY;~7zF@%F5gG?P2%-T!00v?i0R#>O00zTsX`lr{1Ol!=s~#gkr9Y10ASWQ~U;#^j0{<KUD+U__0HXg002~0=H5o4B02Gm;l;Z-R76AA6EifIuU_%K&0BbudjKTq5;5+~V0r52g2a2K=AXi~*YyVSlWo2XqKdHZ&nVFfHnuy>F_X7d!4Z#5&00Dg_9zjzTH8U++fWHGC09OhP*Wdul00jX<2GJn`qX+<J&KCd!;$FZ23I#(Y3qjxvFyP{V4}ky&p{)!Gf(-x)g$@db52gx*q6^004M7lUKoLd`qY?lDpo5?g00{v>RDOUFU=wa&6b)wy4RP-k0I)lB0Kq#k_c{O;526<UQx^L+G#Wt|9{^Vi{SF#J86N<;B0X&f)*w0(zyKOCdB8IqBZ46*fI<x)U<Ck?9r3~jK^&nT2csOIED;5Rz+@mCp%1%21R)(D?<W-i9}QqNGcHPlU=|H$AP&PP!667^PY?j243!`YArcZoq8xw>`@j>S9DyPYM+Wo_RUH64ksts7BOX@(0Vg*i77s%t9LFUk4@U<Aqc<QJHy|LuN;e@U4F?A)p~`^+5+bS@;S{GpQwoG93Wq2n3Y;klhp6E}#1D!<B?W2=2`UQ*D>9!B05XXO+AIq(A%5V`01OK;C)F$$CoLBzE-^n70O#5)2n+Qu#KAl<=Q{u|Fak{A7dAA0KVdK+09OnTXF`cF0YltC4L$(^pg&*@LjVv20$iX1rCgv5KmlX~06+mU2qS7BEe$g0{0G2lASf096#!GO7d104OyDyOXEag`Xa)=d4Pp!pd^HVc?FtQZusv!aJuy6g05$*tC=>u{AomzHG!LOSAploP4G<k7H~~W)AP!qW1OlKBpbi}&1OOc%0;L@wF%Dfp2EZ%;E)RH!2_W`pz$q6S!5B3&FbZhEISdCn3<w**3<Vp&@(dad3=_EF4H-HF{}xqFNmfNtQ~yCsAVNV*Od$VINLf=!LsJC*2|;9JNM&JU|7CIn4nuWvcK>A{O>bmrW@&r@;QC`GQ)6Ll^nm|#Xk{Q`Wo~5uAa8CUWp-t9-+3T&Xm9p|aAEgza|H5=1Wr#*|3w4`OJ#XtY5#6y1P4TAW?}zzY;*(|Q)q90Z**yHXF56!jqgTmVQ2Y_RBvbBXKZBz3=-o(ZU1j|Zgd1TNN>M)AZ>MHXb_`x`Dh8C69RKCAW&g{b95jvE;S$(g5P0mY#?*M;d3DWb#Md&O=)fg<3I$KK$f5Zpka6f{|H27V`*(+Y{zp17830Zgd?F-Z2f5?p$tQ4VRC2NWgyEU1PUg=Q)Pc+bZKvH1Q7!y-$8J2Y-uGRRBzt|DpzP}6d-VKe|KeaAYx&15(3l_ViiDa7yxqsfO8=KWN&wF1O!5F?{sJc1Q%d)1O?tB;sggza0?-G1fd!Np(Vo)qYP*Z5I{s%a&K@5f;=LjW*@=4A3+Z1W@&6}BLFdfAZc?TZf|lOfafeAFeCs0z-VD?U1lTW1wYUt#1#$g{vD$UQbAWBP)~nXMN$L{Ms+H{_8uby9XY}vVRRt*W&)ud!)b1FbYVYkbZmJ96+Nd0ss9W~ZgXL7Wgz`fBcTK~MR;^_>tP@zLt#tcXk}@?XJ~XTAXH8Oa|$nFb0&mt`d~Xi89*+eR5nNn>JSRTASDPdF@sfeIKUtUNgxfOLPVkV9HJm$H{f|7bZ<KZ3Ic}&JySIzN(TRTX>@3Bb#x%VcV%H~Wo}PlY4#OhLS;IEFfKPBuW583Yzp9WW1(_&bSoziUm$cKO<;hXX+)uNa|9Ix0!IYdDg<Iif-WF7N^)WMX>(-@VP<b~AU|zya%BV$X(uS-vk^!p;tWUxD-L38w_$Z|WuRehX<#n<AW{h_bZ>AVV-Ig~Ze<a{3I_=z6aXZ8;1)^>L%}xWDgj~@pOO`U3k6~d#4rZ}601z_X=ZeDcBgM<X7+eOXL5c(WB?4}{{sU71puobCGP-N2np-pC^9SWH5(WJ0KygkJ)aO70R#w6z)FBmcWwXx1-}FgV|julRC*zF20shn4V-~q!*^3~WDJ1<0R$3F!VzQ&VWEY?5x*B;31WDaKy4xyfCK^o2pvfOLJAoG?=%zue*yqc06QE%9%c6j068Av0t5+TjJAPF;RFW(LLedtpEVO37WDuKgbHqB2%;$;0xro5oI)t)B9{}t99F2p2osJRe;jHKH~~;Y312RIxItoWq9!i^00UJ3B<}$4GZR$+JrEmz0R#zdZ&Pcq;QK>FQ(zAQ0#X3G-T*vc?==-Vps@EmA}Rsk0}24||2G!^1OV?g7XJVR0J<PM1pwa$0IMS<KEOU4|3d%<1P=#30RK2H77jQ70V(|$H$bpHBr5=6{{;jq03ZND4gLZlG63&98UP6XMF4m(M*vp|47&gc3V;#-3ISjZt^lCU7Xbkx3lHE7-UC275&#VmKn@P?0Pi~+5kUGwJ^uh706zf0Jrw^VHyZ#e3?T`=1Hlad?>ZU-!9w3W03ZIY1Hcm_zcv~GLJ%4eA`gE6!x<0_FCJ6i|34u^08uIv0RIOb04on93;=uYJrTjb3l|YhK!0BVc?Lu?LkWQY5&#eY?>QL&{Som15+MNo5kcK70pJn<6A<7Q0NE4`!U14C78AhlJpUX36#y#^9t-Y&KoI~I0H6*47ykh7J{SNP0Pp`l7yuan{uV~HF#$js0s%l70s$AJM=}ru1i)v&KLVjE{}3e&05cyLEGh{C8VEug2tphPM*;w72tWb=2ud6a!W;kyOZ^)f07o=N0KEkN^#=dj90Uzg_hETs@E}lOa$)~%a|8o!Wp@OB1VwIjZ3GbmB>zTfY;<LERC)h!WdsLBcw=neb!24(3Id1<N55rsP;6m&vB3$phv8vk1>gi42IEA(WpiU?Ze;5~bNt=_>_B5>a|8}U|8Hz;X>)0BZuLi{U~mmUWpi+4pJQ}GVQvE=3?K>rcW-iQb8ul}|78RSP;YZ-bnXR!1P4|GfNyd$`veCTqyz+0X?lNU1OZqDKj1Rp{xd)X8AEk)a%KN+bWmt{b7^D$VQf%xZ*XOD>vU-jzz7f}1OZw91O-NHZ*Ou0{{~WFWNCGC1osL>Y#^X%V`+5Pc?1vvXIIn01PgysWpi|CbafD-UkFBWX=4%M4gn?n1jD$12mt~P0Pg<`J}DvqLJSycpQ1ut02xf-A46k6lx$#TAOTB2G+Y8(fC{+|RN%qD0IMVepg8>)R-gv}GXewydrWUJU`T0aXv3iY4FdtG0RX`}+b}xGAOR+;K~om@HZ(0BKm#8DSGx-iaG(GH1pz|_uK>;%00M#sB0vcK1LFw*+AIq)0QnDMfCa${00Acz{{RaBQx-KdE~*5e3<$gp2&V=Jw+^NVrJ@XhAPnIT5Fij(3u9+O0Ye7>1ONyY;#CtAKokpy2@8!C6h>th6kHb!!yiBZ85O7f1QoBaJRvLq!LK|qI{<;8Cn;hV`!+Nnp&K9oR}2vkDPsXcDPS2XU;=<CVHq3)<0)V*2q2^dz$svRC>AMU7d104E+Ew%2&Wzf1<nYdx+D8O2#SCJ03RX%cUKM(pkS*fCYa*kApzn>fG7bF03!g}%PkBH0Rs`@3<cZ{?-DmI2Cc#*1LfZ^GZ6qKJOCyj{{Z?yI{+pCLiYfo5D>tyJs~jv0Kq*mJOC#Ey8$R0!WcF*69Fhj4B!nAMMD8YML-%Gz+?h|8^I|9;~T&(1slYy1;9l>DHjUiJ|@9F&oMm!D!ITW!WlNJG%!p+D;eViO`rut8$(b)8w%hYfF{8#9plC(z%K_T!~-BuKq?qsP(c|rGci>FEeO0-E(oU$2)8d0XD|i@z0MI}x+OpgFM}kn09OzbFM%m9fITN205JjLFMtp*!!Lm2FA6V#bAS}c+z=AuIWRAPbRaK)GBp$b05SlV05={#{{WshFEb+mivJTF2@V}H1PT8^b#!kaL}_-Oq~JkhWK))4mw^n=Pi$l$13?2K1Wx~9ZDj-mPESt%MFa;+WqD$0|88Ui2SjCNVc&IZbOb2}p>rVLbZBKDa)01-An$i!c_0dab76M>Wgv5CZ*+4Y|7LG;AbD?f1l<d)A#!POlS4ycziez`VPk6$fMow<RBvZzY-I#}5)tB3Wn^h`5kOuO15ZI|Z42XM6yVn&VRQ{*Vh5lgVSjTVX>=fLWeq_8b1WcfZgX^H|6ybxZ)PBDb>D7hX>Ml%Kp<g%AZBTJWn>@<LwXyb4;|qkO<{5bK>r{pb14J^O=<sb1wY#1N3In6df@?}VR!{U!T;-p9=K8L1PK2`Wn*b=VQh2%1U*G~baG)Je{^YWWguc@8esWl9)c2qE+A52X<Kt;5rJuD9YG+lK!0p(AY*TBZ4?3bVRU62qEl>XWcy`uE~H9zZEytt6-RGjY-?p@=Dy%MIx&I*!URTa|6ykYYD{HeaDp5_ZYjVk;UD5Dfggc$-ym;xWpW{8av=3+zoIN7#ba-CbkHFJBVZu`Gr?!r0B&Ud7i}PHVQyq|1pf#}OCVBZVPmOi?7#rQAUoh}Fkl3qG+A$TawniUpk(`HW&%NTAYpEK!5}aKE<hR}KZ65<AaeI%Zf7|FQ)q8@@CpD10wbUTVIo9wVVQSDBn62eVG{#HK?(mzWnpr3Vr601bOZ$W;tCMtLT~?g1O!HPZes-h1Wa#la0CQFHF)!&2NFaC8Yt-(M9vxGAOs8Yg+d?%4Xj=w^u|nAFTis)LSgf4Z$=<g;Bp{rX^U=U9Drm>KrcjD0Vn@+AaG%HXf7cBA|h{hZXj!AdHNxMY+fL9Aa`kQe*_3aVRU0?48d6n48j4z1Tg}lWhTOnbOWIvax5WJ;SHi<|8Hb@EFf)ZWc@8%0(5V01Po2TVP|e-bRY-=QeRMVWpi^`;bRNoUm$RGY;0m9ZY7|I{lGDWaH4GoLonh{;Buv5a-wNSfg6HoJ>n4*Gy)97QZ`~CGv^3uGsyV}L_#rP0%vOg3jg8*0RaO5s~`51pa=>5fIScz0cQjVVTxc|fdBvl@(~9E;V=LL)C>o~fF%TUF$n}=Dxw4xXKO%&47BG6XKR215TFDB0sjU7Ff=FtPXPZs96ta<2|)nACM*C~2n!k@2e$w@02-nUR9gUZe{f-PWo~168#SkIY-FY(3S$TgWIp~1V5=Y`0Pi#uCJF$e3A+FbVFJ7W3u1Qy1Pxqebz)+mfX)qH0R#&?qabAn0{;OH0C7AWIWONI05CNv86Y|w{XiE1046^XD<uB_p(PMH06PHxaXueAF&+S&{|YTT2nYbb4f_rY5Q5nf90ouC0L(Kh0KW?o{|W(=Eg}jH8UEwo;spQz4g-1r7aagX3L5~rryn{5A|L@q0s^N4tONokAp`&%00t+51^NL&2PonO0XQ8w{|_?;1OZe80sl}014VFi1PA{~XKrtDWn={31w(IjZhgR0bbDoRF`y3u0X9lN`6Vy_N<mKmJsdv&0IMP;01*%a{|f*D0JjeSVfO_GDB1w4BP9U;?>83!0{~Gg{^h_G0HO*21pxoZ07Nx60PYXnLgpaMHZBE#3@)DlC;+P@1%Tne1OEV0L@W>h-T=P@3IN(I1oL14{{;Zm9tblIIsX6=5(f_e0|MXsLMRyy@4!9)_d*mNDL_FWN&ve;4*?-VBt<HM1^)mj4F~{279;Nf0Wlg5V6a9a-7G00LJlPM;5-1|?>ZO&1_B~a0RKiEMF717CkfvG4FIbq5P&)wJ{BNC6CeQZ`QR5||1lB(2OR(>KmREhIRHWv9sv9AKL=q31P~2G{{V782}my)0PkQLBsB@-y#x*a0{{XB1POC=|6yclb!|^>1pfz9R6#^ZRZX)527>`AA#h{kpalC4M)d$jX>xOP|3heLY-9umP<~gTbN~V31OW-4u6DuiGZQ*O8B?MH&j42k3KM`{00RZHKkz^x06+ym0OJ4{2j+Ug8G#-oW+F47fB?P;BToQ79X?Lt-ah~W1pwM8ECFc1@31-{D<lG?A1=K-Bp@*Y1O@0IW9MZA1r=fvU;_aFxde$q5@P`+6g_~7-xC}O2^a;22SnDLfO2nd;sOQ0<ty_#7<C{PfB^s~GVdxi8Wwef3Sn;lbZJy!V{2?>UVGpL009bdWIAzRuSXj*G#$Vad!Rb~4lzIiEdT)~6}}IEusb3x00Ke<{sKjc6dei*8U_CZ1WsXXWdsBNUL`FA00abQ|8sR>1O_E@D)&cABn#sk0D1|%4OPLgJR&P4-~zuL0J0!ICP#oh)_<US2t}X+D8K|Au>cH!MMGNwKL7(val2?mG=1_r7>iNM|f1K$S#?=})9AOHaW2Oa<~B`+2_-vCY%3k8aU5gWe;1O#+>a4W!c^<j!Z2JaweWpo7Z26Sm{)4>UCZ~tUzW@%+|a|HhiaB^>OWpZ@=Y3aZYV`yP=Xa8kHb#h^JX>WOMv?5i2<t#cEEXDqzf)P?>b8uy2|8zrPZbNTuZ1ZVkEWt{E1OS;Z`70^FNu&S(104YNI6@i&Jp=?4Rc`%aQo(X>ZBk`!_he;qe!&C=MpZvlUq?#-00")), p432
    )
  end, function(p433, p434)
    return function()
      local element78 = p434[1][2][p434[1][1]]

      if not element78 then
        return
      end

      if not (element78.ball.Parent and element78.target.Parent) or os.clock() > element78.deadline then
        return p434[2][2][p434[2][1]]()
      end

      local networkOwner9 = element78.ball:FindFirstChild("NetworkOwner")

      if networkOwner9 and networkOwner9.Value ~= p434[3][2][p434[3][1]] then
        return p434[2][2][p434[2][1]]()
      end

      local vector26 = Vector3.new(1, 0, 1)
      local element79 = element78.ball.AssemblyLinearVelocity * vector26
      local magnitude31 = element79.Magnitude

      if magnitude31 < 8 then
        if element78.started then
          return p434[2][2][p434[2][1]]()
        end

        return
      end

      element78.started = true
      local element80 = (element78.target.Position - element78.ball.Position) * vector26
      local magnitude32 = element80.Magnitude

      if magnitude32 < element78.minDist then
        element78.minDist = magnitude32
      end

      if magnitude32 < 2 or magnitude32 > element78.minDist + 1.5 then
        return p434[2][2][p434[2][1]]()
      end

      local object3, val620 = element79 / magnitude31, element80 / magnitude32
      local element81 = val620 - object3 * object3:Dot(val620)

      if element81.Magnitude < 0.001 then
        element78.force.Force = Vector3.zero
        return
      end

      local val621 = element78.gain * magnitude31 * magnitude31 * element81.Magnitude / magnitude32
      element78.force.Force = element81.Unit * math.min(val621, element78.cap) * element78.mass
    end
  end, function(p435, p436)
    return function(p437, p438)
      local val622 = 61
      local val623, val624, val625, val626, val627, val628, val629, val630, val631, val632

      repeat
        if val622 >= 185 then
          if val622 <= 200 then
            if val622 > 189 then
              if val622 > 193 then
                val622 = val629 < val627 and 144 or 185
              else
                val622 = val631 > 0 and 382 - val622 or 79
              end
            elseif val622 < 188 then
              val622 = val631 ~= val631 and 329 - val622 or 108
            elseif val622 > 188 then
              val622 = val629 > val627 and 144 or 79
            else
              val622 = val631 <= 0 and 412 - val622 or 20304 / val622
            end
          elseif val622 <= 224 then
            if val622 <= 219 then
              if val622 <= 215 then
                val622, val632 = val622 + 4, p435.c(val632(val624, p435.d(val626)))
              else
                val622, val623 = 252, val623(p435.d(val632))
                val628 = val628 .. val623
              end
            else
              val622 = val629 < val627 and 368 - val622 or val622 + -116
            end
          else
            val629 = val629 + val631
            val622 = val631 > 0 and 149 or 70
          end
        elseif val622 <= 79 then
          if val622 > 62 then
            if val622 > 70 then
              val622 = val631 ~= val631 and 224 or 188
            else
              val622 = val631 <= 0 and 270 - val622 or 185
            end
          elseif val622 >= 61 then
            if val622 <= 61 then
              val632, val629, val623, val628 = 1, 0, #p437, ""
              val631, val627 = val632, val623 - val632
              val622 = val627 ~= val627 and 144 or 193
            else
              val622, val626 = 215, p435.c(val626(val630, val625))
            end
          else
            val624 = val624(val626, val630)
            local val633
            val630, val626, val633 = p438, p436[1][2][p436[1][1]], #p438
            val625, val633 = val629 % val633, 1
            val622, val625 = 62, val625 + val633
          end
        elseif val622 >= 144 then
          if val622 > 144 then
            val622 = val629 > val627 and val622 + -5 or 70
          else
            return val628
          end
        else
          val622, val623, val626, val624, val630, val632 = val622 + -69, p436[2][2][p436[2][1]], p437, p436[1][2][p436[1][1]], 1, p436[3][2][p436[3][1]]
          val630 = val629 + val630
        end
      until false
    end
  end, function(p439, p440)
    return function(p441)
      return function(...)
        local val634, success23 = pcall(p441, ...)

        if not val634 then
          p440[1][2][p440[1][1]].Error, p440[1][2][p440[1][1]].ErrorAt = tostring(success23), os.clock()
        end
      end
    end
  end, function(p442, p443)
    return function(p444, p445)
      local mouth = p443[1][2][p443[1][1]].mouthOff[p444]

      if mouth then
        return mouth
      end

      mouth = p443[1][2][p443[1][1]].MOUTH

      local game3 = p443[2][2][p443[2][1]]:FindFirstChild("Game")
      game3 = game3 and game3:FindFirstChild("Pitch")
      game3 = game3 and game3:FindFirstChild("Nets")

      if game3 then
        local element82, val635

        for v807, v808 in game3:GetDescendants() do
          if v808:IsA("BasePart") and v808.Name == "Post" and v808.CanCollide then
            local magnitude33 = (v808.Position - p444.Position).Magnitude

            if not val635 or magnitude33 < val635 then
              element82, val635 = v808, magnitude33
            end
          end
        end

        if element82 then
          local dot16 = (element82.Position - p444.Position):Dot(p445)

          if dot16 > 0.5 and dot16 < 25 then
            mouth = dot16
          end
        end
      end

      p443[1][2][p443[1][1]].mouthOff[p444] = mouth
      return mouth
    end
  end, function(p446, p447)
    return function()
      local character19 = p447[1][2][p447[1][1]].Character
      local humanoidRootPart11 = character19 and character19:FindFirstChild("HumanoidRootPart")

      if not humanoidRootPart11 then
        return
      end

      local object4 = p447[2][2][p447[2][1]](
        humanoidRootPart11.Position, humanoidRootPart11.CFrame.LookVector, 12
      )

      if not object4 then
        return
      end

      local networkOwner10 = object4:FindFirstChild("NetworkOwner")

      if not (networkOwner10 and networkOwner10.Value == p447[1][2][p447[1][1]]) then
        return
      end

      local bodyVelocity3 = object4:FindFirstChildOfClass("BodyVelocity")

      if not bodyVelocity3 then
        return
      end

      p447[3][2][p447[3][1]].until_ = 0
      local element83 = humanoidRootPart11.CFrame.LookVector * -14

      bodyVelocity3.MaxForce = Vector3.new(100000, 0, 100000)
      bodyVelocity3.Velocity = Vector3.new(element83.X, 0, element83.Z)

      debris:AddItem(p447[4][2][p447[4][1]]("BodyVelocity", humanoidRootPart11, {
        MaxForce = Vector3.new(100000, 0, 100000), Velocity = Vector3.new(element83.X, 0, element83.Z), }), 0.2)
    end
  end, function(p448, p449)
    return function(p450)
      if not p450 then
        return false
      end

      local networkOwner11 = p450:FindFirstChild("NetworkOwner")

      if not networkOwner11 or networkOwner11.Value == p449[1][2][p449[1][1]] then
        return true
      end

      return not (p450:FindFirstChild("TouchCooldown") or p450:FindFirstChild("ReactDecline"))
    end
  end, function(p451)
    local val636 = p451
    val636 = { [1] = 3, [3] = val636 }
    val636[2] = val636

    local val637 = type
    val637 = { [1] = 3, [3] = val637 }
    val637[2] = val637

    local val638 = pcall
    val638 = { [1] = 3, [3] = val638 }
    val638[2] = val638

    local val639 = error
    val639 = { [1] = 3, [3] = val639 }
    val639[2] = val639

    local val640 = tonumber
    val640 = { [1] = 3, [3] = val640 }
    val640[2] = val640

    local val641 = pairs
    val641 = { [1] = 3, [3] = val641 }
    val641[2] = val641

    local val642 = select
    val642 = { [1] = 3, [3] = val642 }
    val642[2] = val642

    local val643 = setmetatable
    val643 = { [1] = 3, [3] = val643 }
    val643[2] = val643

    local val644 = getmetatable
    val644 = { [1] = 3, [3] = val644 }
    val644[2] = val644

    local cc3, val645 = p451.bc[-2496] or p451:cc(p451.Eb("x3T"), p451.Eb("!2"), -2496), {}
    val645[p451.bc[30170] or p451:cc(p451.Eb("C=aF>G_C"), p451.Eb("%TRX"), 30170)] = cc3

    local val646 = val645
    val646 = { [1] = 3, [3] = val646 }
    val646[2] = val646

    cc3 = string

    val645 = cc3[p451.bc[10521] or p451:cc(p451.Eb("?iLRE8x;"), p451.Eb("et4S"), 10521)]
    val645 = { [1] = 3, [3] = val645 }
    val645[2] = val645

    local val647 = cc3

    cc3 = val647[p451.bc[-14691] or p451:cc(p451.Eb("_+{>S"), p451.Eb("9GU"), -14691)]
    cc3 = { [1] = 3, [3] = cc3 }
    cc3[2] = cc3

    local val648 = val647
    local val649
    val647, val649 = val648[p451.bc[272] or p451:cc(p451.Eb("?gH!>"), p451.Eb("YK;"), 272)], val648

    val648 = val649[p451.bc[-6719] or p451:cc(p451.Eb("b0Q94EC&"), p451.Eb("Z%-5"), -6719)]
    val648 = { [1] = 3, [3] = val648 }
    val648[2] = val648

    local val650 = table

    val649 = val650[p451.bc[-24209] or p451:cc(p451.Eb("-0;Wx"), p451.Eb("pRo"), -24209)]
    val649 = { [1] = 3, [3] = val649 }
    val649[2] = val649

    local val651 = val650

    val650 = val651[p451.bc[-7392] or p451:cc(p451.Eb("-A&F%"), p451.Eb("EUf"), -7392)]
    val650 = { [1] = 3, [3] = val650 }
    val650[2] = val650

    local val652 = val651

    val651 = val652[p451.bc[-16789] or p451:cc(p451.Eb("A<!Ws)*%"), p451.Eb("M500"), -16789)]
    val651 = { [1] = 3, [3] = val651 }
    val651[2] = val651

    local val653 = val652

    val652 = val653[p451.bc[18047] or p451:cc(p451.Eb(">Wxt5kyi"), p451.Eb("BjbY"), 18047)]
    val652 = { [1] = 3, [3] = val652 }
    val652[2] = val652

    val653 = getfenv
    val653 = { [1] = 3, [3] = val653 }
    val653[2] = val653

    local val654 = bit32

    local val655 = val654[p451.bc[27572] or p451:cc(p451.Eb("vAm%"), p451.Eb("(*"), 27572)]
    val655 = { [1] = 3, [3] = val655 }
    val655[2] = val655

    local val656 = val654
    local val657
    val654, val657 = val656[p451.bc[-9065] or p451:cc(p451.Eb("CuAya"), p451.Eb("97O"), -9065)], val656

    val656 = val657[p451.bc[7322] or p451:cc(p451.Eb("0(}m6"), p451.Eb("9AE"), 7322)]
    val656 = { [1] = 3, [3] = val656 }
    val656[2] = val656

    local val658 = val657

    val657 = val658[p451.bc[7729] or p451:cc(p451.Eb("H@`5rAp"), p451.Eb("%T)"), 7729)]
    val657 = { [1] = 3, [3] = val657 }
    val657[2] = val657

    local ub = val658

    val658 = ub[p451.bc[28783] or p451:cc(p451.Eb("&=5J*1tk"), p451.Eb("QDeL"), 28783)]
    val658 = { [1] = 3, [3] = val658 }
    val658[2] = val658

    ub = p451:Ub({
      val658, val644, val643, val639, val653, val641, val657, val640, val655, val656, val637, val638, val648, val649, val645, val646, val652, val650, cc3, val642, val651, val636, })

    return ub
  end, function(p452, p453)
    return function()
      if not p453[1][2][p453[1][1]] then
        return
      end

      p453[1][2][p453[1][1]] = false
      p453[2][2][p453[2][1]].Transparency = 1

      for i40 = 1, p453[3][2][p453[3][1]] do
        p453[4][2][p453[4][1]][i40].Transparency = 1
      end
    end
  end, {}, closureFactory(), function(p454, p455)
    return function()
      local character20 = p455[1][2][p455[1][1]].Character
      local humanoidRootPart12 = character20 and character20:FindFirstChild("HumanoidRootPart")

      if not humanoidRootPart12 then
        return
      end

      if p455[2][2][p455[2][1]].feetBox then
        p455[3][2][p455[3][1]].DrawBox(
          p455[4][2][p455[4][1]], character20, humanoidRootPart12, "feet"
        )
      else
        p455[4][2][p455[4][1]].Transparency = 1
      end

      if p455[2][2][p455[2][1]].headBox then
        p455[3][2][p455[3][1]].DrawBox(
          p455[5][2][p455[5][1]], character20, humanoidRootPart12, "head"
        )
      else
        p455[5][2][p455[5][1]].Transparency = 1
      end

      if not (p455[2][2][p455[2][1]].feetBox or p455[2][2][p455[2][1]].headBox) then
        p455[3][2][p455[3][1]].DrawBox(
          p455[4][2][p455[4][1]], character20, humanoidRootPart12, nil
        )
      end
    end
  end, function(p456, p457)
    return function(p458, p459)
      if type(firetouchinterest) == "function" then
        pcall(firetouchinterest, p458, p459, 0)
        pcall(firetouchinterest, p458, p459, 1)
        return true
      end

      if type(getconnections) ~= "function" then
        return false
      end

      local val659, success24 = pcall(getconnections, p458.Touched)

      if not val659 or type(success24) ~= "table" then
        return false
      end

      local val660 = false

      for v837, v838 in success24 do
        local val661, success25 = pcall(function() return v838.Function end)

        if val661 and type(success25) == "function" then
          task.spawn(pcall, success25, p459)
          val660 = true
        end
      end

      return val660
    end
  end, function(p460, p461)
    return function()
      local val662, success26 = pcall(p461[1][2][p461[1][1]].GetNetworkPing, p461[1][2][p461[1][1]])
      return math.clamp((val662 and success26 or 0.05) * 2, 0.05, p461[2][2][p461[2][1]].cd)
    end
  end, function(p462, p463) return function() end end, function(p464, p465)
    return function(p466, ...)
      local swap = p465[1][2][p465[1][1]].Swap

      if swap and p466 == p465[1][2][p465[1][1]].Event and getnamecallmethod() == "FireServer" then
        return p465[1][2][p465[1][1]].Old(p466, swap())
      end

      return p465[1][2][p465[1][1]].Old(p466, ...)
    end
  end, function(p467, p468)
    return function()
      if not p468[1][2][p468[1][1]].antiTackle then
        table.clear(p468[2][2][p468[2][1]])
        p468[3][2][p468[3][1]] = nil
        return
      end

      local character21 = p468[4][2][p468[4][1]].Character

      if not (character21 and type(getconnections) == "function") then
        return
      end

      if character21 ~= p468[3][2][p468[3][1]] then
        table.clear(p468[2][2][p468[2][1]])
        p468[3][2][p468[3][1]] = character21
      end

      local val663, success27 = pcall(getconnections, character21.ChildAdded)

      if not (val663 and type(success27) == "table") then
        return
      end

      for v845, v846 in success27 do
        local val664, success28 = pcall(function() return v846.Function end)

        if val664 and type(success28) == "function" then
          local val665, success29 = pcall(debug.getupvalues, success28)

          if val665 and type(success29) == "table" and success29[1] == p468[4][2][p468[4][1]]
            and type(success29[2]) == "function" and success29[3] == nil then
            pcall(function()
              if v846.Enabled then
                v846:Disable()
              end
            end)

            p468[2][2][p468[2][1]][v846] = true
          end
        end
      end
    end
  end, function(p469)
    local element84 = string

    local unpack, sub, byte3
    unpack, element84, sub, byte3 = element84.unpack, bit32, element84.sub, element84.byte

    local band2, rshift
    band2, rshift, element84 = element84.band, element84.rshift, table

    local concat
    concat, element84 = element84.concat, {}

    local val666 = element84

    unpack = { [1] = 3, [3] = unpack }
    unpack[2] = unpack

    sub = { [1] = 3, [3] = sub }
    sub[2] = sub

    byte3 = { [1] = 3, [3] = byte3 }
    byte3[2] = byte3

    rshift = { [1] = 3, [3] = rshift }
    rshift[2] = rshift

    band2 = { [1] = 3, [3] = band2 }
    band2[2] = band2

    concat = { [1] = 3, [3] = concat }
    concat[2] = concat

    val666 = { [1] = 3, [3] = val666 }
    val666[2] = val666

    element84 = p469:Ib({ band2, sub, byte3, val666, concat, unpack, rshift })
    return element84
  end, function(p470, p471)
    return function(p472)
      local val667 = 179
      local val668, val669, val670, find, val671, val672, val673, val674

      repeat
        if val667 <= 196 then
          if val667 < 179 then
            find = 85
            local val675, sub2, val676, val677
            val676, val675, sub2, val672, find, val677 = val673, val673, p472.sub, val671 * find, "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!#$%&()*+-;<=>?@^_`{|}~", p472
            sub2 = sub2(val677, val675, val676)
            find, val668, val677, val675 = find.find, find, 1, true
            val667, find = 221, find(val668, sub2, val677, val675)
            val672, val670 = 1, val672 + find
            val671 = val670 - val672
          elseif val667 <= 179 then
            val671, val673, val669 = 0, 1, 5
            val674 = val673

            val667 = (val669 ~= val669 or val674 > 0 and val673 > val669
                  or (val674 <= 0 or val674 ~= val674) and val673 < val669)
                and 196
              or 96
          else
            val673, val670, val669, val674 = p471[2][2][p471[2][1]], 24, p471[3][2][p471[3][1]], val671
            val669 = val669(val674, val670)
            val672, val674, val670, find = val671, p471[1][2][p471[1][1]], p471[3][2][p471[3][1]], 16
            val670 = val670(val672, find)
            val672 = 255
            val674 = val674(val670, val672)
            val668, find, val672, val670 = 8, val671, p471[3][2][p471[3][1]], p471[1][2][p471[1][1]]
            val672 = val672(find, val668)
            find = 255
            val670 = val670(val672, find)
            val668, val672, find = 255, p471[1][2][p471[1][1]], val671
            val672 = p470.c(val672(find, val668))
            val673 = p470.c(val673(val669, val674, val670, p470.d(val672)))
            return p470.d(val673)
          end
        else
          val673 = val673 + val674

          val667 = (val674 > 0 and val673 > val669 or val674 <= 0 and val673 < val669 or val674 ~= val674)
              and val667 + -25
            or 96
        end
      until false
    end
  end, function(p473, p474)
    return function()
      local character22 = p474[1][2][p474[1][1]].Character

      if not character22 then
        return nil
      end

      local humanoidRootPart13 = character22:FindFirstChild("HumanoidRootPart")
      local humanoid4 = character22:FindFirstChildOfClass("Humanoid")

      if not (humanoidRootPart13 and humanoid4) or humanoid4.Health <= 0 then
        return nil
      end

      return character22, humanoidRootPart13, humanoid4
    end
  end, function(p475, p476)
    return function(p477, p478)
      local val678 = 60

      local val679, val680, val681, val682, val683, val684, val685, val686, val687, val688, val689, val690, val691, val692, val693, val694, val695, val696, val697, val698, val699, val700, val701, val702, val703, val704, val705, val706, val707, val708, val709, val710, val711, val712, val713, val714, val715, val716, val717, val718, val719, val720, val721, val722, val723, val724, val725, val726, val727, val728, val729, val730, val731, val732, val733, val734, val735, val736, val737, val738, val739, val740, val741, val742, val743, val744, val745, val746, iter, val747, val748, val749, val750, val751, val752, val753, val754, val755, val756, iter2, val757, val758, val759, val760, val761, val762, val763, val764, val765, val766, val767, val768, val769

      repeat
        if val678 <= 795 then
          if val678 < 374 then
            if val678 > 181 then
              if val678 < 263 then
                if val678 <= 217 then
                  if val678 > 201 then
                    if val678 < 209 then
                      if val678 <= 205 then
                        if val678 > 204 then
                          val700 = 166
                          val678 = val699 < val700 and 42 or 36080 / val678
                        elseif val678 > 203 then
                          val700 = 185
                          val678 = val699 > val700 and val678 + 532 or 766
                        elseif val678 > 202 then
                          val745 = val705[14733]
                          val747, val748 = nil, val767[val745]
                          val678 = val748 == val747 and 4010 - val678 or val678 + 3338
                        else
                          val700 = 74
                          val678 = val699 >= val700 and 821 or 952 - val678
                        end
                      elseif val678 <= 206 then
                        val700, val733 = 43, 231
                        val678 = val699 > val700 and val678 + 12 or val678 + 55
                      else
                        val700 = 275
                        val678 = val699 >= val700 and 218 - val678 or 65
                      end
                    elseif val678 <= 215 then
                      if val678 < 214 then
                        if val678 <= 209 then
                          val747 = {}
                          val747[1] = val745
                          val747[2] = p477

                          val748 = val747
                          val678, val767[val745] = 756, val748
                        else
                          val700 = 188
                          val678 = val699 <= val700 and 166268 / val678 or 564
                        end
                      elseif val678 <= 214 then
                        val700 = 221
                        val678 = val699 <= val700 and 624 or val678 + 404
                      else
                        val678 = val731 and 1418 or val678 + 2063
                      end
                    elseif val678 <= 216 then
                      val709 = 1
                      val731 = val690 - val709
                      val678 = val719 < val709 and 213840 / val678 or 696
                    else
                      val700 = 560
                      val678 = val699 > val700 and 54901 / val678 or 112
                    end
                  elseif val678 <= 194 then
                    if val678 < 191 then
                      if val678 > 187 then
                        val747 = {}
                        val747[1] = val745
                        val747[2] = p477

                        val748 = val747
                        val767[val745] = val748
                        val678 = val682 < val689 and 657 or val678 + 498
                      elseif val678 > 186 then
                        val700 = 147
                        val678 = val699 >= val700 and 188683 / val678 or 536
                      elseif val678 <= 184 then
                        val709, val715 = val755 - val700, 1
                        val678, val731 = 4020, val709 + val715
                      else
                        val753, val700 = 58, 202
                        val678 = val699 < val700 and val678 + -175 or 35526 / val678
                      end
                    elseif val678 <= 193 then
                      if val678 > 192 then
                        val700 = 236
                        val678 = val699 <= val700 and 13896 / val678 or 353 - val678
                      elseif val678 <= 191 then
                        val700 = 204
                        val678 = val699 <= val700 and 871 or 964
                      else
                        val700 = 889
                        val678 = val699 >= val700 and 30144 / val678 or 45
                      end
                    else
                      val690, val740 = val681[6284], 21
                      val709, val731, val700 = 6, val681[14733], val690 - val740
                      val740, val731 = val731 - val709, 1
                      val690 = val740 == val731
                      p477[val700] = val690

                      val731, val709 = val681[49287], 4
                      val731, val700, val709 = val681[49932], val731 - val709, 46

                      val690, val731, val709 = val731 - val709, val681[24799], 5
                      val740, val709 = val731 - val709, 0
                      val731 = val690 == val709
                      val678 = val731 and 402 or 893
                    end
                  elseif val678 >= 199 then
                    if val678 < 200 then
                      val700 = 56
                      val678 = val699 >= val700 and 619 - val678 or 574
                    elseif val678 > 200 then
                      val700 = 194
                      val678 = val699 >= val700 and val678 + 788 or val678 + 693
                    else
                      val700 = 78
                      val678 = val699 > val700 and 441 or 660
                    end
                  elseif val678 >= 196 then
                    if val678 > 196 then
                      val700 = 498
                      val678 = val699 >= val700 and val678 + -166 or 71
                    else
                      val700 = 624
                      val678 = val699 < val700 and 217 or 68
                    end
                  else
                    val700 = 121
                    val678 = val699 <= val700 and 1026 - val678 or 888
                  end
                elseif val678 <= 242 then
                  if val678 < 233 then
                    if val678 >= 223 then
                      if val678 < 225 then
                        val731, val690, val709 = val681[14733], p476[10][2][p476[10][1]], 42
                        val740 = val731 - val709
                        val700, val740, val731 = val690[val740], val681[6284], 32
                        val690, val731, val709 = val740 - val731, val700[2], val700[1]
                        val740 = val731[val709]
                        p477[val690] = val740
                        val740, val731 = val681[49287], 14
                        val690, val705, val715 = val740 - val731, 59, val681[49932]
                        val678, val709 = 220, val715 - val705
                        val731 = p477[val709]
                        val740 = #val731
                        p477[val690] = val740
                      elseif val678 <= 225 then
                        val760, val705 = 1, val683[val713]
                        val745, val760, val713 = 1, val705[6284], val713 + val760
                        val678 = val760 == val745 and val678 + 123 or 468 - val678
                      else
                        val700 = 432
                        val678 = val699 < val700 and 917 or 302
                      end
                    elseif val678 >= 219 then
                      if val678 <= 219 then
                        val700 = 243
                        val678 = val699 < val700 and val678 + -204 or 164
                      else
                        val681, val724, val723 = val683[val713], 103, 92
                        val699, val700 = val681[15562], 1
                        val700, val713 = 175, val713 + val700
                        val678 = val699 >= val700 and 36300 / val678 or 28
                      end
                    else
                      val731, val709 = val681[6284], 55
                      val731, val709, val700 = val681[14733], 19, val731 - val709
                      val731, val709, val690 = val681[49287], 45, val731 - val709

                      val709, val740 = 0, val731 - val709
                      val731 = val690 == val709
                      val678 = val731 and 1013 - val678 or 743
                    end
                  elseif val678 >= 238 then
                    if val678 <= 241 then
                      if val678 <= 239 then
                        if val678 > 238 then
                          val740, val731 = val681[6284], 28
                          val678, val690 = 220, val740 - val731
                          val690, val715, val700, val709 = val681[29601], 59, p477[val690], val681[14733]
                          val731 = val709 - val715
                          val740 = p477[val731]
                          val700[val690] = val740
                          val740, val690 = 22, val681[49287]
                          val700, val690 = val690 - val740, nil
                          p477[val700] = val690
                        else
                          val700 = 225
                          val678 = val699 > val700 and 157556 / val678 or 184688 / val678
                        end
                      else
                        val688, val700 = 217, 137
                        val678 = val699 < val700 and 16 or 172
                      end
                    else
                      val700 = 334
                      val678 = val699 <= val700 and 283 or 694
                    end
                  elseif val678 >= 234 then
                    if val678 <= 234 then
                      val748 = val760[14733]
                      iter, val747 = nil, val767[val748]
                      val678 = val747 == iter and val678 + 3443 or val678 + 929
                    else
                      val760 = 1
                      val678, val705 = val678 + 3748, val740 - val760
                    end
                  else
                    val700 = 117
                    val678 = val699 <= val700 and 129781 / val678 or 143295 / val678
                  end
                elseif val678 < 254 then
                  if val678 < 248 then
                    if val678 <= 245 then
                      if val678 <= 243 then
                        val747, val748 = val705[14733], p476[10][2][p476[10][1]]
                        val678, val745 = 2669 - val678, val748[val747]
                        val740[val731] = val745
                      else
                        val700 = 14
                        val678 = val699 <= val700 and 848 - val678 or 465 - val678
                      end
                    else
                      val700 = 213
                      val678 = val699 < val700 and 69 or 290 - val678
                    end
                  elseif val678 < 251 then
                    val695, val700 = 62, 206
                    val678 = val699 < val700 and 40176 / val678 or 140
                  elseif val678 > 251 then
                    val700 = 576
                    val678 = val699 > val700 and 356 - val678 or 203159 / val678
                  else
                    val745 = val705[14733]
                    val748, val747 = val767[val745], nil
                    val678 = val748 == val747 and 1324 - val678 or 738693 / val678
                  end
                elseif val678 <= 257 then
                  if val678 > 256 then
                    val709, val731, val760, val678, val705, val740, val715 = 1, p478[24830], p477, 2903, val700, p476[6][2][p476[6][1]], val690
                  elseif val678 >= 255 then
                    if val678 <= 255 then
                      val700 = 97
                      val678 = val699 >= val700 and 52 or val678 + -221
                    else
                      val747, val691 = p476[2][2][p476[2][1]], 37
                      val678, val691, val754, iter2 = 2318 - val678, p476[16][2][p476[16][1]], val745, val709 * val691
                    end
                  else
                    val700 = 55
                    val678 = val699 >= val700 and 50546 / val678 or 425 - val678
                  end
                elseif val678 <= 258 then
                  val740, val690 = 14, val681[6284]
                  val700, val715, val709 = val690 - val740, 32, val681[14733]
                  val731 = val709 - val715
                  val740 = p477[val731]
                  val690 = #val740
                  val678, p477[val700] = val678 + -38, val690
                  val690, val740 = val681[49287], 17
                  val700, val740 = val690 - val740, val681[49932]
                  val690 = p477[val740]
                  p477[val700] = val690
                else
                  val690, val740 = val681[6284], 5
                  val715, val709, val700 = 1, val681[14733], val690 - val740
                  val731 = val709 - val715
                  val740, val705, val715 = p477[val731], 24, val681[49287]
                  val709 = val715 - val705
                  val731 = p477[val709]
                  val690 = val740 + val731
                  p477[val700] = val690
                  val678 = val733 < val705 and 478 or 220
                end
              elseif val678 <= 312 then
                if val678 <= 290 then
                  if val678 <= 280 then
                    if val678 < 269 then
                      if val678 <= 266 then
                        if val678 > 265 then
                          val690, val740 = val681[6284], 24
                          val740, val731, val678, val700 = p476[15][2][p476[15][1]], val681[29601], 220, val690 - val740
                          val690 = val740[val731]
                          p477[val700] = val690
                          val740, val690 = 3, val681[14733]
                          val690, val700 = val681[44007], val690 - val740
                          p477[val700] = val690
                        elseif val678 <= 263 then
                          val740, val690 = 7, val681[6284]
                          val731, val678, val700, val709 = val681[14733], 220, val690 - val740, 23
                          val740 = val731 - val709
                          val690 = p477[val740]
                          p477[val700] = val690
                        else
                          val740, val690 = 8, val681[6284]
                          val700, val715, val709 = val690 - val740, 38, val681[14733]
                          val731 = val709 - val715
                          val740 = p477[val731]
                          val690 = #val740
                          p477[val700] = val690
                          val690, val740 = val681[49287], 18
                          val740, val731, val700 = val681[23485], 6, val690 - val740
                          val690 = val740 - val731
                          p477[val700] = val690
                          val678 = val761 > val715 and 485 - val678 or 846
                        end
                      else
                        val740, val690 = 47, val681[6284]
                        val709, val715, val700 = val681[14733], 18, val690 - val740
                        val731 = val709 - val715
                        val678, val740 = 58740 / val678, p477[val731]
                        val690 = -val740
                        p477[val700] = val690
                      end
                    elseif val678 >= 278 then
                      if val678 > 278 then
                        val740, val690 = 18, val681[6284]
                        val700, val740, val731 = val690 - val740, val681[14733], 1
                        val678, val690 = 220, val740 == val731
                        p477[val700] = val690
                      else
                        val760, val705 = 1, val683[val713]
                        val745, val760, val713 = 1, val705[6284], val713 + val760
                        val678 = val760 == val745 and 146228 / val678 or 545
                      end
                    elseif val678 > 269 then
                      val678, val731 = 291, val755 - val700
                    else
                      val705 = val715[1]
                      val678 = val705 >= val700 and 1097 - val678 or 1516 - val678
                    end
                  elseif val678 < 285 then
                    if val678 < 282 then
                      val705, val760 = val683[val713], 1
                      val713, val745, val760 = val713 + val760, 1, val705[6284]
                      val678 = val760 == val745 and 4007 or 1896 - val678
                    elseif val678 > 282 then
                      val690, val740 = val681[6284], 9
                      val700, val678, val709, val715 = val690 - val740, 220, val681[14733], 34
                      val731 = val709 - val715
                      val740, val731 = p477[val731], val681[29601]
                      val690 = val740[val731]
                      p477[val700] = val690

                      val740, val690 = 45, val681[49287]
                      val740, val700 = {}, val690 - val740

                      val690 = val740
                      p477[val700] = val690
                    else
                      val731, val690, val709 = val681[14733], p476[10][2][p476[10][1]], 13
                      val740 = val731 - val709
                      val700, val740, val731 = val690[val740], val681[6284], 8
                      val709, val690, val731 = val700[1], val740 - val731, val700[2]
                      val740 = val731[val709]
                      p477[val690] = val740
                      val731, val740 = 49, val681[49287]
                      val690, val678, val731 = val740 - val731, 220, {}
                      val740 = val731
                      p477[val690] = val740
                    end
                  elseif val678 >= 287 then
                    if val678 > 287 then
                      val678, val713 = 510 - val678, val713 + val740
                    else
                      val709, val731, val690 = 45, val681[14733], p476[10][2][p476[10][1]]
                      val740 = val731 - val709
                      val700 = val690[val740]
                      val690, val705, val740, val715 = val700[2], 50, val700[1], val681[6284]
                      val709 = val715 - val705
                      val731 = p477[val709]
                      val678, val690[val740] = 220, val731
                      val740, val709, val715 = p476[10][2][p476[10][1]], val681[49932], 18
                      val731 = val709 - val715
                      val690 = val740[val731]
                      val705, val731, val740, val760 = val681[49287], val690[1], val690[2], 22
                      val715 = val705 - val760
                      val709 = p477[val715]
                      val740[val731] = val709
                    end
                  else
                    val690, val740 = val681[6284], 23
                    val700, val740, val731 = val690 - val740, val681[14733], 15
                    val731, val709, val690 = val681[8652], 55, val740 - val731
                    val709, val731, val715, val740 = p477[val700], val681[6863], p477[val690], val731 - val709
                    val678 = val709 >= val715 and 1001 - val678 or 112290 / val678
                  end
                elseif val678 > 301 then
                  if val678 <= 304 then
                    if val678 >= 303 then
                      if val678 <= 303 then
                        val690, val740 = val681[6284], 52
                        val709, val731, val700 = 13, val681[14733], val690 - val740
                        val740 = val731 - val709
                        val690 = p477[val740]
                        p477[val700] = val690
                        val740, val690 = 18, val681[49287]
                        val700, val690, val731, val740 = val690 - val740, val767, nil, nil
                        val690, val740, val731 = p475.b(val690, val740, val731)
                        val709, val715 = val690(val740, val731)
                        val731 = val709
                        val678 = val731 == nil and 220 or 676
                      else
                        val678 = val709 and 259616 / val678 or 279376 / val678
                      end
                    else
                      val700 = 432
                      val678 = val699 > val700 and 760 or 183616 / val678
                    end
                  elseif val678 <= 311 then
                    val740, val731 = val681[6284], 8
                    val690 = val740 - val731
                    val709, val700, val731 = 24, p477[val690], val681[14733]
                    val740 = val731 - val709
                    val709, val690, val715 = val681[49287], p477[val740], 27
                    val731 = val709 - val715
                    val740 = p477[val731]
                    val700[val690] = val740
                    val690, val740 = val681[49932], 9
                    val740, val700, val731 = val681[24799], val690 - val740, 44

                    val731, val690 = 1, val740 - val731
                    val731, val740, val709 = nil, val690 - val731, -1

                    val678 = val740 == val709 and 995 or 317220 / val678
                  else
                    val740, val690 = 24, val681[6284]
                    val709, val731, val700 = 41, val681[14733], val690 - val740
                    val740 = val731 - val709
                    val690 = p477[val740]
                    p477[val700] = val690
                    val678, val690, val740 = 220, val681[49287], 35
                    val731, val709, val700 = val681[49932], 44, val690 - val740
                    val740 = val731 - val709
                    val690 = p477[val740]
                    p477[val700] = val690
                  end
                elseif val678 > 298 then
                  if val678 <= 300 then
                    if val678 <= 299 then
                      val760, val705 = 31, val681[6863]
                      val715 = val705 - val760
                      val678, val713 = val678 + -79, val713 + val715
                    else
                      val690, val678, val709, val731 = p476[10][2][p476[10][1]], 220, 8, val681[14733]
                      val740 = val731 - val709
                      val700 = val690[val740]
                      val740, val705, val690, val715 = val700[1], 42, val700[2], val681[6284]
                      val709 = val715 - val705
                      val731 = p477[val709]
                      val690[val740] = val731
                      val709, val740, val715 = val681[49932], p476[10][2][p476[10][1]], 61
                      val731 = val709 - val715
                      val690, val709, val731 = val740[val731], 17, val681[49287]
                      val709, val740, val715 = val690[2], val731 - val709, val690[1]
                      val731 = val709[val715]
                      p477[val740] = val731
                    end
                  else
                    val713 = val713 + val740
                    val678 = val746 > val734 and 220 or 67725 / val678
                  end
                elseif val678 > 295 then
                  val690, val740 = val681[6284], 27
                  val709, val700, val715 = val681[14733], val690 - val740, 30
                  val678, val731 = 65560 / val678, val709 - val715
                  val705, val715, val740 = 10, val681[49287], p477[val731]
                  val709 = val715 - val705
                  val731 = p477[val709]
                  val690 = val740 >= val731
                  p477[val700] = val690
                elseif val678 >= 292 then
                  if val678 <= 292 then
                    val678, val747 = 2219, iter2
                  else
                    val715 = val690 <= val731
                    val709 = not val715
                    val678 = val709 and 421 or 664 - val678
                  end
                else
                  val678 = val731 and 239493 / val678 or val678 + -124
                end
              elseif val678 >= 341 then
                if val678 <= 359 then
                  if val678 > 355 then
                    if val678 >= 358 then
                      if val678 > 358 then
                        val678, val731 = 944, val755 - val700
                      else
                        val700 = 171
                        val678 = val699 <= val700 and 870 or val678 + 604
                      end
                    else
                      val690, val740 = val681[6284], 51
                      val740, val700, val731 = val681[23485], val690 - val740, 53
                      val690 = val740 - val731
                      p477[val700] = val690
                      val740, val690 = 56, val681[14733]
                      val700, val709, val731 = val690 - val740, 34, val681[49287]
                      val731, val740 = 1, val731 - val709
                      val678, val690 = 220, val740 == val731
                      p477[val700] = val690
                    end
                  elseif val678 > 349 then
                    val760, val745 = val715[2], val715[1]
                    val705 = val760[val745]

                    val715[3] = val705
                    val715[2] = val715

                    val705 = 3
                    val715[1] = val705
                    val678, val705 = 2672 - val678, nil
                    val767[val709] = val705
                  elseif val678 > 348 then
                    val690, val740 = val681[6284], 21
                    val709, val700, val731 = 23, val690 - val740, val681[14733]
                    val678, val740 = 365403 / val678, val731 - val709
                    val690 = p477[val740]
                    p477[val700] = val690
                    val740, val731 = val681[24799], 61
                    val690 = val740 - val731
                    val700, val740, val731 = val756[val690], val681[49932], 34
                    val690, val740 = val740 - val731, p476[7][2][p476[7][1]]
                    val731 = val690
                  elseif val678 > 341 then
                    val745 = val705[14733]
                    val748, val747 = val767[val745], nil
                    val678 = val748 == val747 and 209 or 1104 - val678
                  else
                    val740, val690 = 54, val681[6284]
                    val690, val700 = nil, val690 - val740
                    p477[val700] = val690
                    val740, val690 = 20, val681[14733]
                    val700, val731, val740 = val690 - val740, 46, val681[23485]
                    val678, val690 = 75020 / val678, val740 - val731
                    p477[val700] = val690
                  end
                elseif val678 >= 369 then
                  if val678 < 371 then
                    val715, val705 = val681[8652], 29
                    val709 = val715 - val705
                    val678, val713 = 220, val713 + val709
                  elseif val678 <= 371 then
                    val709, val715 = val681[49932], 46
                    val715, val731 = {}, val709 - val715
                    val709 = val715
                    val678, p477[val731] = 220, val709
                  else
                    val709, val731 = 23, val681[6284]
                    val709, val731, val700 = 39, val681[14733], val731 - val709
                    val709, val690, val731 = 23, val731 - val709, val681[49287]
                    val709, val740 = 0, val731 - val709

                    val731 = val690 == val709
                    val678 = val731 and val678 + 342 or 773
                  end
                elseif val678 > 365 then
                  val740, val690 = 10, val681[6284]
                  val709, val715, val700 = val681[14733], 40, val690 - val740
                  val731 = val709 - val715
                  val715, val740, val705 = val681[49287], p477[val731], 45
                  val709 = val715 - val705
                  val731 = p477[val709]
                  val690 = val740 ~= val731
                  p477[val700] = val690
                  val740, val690 = 50, val681[49932]
                  val700, val740, val731 = val690 - val740, val681[24799], 11
                  val690, val731 = val740 - val731, 1
                  val731, val709, val740 = nil, -1, val690 - val731
                  val678 = val740 == val709 and 938 or 864
                elseif val678 <= 364 then
                  val678, val709 = val678 + 317, 1
                  val731 = val690 - val709
                else
                  val690, val740 = val681[6284], 61
                  val715, val700, val709 = 32, val690 - val740, val681[14733]
                  val731 = val709 - val715
                  val740, val705, val715 = p477[val731], 21, val681[49287]
                  val709 = val715 - val705
                  val731 = p477[val709]
                  val690 = val740 - val731
                  val678, p477[val700] = 220, val690
                end
              elseif val678 <= 331 then
                if val678 <= 324 then
                  if val678 <= 323 then
                    if val678 >= 319 then
                      if val678 <= 319 then
                        val700 = 498
                        val678 = val699 <= val700 and 562 or 1338 - val678
                      else
                        val709, val731 = 7, val681[6284]
                        val731, val709, val700 = val681[14733], 9, val731 - val709
                        val690, val731, val709 = val731 - val709, val681[49287], 8
                        val709, val740 = 0, val731 - val709
                        val731 = val690 == val709
                        val678 = val731 and 87210 / val678 or 614 - val678
                      end
                    else
                      val740, val690 = 2, val681[6284]
                      val700, val678, val709, val715 = val690 - val740, 69740 / val678, val681[14733], 24
                      val731 = val709 - val715
                      val705, val740, val715 = 10, p477[val731], val681[49287]
                      val709 = val715 - val705
                      val731 = p477[val709]
                      val690 = val740 - val731
                      p477[val700] = val690
                      val709, val731, val690 = 18, val681[24799], p476[10][2][p476[10][1]]

                      val740 = val731 - val709
                      val740, val700, val731 = val681[49932], val690[val740], 22

                      val690, val709, val731 = val740 - val731, val700[1], val700[2]
                      val740 = val731[val709]
                      p477[val690] = val740
                    end
                  else
                    val690, val740 = val681[6284], 56
                    val740, val731, val700 = val681[14733], 34, val690 - val740
                    val690, val731, val709 = val740 - val731, val681[8652], 16
                    val740, val709, val715 = val731 - val709, val681[6863], 55
                    val715, val709, val731 = p477[val690], p477[val700], val709 - val715
                    val678 = val709 ~= val715 and 97524 / val678 or 1123 - val678
                  end
                elseif val678 > 328 then
                  val705, val678, val715 = 1, 452, val755 - val690
                  val709 = val715 + val705
                elseif val678 <= 325 then
                  val740, val690 = 52, val681[6284]
                  val731, val709, val700 = val681[14733], 9, val690 - val740
                  val740 = val731 - val709
                  val690 = p477[val740]
                  p477[val700] = val690
                  val709, val690, val731 = 45, p476[10][2][p476[10][1]], val681[49932]
                  val678, val740 = 220, val731 - val709
                  val740, val700, val731 = val681[49287], val690[val740], 17
                  val709, val731, val690 = val700[1], val700[2], val740 - val731
                  val740 = val731[val709]
                  p477[val690] = val740
                else
                  val678, val731 = 488, val755 - val700
                end
              elseif val678 < 338 then
                if val678 > 332 then
                  val709, val715 = p477[val700], p476[3][2][p476[3][1]]
                  val760, val705, val747, val745 = p476[4][2][p476[4][1]], val709, 1, p477
                  val678, val747, val748 = 1315311 / val678, val700 + val731, val700 + val747
                else
                  val731, val709 = val681[6284], 42
                  val700, val731, val709 = val731 - val709, val681[14733], 25
                  val690, val709, val731 = val731 - val709, 14, val681[49287]
                  val709, val740 = 0, val731 - val709
                  val731 = val690 == val709
                  val678 = val731 and 625 or 271908 / val678
                end
              elseif val678 > 339 then
                val731, val709, val690 = val681[14733], 21, p476[10][2][p476[10][1]]
                val740 = val731 - val709
                val700, val740, val731 = val690[val740], val681[6284], 25
                val690, val731, val709 = val740 - val731, val700[2], val700[1]
                val740 = val731[val709]
                p477[val690] = val740

                val715, val709 = 41, val681[49287]
                val715, val690, val709 = 52, val709 - val715, val681[49932]
                val715, val709, val740 = 49, val681[24799], val709 - val715
                val715, val731 = 0, val709 - val715

                val709 = val740 == val715
                val678 = val709 and val678 + 378 or 304
              elseif val678 <= 338 then
                val740, val690 = 8, val681[6284]
                val715, val700, val709 = 31, val690 - val740, val681[14733]
                val731 = val709 - val715
                val705, val740, val715 = 51, p477[val731], val681[49287]
                val709 = val715 - val705
                val731 = p477[val709]
                val690 = val740 >= val731
                p477[val700] = val690
                val740, val690 = 39, val681[49932]

                val731, val740, val700 = 28, val681[24799], val690 - val740
                val731, val690 = 1, val740 - val731

                val740, val731, val709 = val690 - val731, nil, -1
                val678 = val740 == val709 and 1055 - val678 or 907
              else
                val690, val678, val740 = val681[6284], 559 - val678, 57
                val700, val731, val709 = val690 - val740, val681[14733], 39
                val740 = val731 - val709
                val690 = p477[val740]
                p477[val700] = val690
                val740, val690 = 22, val681[49287]
                val700, val690 = val690 - val740, nil
                p477[val700] = val690
              end
            elseif val678 >= 87 then
              if val678 >= 143 then
                if val678 < 164 then
                  if val678 >= 155 then
                    if val678 >= 159 then
                      if val678 < 162 then
                        if val678 > 159 then
                          val700 = 238
                          val678 = val699 > val700 and val678 + 636 or val678 + 325
                        else
                          val690, val740 = val681[6284], 50
                          val731, val700, val709 = val681[14733], val690 - val740, 13
                          val740 = val731 - val709
                          val690 = p477[val740]
                          p477[val700] = val690

                          val740, val690 = 56, val681[49287]
                          val740, val700, val731 = val681[49932], val690 - val740, 27

                          val690, val731 = val740 - val731, 1
                          val731, val709, val740 = nil, -1, val690 - val731
                          val678 = val740 == val709 and val678 + 807 or val678 + 285
                        end
                      elseif val678 > 162 then
                        val700 = 178
                        val678 = val699 < val700 and 19397 / val678 or 98
                      else
                        val700 = 189
                        val678 = val699 > val700 and 246 - val678 or val678 + -96
                      end
                    elseif val678 < 157 then
                      val700 = 218
                      val678 = val699 >= val700 and 9145 / val678 or 246
                    elseif val678 <= 157 then
                      val700 = 994
                      val678 = val699 > val700 and 215 - val678 or 79
                    else
                      val700 = 109
                      val678 = val699 < val700 and 117710 / val678 or 1100 - val678
                    end
                  elseif val678 < 151 then
                    if val678 <= 145 then
                      if val678 <= 143 then
                        val740, val690 = 27, val681[6284]
                        val715, val709, val700 = 23, val681[14733], val690 - val740
                        val731 = val709 - val715
                        val715, val678, val740, val705 = val681[49287], 363 - val678, p477[val731], 11
                        val709 = val715 - val705
                        val731 = p477[val709]
                        val690 = val740 > val731
                        p477[val700] = val690
                      else
                        val700 = 82
                        val678 = val699 <= val700 and 904 or val678 + 543
                      end
                    else
                      val700 = 132
                      val678 = val699 <= val700 and 200 - val678 or 81
                    end
                  elseif val678 < 153 then
                    val700, val732, val702 = 123, 169, 172
                    val678 = val699 < val700 and 8154 / val678 or 150
                  elseif val678 <= 153 then
                    val700 = 42
                    val678 = val699 > val700 and 31518 / val678 or 180
                  else
                    val700 = 79
                    val678 = val699 > val700 and 20790 / val678 or 7
                  end
                elseif val678 > 172 then
                  if val678 > 179 then
                    if val678 <= 180 then
                      val700 = 41
                      val678 = val699 < val700 and val678 + 818 or 1012 - val678
                    else
                      val700 = 39
                      val678 = val699 < val700 and 32037 / val678 or 334 - val678
                    end
                  elseif val678 >= 178 then
                    if val678 > 178 then
                      val719, val700, val765, val752 = 176, 47, 15, 136
                      val678 = val699 <= val700 and 252 - val678 or 113
                    else
                      val700 = 16
                      val678 = val699 <= val700 and 755 - val678 or val678 + 548
                    end
                  elseif val678 <= 176 then
                    val700 = 171
                    val678 = val699 < val700 and 143 or 63008 / val678
                  else
                    val700 = 26
                    val678 = val699 >= val700 and 7257 / val678 or 29
                  end
                elseif val678 > 167 then
                  if val678 >= 171 then
                    if val678 <= 171 then
                      val700 = 48
                      val678 = val699 > val700 and 928 or 548
                    else
                      val700 = 153
                      val678 = val699 < val700 and 14792 / val678 or 6880 / val678
                    end
                  else
                    val700, val736 = 455, 226
                    val678 = val699 <= val700 and val678 + 677 or 901
                  end
                elseif val678 < 166 then
                  if val678 <= 164 then
                    val700 = 243
                    val678 = val699 <= val700 and 874 or 460
                  else
                    val766, val708, val700, val751, val743 = 116, 198, 247, 43, 190
                    val678 = val699 >= val700 and 115 or 40920 / val678
                  end
                elseif val678 <= 166 then
                  val715, val709 = p476[3][2][p476[3][1]], p477[val700]
                  val705, val747, val760, val745 = val709, 1, p476[4][2][p476[4][1]], p477
                  val678, val748, val747 = 4095, val700 + val747, val700 + val731
                else
                  val709 = 1
                  val678, val731 = 823, val690 - val709
                end
              elseif val678 <= 119 then
                if val678 <= 103 then
                  if val678 <= 94 then
                    if val678 > 90 then
                      if val678 <= 91 then
                        val700 = 63
                        val678 = val699 < val700 and val678 + -36 or 6097 / val678
                      else
                        val700 = 312
                        val678 = val699 >= val700 and val678 + 728 or 640 - val678
                      end
                    elseif val678 < 89 then
                      val700 = 247
                      val678 = val699 > val700 and 501 - val678 or val678 + 358
                    elseif val678 > 89 then
                      val740, val690 = 17, val681[6284]
                      val709, val715, val700 = val681[14733], 55, val690 - val740
                      val731 = val709 - val715
                      val715, val740, val705 = val681[49287], p477[val731], 3
                      val709 = val715 - val705
                      val731 = p477[val709]
                      val690 = val740 > val731
                      p477[val700] = val690

                      val740, val690 = val705, val681[49932]
                      val740, val700, val731 = val681[24799], val690 - val740, 1

                      val690 = val740 - val731
                      val709, val740, val731 = -1, val690 - val731, nil
                      val678 = val740 == val709 and 84060 / val678 or 216
                    else
                      val700 = 769
                      val678 = val699 <= val700 and val678 + 107 or 192
                    end
                  elseif val678 > 99 then
                    val690, val740 = val681[6284], 7
                    val731, val740, val690, val700 = nil, nil, val767, val690 - val740
                    val690, val740, val731 = p475.b(val690, val740, val731)
                    val709, val715 = val690(val740, val731)
                    val731 = val709
                    val678 = val731 == nil and 787 or 816
                  elseif val678 > 98 then
                    val700 = 735
                    val678 = val699 > val700 and 765 or val678 + 393
                  else
                    val700 = 181
                    val678 = val699 < val700 and 960 or 1057 - val678
                  end
                elseif val678 <= 113 then
                  if val678 > 112 then
                    val700 = 67
                    val678 = val699 < val700 and 0 or val678 + 41
                  elseif val678 > 105 then
                    val700 = 540
                    val678 = val699 > val700 and 874 - val678 or 473
                  elseif val678 <= 104 then
                    val700 = 95
                    val678 = val699 > val700 and 418 or 419
                  else
                    val700 = 193
                    val678 = val699 >= val700 and 201 or 62
                  end
                elseif val678 > 115 then
                  val700 = 175
                  val678 = val699 > val700 and 755 or 35700 / val678
                else
                  val689, val700, val682 = 126, 516, 21
                  val678 = val699 > val700 and 89 or 38
                end
              elseif val678 > 134 then
                if val678 >= 139 then
                  if val678 < 140 then
                    val700 = 253
                    val678 = val699 > val700 and 730 or val678 + 295
                  elseif val678 > 140 then
                    val700 = 434
                    val678 = val699 <= val700 and val678 + 88 or 310 - val678
                  else
                    val700 = 229
                    val678 = val699 > val700 and 19 or 295 - val678
                  end
                elseif val678 > 135 then
                  val709, val715 = val690(val740, val731)
                  val731 = val709
                  val678 = val731 == nil and val678 + 82 or 876
                else
                  val700 = 83
                  val678 = val699 > val700 and 225 - val678 or 280 - val678
                end
              elseif val678 < 128 then
                if val678 >= 122 then
                  if val678 <= 122 then
                    val700 = 253
                    val678 = val699 < val700 and 817 or 139
                  else
                    val700 = 776
                    val678 = val699 <= val700 and val678 + 795 or 122598 / val678
                  end
                else
                  val700 = 113
                  val678 = val699 <= val700 and 478 or 77682 / val678
                end
              elseif val678 >= 132 then
                if val678 > 132 then
                  val700 = 157
                  val678 = val699 > val700 and 312 or 649
                else
                  val700 = 6
                  val678 = val699 < val700 and 1000 - val678 or 543
                end
              elseif val678 <= 128 then
                val740, val690 = 44, val681[6284]
                val731, val700, val740 = val681[29601], val690 - val740, p476[15][2][p476[15][1]]
                val690 = val740[val731]
                p477[val700] = val690
                val709, val731, val690 = 42, val681[49287], p476[10][2][p476[10][1]]
                val740 = val731 - val709
                val678, val700, val740, val731 = 220, val690[val740], val681[14733], 45
                val690, val709, val731 = val740 - val731, val700[1], val700[2]
                val740 = val731[val709]
                p477[val690] = val740
              else
                val735, val729, val700 = 239, 93, 763
                val678 = val699 > val700 and val678 + 280 or val678 + 714
              end
            elseif val678 > 49 then
              if val678 < 67 then
                if val678 >= 59 then
                  if val678 >= 64 then
                    if val678 < 65 then
                      val700 = 7
                      val678 = val699 > val700 and val678 + -58 or 1
                    elseif val678 > 65 then
                      val700 = 183
                      val678 = val699 >= val700 and 49 or 229 - val678
                    else
                      val700 = 250
                      val678 = val699 >= val700 and 122 or 87
                    end
                  elseif val678 < 60 then
                    val700 = 222
                    val678 = val699 <= val700 and val678 + 155 or val678 + 179
                  elseif val678 > 60 then
                    val700 = 191
                    val678 = val699 > val700 and 785 - val678 or 35030 / val678
                  else
                    val686, val749, val696, val744, val678, val767, val750, val728, val727, val680, val697, val713, val755, val714, val739 = 127, 137, 205, 247, 2433, p476[12][2][p476[12][1]], 224, 210, 227, 175, 10, 1, -1, 57, {}
                    val756, val739 = val739, p476[17][2][p476[17][1]]
                  end
                elseif val678 >= 54 then
                  if val678 > 55 then
                    val700 = 997
                    val678 = val699 > val700 and 786 or 829 - val678
                  elseif val678 > 54 then
                    val700 = 61
                    val678 = val699 <= val700 and 484 or 836
                  else
                    val700, val726 = 119, 145
                    val678 = val699 <= val700 and 233 or 195
                  end
                elseif val678 > 51 then
                  val700 = 112
                  val678 = val699 > val700 and 6292 / val678 or 158
                elseif val678 <= 50 then
                  val700 = 125
                  val678 = val699 > val700 and 535 or 561
                else
                  val700 = 148
                  val678 = val699 <= val700 and 187 or 74
                end
              elseif val678 <= 74 then
                if val678 <= 71 then
                  if val678 < 69 then
                    if val678 <= 67 then
                      val700 = 65
                      val678 = val699 >= val700 and val678 + 870 or 578 - val678
                    else
                      val700 = 742
                      val678 = val699 <= val700 and 99 or val678 + 63
                    end
                  elseif val678 > 69 then
                    val700 = 467
                    val678 = val699 > val700 and 809 or 27690 / val678
                  else
                    val700 = 208
                    val678 = val699 >= val700 and 825 or 280
                  end
                elseif val678 > 73 then
                  val700 = 151
                  val678 = val699 > val700 and 17686 / val678 or 25234 / val678
                elseif val678 > 72 then
                  val700 = 19
                  val678 = val699 < val700 and 64 or val678 + 108
                else
                  val700 = 233
                  val678 = val699 > val700 and 730 - val678 or 999 - val678
                end
              elseif val678 < 81 then
                if val678 <= 79 then
                  if val678 > 75 then
                    val700 = 915
                    val678 = val699 > val700 and 349 or 498
                  else
                    val700 = 141
                    val678 = val699 <= val700 and 9 or 35
                  end
                else
                  val700 = 1
                  val678 = val699 < val700 and val678 + 351 or 757
                end
              elseif val678 >= 84 then
                if val678 <= 84 then
                  val700 = 196
                  val678 = val699 >= val700 and 186 or val678 + 21
                else
                  val700 = 144
                  val678 = val699 > val700 and 137 - val678 or val678 + -11
                end
              else
                val700 = 133
                val678 = val699 <= val700 and 266 or 890
              end
            elseif val678 < 23 then
              if val678 <= 10 then
                if val678 < 6 then
                  if val678 <= 1 then
                    if val678 <= 0 then
                      val700 = 61
                      val678 = val699 < val700 and val678 + 254 or 91
                    else
                      val700 = 5
                      val678 = val699 < val700 and 80 or 132 / val678
                    end
                  else
                    val722, val700, val764 = 84, 458, 212
                    val678 = val699 > val700 and 197 or 141
                  end
                elseif val678 <= 9 then
                  if val678 <= 7 then
                    if val678 > 6 then
                      val700 = 77
                      val678 = val699 <= val700 and 202 or 200
                    else
                      val757, val700, val703 = 34, 15, 213
                      val678 = val699 <= val700 and 245 or 178
                    end
                  else
                    val700 = 139
                    val678 = val699 <= val700 and val678 + 460 or 882
                  end
                else
                  val700 = 322
                  val678 = val699 <= val700 and 104 - val678 or 242
                end
              elseif val678 >= 18 then
                if val678 > 19 then
                  val700 = 161
                  val678 = val699 <= val700 and 7128 / val678 or 709
                elseif val678 > 18 then
                  val700 = 239
                  val678 = val699 <= val700 and 193 or 4161 / val678
                else
                  val734, val700, val746 = 8, 158, 193
                  val678 = val699 > val700 and 22 or 2412 / val678
                end
              elseif val678 > 15 then
                val725, val700 = 90, 114
                val678 = val699 > val700 and 151 or val678 + 239
              elseif val678 <= 11 then
                val700 = 196
                val678 = val699 <= val700 and 440 or 581
              else
                val700 = 241
                val678 = val699 <= val700 and 4470 / val678 or 791
              end
            elseif val678 > 40 then
              if val678 > 44 then
                if val678 <= 45 then
                  val700 = 870
                  val678 = val699 >= val700 and val678 + -2 or 171 - val678
                else
                  val700 = 187
                  val678 = val699 >= val700 and 211 or 204
                end
              elseif val678 >= 43 then
                if val678 <= 43 then
                  val700 = 873
                  val678 = val699 > val700 and 416 or 642 - val678
                else
                  val700 = 216
                  val678 = val699 < val700 and 697 or 931
                end
              elseif val678 <= 41 then
                val700 = 28
                val678 = val699 < val700 and 509 or 707
              else
                val700 = 163
                val678 = val699 > val700 and 523 or 26544 / val678
              end
            elseif val678 > 34 then
              if val678 >= 38 then
                if val678 > 38 then
                  val700 = 162
                  val678 = val699 <= val700 and val678 + -22 or 205
                else
                  val700 = 404
                  val678 = val699 < val700 and val678 + 170 or 2
                end
              else
                val700 = 142
                val678 = val699 > val700 and 679 or 27720 / val678
              end
            elseif val678 > 29 then
              if val678 <= 31 then
                val700 = 515
                val678 = val699 > val700 and 892 or 319
              else
                val700 = 93
                val678 = val699 < val700 and 23 or 3536 / val678
              end
            elseif val678 < 28 then
              val700 = 87
              val678 = val699 <= val700 and 862 or 357
            elseif val678 <= 28 then
              val693, val742, val730, val758, val700, val704, val759 = 31, 103, 116, 55, 87, 17, 115
              val678 = val699 < val700 and val678 + 151 or val678 + 213
            else
              val700 = 19
              val678 = val699 <= val700 and 9831 / val678 or val678 + 478
            end
          elseif val678 >= 591 then
            if val678 > 709 then
              if val678 < 756 then
                if val678 > 727 then
                  if val678 > 743 then
                    if val678 < 750 then
                      if val678 > 745 then
                        val678, val731 = 3527, p475.c(val731(val709, val715))
                      else
                        val700 = 97
                        val678 = val699 <= val700 and 812 or 583
                      end
                    elseif val678 >= 754 then
                      if val678 <= 754 then
                        val747, iter = p476[10][2][p476[10][1]], val760[14733]
                        val678, val748 = 2596, val747[iter]
                        val731[val709] = val748
                      else
                        val731, val709 = val681[6284], 57

                        val709, val700, val731 = 41, val731 - val709, val681[14733]
                        val709, val690, val731 = 32, val731 - val709, val681[49287]
                        val709, val740 = 0, val731 - val709

                        val731 = val690 == val709
                        val678 = val731 and 1114 - val678 or val678 + 189
                      end
                    else
                      val700 = 67
                      val678 = val699 <= val700 and 950 or 925
                    end
                  elseif val678 < 736 then
                    if val678 <= 732 then
                      if val678 > 730 then
                        val760, val678, val745 = val715[2], 427, val715[1]
                        val705 = val760[val745]

                        val715[3] = val705
                        val715[2] = val715

                        val705 = 3
                        val715[1] = val705
                        val705 = nil
                        val767[val709] = val705
                      else
                        val690, val740 = val681[6284], 11
                        val709, val700, val715 = val681[14733], val690 - val740, 37
                        val678, val731 = 220, val709 - val715
                        val740, val715, val705 = p477[val731], val681[49287], 57
                        val709 = val715 - val705
                        val731 = p477[val709]
                        val690 = val740 * val731
                        p477[val700] = val690
                      end
                    else
                      val760, val745 = val700 + val705, 1
                      val678, val755 = 2002556 / val678, val760 - val745
                    end
                  elseif val678 <= 742 then
                    if val678 <= 738 then
                      if val678 > 736 then
                        val678, val709 = val678 + -236, 1
                        val731 = val690 - val709
                      else
                        val740, val731 = val681[6284], 2
                        val690 = val740 - val731
                        val715, val700, val709, val690 = 28, p477[val690], val681[14733], val681[29601]
                        val731 = val709 - val715
                        val740 = p477[val731]
                        val700[val690] = val740

                        val740, val690 = 54, val681[49287]
                        val740, val700 = {}, val690 - val740

                        val690 = val740
                        val678, p477[val700] = val678 + -516, val690
                      end
                    else
                      val678, val707 = 3456 - val678, val707(val685, val684)
                      iter2 = val707
                    end
                  else
                    val678 = val731 and 1245 - val678 or 738
                  end
                elseif val678 > 718 then
                  if val678 <= 724 then
                    if val678 > 723 then
                      val678 = val731 and 1061 - val678 or 978
                    elseif val678 < 722 then
                      val745, val760, val715, val709, val705 = 1, val700 + val731, p477, p476[4][2][p476[4][1]], val700
                      val678, val760 = 1716, val760 - val745
                    elseif val678 <= 722 then
                      val731, val678, val740 = 29, val678 + -502, val681[6284]
                      val690 = val740 - val731
                      val731, val700, val709 = val681[14733], p477[val690], 44
                      val740 = val731 - val709
                      val709, val715, val690 = val681[49287], 53, p477[val740]
                      val731 = val709 - val715
                      val740 = p477[val731]
                      val700[val690] = val740
                      val740, val690 = val715, val681[49932]
                      val731, val700, val709 = val681[24799], val690 - val740, val715
                      val740, val731 = val731 - val709, 1
                      val690 = val740 == val731
                      p477[val700] = val690
                    else
                      val740, val690 = 43, val681[6284]
                      val709, val700, val731 = 17, val690 - val740, val681[14733]
                      val740 = val731 - val709
                      val690 = p477[val740]
                      p477[val700] = val690
                      val709, val731 = 11, val681[49287]
                      val731, val709, val700 = val681[49932], 31, val731 - val709
                      val709, val690, val731 = 59, val731 - val709, val681[24799]
                      val740, val709 = val731 - val709, 0
                      val731 = val690 == val709
                      val678 = val731 and 769 or 426570 / val678
                    end
                  elseif val678 > 726 then
                    val709, val715 = val690(val740, val731)
                    val731 = val709
                    val678 = val731 == nil and val678 + -199 or 1165 - val678
                  else
                    val678, val690, val740 = 159720 / val678, val681[6284], 9
                    val709, val700, val715 = val681[14733], val690 - val740, 11

                    val731 = val709 - val715
                    val731, val740 = val681[29601], p477[val731]

                    val690 = val740[val731]
                    p477[val700] = val690
                    val700, val690 = val681[49287], nil
                    p477[val700] = val690
                  end
                elseif val678 >= 715 then
                  if val678 > 717 then
                    val678, val709 = 304, val755 - val690
                  elseif val678 < 716 then
                    val740, val690 = 7, val681[6284]
                    val715, val700, val709 = 4, val690 - val740, val681[14733]
                    val731 = val709 - val715
                    val740, val705, val715 = p477[val731], 59, val681[49287]
                    val709 = val715 - val705
                    val731 = p477[val709]
                    val690 = val740 < val731
                    p477[val700] = val690
                    val690, val740 = val681[49932], 56
                    val740, val700, val731 = val681[24799], val690 - val740, 8
                    val731, val690 = 1, val740 - val731
                    val709, val740, val731 = -1, val690 - val731, nil
                    val678 = val740 == val709 and 645645 / val678 or 675675 / val678
                  elseif val678 > 716 then
                    val709, val715 = val755 - val700, 1
                    val731 = val709 + val715
                    val678 = val726 <= val715 and val678 + 1694 or 2732 - val678
                  else
                    val678, val713 = 936 - val678, val713 + val740
                  end
                elseif val678 < 712 then
                  val748, iter2, val747, val760, val678, val745, iter = 1, p477, val705, p476[6][2][p476[6][1]], 1824 - val678, val715, val700
                elseif val678 <= 712 then
                  val709, val715 = p477[val700], p476[3][2][p476[3][1]]
                  val747, val745, val760, val705 = 1, p477, p476[4][2][p476[4][1]], val709
                  val678, val748, val747 = 1211, val700 + val747, val700 + val731
                else
                  val678, val731 = 551922 / val678, val755 - val700
                end
              elseif val678 < 774 then
                if val678 < 765 then
                  if val678 >= 760 then
                    if val678 > 762 then
                      val709 = 1
                      val678, val731 = val678 + 119, val690 - val709
                    elseif val678 <= 760 then
                      val740, val690 = 60, val681[6284]
                      val690, val700 = val681[29601], val690 - val740
                      p477[val700] = val690
                      val690, val740 = val681[14733], 17
                      val740, val700, val731 = p476[15][2][p476[15][1]], val690 - val740, val681[44007]
                      val690 = val740[val731]
                      p477[val700] = val690
                      val678 = val764 <= val722 and 1073 or 220
                    else
                      val740, val690 = 21, val681[6284]
                      val709, val678, val731, val700 = 13, 220, val681[14733], val690 - val740
                      val740 = val731 - val709
                      val690 = p477[val740]
                      p477[val700] = val690
                      val690, val740 = val681[49287], 58
                      val700, val740 = val690 - val740, {}
                      val690 = val740
                      p477[val700] = val690
                    end
                  elseif val678 <= 757 then
                    if val678 > 756 then
                      val700 = 1
                      val678 = val699 <= val700 and 1244 - val678 or 540
                    else
                      val740[val731] = val748
                      val678 = val696 >= val749 and 3182 - val678 or 675864 / val678
                    end
                  else
                    val700 = 230
                    val678 = val699 > val700 and val678 + -477 or 1366 - val678
                  end
                elseif val678 > 769 then
                  if val678 < 772 then
                    val690, val740 = val681[6284], 12
                    val700, val709, val731 = val690 - val740, 45, val681[14733]
                    val740 = val731 - val709
                    val678, val690 = val678 + -551, p477[val740]
                    p477[val700] = val690
                    val690, val740 = val681[49287], val709
                    val700, val690 = val690 - val740, val681[29601]
                    p477[val700] = val690
                  elseif val678 > 772 then
                    val710 = 177
                    val678 = val731 and 2555 - val678 or val678 + 1029
                  else
                    val745, val678, val760 = 1, 4756 - val678, val700 + val705
                    val755 = val760 - val745
                  end
                elseif val678 >= 768 then
                  if val678 > 768 then
                    val678, val731 = val678 + -179, val755 - val700
                  else
                    val769, val701, val690, val740 = 186, 2, val681[6284], 22
                    val709, val700, val731 = 63, val690 - val740, val681[14733]
                    val740, val731 = val731 - val709, 1
                    val690 = val740 == val731
                    p477[val700] = val690

                    val740, val690 = 40, val681[49287]
                    val740, val731, val690, val700 = nil, nil, val767, val690 - val740

                    val690, val740, val731 = p475.b(val690, val740, val731)
                    val709, val715 = val690(val740, val731)
                    val731 = val709
                    val678 = val731 == nil and 220 or val678 + -499
                  end
                elseif val678 > 765 then
                  val700 = 183
                  val678 = val699 > val700 and 820 or 400
                else
                  val690, val740 = val681[6284], 33
                  val740, val700 = {}, val690 - val740
                  val690 = val740
                  val678, p477[val700] = val678 + -545, val690
                  val690, val740 = val681[14733], 60
                  val709, val700, val731 = 5, val690 - val740, val681[49287]
                  val740, val731 = val731 - val709, 1
                  val690 = val740 == val731
                  p477[val700] = val690
                end
              elseif val678 >= 787 then
                if val678 < 791 then
                  if val678 >= 788 then
                    if val678 > 788 then
                      val760, val745 = val715[2], val715[1]
                      val705 = val760[val745]
                      val678, val715[3] = 574330 / val678, val705
                      val715[2] = val715
                      val705 = 3
                      val715[1] = val705
                      val705 = nil
                      val767[val709] = val705
                    else
                      val700 = 187
                      val678 = val699 > val700 and val678 + 124 or 302592 / val678
                    end
                  else
                    val740, val731 = val681[14733], 44
                    val731, val740, val709, val690 = nil, val767, nil, val740 - val731
                    val740, val731, val709 = p475.b(val740, val731, val709)
                    val715, val705 = val740(val731, val709)
                    val709 = val715
                    val678 = val709 == nil and 1007 - val678 or 1015
                  end
                elseif val678 <= 794 then
                  if val678 >= 792 then
                    if val678 > 792 then
                      val760 = 1
                      val678, val705 = 2411, val740 - val760
                    else
                      val690, val740 = val681[6284], 20
                      val700, val731, val709 = val690 - val740, val681[14733], 54
                      val731, val740 = 1, val731 - val709
                      val690 = val740 == val731
                      p477[val700] = val690
                      val690, val709, val731 = p476[10][2][p476[10][1]], 58, val681[49932]
                      val740 = val731 - val709
                      val700 = val690[val740]
                      val705, val740, val715, val690 = 6, val700[1], val681[49287], val700[2]
                      val678, val709 = val678 + -572, val715 - val705
                      val731 = p477[val709]
                      val690[val740] = val731
                    end
                  else
                    val690, val740 = val681[6284], 62
                    val731, val700, val740 = 42, val690 - val740, val681[23485]
                    val690 = val740 - val731
                    p477[val700] = val690
                    val709, val731, val690 = 55, val681[49287], p476[10][2][p476[10][1]]
                    val678, val740 = val678 + -571, val731 - val709
                    val700 = val690[val740]
                    val740, val705, val715, val690 = val700[1], 62, val681[14733], val700[2]
                    val709 = val715 - val705
                    val731 = p477[val709]
                    val690[val740] = val731
                  end
                else
                  val678, val731 = 743, val755 - val700
                end
              elseif val678 > 778 then
                if val678 <= 781 then
                  val678, val709 = 947 - val678, 1
                  val731 = val690 - val709
                else
                  val740, val690 = 62, val681[6284]
                  val731, val740, val700, val690 = nil, nil, val690 - val740, val767
                  val690, val740, val731 = p475.b(val690, val740, val731)
                  val709, val715 = val690(val740, val731)
                  val731 = val709
                  val678 = val731 == nil and 528 or 438
                end
              elseif val678 < 777 then
                if val678 > 774 then
                  val740, val690 = 44, val681[6284]
                  val731, val709, val700 = val681[14733], 29, val690 - val740
                  val740 = val731 - val709
                  val690 = p477[val740]
                  p477[val700] = val690
                  val740, val690 = 43, val681[49287]
                  val731, val709, val700 = val681[49932], 14, val690 - val740
                  val678, val740, val731 = 170720 / val678, val731 - val709, 1
                  val690 = val740 == val731
                  p477[val700] = val690
                else
                  val700 = 154
                  val678 = val699 <= val700 and val678 + -90 or 626
                end
              elseif val678 > 777 then
                val690, val740 = val681[13110], 57
                val700 = val690 - val740
                val678, val713 = 220, val713 + val700
              else
                val678, val705, val715 = 170940 / val678, 28, val681[6863]
                val709 = val715 - val705
                val713 = val713 + val709
              end
            elseif val678 <= 647 then
              if val678 <= 615 then
                if val678 <= 604 then
                  if val678 <= 599 then
                    if val678 >= 597 then
                      if val678 < 598 then
                        val760, val705 = 1, val683[val713]
                        val713, val745, val760 = val713 + val760, 1, val705[6284]
                        val678 = val760 == val745 and 376 or 584463 / val678
                      elseif val678 > 598 then
                        val700 = 870
                        val678 = val699 <= val700 and 1024 - val678 or 797
                      else
                        val705 = val709 <= val740
                        val715 = not val705
                        val678 = val715 and val678 + 419 or 489164 / val678
                      end
                    elseif val678 <= 591 then
                      val740, val690 = 14, val681[6284]
                      val709, val700, val731 = 33, val690 - val740, val681[14733]
                      val740 = val731 - val709
                      val690 = p477[val740]
                      p477[val700] = val690
                      val740, val690 = 14, val681[49287]
                      val678, val740, val731, val700 = 130020 / val678, p476[15][2][p476[15][1]], val681[29601], val690 - val740
                      val690 = val740[val731]
                      p477[val700] = val690
                    else
                      val678, val709 = val678 + 3426, 1
                      val731 = val690 - val709
                    end
                  elseif val678 < 603 then
                    val760, val745 = val715[2], val715[1]
                    val678, val705 = 3814, val760[val745]

                    val715[3] = val705
                    val715[2] = val715

                    val705 = 3
                    val715[1] = val705
                    val705 = nil
                    val767[val709] = val705
                  elseif val678 > 603 then
                    val678, val740, val690 = 132880 / val678, 21, val681[6284]
                    val690, val700 = nil, val690 - val740
                    p477[val700] = val690
                    val709, val731, val690 = 9, val681[49287], p476[10][2][p476[10][1]]
                    val740 = val731 - val709
                    val700, val740, val731 = val690[val740], val681[14733], 56
                    val690, val731, val709 = val740 - val731, val700[2], val700[1]
                    val740 = val731[val709]
                    p477[val690] = val740
                  else
                    val700 = 10
                    val678 = val699 <= val700 and 889 or val678 + -318
                  end
                elseif val678 > 612 then
                  if val678 <= 613 then
                    val731, val740 = 41, val681[6284]
                    val690 = val740 - val731
                    val731, val709, val700 = val681[14733], 40, p477[val690]
                    val678, val740 = 220, val731 - val709
                    val690, val709, val715 = p477[val740], val681[49287], 6
                    val731 = val709 - val715
                    val740 = p477[val731]
                    val700[val690] = val740
                    val740, val690 = 43, val681[49932]
                    val700, val740 = val690 - val740, {}
                    val690 = val740
                    p477[val700] = val690
                  else
                    val690, val740 = val681[6284], 62
                    val715, val700, val709 = 22, val690 - val740, val681[14733]
                    val678, val731 = 135300 / val678, val709 - val715
                    val740, val705, val715 = p477[val731], 17, val681[49287]
                    val709 = val715 - val705
                    val731 = p477[val709]
                    val690 = val740 + val731
                    p477[val700] = val690
                    val731, val690, val709 = val681[24799], p476[10][2][p476[10][1]], 44
                    val740 = val731 - val709
                    val700 = val690[val740]
                    val690, val740, val705, val715 = val700[2], val700[1], 36, val681[49932]
                    val709 = val715 - val705
                    val731 = p477[val709]
                    val690[val740] = val731
                  end
                elseif val678 < 611 then
                  if val678 <= 607 then
                    val740, val690 = 31, val681[6284]
                    val690, val700 = nil, val690 - val740
                    p477[val700] = val690
                    val731, val740 = 43, val681[49932]
                    val678, val690 = val678 + 996, val740 - val731

                    val740, val731, val700 = val681[49287], 17, val739[val690]
                    val740, val690 = p476[7][2][p476[7][1]], val740 - val731

                    val731 = val690
                  else
                    val690, val709, val731 = p476[10][2][p476[10][1]], 28, val681[14733]

                    val740 = val731 - val709
                    val740, val731, val700 = val681[6284], 42, val690[val740]

                    val731, val690, val709 = val700[2], val740 - val731, val700[1]
                    val740 = val731[val709]
                    p477[val690] = val740
                    val740, val678, val731 = val681[49287], 220, 8
                    val705, val715, val690 = 16, val681[49932], val740 - val731
                    val709 = val715 - val705
                    val705, val760, val731 = val681[24799], 15, p477[val709]
                    val715 = val705 - val760
                    val709 = p477[val715]
                    val740 = val731 .. val709
                    p477[val690] = val740
                  end
                elseif val678 <= 611 then
                  val690, val740 = val681[6284], 28
                  val700, val709, val731 = val690 - val740, 56, val681[14733]
                  val731, val740 = 1, val731 - val709
                  val690 = val740 == val731
                  val678, p477[val700] = 134420 / val678, val690
                  val740, val690 = 4, val681[49287]
                  val700, val740, val731 = val690 - val740, p476[15][2][p476[15][1]], val681[29601]
                  val690 = val740[val731]
                  p477[val700] = val690
                else
                  val731 = val755 - val700
                  val678 = val742 >= val758 and 336600 / val678 or 657
                end
              elseif val678 < 626 then
                if val678 < 623 then
                  if val678 < 617 then
                    val678 = val731 and 811 or 443
                  elseif val678 <= 617 then
                    val760, val678, val745 = val700 + val705, 732996 / val678, 1
                    val755 = val760 - val745
                  else
                    val690, val740 = val681[6284], 4
                    val740, val700, val731 = p476[15][2][p476[15][1]], val690 - val740, val681[29601]
                    val690 = val740[val731]
                    p477[val700] = val690
                    val678 = val743 > val708 and 38 or 838 - val678
                  end
                elseif val678 < 624 then
                  val740, val731 = val681[14733], 60
                  val731, val690, val709 = p476[15][2][p476[15][1]], val740 - val731, val681[29601]
                  val678, val740 = val678 + -403, val731[val709]
                  p477[val690] = val740
                elseif val678 <= 624 then
                  val700 = 220
                  val678 = val699 > val700 and 674 or 491
                else
                  val678, val731 = 819, val755 - val700
                end
              elseif val678 >= 632 then
                if val678 <= 642 then
                  if val678 > 638 then
                    val740, val690 = 37, val681[6284]
                    val678, val731, val700, val709 = 220, val681[14733], val690 - val740, 14
                    val740 = val731 - val709
                    val690 = p477[val740]
                    p477[val700] = val690
                    val740, val731 = val681[49287], 1
                    val690 = val740 - val731
                    val700, val709, val731 = p477[val690], 63, val681[49932]
                    val740 = val731 - val709
                    val709, val690, val715 = val681[24799], p477[val740], 54
                    val731 = val709 - val715
                    val740 = p477[val731]
                    val700[val690] = val740
                  elseif val678 <= 632 then
                    val690, val740 = val681[6284], 23
                    val731, val700, val690, val740 = nil, val690 - val740, val767, nil
                    val690, val740, val731 = p475.b(val690, val740, val731)
                    val709, val715 = val690(val740, val731)
                    val731 = val709
                    val678 = val731 == nil and 220 or 541
                  else
                    val678, val713 = 220, val713 + val731
                  end
                else
                  val678, val690, val731, val709 = val678 + -427, p476[10][2][p476[10][1]], val681[14733], 10

                  val740 = val731 - val709
                  val740, val700, val731 = val681[6284], val690[val740], 16

                  val731, val690, val709 = val700[2], val740 - val731, val700[1]
                  val740 = val731[val709]
                  p477[val690] = val740

                  val740, val731 = val681[49287], 22
                  val740, val690 = val681[29601], val740 - val731

                  p477[val690] = val740
                end
              elseif val678 > 630 then
                val715, val705 = val681[8652], 50
                val709 = val715 - val705
                val713 = val713 + val709
                val678 = val687 > val705 and 220 or 1346 - val678
              elseif val678 <= 626 then
                val690, val709, val731 = p476[10][2][p476[10][1]], 6, val681[14733]
                val740 = val731 - val709

                val731, val740, val700 = 2, val681[6284], val690[val740]
                val731, val690, val709 = val700[2], val740 - val731, val700[1]

                val740 = val731[val709]
                p477[val690] = val740
                val731, val709 = val681[49287], 40
                val740 = val731 - val709
                val690, val715, val709 = p477[val740], 57, val681[49932]
                val731 = val709 - val715
                val715, val740, val705 = val681[24799], p477[val731], 6
                val709 = val715 - val705
                val731 = p477[val709]
                val690[val740] = val731
                val678 = val688 < val705 and val678 + 220 or val678 + -406
              else
                val745, val760 = val715[1], val715[2]
                val705 = val760[val745]

                val715[3] = val705
                val715[2] = val715

                val705 = 3
                val678, val715[1] = 3516 - val678, val705
                val705 = nil
                val767[val709] = val705
              end
            elseif val678 > 681 then
              if val678 <= 697 then
                if val678 < 688 then
                  if val678 >= 686 then
                    if val678 > 686 then
                      val709, val690, val731 = 7, p476[10][2][p476[10][1]], val681[14733]

                      val740 = val731 - val709
                      val740, val731, val700 = val681[6284], 19, val690[val740]

                      val709, val731, val690 = val700[1], val700[2], val740 - val731
                      val740 = val731[val709]
                      p477[val690] = val740
                      val740, val678, val731 = val681[49287], 220, 19
                      val715, val690, val705 = val681[49932], val740 - val731, 57
                      val709 = val715 - val705
                      val731, val760, val705 = p477[val709], 53, val681[24799]
                      val715 = val705 - val760
                      val709 = p477[val715]
                      val740 = val731 == val709
                      p477[val690] = val740
                    else
                      val690, val740 = val681[6284], 38
                      val740, val700 = {}, val690 - val740
                      val690 = val740
                      val678, p477[val700] = 150920 / val678, val690
                      val709, val690, val731 = 25, p476[10][2][p476[10][1]], val681[49287]
                      val740 = val731 - val709
                      val731, val700, val740 = 48, val690[val740], val681[14733]
                      val690, val731, val709 = val740 - val731, val700[2], val700[1]
                      val740 = val731[val709]
                      p477[val690] = val740
                    end
                  else
                    val709, val731, val690 = 13, val681[14733], p476[10][2][p476[10][1]]
                    val740 = val731 - val709
                    val700 = val690[val740]
                    val690, val705, val715, val740 = val700[2], 15, val681[6284], val700[1]
                    val709 = val715 - val705
                    val731 = p477[val709]
                    val690[val740] = val731
                    val731, val740 = 25, val681[49287]
                    val709, val690, val731 = val681[29601], val740 - val731, p476[15][2][p476[15][1]]
                    val740 = val731[val709]
                    p477[val690] = val740
                    val678 = val686 < val705 and 452 or 150480 / val678
                  end
                elseif val678 > 696 then
                  val709, val731 = 8, val681[6284]

                  val731, val700, val709 = val681[14733], val731 - val709, 55
                  val731, val709, val690 = val681[49287], 7, val731 - val709

                  val709, val740 = 0, val731 - val709
                  val731 = val690 == val709
                  val678 = val731 and 1682 - val678 or 724
                elseif val678 > 694 then
                  val678, val760, val715, val745, val709, val705 = 4163 - val678, val700 + val731, p477, 1, p476[4][2][p476[4][1]], val700
                  val760 = val760 - val745
                elseif val678 <= 688 then
                  val731, val709 = val681[6284], 43
                  val709, val731, val700 = 48, val681[14733], val731 - val709
                  val731, val709, val690 = val681[49287], 52, val731 - val709
                  val709, val740 = 0, val731 - val709
                  val731 = val690 == val709
                  val678 = val731 and 453 or 616
                else
                  val690, val740 = val681[6284], 36
                  val740, val700 = {}, val690 - val740
                  val690 = val740
                  p477[val700] = val690

                  val740, val678, val690 = 2, 220, val681[14733]
                  val740, val731, val700 = val681[23485], 59, val690 - val740

                  val690 = val740 - val731
                  p477[val700] = val690
                end
              elseif val678 < 706 then
                if val678 <= 699 then
                  iter, iter2, val691 = iter(iter2)
                  val678, val705, val715, val709 = 1578, val691, iter2, iter
                else
                  val678 = val715 <= 0 and 534 or 1244
                end
              elseif val678 > 707 then
                val690, val740 = val681[6284], 6
                val740, val731, val700 = val681[23485], 6, val690 - val740
                val690 = val740 - val731
                val678, p477[val700] = 155980 / val678, val690
              elseif val678 <= 706 then
                val740, val690 = 22, val681[6284]
                val715, val709, val700 = 4, val681[14733], val690 - val740
                val731 = val709 - val715
                val715, val740, val705 = val681[49287], p477[val731], 63
                val709 = val715 - val705
                val731 = p477[val709]
                val690 = val740 - val731
                p477[val700] = val690
                val709, val700, val731 = 29, val681[49932], val681[24799]
                val740 = val731 - val709
                val690 = p477[val740]
                p477[val700] = val690
                val678 = val695 >= val709 and 220 or 304
              else
                val700 = 28
                val678 = val699 <= val700 and val678 + -60 or 930 - val678
              end
            elseif val678 > 663 then
              if val678 >= 676 then
                if val678 > 679 then
                  val715, val709 = p476[3][2][p476[3][1]], p477[val700]
                  val747, val760, val745, val705 = 1, p476[4][2][p476[4][1]], p477, val709
                  val747, val678, val748 = val700 + val731, 1648, val700 + val747
                elseif val678 <= 676 then
                  val705 = val715[1]
                  val678 = val705 >= val700 and 239980 / val678 or 2317
                else
                  val731, val740, val690, val700 = nil, nil, val767, val681[6284]
                  val690, val740, val731 = p475.b(val690, val740, val731)
                  val709, val715 = val690(val740, val731)
                  val731 = val709
                  val678 = val731 == nil and 1211 - val678 or 1204 - val678
                end
              elseif val678 >= 670 then
                if val678 <= 670 then
                  val709, val715 = val755 - val700, 1
                  val678, val731 = 1553 - val678, val709 + val715
                else
                  val740, val690 = 3, val681[6284]
                  val740, val700 = {}, val690 - val740

                  val678, val690 = 894 - val678, val740
                  p477[val700] = val690
                  val740, val690 = 24, val681[14733]
                  val700, val731, val709 = val690 - val740, val681[49287], 58
                  val740 = val731 - val709
                  val690 = p477[val740]
                  p477[val700] = val690
                end
              else
                val715, val705, val760 = val715(val705, val760)
                val715, val705, val760 = p475.b(val715, val705, val760)

                val745 = val715(val705, val760)
                val760 = val745
                val678 = val760 == nil and 582992 / val678 or 256
              end
            elseif val678 <= 658 then
              if val678 <= 656 then
                if val678 < 650 then
                  val700 = 154
                  val678 = val699 >= val700 and 774 or 128
                elseif val678 <= 650 then
                  val705, val678, val715, val760, val745, val709 = val700, 3549, p477, val700 + val731, 1, p476[4][2][p476[4][1]]
                  val760 = val760 - val745
                else
                  val747, val748, val745, val760, iter2, val678, iter = val705, 1, val715, p476[6][2][p476[6][1]], p477, 1076496 / val678, val700
                end
              elseif val678 <= 657 then
                val678, val740[val731] = 3477 - val678, val748
              else
                val690, val740 = val681[6284], 22
                val678, val709, val700, val715 = val678 + -438, val681[14733], val690 - val740, 25
                val731 = val709 - val715
                val705, val715, val740 = 29, val681[49287], p477[val731]
                val709 = val715 - val705
                val731 = p477[val709]
                val690 = val740 < val731
                p477[val700] = val690
              end
            elseif val678 < 662 then
              val690, val740 = val681[6284], 17
              val678, val700, val709, val715 = val678 + -440, val690 - val740, val681[14733], 2
              val731 = val709 - val715
              val715, val740, val705 = val681[49287], p477[val731], 7
              val709 = val715 - val705
              val731 = p477[val709]
              val690 = val740 ~= val731
              p477[val700] = val690
            elseif val678 > 662 then
              val678, val709 = 476, 1
              val731 = val690 - val709
            else
              val690, val709, val731 = p476[10][2][p476[10][1]], 22, val681[14733]
              val740 = val731 - val709
              val700, val740, val731 = val690[val740], val681[6284], 43
              val709, val690, val731 = val700[1], val740 - val731, val700[2]
              val740 = val731[val709]
              val678, p477[val690] = 145640 / val678, val740
              val740, val731 = val681[49287], 56

              val709, val690, val715 = val681[49932], val740 - val731, 43
              val709, val731 = 1, val709 - val715

              val740 = val731 == val709
              p477[val690] = val740
            end
          elseif val678 <= 487 then
            if val678 <= 431 then
              if val678 > 403 then
                if val678 < 418 then
                  if val678 <= 413 then
                    if val678 <= 411 then
                      if val678 >= 406 then
                        if val678 > 406 then
                          val740, val690 = 29, val681[6284]
                          val700, val690 = val690 - val740, nil
                          p477[val700] = val690
                          val690, val678, val740 = val681[14733], val678 + -191, 60
                          val731, val700, val740 = val681[29601], val690 - val740, p476[15][2][p476[15][1]]
                          val690 = val740[val731]
                          p477[val700] = val690
                        else
                          val709, val731 = 42, val681[6284]
                          val709, val731, val700 = 3, val681[14733], val731 - val709

                          val690, val709, val731 = val731 - val709, 17, val681[49287]
                          val709, val740 = 0, val731 - val709
                          val731 = val690 == val709
                          val678 = val731 and val678 + 493 or 215
                        end
                      else
                        val705 = val715[1]
                        val678 = val705 >= val700 and 1422 - val678 or 2996
                      end
                    else
                      val678, val705, val715 = 90860 / val678, 42, val681[6863]
                      val709 = val715 - val705
                      val713 = val713 + val709
                    end
                  elseif val678 <= 414 then
                    val690, val740 = val681[6284], 6
                    val731, val700, val709 = val681[14733], val690 - val740, 50
                    val678, val740 = val678 + -194, val731 - val709
                    val690 = p477[val740]
                    p477[val700] = val690
                    val690, val740 = val681[49287], 53
                    val700, val740, val731 = val690 - val740, val681[23485], 41
                    val690 = val740 - val731
                    p477[val700] = val690
                  else
                    val690, val740 = val681[6284], 42
                    val700, val690 = val690 - val740, nil
                    val678, p477[val700] = 91520 / val678, val690
                    val740, val690 = 39, val681[14733]
                    val700, val690 = val690 - val740, val681[29601]
                    p477[val700] = val690
                  end
                elseif val678 >= 421 then
                  if val678 < 427 then
                    if val678 > 421 then
                      val740, val690 = 14, val681[6284]
                      val700, val731, val740 = val690 - val740, val681[29601], p476[15][2][p476[15][1]]
                      val690 = val740[val731]
                      val678, p477[val700] = val678 + -205, val690

                      val740, val690 = 53, val681[14733]
                      val740, val700 = {}, val690 - val740

                      val690 = val740
                      p477[val700] = val690
                    else
                      val678, val715, val705 = 220, val681[6863], 42
                      val709 = val715 - val705
                      val713 = val713 + val709
                    end
                  elseif val678 > 427 then
                    val690, val740 = val681[6284], 25
                    val700, val690 = val690 - val740, val681[29601]
                    val678, p477[val700] = val678 + -211, val690
                  else
                    val709, val715 = val690(val740, val731)
                    val731 = val709
                    val678 = val731 == nil and val678 + 360 or 348432 / val678
                  end
                elseif val678 > 419 then
                  val700 = 56
                  val678 = val699 <= val700 and 325 or 840
                elseif val678 > 418 then
                  val700 = 93
                  val678 = val699 > val700 and 365 or 800
                else
                  val690, val740 = val681[6284], 45
                  val690, val700 = nil, val690 - val740

                  p477[val700] = val690
                  val740, val731 = val681[14733], 19
                  val690 = val740 - val731
                  val715, val700, val690, val709 = 28, p477[val690], val681[29601], val681[49287]
                  val731 = val709 - val715
                  val740 = p477[val731]
                  val700[val690] = val740
                  val678 = val724 < val715 and val678 + -238 or 220
                end
              elseif val678 >= 394 then
                if val678 > 399 then
                  if val678 <= 402 then
                    if val678 > 400 then
                      val678, val731 = 1295 - val678, val755 - val700
                    else
                      val690, val740 = val681[6284], 11
                      val690, val700 = nil, val690 - val740
                      val678, p477[val700] = 220, val690
                    end
                  else
                    val740, val731 = val681[49287], 3
                    val690 = val740 - val731
                    val731, val700, val740 = 49, val756[val690], val681[14733]
                    val740, val678, val690 = p476[7][2][p476[7][1]], 2703, val740 - val731
                    val731 = val690
                  end
                elseif val678 < 398 then
                  if val678 <= 394 then
                    val678, val713 = 220, val713 + val731
                  else
                    val731, val709 = val681[6284], 8

                    val709, val731, val700 = 22, val681[14733], val731 - val709
                    val709, val731, val690 = 27, val681[49287], val731 - val709

                    val740, val709 = val731 - val709, 0
                    val731 = val690 == val709
                    val678 = val731 and 1134 or val678 + 3596
                  end
                elseif val678 <= 398 then
                  val690, val740 = val681[6284], 45
                  val690, val700 = nil, val690 - val740

                  p477[val700] = val690
                  val740, val690 = 36, val681[14733]
                  val690, val700 = nil, val690 - val740
                  val678, p477[val700] = 220, val690
                else
                  val678, val709 = val678 + 98, 1
                  val731 = val690 - val709
                end
              elseif val678 > 380 then
                if val678 > 384 then
                  val690, val740 = val681[6284], 31
                  val715, val700, val709 = 60, val690 - val740, val681[14733]
                  val731 = val709 - val715
                  val740 = p477[val731]
                  val690 = -val740
                  p477[val700] = val690
                  val740, val690 = 2, val681[49287]
                  val678, val700, val740 = 220, val690 - val740, {}
                  val690 = val740
                  p477[val700] = val690
                elseif val678 > 381 then
                  val731, val740 = 26, val681[6284]
                  val690 = val740 - val731
                  val709, val690, val715, val700 = val681[14733], val681[29601], 25, p477[val690]
                  val731 = val709 - val715
                  val740 = p477[val731]
                  val700[val690] = val740
                  val740, val690 = 39, val681[49287]

                  val690, val700, val740, val731 = val767, val690 - val740, nil, nil
                  val690, val740, val731 = p475.b(val690, val740, val731)

                  val709, val715 = val690(val740, val731)
                  val731 = val709
                  val678 = val731 == nil and 220 or 404
                else
                  val705, val760 = val683[val713], 1
                  val713, val760, val745 = val713 + val760, val705[6284], 1
                  val678 = val760 == val745 and 3247 or 3942
                end
              elseif val678 <= 377 then
                if val678 >= 376 then
                  if val678 > 376 then
                    val745, val709, val705, val715, val760 = 1, p476[4][2][p476[4][1]], val700, p477, val700 + val731
                    val678, val760 = 1168, val760 - val745
                  else
                    val745 = val705[14733]
                    val747, val748 = nil, val767[val745]
                    val678 = val748 == val747 and 71064 / val678 or 1033 - val678
                  end
                else
                  val705 = val715[1]
                  val678 = val705 >= val700 and val678 + 256 or 2886
                end
              else
                val709, val715 = p477[val700], p476[3][2][p476[3][1]]
                val745, val705, val747, val760 = p477, val709, 1, p476[4][2][p476[4][1]]
                val748, val678, val747 = val700 + val747, 4426 - val678, val700 + val731
              end
            elseif val678 <= 452 then
              if val678 < 441 then
                if val678 >= 436 then
                  if val678 < 438 then
                    val709 = 1
                    val678, val731 = 380, val690 - val709
                  elseif val678 > 438 then
                    val731, val740 = 45, val681[49287]
                    val690 = val740 - val731
                    val700, val740, val678, val731 = val756[val690], val681[14733], 1885 - val678, 5
                    val740, val690 = p476[7][2][p476[7][1]], val740 - val731
                    val731 = val690
                  else
                    val705 = val715[1]
                    val678 = val705 >= val700 and 1228 - val678 or 727
                  end
                elseif val678 < 434 then
                  val678, val690, val740 = 653 - val678, val681[6284], 21
                  val740, val700 = {}, val690 - val740
                  val690 = val740
                  p477[val700] = val690
                  val690, val740 = val681[14733], 25
                  val700, val740 = val690 - val740, {}
                  val690 = val740
                  p477[val700] = val690
                elseif val678 > 434 then
                  val678, val731, val740 = val678 + 1722, val690, p476[13][2][p476[13][1]]
                else
                  val690, val740 = val681[6284], 7
                  val690, val740, val731, val700 = val767, nil, nil, val690 - val740
                  val690, val740, val731 = p475.b(val690, val740, val731)

                  val709, val715 = val690(val740, val731)
                  val731 = val709
                  val678 = val731 == nil and 623 or 374
                end
              elseif val678 <= 444 then
                if val678 < 443 then
                  if val678 > 441 then
                    val760, val745 = val700 + val705, 1
                    val755 = val760 - val745
                    val678 = val716 > val745 and 1382134 / val678 or 987
                  else
                    val740, val690, val738, val741 = 61, val681[6284], 99, 102
                    val700, val731, val740 = val690 - val740, 28, val681[8652]
                    val709, val690, val731 = 57, val740 - val731, val681[6863]
                    val731, val740 = p477[val700], val731 - val709
                    val678 = val731 and 961 or 256662 / val678
                  end
                elseif val678 <= 443 then
                  val678, val709 = 811, 1
                  val731 = val690 - val709
                else
                  val678, val709 = val678 + 563, 1
                  val731 = val690 - val709
                end
              elseif val678 > 450 then
                val705, val715, val748, val745, val760 = p477, p476[4][2][p476[4][1]], 1, val690 + val709, val690
                val678, val745 = 3492 - val678, val745 - val748
              elseif val678 > 445 then
                val709, val678, val715 = val755 - val700, 476, 1
                val731 = val709 + val715
              else
                val690, val740 = val681[6284], 28
                val740, val700, val731 = val681[14733], val690 - val740, 43
                val731, val709, val690 = val681[8652], 45, val740 - val731

                val709, val740, val715 = val681[6863], val731 - val709, 8
                val709, val731, val715 = p477[val700], val709 - val715, p477[val690]

                val678 = val709 > val715 and 1296 - val678 or val678 + 193
              end
            elseif val678 > 473 then
              if val678 > 484 then
                if val678 <= 485 then
                  val731, val709, val690 = val681[14733], 40, p476[10][2][p476[10][1]]
                  val740 = val731 - val709
                  val700, val740, val731 = val690[val740], val681[6284], 31
                  val709, val731, val690 = val700[1], val700[2], val740 - val731
                  val678, val740 = 106700 / val678, val731[val709]
                  p477[val690] = val740
                  val731, val740 = 58, val681[49287]
                  val709, val715, val690 = val681[49932], 9, val740 - val731
                  val731 = val709 - val715
                  val740 = p477[val731]
                  p477[val690] = val740
                else
                  val740, val690 = 36, val681[6284]
                  val731, val700, val678, val740 = 19, val690 - val740, 707 - val678, val681[14733]
                  val740, val690 = val681[29601], val740 - val731
                  val715, val731 = 1, p477[val690]
                  val709 = val700 + val715
                  p477[val709] = val731
                  val709 = val731[val740]
                  p477[val700] = val709
                end
              elseif val678 >= 478 then
                if val678 > 478 then
                  val690, val740 = val681[6284], 15
                  val740, val700, val731 = val681[14733], val690 - val740, 25

                  val731, val690 = 1, val740 - val731
                  val731, val709, val740 = nil, -1, val690 - val731

                  val678 = val740 == val709 and 670 or 764
                else
                  val709, val731, val690 = 29, val681[14733], p476[10][2][p476[10][1]]
                  val678, val740 = 220, val731 - val709
                  val731, val700, val740 = 44, val690[val740], val681[6284]
                  val709, val690, val731 = val700[1], val740 - val731, val700[2]
                  val740 = val731[val709]
                  p477[val690] = val740
                  val731, val740 = 27, val681[49287]
                  val705, val690, val715 = 54, val740 - val731, val681[49932]
                  val709 = val715 - val705
                  val705, val760, val731 = val681[24799], 59, p477[val709]
                  val715 = val705 - val760
                  val709 = p477[val715]
                  val740 = val731[val709]
                  p477[val690] = val740
                end
              else
                val760, val715, val745, val678, val705, val709 = val700 + val731, p477, 1, 1589, val700, p476[4][2][p476[4][1]]
                val760 = val760 - val745
              end
            elseif val678 < 460 then
              if val678 <= 457 then
                if val678 > 453 then
                  val715, val678, val709 = 1, 265060 / val678, val755 - val690
                  val740 = val709 + val715
                else
                  val731 = val755 - val700
                  val678 = val765 <= val752 and 279048 / val678 or 1711887 / val678
                end
              else
                val709 = 1
                val678, val731 = 326096 / val678, val690 - val709
              end
            elseif val678 <= 469 then
              if val678 < 464 then
                val731, val690, val709 = val681[14733], p476[10][2][p476[10][1]], 59
                val740 = val731 - val709

                val731, val700, val740 = 32, val690[val740], val681[6284]
                val731, val709, val690 = val700[2], val700[1], val740 - val731

                val740 = val731[val709]
                p477[val690] = val740
                val731, val740 = 33, val681[49287]
                val715, val705, val690 = val681[49932], 51, val740 - val731
                val709 = val715 - val705
                val731, val760, val705 = p477[val709], 1, val681[24799]
                val678, val715 = 220, val705 - val760
                val709 = p477[val715]
                val740 = val731 < val709
                p477[val690] = val740
              elseif val678 > 464 then
                val700 = 138
                val678 = val699 <= val700 and 395367 / val678 or 287
              else
                val690, val731, val709 = p476[10][2][p476[10][1]], val681[14733], 5
                val740 = val731 - val709
                val731, val700, val740 = 59, val690[val740], val681[6284]
                val709, val690, val731 = val700[1], val740 - val731, val700[2]
                val740 = val731[val709]
                p477[val690] = val740
                val715, val709, val740 = 16, val681[49932], p476[10][2][p476[10][1]]

                val731 = val709 - val715
                val731, val690, val709 = val681[49287], val740[val731], 23

                val740, val709, val715 = val731 - val709, val690[2], val690[1]
                val731 = val709[val715]
                p477[val740] = val731
                val678 = val737 >= val718 and 220 or 94
              end
            else
              val700 = 534
              val678 = val699 <= val700 and 252109 / val678 or 993
            end
          elseif val678 <= 540 then
            if val678 > 518 then
              if val678 > 532 then
                if val678 >= 535 then
                  if val678 >= 536 then
                    if val678 <= 536 then
                      val740, val690 = 10, val681[6284]
                      val700, val740 = val690 - val740, {}
                      val690 = val740
                      p477[val700] = val690
                      val690, val740 = val681[14733], 43
                      val709, val700, val731 = 17, val690 - val740, val681[49287]
                      val731, val740 = 1, val731 - val709
                      val690, val740 = val740 - val731, -1
                      val678 = val690 == val740 and 1006 or 257
                    else
                      val740, val678, val731 = val681[49287], 2516, 4
                      val690 = val740 - val731

                      val740, val731, val700 = val681[14733], 63, val739[val690]
                      val740, val690 = p476[7][2][p476[7][1]], val740 - val731

                      val731 = val690
                    end
                  else
                    val690, val709, val731 = p476[10][2][p476[10][1]], 30, val681[14733]

                    val740 = val731 - val709
                    val740, val731, val700 = val681[6284], 48, val690[val740]

                    val731, val709, val690 = val700[2], val700[1], val740 - val731
                    val740 = val731[val709]
                    val678, p477[val690] = 2309, val740
                    val709, val731 = 62, val681[24799]
                    val740 = val731 - val709
                    val690, val709, val731 = val756[val740], 22, val681[49932]
                    val731, val740 = p476[7][2][p476[7][1]], val731 - val709
                    val709 = val740
                  end
                elseif val678 <= 533 then
                  val678, val690, val709, val731 = 220, p476[10][2][p476[10][1]], 22, val681[14733]
                  val740 = val731 - val709
                  val731, val700, val740 = 50, val690[val740], val681[6284]
                  val709, val690, val731 = val700[1], val740 - val731, val700[2]
                  val740 = val731[val709]
                  p477[val690] = val740
                  val740, val731 = val681[49287], 51
                  val715, val705, val690 = val681[49932], 2, val740 - val731
                  val709 = val715 - val705
                  val705, val760, val731 = val681[24799], 10, p477[val709]
                  val715 = val705 - val760
                  val709 = p477[val715]
                  val740 = val731 * val709
                  p477[val690] = val740
                else
                  val678 = val731 < val709 and 371 or 1778 - val678
                end
              elseif val678 < 526 then
                if val678 >= 523 then
                  if val678 > 523 then
                    val705 = val715[1]
                    val678 = val705 >= val700 and 1127 - val678 or 2002350 / val678
                  else
                    val690, val740 = val681[6284], 30
                    val690, val700 = nil, val690 - val740

                    val678, p477[val700] = 220, val690
                    val709, val690, val731 = 45, p476[10][2][p476[10][1]], val681[49287]
                    val740 = val731 - val709
                    val700 = val690[val740]
                    val690, val715, val705, val740 = val700[2], val681[14733], 59, val700[1]
                    val709 = val715 - val705
                    val731 = p477[val709]
                    val690[val740] = val731
                  end
                else
                  val709 = 1
                  val731 = val700 + val709
                  val740, val709 = p477[val731], p476[5][2][p476[5][1]]
                  val678, val715 = 1810, val740
                end
              elseif val678 < 530 then
                if val678 > 526 then
                  val715, val709, val740 = 4, val681[49287], p476[10][2][p476[10][1]]
                  val678, val731 = 220, val709 - val715
                  val690, val709, val731 = val740[val731], 32, val681[14733]
                  val715, val740, val709 = val690[1], val731 - val709, val690[2]
                  val731 = val709[val715]
                  p477[val740] = val731
                else
                  val745 = val705[14733]
                  val748, val747 = val767[val745], nil
                  val678 = val748 == val747 and val678 + 1845 or 2461
                end
              elseif val678 > 530 then
                val740, val731 = val681[14733], 34
                val690, val731, val709 = val740 - val731, val681[49287], 33
                val709, val740 = 1, val731 - val709
                val731, val715, val709 = val740 - val709, -1, nil
                val678 = val731 == val715 and 810 or 510
              else
                val678, val760 = 3131, p475.c(val760(val745, val748, val747))
              end
            elseif val678 > 507 then
              if val678 <= 513 then
                if val678 <= 511 then
                  if val678 > 510 then
                    val740, val690 = 62, val681[6284]
                    val740, val731, val700 = val681[14733], 3, val690 - val740

                    val709, val690 = 1, val740 - val731
                    val731 = val700 + val709
                    val715, val740 = 2, p477[val731]
                    val709 = val700 + val715
                    val715, val731 = p477[val700], p477[val709]
                    val709 = val715 + val731

                    p477[val700] = val709
                    p477[val690] = val709

                    val715 = 0
                    val678 = val731 > val715 and 305578 / val678 or 900
                  elseif val678 > 509 then
                    val715 = 1
                    val678, val709 = 2323, val740 - val715
                  else
                    val740, val690 = 27, val681[6284]
                    val740, val700 = {}, val690 - val740

                    val690 = val740
                    p477[val700] = val690
                    val740, val731 = val681[14733], 61
                    val678, val690 = 220, val740 - val731
                    val715, val700, val690, val709 = 8, p477[val690], val681[29601], val681[49287]
                    val731 = val709 - val715
                    val740 = p477[val731]
                    val700[val690] = val740
                  end
                else
                  val740, val690 = 45, val681[6284]
                  val700, val709, val715 = val690 - val740, val681[14733], 61
                  val731 = val709 - val715
                  val705, val740, val715 = 55, p477[val731], val681[49287]
                  val709 = val715 - val705
                  val731 = p477[val709]
                  val678, val690 = 220, val740 + val731
                  p477[val700] = val690
                  val690, val740 = val681[49932], 1
                  val700, val731, val709 = val690 - val740, val681[24799], 39
                  val740 = val731 - val709
                  val690 = p477[val740]
                  p477[val700] = val690
                end
              elseif val678 <= 514 then
                val690, val740 = val681[6284], 10
                val700, val709, val731 = val690 - val740, 20, val681[14733]
                val740 = val731 - val709
                val690 = p477[val740]
                p477[val700] = val690
                val678, val740, val731 = 4455 - val678, val681[24799], 36
                val690 = val740 - val731
                val700, val731, val740 = val739[val690], 32, val681[49932]
                val740, val690 = p476[7][2][p476[7][1]], val740 - val731
                val731 = val690
              else
                val745, val760 = val715[1], val715[2]
                val705 = val760[val745]

                val715[3] = val705
                val715[2] = val715

                val678, val705 = 2779 - val678, 3
                val715[1] = val705
                val705 = nil
                val767[val709] = val705
              end
            elseif val678 >= 497 then
              if val678 < 502 then
                if val678 <= 497 then
                  val709, val715 = p477[val700], p476[3][2][p476[3][1]]
                  val745, val747, val760, val705 = p477, 1, p476[4][2][p476[4][1]], val709
                  val748, val678, val747 = val700 + val747, 263410 / val678, val700 + val731
                else
                  val700 = 889
                  val678 = val699 > val700 and 1102 - val678 or 931 - val678
                end
              elseif val678 > 502 then
                val690, val740 = val681[6284], 57

                val731, val709, val700 = val681[14733], 21, val690 - val740
                val731, val740 = 1, val731 - val709

                val690 = val740 == val731
                p477[val700] = val690
                val690, val740 = val681[49287], 32
                val731, val740, val700 = 5, val681[23485], val690 - val740
                val690 = val740 - val731
                p477[val700] = val690
                val678 = val697 <= val709 and 727 - val678 or 706 - val678
              else
                val715, val709 = p476[3][2][p476[3][1]], p477[val700]
                val747, val760, val705, val745 = 1, p476[4][2][p476[4][1]], val709, p477
                val678, val747, val748 = 1014, val700 + val731, val700 + val747
              end
            elseif val678 < 492 then
              if val678 <= 488 then
                val678 = val731 and 166 or 781
              else
                val700 = 218
                val678 = val699 <= val700 and 403 or val678 + -85
              end
            elseif val678 <= 492 then
              val700 = 711
              val678 = val699 >= val700 and 850 or 1005 - val678
            else
              val690, val740 = val681[6284], 48
              val731, val740, val700 = 7, val681[23485], val690 - val740
              val690 = val740 - val731
              p477[val700] = val690
              val740, val690 = 48, val681[14733]
              val690, val700 = nil, val690 - val740
              val678, p477[val700] = val678 + -276, val690
            end
          elseif val678 <= 565 then
            if val678 > 550 then
              if val678 <= 563 then
                if val678 <= 562 then
                  if val678 >= 561 then
                    if val678 > 561 then
                      val740, val690 = 21, val681[6284]
                      val700, val690 = val690 - val740, nil
                      p477[val700] = val690
                      val709, val700, val731 = 39, val681[14733], val681[49287]
                      val731, val740 = 1, val731 - val709
                      val690 = val740 == val731
                      p477[val700] = val690
                      val678 = val751 > val731 and val678 + -342 or 975 - val678
                    else
                      val700 = 123
                      val678 = val699 > val700 and 449361 / val678 or 1057 - val678
                    end
                  else
                    val700 = 116
                    val678 = val699 <= val700 and 188266 / val678 or val678 + -299
                  end
                else
                  val709 = val709(val715, val705)
                  p477[val731] = val709
                  val731, val709 = 1, val690
                  val715 = val731
                  val678 = val709 ~= val709 and val678 + -343 or 2093
                end
              elseif val678 <= 564 then
                val690, val740 = val681[6284], 1
                val740, val700, val731 = val681[14733], val690 - val740, 2
                val690, val731, val740, val705 = val740 - val731, p477[val700], p476[3][2][p476[3][1]], 1
                val715 = val700 + val705
                val705, val678, val709 = 2, 2651, p477[val715]

                val715 = val700 + val705
                val715 = p477[val715]
              else
                val740, val731 = val681[6284], 7
                val690 = val740 - val731
                val709, val678, val700, val731 = 7, 220, p477[val690], val681[14733]
                val740 = val731 - val709
                val690, val709, val715 = p477[val740], val681[49287], 12
                val731 = val709 - val715
                val740 = p477[val731]
                val700[val690] = val740
              end
            elseif val678 < 545 then
              if val678 <= 542 then
                if val678 <= 541 then
                  val705 = val715[1]
                  val678 = val705 >= val700 and val678 + -23 or 2261
                else
                  val715, val705 = val715(p475.d(val705))
                  val760 = 0
                  val678 = val740 == val760 and 1314 - val678 or 778 - val678
                end
              else
                val700 = 6
                val678 = val699 > val700 and 778 or 436572 / val678
              end
            elseif val678 > 548 then
              val678 = val731 and 3497 - val678 or val678 + 2224
            elseif val678 > 546 then
              val740, val690 = 50, val681[6284]
              val715, val709, val700 = 39, val681[14733], val690 - val740
              val731 = val709 - val715
              val678, val740 = 220, p477[val731]
              val690 = not val740
              p477[val700] = val690
            elseif val678 <= 545 then
              val747, val748 = val705[14733], p476[10][2][p476[10][1]]
              val745 = val748[val747]
              val678, val740[val731] = 4338 - val678, val745
            else
              val700 = 275
              val678 = val699 > val700 and 613 or 970
            end
          elseif val678 <= 581 then
            if val678 < 576 then
              if val678 < 571 then
                val731, val709 = val681[6284], 31

                val709, val700, val731 = 58, val731 - val709, val681[14733]
                val709, val690, val731 = 37, val731 - val709, val681[49287]

                val740, val709 = val731 - val709, 0
                val731 = val690 == val709
                val678 = val731 and 185976 / val678 or 488
              elseif val678 <= 571 then
                val740, val690 = 45, val681[6284]

                val731, val740, val700 = 51, val681[14733], val690 - val740
                val731, val690, val709 = val681[8652], val740 - val731, 21

                val740, val709, val715 = val731 - val709, val681[6863], 10
                val731, val709, val715 = val709 - val715, p477[val700], p477[val690]
                val678 = val709 < val715 and val678 + 368 or 568716 / val678
              else
                val690, val731, val709 = p476[10][2][p476[10][1]], val681[14733], 53
                val740 = val731 - val709
                val700, val690 = val690[val740], val681[6284]
                val731, val709 = val700[2], val700[1]
                val740 = val731[val709]
                p477[val690] = val740
                val731, val740 = 47, val681[49287]
                val690, val740 = val740 - val731, nil
                val678, p477[val690] = 794 - val678, val740
              end
            elseif val678 >= 580 then
              if val678 > 580 then
                val740, val690 = 53, val681[6284]
                val700 = val690 - val740
                val678, val690, val731 = 3062 - val678, p477[val700], p476[5][2][p476[5][1]]
                val709 = val690
              else
                val715, val745, val709, val748, val705 = p477, val690 + val740, p476[6][2][p476[6][1]], 1, val690
                val745, val678, val748, val760 = val731, 3545, p477[val700], val745 - val748
              end
            elseif val678 > 576 then
              val740, val690 = 5, val681[6284]
              val731, val740, val700 = 45, val681[14733], val690 - val740
              val690, val731, val709 = val740 - val731, val681[8652], 58
              val740, val715, val709 = val731 - val709, 61, val681[6863]
              val731, val715, val709 = val709 - val715, p477[val690], p477[val700]
              val678 = val709 == val715 and val678 + -287 or 576
            else
              val713 = val713 + val731
              val678 = val703 > val757 and 126720 / val678 or 916 - val678
            end
          elseif val678 > 588 then
            if val678 <= 589 then
              val760, val678, val745 = val700 + val705, 2699, 1
              val755 = val760 - val745
            else
              val678 = val731 and 712 or val678 + -132
            end
          elseif val678 > 583 then
            val740, val690 = 63, val681[6284]
            val715, val709, val700 = 10, val681[14733], val690 - val740
            val678, val731 = 220, val709 - val715
            val715, val740, val705 = val681[49287], p477[val731], 42
            val709 = val715 - val705
            val731 = p477[val709]
            val690 = val740[val731]
            p477[val700] = val690
          elseif val678 > 582 then
            val740, val690 = 27, val681[6284]
            val700, val690 = val690 - val740, val681[29601]
            val678, p477[val700] = 220, val690
            val740, val690 = 39, val681[14733]
            val731, val700, val709 = val681[49287], val690 - val740, 62
            val740 = val731 - val709
            val690 = p477[val740]
            p477[val700] = val690
          else
            val713 = val713 + val740
            val678 = val738 <= val741 and 220 or 1002 - val678
          end
        elseif val678 <= 1867 then
          if val678 < 978 then
            if val678 > 887 then
              if val678 < 923 then
                if val678 > 901 then
                  if val678 >= 912 then
                    if val678 > 919 then
                      if val678 > 920 then
                        val690, val740 = val681[6284], 41
                        val731, val700, val709 = val681[14733], val690 - val740, 63
                        val740 = val731 - val709
                        val690 = p477[val740]
                        p477[val700] = val690
                        val690, val740 = val681[49287], 26
                        val715, val700, val709 = 46, val690 - val740, val681[49932]
                        val731 = val709 - val715
                        val705, val740, val715 = 5, p477[val731], val681[24799]
                        val709 = val715 - val705
                        val731 = p477[val709]
                        val690 = val740[val731]
                        val678, p477[val700] = 220, val690
                      else
                        val678, val760 = 1288, p475.c(val760(val745, val748, val747))
                      end
                    elseif val678 > 918 then
                      val715 = 1
                      val678, val709 = 1773 - val678, val740 - val715
                    elseif val678 < 917 then
                      val690, val740 = val681[6284], 11
                      val700, val740 = val690 - val740, {}
                      val690 = val740
                      p477[val700] = val690
                      val690, val740 = val681[14733], 52
                      val700, val690 = val690 - val740, val681[29601]
                      val678, p477[val700] = 220, val690
                    elseif val678 > 917 then
                      val678 = val715 ~= val715 and 1138 - val678 or 1008
                    else
                      val700 = 404
                      val678 = val699 <= val700 and 311 or 686
                    end
                  elseif val678 > 908 then
                    if val678 <= 909 then
                      val740, val690 = 4, val681[6284]
                      val700, val731, val740 = val690 - val740, 6, val681[23485]
                      val690 = val740 - val731
                      p477[val700] = val690
                      val690, val731, val709 = p476[10][2][p476[10][1]], val681[49287], 48
                      val740 = val731 - val709
                      val690, val678, val700 = val681[14733], val678 + -689, val690[val740]
                      val731, val709 = val700[2], val700[1]
                      val740 = val731[val709]
                      p477[val690] = val740
                    else
                      val705, val715 = 27, val681[6863]
                      val678, val709 = val678 + -691, val715 - val705
                      val713 = val713 + val709
                    end
                  elseif val678 > 907 then
                    val678, val715 = 1360 - val678, 1
                    val709 = val740 - val715
                  elseif val678 <= 904 then
                    if val678 > 903 then
                      val700, val761 = 81, 245
                      val678 = val699 > val700 and 531552 / val678 or 265
                    else
                      val709, val715 = val755 - val700, 1
                      val678, val731 = 650160 / val678, val709 + val715
                    end
                  else
                    val709 = 1
                    val731 = val690 - val709
                    val678 = val702 >= val709 and val678 + 1108 or 598
                  end
                elseif val678 >= 894 then
                  if val678 >= 898 then
                    if val678 > 900 then
                      val690, val740 = val681[6284], 43
                      val700, val709, val715 = val690 - val740, val681[14733], 39
                      val731 = val709 - val715
                      val740, val705, val715 = p477[val731], 44, val681[49287]
                      val709 = val715 - val705
                      val731 = p477[val709]
                      val690 = val740 * val731
                      p477[val700] = val690
                      val740, val690 = 1, val681[49932]
                      val700, val709, val731 = val690 - val740, 14, val681[24799]
                      val740 = val731 - val709
                      val690 = p477[val740]
                      p477[val700] = val690
                      val678 = val736 >= val709 and 220 or val678 + -723
                    elseif val678 <= 899 then
                      if val678 > 898 then
                        val678, val731 = 215, val755 - val700
                      else
                        val731, val679 = 1411754190, 162
                        val678 = val740 ~= val731 and 435 or 466062 / val678
                      end
                    else
                      val705 = val740 <= val709
                      val715 = not val705
                      val678 = val715 and 299 or 736200 / val678
                    end
                  elseif val678 <= 895 then
                    if val678 > 894 then
                      val748, val747 = p476[10][2][p476[10][1]], val705[14733]
                      val745 = val748[val747]
                      val740[val731] = val745
                      val678 = val680 < val714 and 732 or 3004
                    else
                      val690, val740 = val681[6284], 54
                      val700, val690 = val690 - val740, val681[29601]
                      p477[val700] = val690
                      val690 = val681[14733]

                      val731, val700, val678, val709 = val681[49287], val690 - val740, 220, 48
                      val731, val740 = 1, val731 - val709

                      val690 = val740 == val731
                      p477[val700] = val690
                    end
                  else
                    val690, val740 = val681[6284], 48
                    val715, val700, val709 = 14, val690 - val740, val681[14733]
                    val731 = val709 - val715
                    val740, val715, val678, val705 = p477[val731], val681[49287], 220, 30
                    val709 = val715 - val705
                    val731 = p477[val709]
                    val690 = val740 + val731
                    p477[val700] = val690
                    val690, val740 = val681[49932], 52
                    val700, val740 = val690 - val740, {}
                    val690 = val740
                    p477[val700] = val690
                  end
                elseif val678 < 891 then
                  if val678 < 889 then
                    val690, val740 = val681[6284], 6
                    val700, val740, val731 = val690 - val740, p476[15][2][p476[15][1]], val681[29601]
                    val690 = val740[val731]
                    p477[val700] = val690
                    val690, val740 = val681[14733], 5
                    val731, val700, val709 = val681[49287], val690 - val740, 12
                    val740 = val731 - val709
                    val690 = p477[val740]
                    p477[val700] = val690
                    val678 = val732 > val709 and 220 or 1482 - val678
                  elseif val678 > 889 then
                    val690, val740 = val681[6284], 55
                    val700, val709, val715 = val690 - val740, val681[14733], 44
                    val678, val731 = 220, val709 - val715
                    val740, val705, val715 = p477[val731], 61, val681[49287]
                    val709 = val715 - val705
                    val731 = p477[val709]
                    val690 = val740[val731]
                    p477[val700] = val690

                    val690, val740 = val681[49932], 48
                    val690, val700 = nil, val690 - val740

                    p477[val700] = val690
                  else
                    val690, val740 = val681[6284], 46
                    val700, val709, val731 = val690 - val740, 57, val681[14733]
                    val731, val740 = 1, val731 - val709
                    val690 = val740 == val731
                    p477[val700] = val690
                    val740, val678, val690 = 2, 220, val681[49287]
                    val700, val709, val731 = val690 - val740, 63, val681[49932]
                    val740 = val731 - val709
                    val690 = p477[val740]
                    p477[val700] = val690
                  end
                elseif val678 <= 892 then
                  if val678 > 891 then
                    val740, val690 = 12, val681[6284]
                    val715, val700, val709 = 61, val690 - val740, val681[14733]
                    val731 = val709 - val715
                    val740, val715, val705 = p477[val731], val681[49287], 56
                    val709 = val715 - val705
                    val731 = p477[val709]
                    val690 = val740 - val731
                    p477[val700] = val690
                    val690, val740 = val681[49932], 58
                    val740, val678, val700 = {}, 196240 / val678, val690 - val740
                    val690 = val740
                    p477[val700] = val690
                  else
                    val678, val748, val745 = 3861, val705[1], val705[2]
                    val760 = val745[val748]

                    val705[3] = val760
                    val705[2] = val705

                    val760 = 3
                    val705[1] = val760
                    val760 = nil
                    val767[val715] = val760
                  end
                else
                  val678 = val731 and 608133 / val678 or 364
                end
              elseif val678 > 945 then
                if val678 < 962 then
                  if val678 < 959 then
                    if val678 > 950 then
                      val760, val745 = val715[2], val715[1]
                      val705 = val760[val745]

                      val715[3] = val705
                      val715[2] = val715

                      val705 = 3
                      val715[1] = val705
                      val705 = nil
                      val767[val709] = val705
                      val678 = val735 >= val729 and val678 + -814 or 1678376 / val678
                    elseif val678 <= 948 then
                      val760 = 1
                      val678, val705 = val678 + 2179, val740 - val760
                    else
                      val690, val709, val731 = p476[10][2][p476[10][1]], 8, val681[14733]
                      val740 = val731 - val709

                      val731, val700, val740 = 63, val690[val740], val681[6284]
                      val731, val709, val690 = val700[2], val700[1], val740 - val731

                      val740 = val731[val709]
                      p477[val690] = val740
                      val678, val740, val731 = 220, val681[49287], 41
                      val731, val709, val690 = val681[23485], 37, val740 - val731
                      val740 = val731 - val709
                      p477[val690] = val740
                    end
                  elseif val678 <= 960 then
                    if val678 > 959 then
                      val690, val740 = val681[6284], 30
                      val715, val709, val700 = 35, val681[14733], val690 - val740
                      val731 = val709 - val715
                      val705, val740, val715 = 59, p477[val731], val681[49287]
                      val678, val709 = 220, val715 - val705
                      val731 = p477[val709]
                      val690 = val740 == val731
                      p477[val700] = val690
                    else
                      val694, val768, val700 = 49, 41, 181
                      val678 = val699 > val700 and val678 + -253 or 514
                    end
                  else
                    val713 = val713 + val690
                    val678 = val704 >= val759 and 14415 / val678 or 220
                  end
                elseif val678 <= 970 then
                  if val678 >= 966 then
                    if val678 <= 966 then
                      val678, val715, val709 = 972762 / val678, 1, val755 - val700
                      val731 = val709 + val715
                    else
                      val690, val740 = val681[6284], 32
                      val690, val700 = nil, val690 - val740

                      p477[val700] = val690
                      val731, val740 = 63, val681[49932]
                      val690 = val740 - val731
                      val740, val678, val700, val731 = val681[49287], 3931 - val678, val756[val690], 26
                      val690, val740 = val740 - val731, p476[7][2][p476[7][1]]
                      val731 = val690
                    end
                  elseif val678 > 962 then
                    val709, val731, val690 = 47, val681[14733], p476[10][2][p476[10][1]]
                    val740 = val731 - val709
                    val700, val740, val731 = val690[val740], val681[6284], 26
                    val731, val690, val709 = val700[2], val740 - val731, val700[1]
                    val740 = val731[val709]
                    val678, p477[val690] = 1184 - val678, val740
                    val731, val740 = 10, val681[49287]
                    val715, val690, val705 = val681[49932], val740 - val731, 17
                    val709 = val715 - val705
                    val731 = p477[val709]
                    val740 = not val731
                    p477[val690] = val740
                  else
                    val690, val740 = val681[6284], 20
                    val709, val700, val715 = val681[14733], val690 - val740, 45
                    val731 = val709 - val715
                    val705, val740, val715 = 3, p477[val731], val681[49287]
                    val709 = val715 - val705
                    val731 = p477[val709]
                    val690 = val740 <= val731
                    val678, p477[val700] = 211640 / val678, val690
                  end
                elseif val678 > 973 then
                  val678 = val715 ~= val715 and 1531 or val678 + 1227
                else
                  val690, val740 = val681[6284], 33
                  val709, val700, val715 = val681[14733], val690 - val740, 61
                  val731 = val709 - val715
                  val740 = p477[val731]
                  val678, val690 = 220, -val740
                  p477[val700] = val690
                  val740, val690 = 6, val681[49287]
                  val700, val731, val740 = val690 - val740, 54, val681[23485]
                  val690 = val740 - val731
                  p477[val700] = val690
                end
              elseif val678 <= 937 then
                if val678 >= 931 then
                  if val678 >= 934 then
                    if val678 > 934 then
                      val700 = 65
                      val678 = val699 <= val700 and 687 or val678 + -674
                    else
                      val715, val709 = 1, val755 - val700
                      val678, val731 = 650064 / val678, val709 + val715
                    end
                  elseif val678 <= 931 then
                    val737, val700, val718 = 146, 216, 98
                    val678 = val699 > val700 and 464 or 1502 - val678
                  else
                    val678, val747, val748 = 3036 - val678, val705[14733], p476[10][2][p476[10][1]]
                    val745 = val748[val747]
                    val740[val731] = val745
                  end
                elseif val678 < 927 then
                  if val678 > 923 then
                    val690, val740 = val681[6284], 25
                    val690, val700 = nil, val690 - val740

                    p477[val700] = val690
                    val690, val740 = val681[14733], 50
                    val731, val700, val740 = 49, val690 - val740, val681[49287]
                    val690, val731 = val740 - val731, 1
                    val709, val740, val731 = -1, val690 - val731, nil
                    val678 = val740 == val709 and val678 + -741 or 594
                  else
                    val678, val705, val715 = val678 + -703, 2, val681[8652]
                    val709 = val715 - val705
                    val713 = val713 + val709
                  end
                elseif val678 <= 927 then
                  val700 = 232
                  val678 = val699 <= val700 and 759 or 339282 / val678
                else
                  val740, val690 = 22, val681[6284]
                  val715, val700, val709 = 34, val690 - val740, val681[14733]
                  val731 = val709 - val715
                  val740, val715, val705 = p477[val731], val681[49287], 13
                  val678, val709 = 1148 - val678, val715 - val705
                  val731 = p477[val709]
                  val690 = val740 / val731
                  p477[val700] = val690
                end
              elseif val678 <= 942 then
                if val678 < 940 then
                  if val678 > 938 then
                    val678, val713 = 206580 / val678, val713 + val740
                  else
                    val678, val715, val709 = 609700 / val678, 1, val755 - val700
                    val731 = val709 + val715
                  end
                elseif val678 <= 940 then
                  val721, val678, val707 = 55, 886, p476[2][2][p476[2][1]]
                  val762, val721, val684 = val706, p476[16][2][p476[16][1]], iter2 * val721
                else
                  val700 = 109
                  val678 = val699 > val700 and 830 or val678 + -625
                end
              elseif val678 > 944 then
                val709 = 1
                val678, val731 = 720, val690 - val709
              else
                val678 = val731 and 380 or 436
              end
            elseif val678 > 836 then
              if val678 < 866 then
                if val678 <= 854 then
                  if val678 >= 846 then
                    if val678 <= 851 then
                      if val678 > 850 then
                        val713 = val713 + val740
                        val678 = val750 <= val727 and 220 or val678 + -514
                      elseif val678 > 846 then
                        val700 = 711
                        val678 = val699 <= val700 and 226950 / val678 or 768
                      else
                        val740, val690 = 61, val681[6284]
                        val709, val700, val678, val731 = 43, val690 - val740, 220, val681[14733]
                        val740 = val731 - val709
                        val690 = p477[val740]
                        p477[val700] = val690
                        val709, val731, val690 = 23, val681[49932], p476[10][2][p476[10][1]]
                        val740 = val731 - val709
                        val700 = val690[val740]
                        val690, val740, val705, val715 = val700[2], val700[1], 55, val681[49287]
                        val709 = val715 - val705
                        val731 = p477[val709]
                        val690[val740] = val731
                      end
                    else
                      val715, val705 = p477[val690], p476[3][2][p476[3][1]]
                      val678, iter, val748, val760, val745 = 2968, 1, p477, val715, p476[4][2][p476[4][1]]
                      val747, iter = val690 + iter, val690 + val709
                    end
                  elseif val678 > 843 then
                    val731, val740 = 8, val681[6284]
                    val690 = val740 - val731
                    val709, val700, val731 = 23, p477[val690], val681[14733]
                    val740 = val731 - val709
                    val709, val715, val690 = val681[49287], 33, p477[val740]
                    val731 = val709 - val715
                    val740 = p477[val731]
                    val700[val690] = val740

                    val690, val740 = val681[49932], 61
                    val690, val740, val700, val731 = val767, nil, val690 - val740, nil
                    val690, val740, val731 = p475.b(val690, val740, val731)

                    val709, val715 = val690(val740, val731)
                    val731 = val709
                    val678 = val731 == nil and 220 or 1721 - val678
                  elseif val678 <= 840 then
                    val740, val678, val690 = 41, 220, val681[6284]
                    val700, val690 = val690 - val740, val681[29601]
                    p477[val700] = val690
                    val740, val690 = 9, val681[14733]
                    val690, val700 = val681[44007], val690 - val740
                    p477[val700] = val690
                  else
                    val700 = 137
                    val678 = val699 <= val700 and 909 or 397
                  end
                elseif val678 <= 862 then
                  if val678 < 856 then
                    val745 = val715(val705, val760)
                    val760 = val745
                    val678 = val760 == nil and 878 or 256
                  elseif val678 <= 856 then
                    val705, val760 = val683[val713], 1
                    val713, val745, val760 = val713 + val760, 1, val705[6284]
                    val678 = val760 == val745 and val678 + -653 or 933
                  else
                    val740, val731 = val681[6284], 6
                    val690 = val740 - val731
                    val715, val709, val700, val690 = 8, val681[14733], p477[val690], val681[29601]
                    val731 = val709 - val715
                    val740 = p477[val731]
                    val678, val700[val690] = 220, val740
                  end
                elseif val678 <= 864 then
                  val709 = 1
                  val731 = val690 - val709
                  val678 = val728 >= val709 and 1514 - val678 or 1881 - val678
                else
                  val678, val745, val760 = 1509, 1, val700 + val705
                  val755 = val760 - val745
                end
              elseif val678 < 876 then
                if val678 <= 871 then
                  if val678 < 870 then
                    if val678 <= 866 then
                      val705, val678, val715 = 55, 1086 - val678, val681[8652]
                      val709 = val715 - val705
                      val713 = val713 + val709
                    else
                      val740, val690 = 6, val681[6284]
                      val700, val731 = val690 - val740, 1
                      val740 = val700 + val731
                      val709, val690 = 2, p477[val740]
                      val731 = val700 + val709
                      val709, val740 = p477[val700], p477[val731]
                      val731 = val709 + val740
                      p477[val700] = val731
                      val709 = 0
                      val678 = val740 > val709 and 759500 / val678 or val678 + -573
                    end
                  elseif val678 <= 870 then
                    val709, val690, val731 = 35, p476[10][2][p476[10][1]], val681[14733]
                    val678, val740 = 220, val731 - val709
                    val740, val731, val700 = val681[6284], 29, val690[val740]
                    val709, val731, val690 = val700[1], val700[2], val740 - val731
                    val740 = val731[val709]
                    p477[val690] = val740
                  else
                    val700 = 202
                    val678 = val699 > val700 and 398 or 591
                  end
                elseif val678 > 874 then
                  val715 = val731 <= val690
                  val709 = not val715
                  val678 = val709 and 361375 / val678 or 369
                else
                  val740, val690 = 12, val681[6284]
                  val731, val700, val740 = val681[29601], val690 - val740, p476[15][2][p476[15][1]]
                  val690 = val740[val731]
                  p477[val700] = val690
                  val690, val678, val740 = val681[14733], val678 + -654, 28
                  val740, val700, val731 = p476[15][2][p476[15][1]], val690 - val740, val681[44007]
                  val690 = val740[val731]
                  p477[val700] = val690
                end
              elseif val678 < 882 then
                if val678 < 878 then
                  val705 = val715[1]
                  val678 = val705 >= val700 and 952 or 138
                elseif val678 <= 878 then
                  val678, val740 = val678 + 20, val709
                else
                  val678, val760 = 2699, 1
                  val705 = val740 - val760
                end
              elseif val678 > 886 then
                val760 = 1
                val678, val705 = 1188, val740 - val760
              elseif val678 >= 883 then
                if val678 <= 883 then
                  val715, val678, val705, val760, val709, val745 = p477, 1245, val700, val700 + val731, p476[4][2][p476[4][1]], 1
                  val760 = val760 - val745
                else
                  val678, val721 = val678 + -144, val721(val762)
                  val684, val685 = 4294967295, val684 + val721
                end
              else
                val690, val731, val709 = p476[10][2][p476[10][1]], val681[14733], 57
                val740 = val731 - val709
                val678, val700, val731, val740 = val678 + -662, val690[val740], 2, val681[6284]
                val690, val709, val731 = val740 - val731, val700[1], val700[2]
                val740 = val731[val709]
                p477[val690] = val740
                val731, val740 = 28, val681[49287]
                val690, val731, val709 = val740 - val731, p476[15][2][p476[15][1]], val681[29601]
                val740 = val731[val709]
                p477[val690] = val740
              end
            elseif val678 >= 818 then
              if val678 >= 825 then
                if val678 < 831 then
                  if val678 <= 828 then
                    if val678 <= 825 then
                      val700 = 208
                      val678 = val699 <= val700 and 194 or 715
                    else
                      val760, val745 = val715[2], val715[1]
                      val705 = val760[val745]

                      val715[3] = val705
                      val715[2] = val715

                      val705 = 3
                      val715[1] = val705
                      val705 = nil
                      val767[val709] = val705
                      val678 = val769 <= val701 and 197892 / val678 or val678 + 419
                    end
                  else
                    val690, val740 = val681[6284], 20
                    val740, val731, val700 = val681[23485], 3, val690 - val740
                    val690 = val740 - val731
                    p477[val700] = val690
                    val690, val740 = val681[14733], 58
                    val700, val740 = val690 - val740, val681[49287]
                    val690 = p477[val740]
                    p477[val700] = val690
                    val678 = val725 > val731 and 1050 - val678 or 1696 - val678
                  end
                elseif val678 >= 833 then
                  if val678 <= 833 then
                    val745, val760 = 1, val700 + val705
                    val678, val755 = 2342396 / val678, val760 - val745
                  else
                    val690, val731, val709 = p476[10][2][p476[10][1]], val681[14733], 19
                    val740 = val731 - val709
                    val700 = val690[val740]
                    val678, val705, val690, val715, val740 = 183920 / val678, 61, val700[2], val681[6284], val700[1]
                    val709 = val715 - val705
                    val731 = p477[val709]
                    val690[val740] = val731
                  end
                elseif val678 <= 831 then
                  val740, val690 = 61, val681[6284]

                  val731, val700, val709 = val681[14733], val690 - val740, 51
                  val731, val740 = 1, val731 - val709

                  val690 = val740 == val731
                  p477[val700] = val690
                  val690, val740 = val681[49287], 62
                  val740, val700, val731 = val681[49932], val690 - val740, 4
                  val731, val690 = 1, val740 - val731
                  val709, val740, val731 = -1, val690 - val731, nil
                  val678 = val740 == val709 and val678 + -381 or 663
                else
                  val700 = 41
                  val678 = val699 > val700 and 611 or 722
                end
              elseif val678 < 821 then
                if val678 <= 819 then
                  if val678 <= 818 then
                    val760, val705 = 9, val681[8652]
                    val678, val715 = 220, val705 - val760
                    val713 = val713 + val715
                  else
                    val678 = val731 and 497 or 399
                  end
                else
                  val740, val690 = 63, val681[6284]
                  val740, val700 = {}, val690 - val740

                  val690 = val740
                  p477[val700] = val690
                  val690, val740 = val681[14733], 57
                  val700, val715, val709 = val690 - val740, 16, val681[49287]
                  val678, val731 = 220, val709 - val715
                  val740, val731 = p477[val731], val681[29601]
                  val690 = val740[val731]
                  p477[val700] = val690
                end
              elseif val678 >= 823 then
                if val678 <= 823 then
                  val709, val715 = p477[val700], p476[3][2][p476[3][1]]
                  val760, val747, val705, val745 = p476[4][2][p476[4][1]], 1, val709, p477
                  val748, val678, val747 = val700 + val747, 3448 - val678, val700 + val731
                else
                  val678, val760 = 2317088 / val678, 1
                  val705 = val740 - val760
                end
              elseif val678 > 821 then
                val700 = 312
                val678 = val699 > val700 and val678 + -519 or 159
              else
                val700 = 74
                val678 = val699 > val700 and 323 or 567
              end
            elseif val678 >= 804 then
              if val678 <= 811 then
                if val678 > 810 then
                  val715, val709, val716 = p476[3][2][p476[3][1]], p477[val700], 253
                  val747, val760, val678, val745, val705 = 1, p476[4][2][p476[4][1]], 920, p477, val709
                  val748, val747 = val700 + val747, val700 + val731
                elseif val678 <= 809 then
                  if val678 <= 804 then
                    val690, val740 = val681[6284], 57
                    val700, val740, val731 = val690 - val740, val681[14733], 1
                    val690, val715, val709 = val740 - val731, 13, val681[49287]
                    val731, val709 = val709 - val715, 1
                    val740, val715, val709 = val731 - val709, 3, val681[49932]
                    val731, val709 = val709 - val715, -1
                    val678 = val740 == val709 and 457 or 580
                  else
                    val740, val690 = 47, val681[6284]
                    val700, val715, val709 = val690 - val740, 17, val681[14733]
                    val731 = val709 - val715
                    val715, val705, val740 = val681[49287], 41, p477[val731]
                    val709 = val715 - val705
                    val731 = p477[val709]
                    val690 = val740 .. val731
                    p477[val700] = val690
                    val678 = val723 <= val705 and 706 or 220
                  end
                else
                  val715, val678, val705 = val755 - val690, 2323, 1
                  val709 = val715 + val705
                end
              elseif val678 > 816 then
                val690, val740 = val681[6284], 51
                val731, val740, val700 = 31, val681[23485], val690 - val740
                val690 = val740 - val731
                p477[val700] = val690
                val740, val690 = 56, val681[14733]
                val700, val740, val731 = val690 - val740, val681[40758], 62
                val690 = val740 - val731
                val678, p477[val700] = 179740 / val678, val690
              elseif val678 > 812 then
                val705 = val715[1]
                val678 = val705 >= val700 and 597312 / val678 or 1243 - val678
              else
                val690, val740 = val681[6284], 38

                val731, val740, val700 = 3, val681[14733], val690 - val740
                val731, val690 = 1, val740 - val731

                val740, val709 = val700 + val731, 2
                val731, val760, val747 = val700 + val709, p477[val700], 1
                val748 = val700 + val747
                iter, val745 = val709, p477[val748]
                val747 = val700 + iter
                iter, val678, iter2, val748 = p476[5][2][p476[5][1]], 3356 - val678, val760, p477[val747]
              end
            elseif val678 > 800 then
              if val678 <= 801 then
                val731, val709 = val681[6284], 39
                val709, val731, val700 = 22, val681[14733], val731 - val709
                val731, val709, val690 = val681[49287], 2, val731 - val709
                val740, val709 = val731 - val709, 0
                val731 = val690 == val709
                val678 = val731 and val678 + -189 or val678 + -251
              else
                val690, val740 = val681[6284], 61
                val700, val709, val715 = val690 - val740, val681[14733], 21
                val731 = val709 - val715
                val740 = p477[val731]
                val690 = -val740
                p477[val700] = val690
                val740, val690 = 15, val681[49287]
                val690, val700 = nil, val690 - val740
                val678, p477[val700] = 1023 - val678, val690
              end
            elseif val678 > 799 then
              val690, val740 = val681[6284], 4
              val700, val690 = val690 - val740, val681[29601]
              p477[val700] = val690
              val731, val690, val709 = val681[49287], p476[10][2][p476[10][1]], 43
              val678, val740 = 220, val731 - val709
              val700, val740, val731 = val690[val740], val681[14733], 27
              val690, val709, val731 = val740 - val731, val700[1], val700[2]
              val740 = val731[val709]
              p477[val690] = val740
            elseif val678 >= 797 then
              if val678 <= 797 then
                val690, val740 = val681[6284], 44
                val700, val690 = val690 - val740, val681[29601]
                p477[val700] = val690
                val740, val690 = 11, val681[14733]
                val700, val740 = val690 - val740, {}
                val678, val690 = 220, val740
                p477[val700] = val690
              else
                val678, val713 = 220, val713 + val731
              end
            else
              val690, val740 = val681[6284], 50
              val715, val709, val700 = 17, val681[14733], val690 - val740
              val731 = val709 - val715
              val740, val731 = p477[val731], val681[29601]
              val678, val690 = 175120 / val678, val740[val731]
              p477[val700] = val690
            end
          elseif val678 <= 1352 then
            if val678 >= 1078 then
              if val678 >= 1244 then
                if val678 < 1288 then
                  if val678 >= 1255 then
                    if val678 > 1281 then
                      val678 = val731 > val709 and 1507 - val678 or 1255
                    elseif val678 <= 1255 then
                      val678 = val715 ~= val715 and 3548 or 3801
                    else
                      val709 = val709(val715, val705)
                      p477[val731] = val709
                      val709, val731 = val690, 1
                      val715 = val731
                      val678 = val709 ~= val709 and val678 + -1061 or 1892
                    end
                  elseif val678 < 1245 then
                    val678 = val715 ~= val715 and val678 + -873 or 225
                  elseif val678 > 1245 then
                    val709, val715 = val690(val740, val731)
                    val731 = val709
                    val678 = val731 == nil and 274340 / val678 or 269
                  else
                    val709 = p475.c(val709(val715, val705, val760))
                    return p475.d(val709)
                  end
                elseif val678 < 1307 then
                  if val678 < 1291 then
                    val678, val705 = 2984, p475.c(val705(p475.d(val760)))
                  elseif val678 <= 1291 then
                    val709 = val705
                    val678 = val717 < val711 and 2474 or val678 + -321
                  else
                    val709 = p475.c(val709(val715, val705, val760))
                    return p475.d(val709)
                  end
                elseif val678 <= 1348 then
                  if val678 <= 1343 then
                    if val678 <= 1307 then
                      val678, val760, val745 = 2411, val700 + val705, 1
                      val755 = val760 - val745
                    else
                      val715, val705 = val715(p475.d(val705))
                      val760 = 0
                      val678 = val740 == val760 and val678 + 2592 or 2111
                    end
                  else
                    val678 = val731 > val709 and val678 + -1128 or 1637
                  end
                else
                  val715, val705 = val715(p475.d(val705))
                  val760 = 0
                  val678 = val740 == val760 and val678 + -619 or val678 + 26
                end
              elseif val678 > 1163 then
                if val678 >= 1209 then
                  if val678 <= 1211 then
                    if val678 <= 1209 then
                      val709 = val709(val715, val705)
                      p477[val731] = val709
                      val731, val709 = 1, val690
                      val715 = val731
                      val678 = val709 ~= val709 and 220 or 2781
                    else
                      val678, val760 = 5138 - val678, p475.c(val760(val745, val748, val747))
                    end
                  else
                    val678 = val715 > 0 and 1958160 / val678 or 3149
                  end
                elseif val678 < 1169 then
                  val709 = p475.c(val709(val715, val705, val760))
                  return p475.d(val709)
                elseif val678 <= 1169 then
                  val705, val760, val745 = val705(val760, val745)
                  val705, val760, val745 = p475.b(val705, val760, val745)

                  val748 = val705(val760, val745)
                  val745 = val748
                  val678 = val745 == nil and val678 + 520 or 2960
                else
                  val745, iter, val747, val748, val760, val678, iter2 = val715, val700, val705, 1, p476[6][2][p476[6][1]], 2359, p477
                end
              elseif val678 <= 1113 then
                if val678 < 1094 then
                  if val678 <= 1078 then
                    val678 = 3596
                    val740, val731 = val740(p475.d(val731))
                    val705, val715, val709, val760, val748 = 1, val740, p476[6][2][p476[6][1]], val690, 3
                    val748, val745 = p477, val700 + val748
                  else
                    val709 = val709(val715, val705)
                    p477[val731] = val709
                    val731, val709 = 1, val690
                    val715 = val731
                    val678 = val709 ~= val709 and 400309 / val678 or 1327170 / val678
                  end
                elseif val678 > 1094 then
                  val678 = 220
                  val760(val745, val748, val747, iter, iter2)
                else
                  val678 = val731 < val709 and 220 or 3451
                end
              elseif val678 > 1153 then
                val678, val731[val709] = 2596, val747
              elseif val678 > 1134 then
                val678 = val715 ~= val715 and 220 or 597
              else
                val678, val731 = 3993, val755 - val700
              end
            elseif val678 < 1009 then
              if val678 <= 993 then
                if val678 <= 987 then
                  if val678 < 985 then
                    if val678 <= 978 then
                      val678, val709 = 329586 / val678, 1
                      val731 = val690 - val709
                    else
                      val748, val678, val747 = p476[10][2][p476[10][1]], 2760780 / val678, val705[14733]
                      val745 = val748[val747]
                      val740[val731] = val745
                    end
                  elseif val678 > 985 then
                    val745, val760 = 1, val683[val713]
                    val713, val745, val748 = val713 + val745, val760[6284], 1
                    val678 = val745 == val748 and 1221 - val678 or 754
                  else
                    val678, val731 = 724, val755 - val700
                  end
                elseif val678 >= 990 then
                  if val678 > 990 then
                    val690, val740 = val681[6284], 55
                    val700, val690 = val690 - val740, nil
                    p477[val700] = val690
                    val690, val678, val740 = val681[14733], 220, 24
                    val740, val700 = {}, val690 - val740
                    val690 = val740
                    p477[val700] = val690
                  else
                    val740, val690 = 44, val681[6284]
                    val678, val715, val700, val709 = 1210 - val678, 40, val690 - val740, val681[14733]
                    val731 = val709 - val715
                    val705, val740, val715 = 9, p477[val731], val681[49287]
                    val709 = val715 - val705
                    val731 = p477[val709]
                    val690 = val740 + val731
                    p477[val700] = val690
                    val709, val731, val690 = 26, val681[24799], p476[10][2][p476[10][1]]

                    val740 = val731 - val709
                    val740, val700, val731 = val681[49932], val690[val740], 27

                    val709, val731, val690 = val700[1], val700[2], val740 - val731
                    val740 = val731[val709]
                    p477[val690] = val740
                  end
                else
                  val698, val700 = 18, 194
                  val678 = val699 > val700 and 1321 - val678 or val678 + -769
                end
              elseif val678 < 1006 then
                if val678 < 996 then
                  val678, val709, val715 = 377, val755 - val700, 1
                  val731 = val709 + val715
                elseif val678 <= 996 then
                  val678, val713 = 220, val713 + val731
                else
                  val700 = 39
                  val678 = val699 <= val700 and val678 + -101 or 340
                end
              elseif val678 < 1007 then
                val690 = p478[44908]
                val678, val740, val731 = val678 + -749, val700 + val690, 1
                val755 = val740 - val731
              elseif val678 <= 1007 then
                val705, val715, val760, val709, val745 = val700, p477, val700 + val731, p476[4][2][p476[4][1]], 1
                val678, val760 = 3666 - val678, val760 - val745
              else
                val760, val705 = 1, val683[val713]
                val745, val760, val713 = 1, val705[6284], val713 + val760
                val678 = val760 == val745 and 251 or 895
              end
            elseif val678 > 1019 then
              if val678 > 1058 then
                if val678 <= 1069 then
                  val747 = {}
                  val747[1] = val745
                  val747[2] = p477

                  val748 = val747
                  val678, val767[val745] = 3742, val748
                else
                  val747 = {}
                  val747[1] = val745
                  val747[2] = p477

                  val748 = val747
                  val678, val767[val745] = 2943, val748
                end
              elseif val678 >= 1057 then
                if val678 > 1057 then
                  val691, val754, val720 = val691(val754, val720)
                  val691, val754, val720 = p475.b(val691, val754, val720)

                  val706 = val691(val754, val720)
                  val720 = val706
                  val678 = val720 == nil and 308936 / val678 or 940
                else
                  val678 = val715 ~= val715 and 1781 or 2406
                end
              elseif val678 > 1020 then
                val740 = val740(val731)
                val709, val715 = val681[49287], 3
                val705, val678, val731, val709, val715 = val740, 2478, val709 - val715, p476[9][2][p476[9][1]], val700
              else
                val678, val709 = 1397 - val678, 1
                val731 = val690 - val709
              end
            elseif val678 < 1015 then
              if val678 > 1012 then
                val678, val760 = 2857, p475.c(val760(val745, val748, val747))
              elseif val678 <= 1009 then
                val700 = 147
                val678 = val699 <= val700 and 375348 / val678 or 990
              else
                val760 = 1
                val678, val705 = 3962, val740 - val760
              end
            elseif val678 >= 1018 then
              if val678 <= 1018 then
                val760, val745 = val715[2], val715[1]
                val705 = val760[val745]

                val715[3] = val705
                val715[2] = val715

                val678, val705 = 2996, 3
                val715[1] = val705
                val705 = nil
                val767[val709] = val705
              else
                val709, val731, val690 = 3, val681[14733], p476[10][2][p476[10][1]]
                val740 = val731 - val709
                val690, val700 = val681[6284], val690[val740]
                val709, val731 = val700[1], val700[2]
                val740 = val731[val709]
                p477[val690] = val740
                val731, val740 = 60, val681[49287]
                val709, val731, val690 = 33, val681[49932], val740 - val731
                val740, val709 = val731 - val709, 1
                val731, val709, val715 = val740 - val709, nil, -1
                val678 = val731 == val715 and 337289 / val678 or 1927 - val678
              end
            elseif val678 <= 1015 then
              val760 = val705[1]
              val678 = val760 >= val690 and 891 or 4876 - val678
            else
              val678, val705, val760 = 220, val681[6863], 31
              val715 = val705 - val760
              val713 = val713 + val715
            end
          elseif val678 >= 1603 then
            if val678 <= 1705 then
              if val678 > 1646 then
                if val678 > 1689 then
                  if val678 <= 1694 then
                    val678, val705 = 2290288 / val678, p475.c(val705(p475.d(val760)))
                  else
                    val709 = 0
                    val678 = val731 > val709 and 4022 or 3189
                  end
                elseif val678 < 1684 then
                  if val678 > 1648 then
                    val678 = val731 > val709 and 1902 - val678 or 1638268 / val678
                  else
                    val678, val760 = 3555, p475.c(val760(val745, val748, val747))
                  end
                elseif val678 <= 1684 then
                  iter, val678, val747 = val760, 3307, p476[14][2][p476[14][1]]
                else
                  val678, val731 = val678 + 1899, val715
                end
              elseif val678 >= 1628 then
                if val678 > 1641 then
                  val760(val745, val748, val747, iter, iter2)
                  val745, val678, val748 = val681[49932], 220, 7
                  iter2, iter, val760 = 20, val681[24799], val745 - val748
                  val747 = iter - iter2
                  val748 = p477[val747]
                  val745 = not val748
                  p477[val760] = val745
                elseif val678 < 1637 then
                  val678 = val731 > val709 and 220 or 1959
                elseif val678 <= 1637 then
                  val678 = val715 <= 0 and 5402100 / val678 or val678 + -484
                else
                  val760(val745, val748, val747, iter, iter2)
                  val745, val748 = val681[49932], 1
                  val760, val745, val748, val747 = val745 - val748, val767, nil, nil
                  val745, val748, val747 = p475.b(val745, val748, val747)
                  iter, iter2 = val745(val748, val747)
                  val747 = iter
                  val678 = val747 == nil and 220 or val678 + 1841
                end
              elseif val678 <= 1611 then
                if val678 <= 1608 then
                  if val678 > 1603 then
                    val760(val745, val748, val747, iter, iter2)
                    iter, val745, val747 = 28, p476[10][2][p476[10][1]], val681[24799]
                    val678, val748 = 220, val747 - iter
                    val748, val760, val747 = val681[49932], val745[val748], 44
                    iter, val747, val745 = val760[1], val760[2], val748 - val747
                    val748 = val747[iter]
                    p477[val745] = val748
                  else
                    val678, val740 = 6262921 / val678, val740(val731)
                    val715, val709 = 37, val681[14733]
                    val715, val705, val731, val709 = p476[18][2][p476[18][1]], val740, val709 - val715, val700
                  end
                else
                  val678 = val731 < val709 and 1831 - val678 or 856
                end
              else
                val747, val748 = val705[14733], p476[10][2][p476[10][1]]
                val745 = val748[val747]
                val678, val740[val731] = val678 + 993, val745
              end
            elseif val678 >= 1802 then
              if val678 > 1839 then
                if val678 > 1841 then
                  val678 = val715 <= 0 and 2425 or 3165
                else
                  val678, val745, val760 = 1308951 / val678, 1, val700 + val705
                  val755 = val760 - val745
                end
              elseif val678 >= 1819 then
                if val678 <= 1819 then
                  val715, val705 = val681[6863], 51
                  val678, val709 = 220, val715 - val705
                  val713 = val713 + val709
                else
                  iter, val748, val678, val760, val747, val745, iter2 = val700, 1, val678 + -193, p476[6][2][p476[6][1]], val705, val715, p477
                end
              elseif val678 > 1802 then
                val678, val709 = 1169, val709(val715)
                val760, val705, val745, val715 = val709, p476[11][2][p476[11][1]], ".", 5381
              else
                val709 = 1
                val678, val731 = 1782, val690 - val709
              end
            elseif val678 <= 1781 then
              if val678 >= 1763 then
                if val678 > 1763 then
                  val678 = val731 < val709 and 220 or 2062 - val678
                else
                  val678, val709, val731 = 2357, val740, p476[13][2][p476[13][1]]
                end
              elseif val678 <= 1716 then
                val709 = p475.c(val709(val715, val705, val760))
                return p475.d(val709)
              else
                val678 = val705 ~= val705 and 3331 or 2394
              end
            elseif val678 <= 1782 then
              val709, val715 = p477[val700], p476[3][2][p476[3][1]]
              val678, val760, val745, val705, val747 = 5145 - val678, p476[4][2][p476[4][1]], p477, val709, 1
              val747, val748 = val700 + val731, val700 + val747
            else
              val678 = val715 <= 0 and 1965918 / val678 or 3451
            end
          elseif val678 <= 1509 then
            if val678 < 1418 then
              if val678 >= 1397 then
                if val678 >= 1411 then
                  if val678 <= 1411 then
                    val678 = val715 <= 0 and val678 + 2096 or 2419 - val678
                  else
                    val678, val760 = val678 + 282, p475.c(val760(val745, val748, val747))
                  end
                else
                  val684 = val684(val721, val762)
                  val678, val754 = 3777, val684
                end
              elseif val678 <= 1378 then
                if val678 <= 1362 then
                  val678 = val715 ~= val715 and 299640 / val678 or val678 + -1081
                else
                  val760 = 1
                  val678, val705 = 2732, val740 - val760
                end
              else
                val678, val705 = val678 + 774, p475.c(val705(p475.d(val760)))
              end
            elseif val678 > 1465 then
              if val678 >= 1488 then
                if val678 > 1488 then
                  val748, val678, iter2, val747, iter, val745, val760 = 1, 2632, p477, val705, val700, val715, p476[6][2][p476[6][1]]
                else
                  iter2 = val747
                  val678 = iter2 and 1956 or 4983 - val678
                end
              else
                val678, val705 = 2905, p475.c(val705(p475.d(val760)))
              end
            elseif val678 < 1455 then
              if val678 > 1418 then
                val678, val740 = 2524 - val678, val740(val731)
                val709, val715 = val681[6284], 28
                val709, val715, val705, val731 = p476[9][2][p476[9][1]], val700, val740, val709 - val715
              else
                val709, val715 = p477[val700], p476[3][2][p476[3][1]]
                val747, val705, val745, val760 = 1, val709, p477, p476[4][2][p476[4][1]]
                val678, val747, val748 = 1412, val700 + val731, val700 + val747
              end
            elseif val678 <= 1455 then
              val678 = val715 > 0 and 1682 or 974
            else
              val748, val678, val745 = 1, 2019, val690 + val760
              val755 = val745 - val748
            end
          elseif val678 <= 1569 then
            if val678 <= 1531 then
              if val678 < 1519 then
                if val678 > 1510 then
                  val715, val705 = val715(p475.d(val705))
                  val760 = 0
                  val678 = val740 == val760 and 1841 or 4011
                else
                  val678 = val731 > val709 and 1730 - val678 or val678 + 1803
                end
              elseif val678 > 1519 then
                val678 = val731 < val709 and 336820 / val678 or 914007 / val678
              else
                iter2, val678, iter = 1, 3779, val755 - val760
                val747 = iter + iter2
              end
            elseif val678 < 1537 then
              val715, val717, val687, val711 = 2, 134, 68, 163
              val709 = val700 + val715
              val715, val731 = p476[5][2][p476[5][1]], p477[val709]
              val678, val705 = 3575015 / val678, val731
            elseif val678 > 1537 then
              val678, iter2 = 2972, val754
            else
              val760 = 1
              val678, val705 = 656, val740 - val760
            end
          elseif val678 <= 1578 then
            if val678 < 1574 then
              val760 = 1
              val678, val705 = val678 + -62, val740 - val760
            elseif val678 <= 1574 then
              val678 = 346280 / val678
              val760(val745, val748, val747, iter, iter2)
            else
              p477[val700] = val709
              p477[val740] = val715

              val678, p477[val731] = 747, val705
              val731, val705, val740 = p477[val700], 1, p476[3][2][p476[3][1]]
              val715 = val700 + val705
              val705, val709 = 2, p477[val715]

              val715 = val700 + val705
              val715 = p477[val715]
            end
          elseif val678 > 1589 then
            val678 = val731 > val709 and 371 or 3149
          else
            val709 = p475.c(val709(val715, val705, val760))
            return p475.d(val709)
          end
        elseif val678 <= 2984 then
          if val678 > 2411 then
            if val678 >= 2694 then
              if val678 >= 2857 then
                if val678 >= 2943 then
                  if val678 >= 2961 then
                    if val678 < 2972 then
                      if val678 <= 2961 then
                        val740 = val740(val731)
                        val678, val715, val709 = 1209, 46, val681[14733]
                        val731, val705, val709, val715 = val709 - val715, val740, p476[9][2][p476[9][1]], val700
                      else
                        val678, val745 = val678 + -799, p475.c(val745(val748, val747, iter))
                      end
                    elseif val678 > 2972 then
                      val715, val705 = val715(p475.d(val705))
                      val760 = 0
                      val678 = val740 == val760 and val678 + -2542 or 3932 - val678
                    else
                      val678, val691 = 3668, 997062039
                      iter = iter2 == val691
                    end
                  elseif val678 <= 2947 then
                    if val678 <= 2943 then
                      val678, val740[val731] = 5947 - val678, val748
                    else
                      val715, val709 = p476[3][2][p476[3][1]], p477[val700]
                      val747, val705, val760, val745 = 1, val709, p476[4][2][p476[4][1]], p477
                      val748, val678, val747 = val700 + val747, 3536, val700 + val731
                    end
                  else
                    val678, val754, iter = 2020, 37, p476[2][2][p476[2][1]]
                    val720, val691, val754 = val748, val715 * val754, p476[16][2][p476[16][1]]
                  end
                elseif val678 >= 2903 then
                  if val678 < 2905 then
                    val740(val731, val709, val715, val705, val760)
                    val678 = val730 <= val709 and 139 or 638660 / val678
                  elseif val678 > 2905 then
                    val678 = val715 > 0 and 4015 or val678 + 551
                  else
                    val715, val705 = val715(p475.d(val705))
                    val760 = 0
                    val678 = val740 == val760 and val678 + -2072 or val678 + -2081
                  end
                elseif val678 < 2876 then
                  val678, val705 = 3399 - val678, p475.c(val705(p475.d(val760)))
                elseif val678 > 2876 then
                  val709, val715 = val690(val740, val731)
                  val731 = val709
                  val678 = val731 == nil and 1797978 / val678 or 1079364 / val678
                else
                  val678 = val715 > 0 and 1287 or 4131 - val678
                end
              elseif val678 > 2732 then
                if val678 < 2812 then
                  if val678 > 2774 then
                    val678 = val715 > 0 and val678 + 1218 or 6319 - val678
                  elseif val678 > 2761 then
                    val678, val709 = 2947, 1
                    val731 = val690 - val709
                  else
                    val678, val740[val731] = 6861085 / val678, val748
                  end
                elseif val678 >= 2817 then
                  if val678 <= 2817 then
                    val678 = val705 > 0 and val678 + 986 or 1742
                  else
                    val731 = val731 + val715
                    val678 = val715 > 0 and val678 + -1472 or 4457 - val678
                  end
                else
                  val760, val748, val747, iter, iter2, val678, val745 = p476[6][2][p476[6][1]], 1, val705, val700, p477, 1608, val715
                end
              elseif val678 >= 2703 then
                if val678 >= 2714 then
                  if val678 > 2714 then
                    val678, val760, iter2, val747, val748, iter, val745 = 3867, p476[6][2][p476[6][1]], p477, val705, 1, val700, val715
                  else
                    val706 = val691(val754, val720)
                    val720 = val706
                    val678 = val720 == nil and 292 or 940
                  end
                elseif val678 > 2703 then
                  val678 = val731 < val709 and 2927 - val678 or val678 + -1789
                else
                  val740 = val740(val731)
                  val715, val709 = 38, val681[6284]
                  val731, val678, val705, val709, val715 = val709 - val715, 563, val740, p476[9][2][p476[9][1]], val700
                end
              elseif val678 < 2695 then
                val760(val745, val748, val747, iter, iter2)
                val745, val748 = val681[49932], 17
                val760, val748 = val745 - val748, {}
                val745 = val748
                val678, p477[val760] = 220, val745
              elseif val678 > 2695 then
                iter2, val747, iter, val748, val678, val745, val760 = p477, val705, val700, 1, val678 + -1125, val715, p476[6][2][p476[6][1]]
              else
                val678 = val731 > val709 and val678 + -2475 or 1867
              end
            elseif val678 <= 2544 then
              if val678 < 2478 then
                if val678 < 2449 then
                  if val678 < 2426 then
                    val678 = val731 < val709 and 220 or 3165
                  elseif val678 <= 2426 then
                    val731 = val731 + val715
                    val678 = val715 > 0 and 1883 or 3130 - val678
                  else
                    val767 = val767(val756, val739)
                    val739 = p476[1][2][p476[1][1]]
                    val756, val683 = val739[44371], val739
                    val739, val678, val681 = val683[45868], 2653 - val678, val683
                    val683, val699, val681 = val681[40274], nil, nil
                  end
                elseif val678 < 2461 then
                  val715, val705 = val715(p475.d(val705))
                  val760 = 0
                  val678 = val740 == val760 and val678 + 1025 or val678 + -1437
                elseif val678 > 2461 then
                  val715 = 1411754190
                  val678 = val709 ~= val715 and 6514 - val678 or 1705
                else
                  val678, val740[val731] = 3793, val748
                end
              elseif val678 >= 2516 then
                if val678 < 2536 then
                  if val678 <= 2516 then
                    val740 = val740(val731)
                    val715, val678, val709 = 62, val678 + -503, val681[6284]
                    val731, val705, val709, val715 = val709 - val715, val740, val700, p476[18][2][p476[18][1]]
                  else
                    val720, val706, val763 = val720(val706, val763)
                    val720, val706, val763 = p475.b(val720, val706, val763)

                    val707 = val720(val706, val763)
                    val763 = val707
                    val678 = val763 == nil and 1569 or 3272
                  end
                elseif val678 <= 2536 then
                  val709 = 1
                  val678, val731 = 3916, val690 - val709
                else
                  iter = iter(iter2)
                  val720, iter2, val678, val754, val691 = ".", 5381, 2691552 / val678, iter, p476[11][2][p476[11][1]]
                end
              elseif val678 >= 2481 then
                if val678 > 2481 then
                  val731 = val731 + val715
                  val678 = val715 > 0 and 5180 - val678 or val678 + -618
                else
                  val678, val731 = 664, val731(val709)
                  val705, val709, val760, val715 = val731, 5381, ".", p476[11][2][p476[11][1]]
                end
              else
                val709 = val709(val715, val705)
                p477[val731] = val709
                val709, val731 = val690, 1
                val715 = val731
                val678 = val709 ~= val709 and 220 or val678 + -1023
              end
            elseif val678 < 2625 then
              if val678 > 2603 then
                if val678 > 2608 then
                  val754, val678, val691 = val760, 2627, p476[5][2][p476[5][1]]
                else
                  val731 = val731 + val715
                  val678 = val715 > 0 and 4236 - val678 or 1959
                end
              elseif val678 > 2596 then
                val715, val705 = val715(p475.d(val705))
                val760 = 0
                val678 = val740 == val760 and 1606051 / val678 or 3490 - val678
              elseif val678 < 2566 then
                val720 = val720(val706)
                val678, val691, val754 = 7837648 / val678, val754 + val720, 4294967295
              elseif val678 > 2566 then
                val709 = val709 + val705
                val678 = val705 > 0 and 2388 or 1984
              else
                val678 = val715 ~= val715 and 220 or 856
              end
            elseif val678 <= 2642 then
              if val678 < 2632 then
                if val678 <= 2625 then
                  val678, val760 = 3674, p475.c(val760(val745, val748, val747))
                else
                  val678, val691 = 2529, val691(val754)
                  val754, val706, val763, val720 = 65599, val691, ".", p476[11][2][p476[11][1]]
                end
              elseif val678 > 2632 then
                val678 = val731 > val709 and 581240 / val678 or 1797
              else
                val760(val745, val748, val747, iter, iter2)
                iter, val745, val747 = 32, p476[10][2][p476[10][1]], val681[24799]
                val678, val748 = 220, val747 - iter
                val760 = val745[val748]
                val748, iter2, val691, val745 = val760[1], val681[49932], 62, val760[2]
                iter = iter2 - val691
                val747 = p477[iter]
                val745[val748] = val747
              end
            elseif val678 <= 2651 then
              val678, val731 = 2857778 / val678, p475.c(val731(val709, val715))
            else
              val709 = p475.c(val709(val715, val705, val760))
              return p475.d(val709)
            end
          elseif val678 <= 2159 then
            if val678 > 1990 then
              if val678 > 2087 then
                if val678 < 2111 then
                  if val678 >= 2093 then
                    if val678 <= 2093 then
                      val678 = val715 > 0 and val678 + 1087 or 1057
                    else
                      val731 = val731 + val715
                      val678 = val715 > 0 and 8470884 / val678 or 5791 - val678
                    end
                  else
                    val678 = val715 <= 0 and 7563147 / val678 or 278
                  end
                elseif val678 > 2157 then
                  val760, val745 = val700 + val705, 1
                  val678, val755 = val678 + -1503, val760 - val745
                elseif val678 <= 2111 then
                  val760 = 1
                  val678, val705 = val678 + -145, val740 - val760
                else
                  val678, val740 = 519, val740(val731)
                  p477[val700] = val740
                  val690 = val740
                end
              elseif val678 >= 2020 then
                if val678 < 2081 then
                  if val678 <= 2020 then
                    val678, val754 = 5966 - val678, val754(val720)
                    val691, iter2 = 4294967295, val691 + val754
                  else
                    val691 = val691(val754)
                    iter, val678, iter2 = iter2 + val691, 5859 - val678, 4294967295
                  end
                elseif val678 <= 2081 then
                  val678, val705 = 2449, p475.c(val705(p475.d(val760)))
                else
                  val678 = iter and 2271 or 1488
                end
              elseif val678 < 2015 then
                val709 = val709(val715, val705)
                p477[val731] = val709
                val709, val731 = val690, 1
                val715 = val731
                val678 = val709 ~= val709 and 220 or 5865882 / val678
              elseif val678 > 2015 then
                val691, val678, val748, val747, iter2, val745, iter = p477, 7195716 / val678, val705, 1, val690, p476[6][2][p476[6][1]], val760
              else
                val709, val760, val745, val678, val705, val715 = p476[4][2][p476[4][1]], val700 + val731, 1, 5749 - val678, val700, p477
                val760 = val760 - val745
              end
            elseif val678 < 1956 then
              if val678 < 1892 then
                if val678 >= 1883 then
                  if val678 <= 1883 then
                    val678 = val731 > val709 and val678 + -1512 or 704
                  else
                    val747 = val760(val745, val748)
                    val748 = val747
                    val678 = val748 == nil and 1291 or 2999
                  end
                else
                  iter2, val678, val691 = val747.__iter, 2087, nil
                  iter = iter2 ~= val691
                end
              elseif val678 > 1913 then
                val760, val745, val748 = val760(val745, val748)
                val760, val745, val748 = p475.b(val760, val745, val748)

                val747 = val760(val745, val748)
                val748 = val747
                val678 = val748 == nil and 1291 or 2999
              elseif val678 > 1912 then
                val678 = val705 ~= val705 and 420860 / val678 or 987
              elseif val678 <= 1892 then
                val678 = val715 > 0 and 2856920 / val678 or 3313
              else
                val678, val705, val715, val709 = 1578, val748, val745, val760
              end
            elseif val678 < 1966 then
              if val678 > 1959 then
                val715, val705 = val715(p475.d(val705))
                val760 = 0
                val678 = val740 == val760 and 2829 - val678 or 1571
              elseif val678 <= 1956 then
                val678, iter2 = 3495, val747.__call
              else
                val678 = val715 <= 0 and 2240 or 1362
              end
            elseif val678 > 1987 then
              val705, val760 = val705(p475.d(val760))
              val745 = 0
              val678 = val731 == val745 and 1465 or 3577
            elseif val678 > 1984 then
              val678, iter2, iter = val678 + 2075, val760, p476[8][2][p476[8][1]]
            elseif val678 <= 1966 then
              val747, iter2, val760, val745, val678, iter, val748 = val705, p477, p476[6][2][p476[6][1]], val715, 4160 - val678, val700, 1
            else
              val678 = val705 <= 0 and 5009 - val678 or 1913
            end
          elseif val678 < 2317 then
            if val678 < 2240 then
              if val678 < 2194 then
                if val678 < 2169 then
                  val760 = 1
                  val705 = val740 - val760
                  val678 = val698 < val760 and 283 or 3977757 / val678
                elseif val678 <= 2169 then
                  val678, val760 = 4316310 / val678, p475.c(val760(p475.d(val745)))
                else
                  val715, val705 = val715(p475.d(val705))
                  val760 = 0
                  val678 = val740 == val760 and 4685030 / val678 or 3707 - val678
                end
              elseif val678 > 2201 then
                iter = 1222593029
                val678 = val747 ~= iter and 1684 or 1912
              elseif val678 > 2194 then
                val678 = val715 <= 0 and 1531 or 597
              else
                val760(val745, val748, val747, iter, iter2)
                val748, val745 = 8, val681[49932]
                val747, val748, val760 = 18, val681[24799], val745 - val748
                val745, val747 = val748 - val747, 1
                val748, iter, val747 = val745 - val747, -1, nil
                val678 = val748 == iter and 3713 - val678 or val678 + 1643
              end
            elseif val678 < 2271 then
              if val678 > 2259 then
                val709, val715 = val690(val740, val731)
                val731 = val709
                val678 = val731 == nil and 220 or 541
              elseif val678 > 2240 then
                val678, val747 = 2761, {}

                val747[1] = val745
                val747[2] = p477

                val748 = val747
                val767[val745] = val748
              else
                val678 = val731 < val709 and val678 + -2020 or 1362
              end
            elseif val678 <= 2278 then
              if val678 > 2271 then
                val678, val709 = 1418, 1
                val731 = val690 - val709
              else
                iter, val678, iter2 = val747.__iter, 699, val760
              end
            else
              val731 = val731(val709)
              val715, val678, val705 = val681[49287], 9002791 / val678, 51
              val709, val760, val715, val705 = val715 - val705, val731, p476[9][2][p476[9][1]], val690
            end
          elseif val678 >= 2370 then
            if val678 <= 2388 then
              if val678 >= 2387 then
                if val678 > 2387 then
                  val678 = val709 > val715 and 220 or 1984
                else
                  val678 = val731 < val709 and 371 or 225
                end
              elseif val678 <= 2370 then
                val678, val705 = 2603, p475.c(val705(p475.d(val760)))
              else
                val747 = {}
                val747[1] = val745
                val747[2] = p477

                val748 = val747
                val767[val745] = val748
                val678 = val768 < val694 and 2461 or 5504 - val678
              end
            elseif val678 <= 2406 then
              if val678 > 2394 then
                val678 = val715 <= 0 and val678 + -625 or val678 + -2125
              else
                val678 = val705 <= 0 and 3331 or 987
              end
            else
              val678, val745, val760, iter2, val747, iter, val748 = val678 + 1545, val715, p476[6][2][p476[6][1]], p477, val705, val700, 1
            end
          elseif val678 < 2343 then
            if val678 <= 2323 then
              if val678 <= 2317 then
                val709, val715 = val690(val740, val731)
                val731 = val709
                val678 = val731 == nil and val678 + -2097 or 1566292 / val678
              else
                val760, val705, val748, val678, val745, val715 = val690, p477, 1, 6377 - val678, val690 + val709, p476[4][2][p476[4][1]]
                val745 = val745 - val748
              end
            else
              val715 = val715(val705)
              val745, val760, val678, val748, val705 = val715, p476[11][2][p476[11][1]], 4260 - val678, ".", 5381
            end
          elseif val678 >= 2357 then
            if val678 <= 2357 then
              val731 = val731(val709)
              val678, val715 = val678 + -822, 1
              val709 = val700 + val715
              p477[val709] = val731
              val740 = val731
            else
              val678 = 220
              val760(val745, val748, val747, iter, iter2)
            end
          else
            val678, val705 = val678 + -1000, p475.c(val705(p475.d(val760)))
          end
        elseif val678 < 3674 then
          if val678 <= 3378 then
            if val678 >= 3180 then
              if val678 <= 3300 then
                if val678 >= 3247 then
                  if val678 > 3272 then
                    val678 = val731 < val709 and 726000 / val678 or 1153
                  elseif val678 < 3257 then
                    val745 = val705[14733]
                    val747, val748 = nil, val767[val745]
                    val678 = val748 == val747 and 5506 - val678 or 8964967 / val678
                  elseif val678 > 3257 then
                    val692, val684 = 35, p476[2][2][p476[2][1]]
                    val762, val678, val692, val712 = val754 * val692, 3333, p476[16][2][p476[16][1]], val707
                  else
                    val715, val705 = val715(p475.d(val705))
                    val760 = 0
                    val678 = val740 == val760 and 4564 - val678 or val678 + -2463
                  end
                elseif val678 > 3189 then
                  val678 = val731 < val709 and 3416 - val678 or 2566
                elseif val678 > 3180 then
                  val715 = val740 <= val690
                  val709 = not val715
                  val678 = val709 and 4082 or 631
                else
                  val678 = val731 > val709 and val678 + -2960 or 3361260 / val678
                end
              elseif val678 >= 3333 then
                if val678 > 3363 then
                  val678 = val715 <= 0 and 6085 - val678 or val678 + -2460
                elseif val678 <= 3333 then
                  val678, val692 = 1397, val692(val712)
                  val721, val762 = val762 + val692, 4294967295
                else
                  val678, val760 = 3776, p475.c(val760(val745, val748, val747))
                end
              elseif val678 >= 3313 then
                if val678 > 3313 then
                  val678 = val709 < val715 and 732820 / val678 or 987
                else
                  val678 = val715 ~= val715 and 3617 or 2091
                end
              else
                val747 = val747(iter)
                iter2 = nil
                iter = val747 ~= iter2
                val678 = iter and val678 + -1433 or 2087
              end
            elseif val678 < 3067 then
              if val678 > 3025 then
                if val678 > 3040 then
                  val760, val678, val745 = val700 + val705, 1839, 1
                  val755 = val760 - val745
                else
                  val715 = p475.c(val715(val705, val760, val745))
                  return p475.d(val715)
                end
              elseif val678 < 3004 then
                if val678 > 2996 then
                  val678, val720, iter2 = 2548, 37, p476[2][2][p476[2][1]]
                  val720, val754, val706 = p476[16][2][p476[16][1]], val705 * val720, val747
                else
                  val709, val715 = val690(val740, val731)
                  val731 = val709
                  val678 = val731 == nil and 659120 / val678 or 404
                end
              elseif val678 > 3004 then
                val678 = val709 < val715 and 220 or 1913
              else
                val731 = val731 + val715
                val678 = val715 > 0 and 3877 or 3378
              end
            elseif val678 > 3131 then
              if val678 >= 3149 then
                if val678 <= 3149 then
                  val678 = val715 ~= val715 and val678 + -762 or 10722345 / val678
                else
                  val678 = val715 ~= val715 and 3385 - val678 or 3546 - val678
                end
              else
                iter, iter2 = val745(val748, val747)
                val747 = iter
                val678 = val747 == nil and 689260 / val678 or val678 + 349
              end
            elseif val678 < 3127 then
              if val678 > 3067 then
                iter2 = iter2(val691, val754)
                val705 = iter2
                val678 = val766 > val754 and 254 or 5816716 / val678
              else
                val720, val754 = iter2[1], iter2[2]
                val691 = val754[val720]

                iter2[3] = val691
                iter2[2] = iter2

                val691 = 3
                val678, iter2[1] = 3133, val691
                val691 = nil
                val767[iter] = val691
              end
            elseif val678 <= 3127 then
              iter, val745, val748, val760, val678, iter2, val747 = val700, val715, 1, p476[6][2][p476[6][1]], 5821 - val678, p477, val705
            else
              val678, val705 = val678 + 503, p475.c(val705(p475.d(val760)))
            end
          elseif val678 >= 3538 then
            if val678 <= 3564 then
              if val678 <= 3548 then
                if val678 < 3545 then
                  if val678 > 3538 then
                    val678, val740[val731] = 2103, val748
                  else
                    val678 = val715 ~= val715 and 1611 or 3827
                  end
                elseif val678 > 3545 then
                  val678 = val731 < val709 and val678 + -3328 or 381
                else
                  val678 = 220
                  val709(val715, val705, val760, val745, val748)
                end
              elseif val678 > 3555 then
                val745(val748, val747, iter, iter2, val691)
                val678 = val744 <= val747 and 3837 or 784080 / val678
              elseif val678 > 3549 then
                val678, val705 = 1511, p475.c(val705(p475.d(val760)))
              else
                val709 = p475.c(val709(val715, val705, val760))
                return p475.d(val709)
              end
            elseif val678 >= 3617 then
              if val678 <= 3634 then
                if val678 > 3617 then
                  val715, val705 = val715(p475.d(val705))
                  val760 = 0
                  val678 = val740 == val760 and val678 + -581 or 2163
                else
                  val678 = val731 < val709 and 3837 - val678 or 3895 - val678
                end
              else
                val678 = iter and 1987 or 1912
              end
            elseif val678 > 3588 then
              val709(val715, val705, val760, val745, val748)
              val715 = 2
              val709, val760 = val700 + val715, 3
              val705 = val700 + val760
              val715 = p477[val705]
              p477[val709] = val715
              val705 = 2

              val715 = val700 + val705
              val715, val709 = nil, p477[val715]

              val678 = val709 == val715 and 911 or 3114136 / val678
            elseif val678 > 3577 then
              val709 = 1411754190
              val678 = val731 ~= val709 and 1763 or val678 + -2053
            else
              val678, val745 = 2019, 1
              val760 = val731 - val745
            end
          elseif val678 > 3474 then
            if val678 <= 3507 then
              if val678 <= 3495 then
                if val678 > 3482 then
                  val691 = nil
                  iter = iter2 == val691
                  val678 = iter and 2620 or 3668
                else
                  val691 = iter2[1]
                  val678 = val691 >= val760 and 3067 or val678 + -349
                end
              else
                val678 = val731 < val709 and 220 or 4515 - val678
              end
            elseif val678 <= 3527 then
              val740, val731 = val740(p475.d(val731))
              val715, val709, val705, val748, val760 = val740, p476[6][2][p476[6][1]], 1, 3, val690
              val678, val745, val748 = 12989941 / val678, val700 + val748, p477
            else
              val678, val760 = 2081, p475.c(val760(val745, val748, val747))
            end
          elseif val678 <= 3465 then
            if val678 < 3460 then
              if val678 <= 3405 then
                val678 = val715 <= 0 and 2387 or 225
              else
                val678 = val715 ~= val715 and 220 or 278
              end
            elseif val678 <= 3460 then
              val748 = val705(val760, val745)
              val745 = val748
              val678 = val745 == nil and 1689 or 2960
            else
              val678 = val715 ~= val715 and 3507 or 1411
            end
          elseif val678 <= 3467 then
            if val678 <= 3466 then
              val678, val760 = 2343, p475.c(val760(val745, val748, val747))
            else
              val709 = p475.c(val709(val715, val705, val760))
              return p475.d(val709)
            end
          else
            val760, val745 = val700 + val705, 1
            val678, val755 = val678 + 488, val760 - val745
          end
        elseif val678 < 3903 then
          if val678 > 3801 then
            if val678 >= 3861 then
              if val678 > 3877 then
                if val678 <= 3892 then
                  val678 = 220
                  val760(val745, val748, val747, iter, iter2)
                  val748, val745 = 18, val681[49932]
                  val760, iter2, iter = val745 - val748, 7, val681[24799]
                  val747 = iter - iter2
                  val748 = p477[val747]
                  val745 = #val748
                  p477[val760] = val745
                else
                  val715 = val715(val705, val760)
                  p477[val709] = val715
                  val715, val709 = val740, 1
                  val705 = val709
                  val678 = val715 ~= val715 and val678 + -3679 or 6716 - val678
                end
              elseif val678 <= 3868 then
                if val678 < 3867 then
                  val715, val705 = val740(val731, val709)
                  val709 = val715
                  val678 = val709 == nil and 220 or 1015
                elseif val678 > 3867 then
                  val709 = val709(val715)
                  val705 = 2
                  val715 = val700 + val705
                  p477[val715] = val709
                  val731 = val709
                  val678 = val753 < val705 and 5887 - val678 or val678 + -2163
                else
                  val678 = 220
                  val760(val745, val748, val747, iter, iter2)
                  val745, val748 = val681[49932], 50
                  val760, val747, iter = val745 - val748, val681[24799], 4
                  val748 = val747 - iter
                  val745 = p477[val748]
                  p477[val760] = val745
                end
              else
                val678 = val731 > val709 and val678 + -3657 or 13096506 / val678
              end
            elseif val678 <= 3815 then
              if val678 > 3814 then
                val760(val745, val748, val747, iter, iter2)
                val748, val745 = 33, val681[49932]
                val760, val678, val745 = val745 - val748, 4035 - val678, nil
                p477[val760] = val745
              elseif val678 < 3807 then
                val678 = val709 > val715 and val678 + -3583 or 1742
              elseif val678 <= 3807 then
                val747 = {}
                val747[1] = val745
                val747[2] = p477

                val748 = val747
                val678, val767[val745] = val678 + -266, val748
              else
                val709, val715 = val690(val740, val731)
                val731 = val709
                val678 = val731 == nil and 532 or 2002350 / val678
              end
            elseif val678 > 3827 then
              iter = 1
              val747 = val745 - iter
              val678 = val693 < iter and 2624508 / val678 or 3779
            else
              val678 = val715 <= 0 and val678 + -2216 or 4683 - val678
            end
          elseif val678 > 3742 then
            if val678 <= 3793 then
              if val678 > 3779 then
                val731 = val731 + val715
                val678 = val715 > 0 and 2642 or 1797
              elseif val678 > 3777 then
                val720, val678, iter, val691, val754, iter2 = 1, 7754 - val678, p476[4][2][p476[4][1]], val760, val760 + val747, p477
                val754 = val754 - val720
              elseif val678 <= 3776 then
                val678, val705 = 3257, p475.c(val705(p475.d(val760)))
              else
                val707 = val720(val706, val763)
                val763 = val707
                val678 = val763 == nil and val678 + -2208 or 12358344 / val678
              end
            elseif val678 <= 3797 then
              val678, val747 = 4652 - val678, val747(iter, iter2)
              val709 = val747
            else
              val678 = val715 <= 0 and 7349 - val678 or 381
            end
          elseif val678 >= 3688 then
            if val678 < 3734 then
              if val678 > 3688 then
                val715, val705 = val715(p475.d(val705))
                val760 = 0
                val678 = val740 == val760 and 2192847 / val678 or val678 + -2843
              else
                val678 = val715 <= 0 and 3196 or 2566
              end
            elseif val678 <= 3734 then
              val709 = p475.c(val709(val715, val705, val760))
              return p475.d(val709)
            else
              val678, val740[val731] = 6350 - val678, val748
            end
          elseif val678 >= 3677 then
            if val678 > 3677 then
              val709(val715, val705, val760, val745, val748)
              val715 = 2
              val760, val709 = 3, val700 + val715
              val705 = val700 + val760
              val715 = p477[val705]
              p477[val709] = val715
              val705 = 2

              val715 = val700 + val705
              val715, val709 = nil, p477[val715]

              val678 = val709 == val715 and 777 or 923
            else
              iter = {}
              val678, iter[1] = 4276351 / val678, val748
              iter[2] = p477
              val747 = iter
              val767[val748] = val747
            end
          else
            val678, val705 = 5638 - val678, p475.c(val705(p475.d(val760)))
          end
        elseif val678 < 3999 then
          if val678 >= 3942 then
            if val678 <= 3962 then
              if val678 < 3956 then
                if val678 > 3942 then
                  iter = iter(iter2, val691)
                  val715 = iter
                  val678 = val679 < val691 and val678 + -486 or 5871648 / val678
                else
                  val747, val748 = val705[14733], p476[10][2][p476[10][1]]
                  val745 = val748[val747]
                  val678, val740[val731] = 6427 - val678, val745
                end
              elseif val678 > 3956 then
                iter, val748, val760, iter2, val678, val745, val747 = val700, 1, p476[6][2][p476[6][1]], p477, 7854 - val678, val715, val705
              else
                val760(val745, val748, val747, iter, iter2)
                val748, val745 = 36, val681[49932]
                iter, val760, val747 = 21, val745 - val748, val681[24799]
                val747, val748 = 1, val747 - iter
                val745 = val748 == val747
                p477[val760] = val745
                val678 = val710 <= iter and val678 + -1482 or 870320 / val678
              end
            elseif val678 <= 3984 then
              if val678 > 3975 then
                val760, val747, val748, iter, val678, val745, iter2 = p476[6][2][p476[6][1]], val705, 1, val700, 3815, val715, p477
              else
                iter = p475.c(iter(iter2, val691, val754))
                return p475.d(iter)
              end
            else
              val678 = val731 and 3916 or 6529 - val678
            end
          elseif val678 <= 3927 then
            if val678 >= 3916 then
              if val678 > 3916 then
                val678, val705 = 14620221 / val678, p475.c(val705(p475.d(val760)))
              else
                val715, val678, val709 = p476[3][2][p476[3][1]], val678 + -450, p477[val700]
                val760, val747, val705, val745 = p476[4][2][p476[4][1]], 1, val709, p477
                val748, val747 = val700 + val747, val700 + val731
              end
            elseif val678 > 3903 then
              val709 = val709(val715, val705)
              p477[val731] = val709
              val709, val731 = val690, 1
              val715 = val731
              val678 = val709 ~= val709 and 220 or val678 + -1031
            else
              val678, val760 = 5382 - val678, p475.c(val760(val745, val748, val747))
            end
          elseif val678 <= 3935 then
            val760, val745 = val700 + val705, 1
            val678, val755 = 1966, val760 - val745
          else
            val740 = val740(val731)
            val715, val709 = 21, val681[49287]
            val715, val678, val705, val709, val731 = p476[18][2][p476[18][1]], 1281, val740, val700, val709 - val715
          end
        elseif val678 >= 4028 then
          if val678 > 4054 then
            if val678 >= 4082 then
              if val678 <= 4082 then
                val705, val715 = 51, val681[6863]
                val709 = val715 - val705
                val678, val713 = 898040 / val678, val713 + val709
              else
                val678, val760 = 5716620 / val678, p475.c(val760(val745, val748, val747))
              end
            else
              iter, iter2, val691 = iter(iter2)
              val715, val678, val709, val705 = iter2, 5640 - val678, iter, val691
            end
          elseif val678 < 4046 then
            if val678 > 4028 then
              val715, val678, val709 = val731, val678 + -172, p476[13][2][p476[13][1]]
            else
              val678 = val731 > val709 and 220 or val678 + -340
            end
          elseif val678 <= 4046 then
            val678, val760 = 9589020 / val678, p475.c(val760(val745, val748, val747))
          else
            val715 = p475.c(val715(val705, val760, val745))
            return p475.d(val715)
          end
        elseif val678 <= 4015 then
          if val678 <= 4011 then
            if val678 <= 4007 then
              if val678 <= 3999 then
                val678 = val731 > val709 and val678 + -3779 or 14148462 / val678
              else
                val745 = val705[14733]
                val747, val748 = nil, val767[val745]
                val678 = val748 == val747 and 1069 or 3742
              end
            else
              val678, val760 = 711, 1
              val705 = val740 - val760
            end
          else
            val678 = val731 > val709 and 220 or 3465
          end
        elseif val678 > 4020 then
          val715 = val690 <= val740
          val709 = not val715
          val678 = val709 and 1819 or 631
        else
          val760, val745, val715, val709, val705 = val700 + val731, 1, p477, p476[4][2][p476[4][1]], val700
          val678, val760 = 5246100 / val678, val760 - val745
        end
      until false
    end
  end, function(p479, p480)
    return function()
      local holdBall = p480[1][2][p480[1][1]].holdBall

      if not (holdBall and holdBall.Parent) or os.clock() >= p480[1][2][p480[1][1]].holdUntil then
        p480[1][2][p480[1][1]].release(holdBall)
        return
      end

      local networkOwner12 = holdBall:FindFirstChild("NetworkOwner")

      if not (networkOwner12 and networkOwner12.Value == p480[2][2][p480[2][1]]) then
        p480[3][2][p480[3][1]](holdBall, true, true)
        return
      end

      if not p480[1][2][p480[1][1]].applied then
        p480[1][2][p480[1][1]].applied = true
        p480[1][2][p480[1][1]].seen = {}

        for v956, v957 in holdBall:GetChildren() do
          if v957:IsA("BodyVelocity") then
            p480[1][2][p480[1][1]].seen[v957] = true
          end
        end

        p480[4][2][p480[4][1]](holdBall, p480[1][2][p480[1][1]].holdLock)

        p480[1][2][p480[1][1]].holdUntil = os.clock()
          + (p480[1][2][p480[1][1]].holdLock and p480[1][2][p480[1][1]].LOCK_HOLD
            or p480[1][2][p480[1][1]].HOLD)

        return
      end

      for v958, v959 in holdBall:GetChildren() do
        if v959:IsA("BodyVelocity") and v959.Name ~= p480[1][2][p480[1][1]].HOLDN
          and not (p480[1][2][p480[1][1]].seen and p480[1][2][p480[1][1]].seen[v959]) then
          p480[1][2][p480[1][1]].release(holdBall)
          return
        end
      end

      if not p480[1][2][p480[1][1]].holdLock
        and not holdBall:FindFirstChild(p480[1][2][p480[1][1]].HOLDN) then
        p480[4][2][p480[4][1]](holdBall, false)
      end
    end
  end, function(p481, p482)
    return function()
      if not p482[1][2][p482[1][1]] then
        return nil
      end

      local val770, success30 = pcall(debug.getupvalue, p482[1][2][p482[1][1]], p482[2][2][p482[2][1]])

      if val770 and type(success30) == "table" then
        return success30
      end

      local val771, success31 = pcall(debug.getupvalues, p482[1][2][p482[1][1]])

      if val771 and type(success31) == "table" and type(success31[p482[2][2][p482[2][1]]]) == "table" then
        return success31[p482[2][2][p482[2][1]]]
      end

      return nil
    end
  end, function(p483, p484)
    return function()
      local character23 = p484[1][2][p484[1][1]].Character
      local humanoidRootPart14 = character23 and character23:FindFirstChild("HumanoidRootPart")

      if not humanoidRootPart14 then
        return
      end

      p484[2][2][p484[2][1]](character23, humanoidRootPart14)

      if not p484[3][2][p484[3][1]] then
        return
      end

      local element85 = rawget(p484[3][2][p484[3][1]], "state")

      if not element85 then
        return
      end

      if not element85.canExecute then
        p484[4][2][p484[4][1]] = false
        return
      end

      if p484[4][2][p484[4][1]] then
        return
      end

      local val772 = p484[5][2][p484[5][1]](character23, humanoidRootPart14)

      if not val772 then
        return
      end

      if not p484[6][2][p484[6][1]](val772) then
        return
      end

      p484[4][2][p484[4][1]] = true

      pcall(p484[3][2][p484[3][1]].handleBallContact, p484[3][2][p484[3][1]], val772)
      pcall(function() element85.canExecute = false end)
    end
  end, function(p485, p486)
    return function(p487, p488, p489)
      local hc = p485.gc[-25764] or p485:hc(18173, 63654, -25764)
      local val773, val774, val775, val776, val777

      while true do
        if hc < 109 then
          if hc <= 65 then
            hc = p488 > p489 and (p485.gc[-21597] or p485:hc(26321, 55394, -21597))
              or p485.gc[-23505] or p485:ic(1904339, 22791, -23505)
          else
            return
          end
        elseif hc <= 109 then
          hc, val777, val773, val774, val775 = p485.bc[19178] or p485:dc(4806029, 25903, 19178), 1, p487, p487[p488], p486[1][2][p486[1][1]]
          val777, val776 = p489, p488 + val777
        else
          val775 = p485.c(val775(val773, val776, val777))
          return val774, p485.d(val775)
        end
      end
    end
  end, function(p490, p491)
    return function()
      local longTracer = p491[1][2][p491[1][1]].longTracer

      if not longTracer then
        longTracer = p491[2][2][p491[2][1]](
          p491[3][2][p491[3][1]].SEGS + 10, p491[3][2][p491[3][1]].FLAT
        )

        p491[1][2][p491[1][1]].longTracer = longTracer
      end

      local character24 = p491[4][2][p491[4][1]].Character
      local humanoidRootPart15 = character24 and character24:FindFirstChild("HumanoidRootPart")
      local tool3 = character24 and character24:FindFirstChildOfClass("Tool")

      if not (humanoidRootPart15 and tool3 and tool3.Name == "Long") then
        longTracer.Hide()
        return
      end

      local longCore = p491[5][2][p491[5][1]].LongCore

      if type(longCore) ~= "table" then
        longTracer.Hide()
        return
      end

      local val778, success32 = pcall(debug.getupvalues, longCore.MButtonEnd)
      local val779

      if val778 and type(success32) == "table" and type(success32[1]) == "table" then
        val779 = success32[1]
      end

      local val780, success33 = pcall(debug.getupvalues, longCore.MobileButton)
      local val781

      if val780 and type(success33) == "table" and type(success33[1]) == "table" then
        val781 = success33[1]
      end

      if not (val779 and val781 and rawget(val779, "phase") == "charging") then
        longTracer.Hide()
        return
      end

      local val782 = p491[1][2][p491[1][1]].longMove(val781)
      local val783 = type(val782) == "table" and rawget(val782, "props") or nil
      local val784 = type(val782) == "table" and rawget(val782, "timing") or nil

      if not (val783 and val784) then
        longTracer.Hide()
        return
      end

      local val785 = p491[6][2][p491[6][1]](
        humanoidRootPart15.Position, humanoidRootPart15.CFrame.LookVector, p491[7][2][p491[7][1]].aimRange
      )

      if not val785 then
        longTracer.Hide()
        return
      end

      local val786 = math.clamp(rawget(val779, "charge") or 0, 0, 1)
      local maxCharge2 = val784.maxCharge or 0

      local val787 = math.max(65, (val786 * maxCharge2 + (val783.basePower or 0) * (val783.chargeRate or 1))
        * (val783.powerMult or 1))

      local val788 = (val786 * maxCharge2 / 5 + (val783.baseAngle or 0)) * (val783.angleMult or 0)
      local cframe6 = humanoidRootPart15.CFrame
      local lookVector5, rightVector7, upVector2 = cframe6.LookVector, cframe6.RightVector, cframe6.UpVector
      local val789 = rawget(val782, "direction")
      local val790

      if val789 == "right" then
        val790 = (rightVector7 + lookVector5 / 5) * val787 / 130 * val787 + upVector2 * (val788 * 0.35)
      elseif val789 == "left" then
        val790 = (-rightVector7 + lookVector5 / 5) * val787 / 130 * val787 + upVector2 * (val788 * 0.35)
      else
        val790 = lookVector5 * val787
          + upVector2 * (val788 * 0.35 * (rawget(val782, "verticalBoost") or 1))
      end

      local val791 = 2.932
      local val792, success34 = pcall(val785.GetMass, val785)

      if val792 and type(success34) == "number" and success34 > 0 then
        val791 = success34
      end

      local zero9 = Vector3.zero

      if rawget(val782, "useRealisticCurve") then
        local val793 = 0
        local shootCore = p491[5][2][p491[5][1]].ShootCore

        if type(shootCore) == "table"
          and type(rawget(shootCore, "calculateRealisticCurve")) == "function" then
          local val794, success35 = pcall(shootCore.calculateRealisticCurve, shootCore, val785)

          if val794 and type(success35) == "number" then
            val793 = success35
          end
        end

        if (Vector3.new(val785.Position.X, 0, val785.Position.Z)
            - Vector3.new(humanoidRootPart15.Position.X, 0, humanoidRootPart15.Position.Z)).Magnitude
          > 5 then
          val793 = 0
        end

        if val793 ~= 0 then
          zero9 = rightVector7 * (val787 * val793 / val791)
        end
      else
        local curveInt2 = val783.curveInt or 0

        if curveInt2 ~= 0 then
          curveInt2 = p491[8][2][p491[8][1]](character24) and -math.abs(curveInt2)
            or math.abs(curveInt2)

          zero9 = -lookVector5 * (val787 * curveInt2 / val791)
        end
      end

      local vector27 = Vector3.new(0, -p491[9][2][p491[9][1]](val785), 0)

      local val795, element86, val796, val797, val798, val799, val800 = p491[10][2][p491[10][1]](
        val785, character24, val784, val790, vector27, zero9
      )

      if not val796 and val797 > -math.huge then
        local element87 = val800(val798)
        local val801 = -element87.Y * p491[3][2][p491[3][1]].BOUNCE
        local vector28 = Vector3.new(element87.X, 0, element87.Z)
        local vector29 = Vector3.new(element86.X, val797 + 0.15, element86.Z)
        val795[#val795] = vector29
        local val802 = p491[9][2][p491[9][1]](val785)

        for i41 = 1, p491[3][2][p491[3][1]].BOUNCES do
          if val801 < 3 or vector28.Magnitude > 400 then
            break
          end

          local val803 = 2 * val801 / val802

          for i42 = 1, 3 do
            local val804 = val803 * (i42 / 3)

            local element88 = vector29 + vector28 * val804
              + Vector3.new(0, val801 * val804 - 0.5 * val802 * val804 * val804, 0)

            val795[#val795 + 1] = Vector3.new(element88.X, math.max(element88.Y, vector29.Y), element88.Z)
          end

          vector29 = Vector3.new(
            vector29.X + vector28.X * val803, vector29.Y, vector29.Z + vector28.Z * val803
          )

          val801 = val801 * p491[3][2][p491[3][1]].BOUNCE
          vector28 = vector28 * p491[3][2][p491[3][1]].BOUNCE_KEEP
        end

        if vector28.Magnitude > 2 then
          local val805 = p491[3][2][p491[3][1]].ROLL * 4
          local val806 = vector28.Magnitude / p491[3][2][p491[3][1]].DECEL / val805
          local total6, val807, val808 = 0, vector29, vector29

          for i43 = 1, val805 do
            local magnitude34 = vector28.Magnitude

            if magnitude34 < 2 or total6 > p491[3][2][p491[3][1]].ROLL_MAX then
              break
            end

            local val809 = -(vector28 / magnitude34) * p491[3][2][p491[3][1]].DECEL

            local vector30 = val807 + vector28 * val806 + val809 * (0.5 * val806 * val806)
            vector30 = Vector3.new(vector30.X, vector29.Y, vector30.Z)

            total6 = total6 + (vector30 - val807).Magnitude
            vector28, val807 = vector28 + val809 * val806, vector30

            if i43 % 4 == 0 or i43 == val805 then
              local element89 = val807 - val808
              local magnitude35 = element89.Magnitude

              if magnitude35 > 0.001 then
                local spherecast7 = p491[11][2][p491[11][1]]:Spherecast(
                  val808, val799, element89, p491[12][2][p491[12][1]]
                )

                if spherecast7 then
                  val795[#val795 + 1] = val808 + element89 * (spherecast7.Distance / magnitude35)
                  break
                end
              end

              val795[#val795 + 1] = val807
              val808 = val807
            end
          end
        end
      end

      if #val795 < 2 then
        longTracer.Hide()
        return
      end

      local bend2 = zero9 ~= Vector3.zero and p491[3][2][p491[3][1]].BEND
        or p491[3][2][p491[3][1]].FLAT

      longTracer.Draw(val795, bend2, bend2)
    end
  end, function(p492, p493)
    return function(p494)
      if not p494 then
        return nil
      end

      local val810 = p493[1][2][p493[1][1]][p494]

      if val810 ~= nil then
        return val810 or nil
      end

      local val811 = false
      local val812, val813 = p493[2][2][p493[2][1]](require, p494)

      if val812 and type(val813) == "table" and debug.getupvalue then
        val811 = p493[3][2][p493[3][1]](val813)
      end

      p493[1][2][p493[1][1]][p494] = val811
      return val811 or nil
    end
  end, function(p495, p496)
    return function(...)
      local hc2 = p495.gc[17362] or p495:hc(13657, 35572, 17362)
      local val814, val815, val816, val817

      while true do
        if hc2 >= 107 then
          val816, val815 = p495.c(...), {}
          p495.e(val815, 1, p495.d(val816))
          val814, val815, val816, hc2, val817 = p496[1][2][p496[1][1]], "#", p495.c(...), p495.gc[-29317] or p495:hc(26048, 56164, -29317), val815
        else
          val814 = p495.c(val814(val815, p495.d(val816)))
          return val817, p495.d(val814)
        end
      end
    end
  end, function(p497, p498, p499, p500)
    p497.gc[p500] = p497.Ab(p498, p499)
    return p497.gc[p500]
  end, function(p501, p502)
    return function(p503, p504, p505)
      local lookVector6 = p504.CFrame.LookVector
      lookVector6 = Vector3.new(lookVector6.X, 0, lookVector6.Z)
      lookVector6 = lookVector6.Magnitude > 0.001 and lookVector6.Unit or Vector3.new(0, 0, -1)

      local position14, feetX, feetY, feetZ, val818, val819

      if p505 == "feet" then
        position14 = p502[1][2][p502[1][1]](p503, p504, true) + Vector3.new(0, 0.6, 0)
        feetX, feetY, feetZ = p502[2][2][p502[2][1]].feetX, p502[2][2][p502[2][1]].feetY, p502[2][2][p502[2][1]].feetZ
      elseif p505 == "head" then
        val818 = true
        local head3 = p503:FindFirstChild("Head")
        position14 = head3 and head3.Position or p504.Position + Vector3.new(0, 1.5, 0)
        feetX, feetY, feetZ = p502[2][2][p502[2][1]].headX, p502[2][2][p502[2][1]].headY, p502[2][2][p502[2][1]].headZ
      elseif p505 == "gk" or p505 == "deflect" then
        position14 = p504.Position
        feetX, feetY, feetZ = p502[2][2][p502[2][1]][p505 .. "X"], p502[2][2][p502[2][1]][p505 .. "Y"], p502[2][2][p502[2][1]][p505 .. "Z"]
        local humanoid5 = p503:FindFirstChildOfClass("Humanoid")
        val819 = humanoid5 and humanoid5.HipHeight + p504.Size.Y * 0.5
      else
        position14 = p504.Position
        feetX = p502[2][2][p502[2][1]].sphR
        feetY, feetZ = feetX, feetX
      end

      if val818 then
        feetY = math.min(feetY, 2)
      end

      if val819 and val819 > feetY then
        feetY = val819
      end

      return position14, lookVector6, Vector3.new(-lookVector6.Z, 0, lookVector6.X), feetX, feetY, feetY, feetZ
    end
  end, }):zb({
  "u", "wb", "qa", "Qa", "fc", "L", "ab", "r", "e", "Fa", "kb", "f", "Ma", "yb", "fb", "hb", "ac", "_c", "jc", "Fb", "j", "pa", "S", "G", "tb", "Wa", "db", "A", "Ia", "v", "rb", "ic", "la", "dc", "_a", "mb", "ya", "ca", "N", "ma", "Wb", "va", "h", "hc", "La", "xa", "Ub", "Oa", "Y", "U", "Ja", "H", "bc", "pb", "Hb", "ib", "oa", "Ta", "Da", "kc", "_b", "Aa", "ec", "ua", "Na", "m", "Pa", "Vb", "B", "w", "xb", "Ua", "ha", "Eb", "i", "Xa", "gc", "P", "eb", "V", "l", "J", "ra", "Ga", "s", "Ib", "X", "lb", "lc", "Bb", "E", "b", "sa", "Gb", "na", "Ca", "Ya", "q", "qb", "ja", "O", "ob", "Ba", "cb", "jb", "F", "Cb", "t", "ta", "g", "n", "T", "D", "bb", "Ha", "fa", "x", "ka", "aa", "nb", "za", "M", "Va", "Q", "W", "da", "ga", "Db", "Ka", "Tb", "C", "gb", "ia", "o", "Xb", "z", "R", "ba", "y", "p", "wa", "vb", "Ab", "Ea", "k", "sb", "Yb", "K", "I", "cc", "Sa", "ub", "ea", "a", "Ra", }, "lc", ...)