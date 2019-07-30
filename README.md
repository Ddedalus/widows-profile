# windows-profile
A bunch of tools that allow you to automatically setup your personal development environment on a managed Windows 10 workstation.

## Problem
Many workplaces, including my university, let users have Windows accounts within their domain and use those to login onto public workstations available around buildings. This system, combined with some sort of cloud file storage is great as you can use any workstation at any time. Windows account allows most of the settings to be carried over and applied during the logon proces.

Unfortunately, Windows is not clever enough to store status of your various applications, in particular, it discards the contents of AppData, which is where most user-installed apps store their files. As a result, every time you login onto a new workstation, your browser greets you as if you've just powered up an electronic device for the first time in your life...

## Solution
The tool in this repository allows user to specify in a josn config file a list of directories from the local machine to copy to a storage device before logoff in order to restore them on a fresh workstation. It also contains sample additional PowerShell and batch scripts showing how to set up additional tasks, like reinstalling certain apps or extensions.

## File copy
The main part of user interface is a `.json` file specifying which files to copy and where. A sample file could look like:
```json
[
    {
        "local": "C:\\path\\to\\local\\storage",
        "store": "H:\\path\\to\\backup\\storage",
        "exclude_file": [
            "large_cache_file"
        ],
        "exclude_dir": [
            "cache_directory"
        ],
        "dirs": [
            {
                "path": "program_directory",
                "exclude_dir": [
                    "program_specific_cache"
                ],
            }
            {
                "path": "another_program_directory"
            },
        ]
    }
]
```
Each element of the outermost list specifies a copy task that will be performed by the `robocopy` utility available on Windows. There are several layers of options to be specified:
  - `local` is an absolute path to a place where programs tend to store their data, like the AppData directory.
  - `store` is a corresponding location on a save, persistent storage, like a network drive of your pendrive. Data from local will be copied over there.
  - `exclude_file` tells `robocopy` about any files that should not be copied over. This may be because they are large or unnecessary. You can use wildcars like `*.log` or `cache*`; optional.
  - `exclude_dir` specifies whole directories that would not get copied over. Wildcars available; optional.
  - `dirs` is a list of paths relative to `local`, usually providing directories of specific programs you'd like to backup; compulsory. Each element of the list can contain the following fields:
      - `path` relative to `local`; compulsory.
      - `exclude_dir` as the global one, but will only be applied while copying this `path`; opitonal.
      - `exclude_file` as above; opitonal.
      - `overwrite` (boolean, default: false). If set to true, target coresponding to this path will be removed before copy. If false, just the new and changed files are copied over; optional.

## Running the job
To load or store your data, use the PowerShell script `copy_from_list.ps1`. You can see how to run it by inspecting `load.bat` or `store.bat`.
The script takes two parameters:
    - `path` specifying the location of the `.json` file described above, defaults to the example file from the repository.
    - `-Store` or `-Load`:
        - if `Store` is passed, files from `local` are copied over to `store`, respecting the exclude rules specified.
        - if `Load` is passed, files are copied back from `store` to `local`; no excludes are applied here (as you only stored the files you wanted in the first place, this is not an issue, right?)

## Creating shortcuts
You can easily run the `.bat` scripts on almost any computer by double-clicking them. Even better, you can create shortcuts to them and click those!

## Additional tasks
The file `load.bat` contains an example of running an additional program (here a GitKraken installer) and invoking another PowerShell script (to reinstall certain VS Code extensions). You may modify these to run extra jobs while loading your data. It is often faster to install a program from scratch and copy its config files than to copy the entire directory where the program got installed.

## Requirements
These scripts depend on a limited set of permissions that your account must have and on some Windows 10 features:
    - read&write access to both `local` and `store` directories.
    - executing `.bat` files.
    - executing PowerShell scripts (`.ps1`) with policy bypass (standard trick recommended by Micro$oft).
    - PowerShell 5.0 or newer
    - a text editor to modify the `.json` file

