local _G = getfenv(0)

local M = {}

local function CanPickRune(object)
  return object.data and object.data.rune and object.data.rune:CanPickRune()
end
M.CanPickRune = CanPickRune

local function GetRuneLocation(object)
  return object.data and object.data.rune and object.data.rune:GetRuneLocation()
end
M.GetRuneLocation = GetRuneLocation

local function GetRuneEntity(object)
  return object.data and object.data.rune and object.data.rune:GetRuneEntity()
end
M.GetRuneEntity = GetRuneEntity

RuneControlling_Utils_Hero = M
