'''
# Dofus Retro Client Loader

This document provides an overview of the Dofus Retro client loader project, instructions for getting started, and a guide to diagnosing and fixing a critical graphic sequence bug.

This project is an ActionScript 2.0-based modification for the Dofus Retro client, designed to be developed and compiled using Adobe Flash CS6.

## Loader Overview

The client loading sequence is initiated by the `loader.fla` file, which serves as the main entry point for the application. The core logic for the loader is managed by the `DofusLoader.as` class.

### File Breakdown

*   **`loader.fla`**: The main Adobe Flash project file. It contains the visual assets for the loader and the initial ActionScript code to start the loading process.
*   **`Visuales/frame_1/DoAction.as`**: This script is executed on the first frame of the `loader.fla` timeline. It makes a single call to `dofus.DofusLoader.main(this);`, passing the main timeline instance to the loader class.
*   **`src/dofus/DofusLoader.as`**: This is the primary class responsible for managing the asset loading process. It displays the loading animation, tracks progress, and initializes the main game client upon completion.
*   **`src/dofus/Electron.as`**: This class contains `ExternalInterface` calls to communicate with a host Electron application. This is used for features like custom chat and console windows that are rendered outside the Flash client itself. The loader bug can block these external UI elements from being displayed.

## Getting Started

### Prerequisites

*   **Adobe Flash CS6**: The project must be opened and compiled using this specific version of the Flash IDE.
*   **MTASC (Optional)**: The project can be compiled using the MTASC compiler for ActionScript 2.0 for a more streamlined build process.

### Building the Project

1.  Open the `loader.fla` file in Adobe Flash CS6.
2.  Go to **File > Publish Settings**.
3.  Ensure the **Flash (.swf)** option is checked.
4.  Click the **Publish** button to compile the project and generate the `loader.swf` file.

## Bug: Loader Fails to Hide

A critical bug exists where the loader interface does not hide after the loading process is complete. This results in the loader blocking all subsequent graphic windows and interfaces, preventing the user from interacting with the game.

### Diagnosis

The `DofusLoader` class manages the display of the loader `MovieClip`. The bug occurs because the loader's `_visible` property is not set to `false` after the main game core (`DofusCore`) has been initialized. The loader remains on top of the display stack, obscuring all other content.

### The Fix

To fix this, we need to explicitly hide the loader `MovieClip` once the loading is complete. The `DofusLoader.as` class can be modified to call a new public static function, `hide()`, which will be responsible for hiding the loader.

See the `bug_fix.as` file for the exact code changes required to resolve this issue.
'''