# Tetrakeys

Reclaim full use of your keyboard by re-purposing the <kbd>CapsLock</kbd> (or any key) into the <kbd>TetraKey!</kbd> modifier.

---

## Introduction

## Prerequisites

1. This project is for Windows only. MacOS support is in the works, but if you want something similar, look into a DIY approach with Karabiner Elements.
2. Administrative privileges is NOT REQUIRED.
1. [AutoHotkey 2.x](https://github.com/AutoHotkey/AutoHotkey/releases/tag/latest)
2. Recommended (but optional): [Visual Studio Code](https://code.visualstudio.com/Download)

> [!NOTE] Visual Studio Code is only recommended if you want to review or customize the behavior. 


## Installation (TODO: In progress)

Open a Command Prompt, or a PowerShell window, and run the following command:
```pwsh copy
Not working yet: Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://thisproject/install.ps1'))
```


1. Clone this repo (or download and extract the contents of the project from the [Releases](https://github.com/volatile-torpedo/Tetrakeys/tags/latest) page) into a target directory of your choice, but preferrably somewhere in your user profile so you can easily make your customizations. 
2. Run the `setup.ps1` file. This will install AutoHotkey into the extracted directory if it can't be detected. This will then launch Tetrakeys

> Due to a Windows limitation, shortcut icons won't display correctly if the folder containing `Tetrakeys.ahk` is not in the %SYSTEMDRIVE% (typically `C:\`). It's strictly a cosmetic issue and does not introduce any functional issues.

---

# FAQ

**Why don't you compile the AHK files into EXEs?**
While compiling them into EXEs is a viable option, all it really does is lock the runtimes into a specific version of the AutoHotkey libraries and icons. It doesn't necessarily reduce resource consumption in a significant way, and it prevents users from experiencing the _joys_ of customizing the experince on their own, discovering other ways to optimize their workflows and even get a chance to interact with the rest of the AutoHotkey community.

**I don't know how to write AHK files, nor am I interested in customizing this inline.**
I totally understand. I started out in the same situation too. In a future release, the customizations are going to be contained within a configuration file, and then possibly a GUI-based configuration system. Stay tuned.

---
