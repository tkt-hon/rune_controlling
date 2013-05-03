local _G = getfenv(0)
local object = _G.object

runfile 'bots/lib/rune_controlling/utils/hero.lua'

local core, behaviorLib, tinsert = object.core, object.behaviorLib, _G.table.insert

local function RuneTakingUtility(botBrain)
  local teambot = core.teamBotBrain
  if Utils_RuneControlling_Hero.CanPickRune(teambot) then
    return 30
  end
  return 0
end

local function RuneTakingExecute(botBrain)
  local bActionTaken = false
  local unitSelf = botBrain.core.unitSelf
  local teambot = core.teamBotBrain
  local runeLocation = Utils_RuneControlling_Hero.GetRuneLocation(teambot)
  local nTargetDistanceSq = Vector3.Distance2DSq(unitSelf:GetPosition(), runeLocation)

  local nRange = 100
  if nTargetDistanceSq < (nRange * nRange) then
    local runeEntity = Utils_RuneControlling_Hero.GetRuneEntity(teambot)
    if runeEntity then
      bActionTaken = core.OrderTouch(botBrain, unitSelf, runeEntity)
    end
  else
    bActionTaken = core.OrderMoveToPosClamp(botBrain, unitSelf, runeLocation)
  end
  return bActionTaken
end

local RuneTakingBehavior = {}
RuneTakingBehavior["Utility"] = RuneTakingUtility
RuneTakingBehavior["Execute"] = RuneTakingExecute
RuneTakingBehavior["Name"] = "Taking rune"
tinsert(behaviorLib.tBehaviors, RuneTakingBehavior)
