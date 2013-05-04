local _G = getfenv(0)

local tinsert = _G.table.insert

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
    if not rune then
      runeData.runeTop = false
    end
  end
  if HoN.CanSeePosition(RUNE_BOTTOM) then
    local rune = GetRuneInSpot(RUNE_BOTTOM)
    if not rune then
      runeData.runeBot = false
    end
  end
end

local function CanPickRune(runeData)
  return runeData:IsRuneUp() and (runeData.runeTop or runeData.runeBot)
end

local function GetRuneLocation(runeData)
  local locations = {}
  if runeData.runeTop then
    tinsert(locations, RUNE_TOP)
  end
  if runeData.runeBot then
    tinsert(locations, RUNE_BOTTOM)
  end
  return locations
end

local function GetRuneEntity(runeData)
  local entities = {}
  if runeData.runeTop and HoN.CanSeePosition(RUNE_TOP) then
    tinsert(entities, GetRuneInSpot(RUNE_TOP))
  end
  if runeData.runeBot and HoN.CanSeePosition(RUNE_BOTTOM) then
    tinsert(entities, GetRuneInSpot(RUNE_BOTTOM))
  end
  return entities
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

local function Initialize(object)
  if not (object.data and object.data.rune) then
    object.data = object.data or {}
    local data = object.data
    data.rune = {}
    local runeData = data.rune
    DeclareFunctions(runeData)
    runeData:ResetRune()
  end
end
M.Initialize = Initialize

RuneControlling_Utils_Team = M
