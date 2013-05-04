local _G = getfenv(0)
local teambot = _G.object

runfile 'bots/lib/rune_controlling/utils/team.lua'

RuneControlling_Utils_Team.Initialize(teambot)

local onthinkOld = teambot.onthink
local function onthinkOverride(object, tGameVariables)
  onthinkOld(object, tGameVariables)
  object.data.rune:Locate()
end
teambot.onthink = onthinkOverride
