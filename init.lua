local _G = getfenv(0)
local object = _G.object

runfile 'bots/lib/rune_controlling/utils/hero.lua'

local core, behaviorLib, tinsert = object.core, object.behaviorLib, _G.table.insert

local CanPickRuneFn = RuneControlling_Utils_Hero.CanPickRune
local GetRuneLocationFn = RuneControlling_Utils_Hero.GetRuneLocation
local GetRuneEntityFn = RuneControlling_Utils_Hero.GetRuneEntity

behaviorLib.RuneControlling = {}
local RuneControlling = behaviorLib.RuneControlling

local function GetRuneLocation(botBrain, locations)
  local unitSelf = botBrain.core.unitSelf
  local vecSelf = unitSelf:GetPosition()
  local vecTarget = nil
  for _, position in ipairs(locations) do
    if not vecTarget or Vector3.Distance2DSq(vecSelf, position) < Vector3.Distance2DSq(vecSelf, vecTarget) then
      vecTarget = position
    end
  end
  return vecTarget
end
RuneControlling.GetRuneLocation = GetRuneLocation

local function GetRuneEntity(vecSelf, entities)
  local target = nil
  for _, rune in ipairs(entities) do
    if not target or Vector3.Distance2DSq(vecSelf, rune:GetPosition()) < Vector3.Distance2DSq(vecSelf, target:GetPosition()) then
      target = rune
    end
  end
  return target
end

local function GetRuneAction(botBrain, unit, rune)
  return core.OrderTouch(botBrain, unit, rune)
end
RuneControlling.GetRuneAction = GetRuneAction

local function GetRunePicker(botBrain)
  return botBrain.core.unitSelf
end
RuneControlling.GetRunePicker = GetRunePicker

local function RuneTakingUtility(botBrain)
  local teambot = core.teamBotBrain
  if CanPickRuneFn(teambot) then
    return 30
  end
  return 0
end

local function RuneTakingExecute(botBrain)
  local bActionTaken = false
  local unitPicker = behaviorLib.RuneControlling.GetRunePicker(botBrain)
  local vecPicker = unitPicker:GetPosition()
  local teambot = core.teamBotBrain
  local runeLocation = behaviorLib.RuneControlling.GetRuneLocation(botBrain, GetRuneLocationFn(teambot))
  local nTargetDistanceSq = Vector3.Distance2DSq(vecPicker, runeLocation)

  local nRange = 100
  if nTargetDistanceSq < (nRange * nRange) then
    local runeEntity = GetRuneEntity(vecPicker, GetRuneEntityFn(teambot))
    if runeEntity then
      bActionTaken = behaviorLib.RuneControlling.GetRuneAction(botBrain, unitPicker, runeEntity)
    end
  else
    bActionTaken = core.OrderMoveToPosClamp(botBrain, unitPicker, runeLocation)
  end
  return bActionTaken
end

local RuneTakingBehavior = {}
RuneTakingBehavior["Utility"] = RuneTakingUtility
RuneTakingBehavior["Execute"] = RuneTakingExecute
RuneTakingBehavior["Name"] = "Taking rune"
behaviorLib.RuneTakingBehavior = RuneTakingBehavior
tinsert(behaviorLib.tBehaviors, RuneTakingBehavior)
