# Rune Controlling utility

This utility has two main points, locating rune and picking rune.

## Installing

Clone this repository under Hon/game/bots with name you want.

To use rune locator, make your teambot load ```Utils_RuneControlling_Team``` and rune Initialize-function in it by giving your teambot as a parameter.

    Utils_RuneControlling_Team.Initialize(object) -- object is the teambot object

To locate rune call Locate-function of rune data in onthink to update state of locator.

    object.data.rune:Locate() -- object is teambot object

To pick runes, make your hero as a rune picker by loading ```Utils_RuneControlling_Hero``` and checking the state with following methods:

    -- Check if rune is ready to pick:
    Utils_RuneControlling_Hero.IsRuneUp(teamBrain) -- teamBrain is teambot object

    -- Make your unit to pick rune:
    Utils_RuneControlling_Hero.PickRune(object, unit, teamBrain) -- object is hero bot object, unit is hero or other unit, teamBrain is teambot object
