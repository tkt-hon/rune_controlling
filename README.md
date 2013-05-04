# Rune Controlling utility

This utility has two main points, locating rune and picking rune.

## Installing

Clone this repository under Hon/game/bots/lib with name ```rune_controlling```.

To use rune locator, make your teambot run file ```bots/lib/rune_controlling/init_team.lua```, which initializes the rune controlling for the team.

    runfile 'bots/lib/rune_controlling/init_team.lua'

To pick runes, make your hero as a rune picker by running file ```bots/lib/rune_controlling/init.lua```.

    runfile 'bots/lib/rune_controlling/init_team.lua'

## Customizing

To customize rune picking, you can edit following functions:

    Vector3 behaviorLib.RuneControlling.GetRuneLocation(botBrain, tLocations)
    boolean behaviorLib.RuneControlling.GetRuneAction(botBrain, unitPicker, powerupRune)
    unit    behaviorLib.RuneControlling.GetRunePicker(botBrain)

You can also use the utils without package behavior.
