local _G = getfenv(0)

local M = {}

local traveling = false

local function IsRuneUp(teambot)
  return teambot.data.rune and teambot.data.rune:CanPickRune()
end
M.IsRuneUp = IsRuneUp

local function PickRune(bot, unit, teambot, action, distance)
  action = action or function(rune)
    bot:OrderEntity(unit, "Touch", rune)
  end
  distance = distance or 100
  local runeData = teambot.data.rune
  local runeLocation = runeData:GetRuneLocation()
  if traveling then
    local beha = unit:GetBehavior()
    if beha and Vector3.Distance2D(beha:GetGoalPosition(), runeLocation) > 200 then
      bot:OrderPosition(unit, "Move", runeLocation)
      return
    end
    if Vector3.Distance2D(unit:GetPosition(), runeLocation) <= distance then
      action(runeData:GetRuneEntity())
      traveling = false
    end
  else
    bot:OrderPosition(unit, "Move", runeLocation)
    traveling = true
  end
end
M.PickRune = PickRune

Utils_RuneControlling_Hero = M
