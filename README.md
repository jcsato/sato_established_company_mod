### Building:

To build, run `build.bat` from the root directory. This will also zip the resulting mod files and place them in the `dist` directory.

Note that this references the modkit directory, so if that changes the batch script will need to change to match.
Additionally, note that this will fail on the cleanup step(s) if run from a path that has spaces in it.


### Installing

To install, run `install.bat` from the root directory. This will find any versions of the mod currently in the game's data directory and save them, with a timestamped filename, in the `old_versions` directory. It will also take the mod `.zip` from the `dist` directory (if any - see the above step on building) and place it in the game's data folder (again, this path is hardcoded).


### Distribution

Move the `sato_established_company_origin.zip` file to a new folder marked with today's date (e.g. `11-04-2019`). Move that folder inside the relevant mod distribution subfolder in the overall `DISTRIBUTION` directory.