# Tetrakeys

Improve your productivity with a library of keyboard shortcuts, auto-replacement of text, and more. Windows Only.
image of the Tetrakeys logo

## Features

1. **Keyboard Shortcuts**: A library of keyboard shortcuts that can be customized to your liking.
2. **Text Expansion**: Automatically replace text with other text.
3. **Customizable**: Customize the behavior of Tetrakeys to your liking.
4. **Hyperkey Chords**: Use the <kbd>CapsLock</kbd> key as a modifier key for your keyboard shortcuts.
5. **Extensible**: A library of extensions will be released to enhance your workflow.

Tetrakeys is a little more than just a simple AutoHotkey script. It's the beginning of an extensible platform that allows you to
customize your workflow. A library of extensions will be released and they may have their own release schedule. This ensures that
the project can continually release without affecting each other.

> **BONUS**
> This project is open-source, and it complements other free projects like Microsoft PowerToys, EpicPen, and Snipaste. It's a great way to enhance your productivity without having to spend a lot of money and resources.

## Video Demonstration

[![Tetrakeys Video Demonstration](https://img.youtube.com/vi/1Q1J9Q1Q1Q1/0.jpg)](https://www.youtube.com/watch?v=1Q1J9Q1Q1Q1)

## Prerequisites

1. This project is for Windows only. MacOS support is in the works, but if you want something similar, look into a DIY approach with Karabiner Elements or Raycast.
1. Administrative privileges on your Windows system is NOT REQUIRED.
1. [AutoHotkey 2.x](https://github.com/AutoHotkey/AutoHotkey/releases/tag/latest)
1. Recommended (but optional): [Visual Studio Code](https://code.visualstudio.com/Download)

> [!NOTE] Visual Studio Code is only recommended if you want to review or customize the behavior.

## Installation (TODO: In progress)

Open a Command Prompt, or a PowerShell window, and run the following command:

```pwsh copy
Not working yet: Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://thisproject/install.ps1'))
```

1. Clone this repo (or download and extract the contents of the project from the [Releases](https://github.com/volatile-torpedo/Tetrakeys/tags/latest) page) into a target directory of your choice, but preferrably somewhere in your user profile so you can easily make your customizations.<br><br>

2. Run the `setup.ps1` file. This will install AutoHotkey into the extracted directory if it can't be detected. This will then launch Tetrakeys

> Due to a Windows limitation, shortcut icons won't display correctly if the folder containing `Tetrakeys.ahk` is not in the %SYSTEMDRIVE% (typically `C:\`). It's strictly a cosmetic issue and does not introduce any functional issues.

## Acknowledgements

| Resources | Credit To | Comments |
| :----------- | :----------- | :----------- |
| Icons | [Icons8](https://icons8.com) | Right Content |
| [WiseGui()](https://www.autohotkey.com/boards/viewtopic.php?f=83&t=94044) | [SKAN](https://www.autohotkey.com/boards/memberlist.php?mode=viewprofile&u=54) | Toast-like notifications on steroids |

## License

TODO: GNU General Public License v2.0 or the alternatives to the MIT License

## FAQ

**Why don't you compile the AHK files into EXEs?**

> While compiling them into EXEs is a viable option, all it really does is lock the runtimes into a specific version of the AutoHotkey libraries and icons. It doesn't necessarily reduce resource consumption in a significant way, and it prevents users from experiencing the _joys_ of customizing the experince on their own, discovering other ways to optimize their workflows and even get a chance to interact with the rest of the AutoHotkey community.

**I don't know how to write AHK files, nor am I interested in customizing this inline.**
> I totally understand. I started out in the same situation too. In a future release, the customizations are going to be contained within a configuration file, and then possibly a GUI-based configuration system. It will depend on this guy's availability to stay on top of his meds, and possibly through other contributors. Stay tuned.

**I have a feature request.**

> Sure thing. You can do one of two things:
>
> 1. Open an issue on this repository.
> 2. Fork this repository, make the changes, and submit a pull request.

**I have a question that's not answered here.**

> Feel free to open an issue on this repository. I'll do my best to answer it. I'm hoping to get some contributors added to this project.
