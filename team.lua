local _G = getfenv(0)

local M = {}

local RUNE_MASK = 0x0000008 + 0x0000020
local INTERVAL = 120000
local RUNE_TOP = Vector3.Create(5824, 9728, -128)
local RUNE_BOTTOM = Vector3.Create(11136, 5376, -128)

local function ResetRune(runeData)
  if not runeData.timer or not (runeData.runeTop or runeData.runeBot) then
    local matchTime = HoN.GetMatchTime()
    local multiplier = 1
    local default_multiplier = math.floor( matchTime / INTERVAL )
    if not runeData.timer then
      if matchTime > 0 then
        multiplier = default_multiplier
      end
    else
      multiplier = default_multiplier + 1
    end
    runeData.timer = multiplier * INTERVAL + 1
    runeData.runeTop = true
    runeData.runeBot = true
  end
end

local function IsRuneUp(runeData)
  return HoN.GetMatchTime() >= runeData.timer
end

local function GetRuneInSpot(spot)
  local powerups = HoN.GetUnitsInRadius(spot, 100, RUNE_MASK)
  for _, rune in pairs(powerups) do
    return rune
  end
  return nil
end

local function AnalyzeRuneSpots(runeData)
  if HoN.CanSeePosition(RUNE_TOP) then
    local rune = GetRuneInSpot(RUNE_TOP)
    if rune then
      runeData.runeBot = false
    else
      runeData.runeTop = false
    end
  end
  if HoN.CanSeePosition(RUNE_BOTTOM) then
    local rune = GetRuneInSpot(RUNE_BOTTOM)
    if rune then
      runeData.runeTop = false
    else
      runeData.runeBot = false
    end
  end
end

local function CanPickRune(runeData)
  return runeData:IsRuneUp() and (runeData.runeTop or runeData.runeBot)
end

local function GetRuneLocation(runeData)
  if runeData.runeTop then
    return RUNE_TOP
  elseif runeData.runeBot then
    return RUNE_BOTTOM
  end
  return nil
end

local function GetRuneEntity(runeData)
  if runeData.runeTop and HoN.CanSeePosition(RUNE_TOP) then
    return GetRuneInSpot(RUNE_TOP)
  elseif runeData.runeBot and HoN.CanSeePosition(RUNE_BOTTOM) then
    return GetRuneInSpot(RUNE_BOTTOM)
  end
end

local function Locate(runeData)
  if not runeData:IsRuneUp() then
    return
  end
  runeData:AnalyzeRuneSpots()
  runeData:ResetRune()
end

local function DeclareFunctions(runeData)
  runeData.ResetRune = ResetRune
  runeData.MarkRuneSpots = MarkRuneSpots
  runeData.IsRuneUp = IsRuneUp
  runeData.AnalyzeRuneSpots = AnalyzeRuneSpots
  runeData.CanPickRune = CanPickRune
  runeData.GetRuneLocation = GetRuneLocation
  runeData.GetRuneEntity = GetRuneEntity
  runeData.Locate = Locate
end

local function Initialize(teambot)
  if not (teambot.data and teambot.data.rune) then
    teambot.data = teambot.data or {}
    teambot.data.rune = {}
    DeclareFunctions(teambot.data.rune)
    teambot.data.rune:ResetRune()
  end
end
M.Initialize = Initialize

Utils_RuneControlling_Team = M
