local _G = getfenv(0)

local M = {}

local function CanPickRune(teambot)
  return teambot.data and teambot.data.rune and teambot.data.rune:CanPickRune()
end
M.CanPickRune = CanPickRune

local function GetRuneLocation(teambot)
  return teambot.data and teambot.data.rune and teambot.data.rune:GetRuneLocation()
end
M.GetRuneLocation = GetRuneLocation

local function GetRuneEntity(teambot)
  return teambot.data and teambot.data.rune and teambot.data.rune:GetRuneEntity()
end
M.GetRuneEntity = GetRuneEntity

Utils_RuneControlling_Hero = M
