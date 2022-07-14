# Sato's Established Company Origin

A mod for the game Battle Brothers ([Steam](https://store.steampowered.com/app/365360/Battle_Brothers/), [GOG](https://www.gog.com/game/battle_brothers), [Developer Site](http://battlebrothersgame.com/buy-battle-brothers/)).

## Table of contents

-   [Features](#features)
-   [Requirements](#requirements)
-   [Installation](#installation)
-   [Uninstallation](#uninstallation)
-   [Compatibility](#compatibility)
-   [Building](#building)

## Features

Adds a new starting scenario, the Established Company. There are no specific advantages or disadvantages to the Established Company; instead, the origin is designed to give you a randomized start with some of the company's history already written.

Maybe you hired a Raider and he lost his nose in the Battle of Greenfield, on that fateful day you betrayed the noble house that hired you. Maybe the village of Erszfels is fond of you for dealing with that strange curse, but the City State of Al-Hazred still holds a grudge against you for the time one of your men made a pass at the vizier's concubine. Maybe Torkel, the Bowyer whose been with you for some time, is in a good mood because he recently learned how to better save for retirement.

The Established Company starts with three random brothers of varying background and skill, randomized relations with the game's various factions, and a randomized smattering of starting food items, renown, reputation, crowns, and so on.

## Requirements

1) [Modding Script Hooks](https://www.nexusmods.com/battlebrothers/mods/42) (v19 or later)

## Installation

1) Download the mod from the [releases page](https://github.com/jcsato/sato_established_company_mod/releases/latest)
2) Without extracting, put the `sato_established_company_origin_*.zip` file in your game's data directory
    1) For Steam installations, this is typically: `C:\Program Files (x86)\Steam\steamapps\common\Battle Brothers\data`
    2) For GOG installations, this is typically: `C:\Program Files (x86)\GOG Galaxy\Games\Battle Brothers\data`

## Uninstallation

1) Remove the relevant `sato_established_company_origin_*.zip` file from your game's data directory

## Compatibility

This should be save game safe. In other words, if you save another campaign with a different origin while this mod is active, you can remove the mod without corrupting that save.

### Building

To build, run the appropriate `build.bat` script. This will automatically compile and zip up the mod and put it in the `dist/` directory, as well as print out compile errors if there are any. The zip behavior requires Powershell / .NET to work - no reason you couldn't sub in 7-zip or another compression utility if you know how, though.

Note that the build script references the modkit directory, so you'll need to edit it to point to that before you can use it. In general, the modkit doesn't play super nicely with spaces in path names, and I'm anything but a batch expert - if you run into issues, try to run things from a directory that doesn't include spaces in its path.

After building, you can easily install the mod with the appropriate `install.bat` script. This will take any existing versions of the mod already in your data directory, append a timestamp to the filename, and move them to an `old_versions/` directory in the mod folder; then it will take the built `.zip` in `dist/` and move it to the data directory.

Note that the install script references your data directory, so you'll need to edit it to point to that before you can use it.
