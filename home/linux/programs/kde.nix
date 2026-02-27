{ config, pkgs, lib, ... }:
{
  # KDE 全局快捷键配置
  # 模拟 niri 的快捷键体验，使用 KDE 原生功能
  xdg.configFile."kglobalshortcutsrc".text = ''
    [kwin]
    # Super+Q 关闭窗口（模拟 niri 的 Mod+Q）
    Window Close=Meta+Q,Alt+F4,Close Window

    # 窗口导航（模拟 niri 的 vim 风格）
    Switch Window Down=Meta+J,Meta+J,Switch to Window Below
    Switch Window Up=Meta+K,Meta+K,Switch to Window Above
    Switch Window Left=Meta+H,Meta+H,Switch to Window to the Left
    Switch Window Right=Meta+L,Meta+L,Switch to Window to the Right

    # 移动窗口
    Window Quick Tile Bottom=Meta+Ctrl+J,,Quick Tile Window to the Bottom
    Window Quick Tile Top=Meta+Ctrl+K,,Quick Tile Window to the Top
    Window Quick Tile Left=Meta+Ctrl+H,,Quick Tile Window to the Left
    Window Quick Tile Right=Meta+Ctrl+L,,Quick Tile Window to the Right

    # 最大化/全屏
    Window Maximize=Meta+F,Meta+F,Maximize Window
    Window Fullscreen=Meta+Shift+F,Meta+Shift+F,Make Window Fullscreen

    # 浮动切换
    Window On All Desktops=Meta+T,,Keep Window on All Desktops

    # 虚拟桌面切换（模拟 niri 工作区）
    Switch to Desktop 1=Meta+1,Meta+1,Switch to Desktop 1
    Switch to Desktop 2=Meta+2,Meta+2,Switch to Desktop 2
    Switch to Desktop 3=Meta+3,Meta+3,Switch to Desktop 3
    Switch to Desktop 4=Meta+4,Meta+4,Switch to Desktop 4
    Switch to Desktop 5=Meta+5,Meta+5,Switch to Desktop 5
    Switch to Desktop 6=Meta+6,Meta+6,Switch to Desktop 6
    Switch to Desktop 7=Meta+7,Meta+7,Switch to Desktop 7
    Switch to Desktop 8=Meta+8,Meta+8,Switch to Desktop 8
    Switch to Desktop 9=Meta+9,Meta+9,Switch to Desktop 9

    # 窗口移动到桌面
    Window to Desktop 1=Meta+Shift+1,,Window to Desktop 1
    Window to Desktop 2=Meta+Shift+2,,Window to Desktop 2
    Window to Desktop 3=Meta+Shift+3,,Window to Desktop 3
    Window to Desktop 4=Meta+Shift+4,,Window to Desktop 4
    Window to Desktop 5=Meta+Shift+5,,Window to Desktop 5
    Window to Desktop 6=Meta+Shift+6,,Window to Desktop 6
    Window to Desktop 7=Meta+Shift+7,,Window to Desktop 7
    Window to Desktop 8=Meta+Shift+8,,Window to Desktop 8
    Window to Desktop 9=Meta+Shift+9,,Window to Desktop 9

    # 上/下一个桌面
    Switch One Desktop Down=Meta+Page_Down,Meta+Page_Down,Switch One Desktop Down
    Switch One Desktop Up=Meta+Page_Up,Meta+Page_Up,Switch One Desktop Up
    Switch One Desktop Down=Meta+U,,Switch One Desktop Down
    Switch One Desktop Up=Meta+I,,Switch One Desktop Up

    # Overview (类似 niri 的 toggle-overview)
    Overview=Meta+Grave,Meta+W,Toggle Overview

    # 窗口大小调整
    Window Grow Horizontal=Meta+Equal,,Increase Window Width
    Window Shrink Horizontal=Meta+Minus,,Decrease Window Width
    Window Grow Vertical=Meta+Shift+Equal,,Increase Window Height
    Window Shrink Vertical=Meta+Shift+Minus,,Decrease Window Height

    [plasmashell]
    # Meta+Space 打开 KRunner (应用启动器)
    activate application launcher=Meta+Space,Meta,Activate Application Launcher

    [ksmserver]
    # 锁屏
    Lock Session=Ctrl+Alt+L,Meta+L,Lock Session
    # 会话菜单
    Log Out=Ctrl+Meta+Q,,Show Logout Screen

    [org.kde.krunner.desktop]
    # KRunner 也可以用 Meta+Space
    RunClipboard=Meta+V,,Run with Clipboard Content

    [klipper]
    # 剪贴板历史
    show_klipper_popup=Meta+Shift+V,,Show Klipper Popup
    clipboard_action=Meta+C,,Enable Clipboard Actions

    [org_kde_powerdevil]
    # 电源管理
    powerProfile=Meta+Shift+P,,Switch Power Profile

    [org.kde.spectacle.desktop]
    # 截图（模拟 niri）
    RectangularRegionScreenShot=Print,Meta+Shift+Print,Capture Rectangular Region
    FullScreenScreenShot=Ctrl+Print,,Capture Entire Desktop
    ActiveWindowScreenShot=Alt+Print,Meta+Print,Capture Active Window

    [kmix]
    # 音量控制（使用媒体键）
    increase_volume=Volume Up,,Increase Volume
    decrease_volume=Volume Down,,Decrease Volume
    mute=Volume Mute,,Mute
  '';

  # 自定义命令快捷键（用于启动程序）
  xdg.configFile."khotkeysrc".text = ''
    [Data]
    DataCount=4

    [Data_1]
    Comment=启动终端 (kitty)
    Enabled=true
    Name=Launch Terminal
    Type=SIMPLE_ACTION_DATA

    [Data_1Actions]
    ActionsCount=1

    [Data_1Actions0]
    CommandURL=kitty
    Type=COMMAND_URL

    [Data_1Conditions]
    ConditionsCount=0

    [Data_1Triggers]
    TriggersCount=1

    [Data_1Triggers0]
    Key=Meta+Return
    Type=SHORTCUT
    Uuid={00000001-0000-0000-0000-000000000001}

    [Data_2]
    Comment=启动浏览器 (Zen)
    Enabled=true
    Name=Launch Browser
    Type=SIMPLE_ACTION_DATA

    [Data_2Actions]
    ActionsCount=1

    [Data_2Actions0]
    CommandURL=zen
    Type=COMMAND_URL

    [Data_2Conditions]
    ConditionsCount=0

    [Data_2Triggers]
    TriggersCount=1

    [Data_2Triggers0]
    Key=Meta+B
    Type=SHORTCUT
    Uuid={00000002-0000-0000-0000-000000000002}

    [Data_3]
    Comment=启动系统监控 (btop)
    Enabled=true
    Name=Launch System Monitor
    Type=SIMPLE_ACTION_DATA

    [Data_3Actions]
    ActionsCount=1

    [Data_3Actions0]
    CommandURL=kitty -e btop
    Type=COMMAND_URL

    [Data_3Conditions]
    ConditionsCount=0

    [Data_3Triggers]
    TriggersCount=1

    [Data_3Triggers0]
    Key=Ctrl+Meta+Period
    Type=SHORTCUT
    Uuid={00000003-0000-0000-0000-000000000003}

    [Data_4]
    Comment=打开 Dolphin 文件管理器
    Enabled=true
    Name=Launch File Manager
    Type=SIMPLE_ACTION_DATA

    [Data_4Actions]
    ActionsCount=1

    [Data_4Actions0]
    CommandURL=dolphin
    Type=COMMAND_URL

    [Data_4Conditions]
    ConditionsCount=0

    [Data_4Triggers]
    TriggersCount=1

    [Data_4Triggers0]
    Key=Meta+E
    Type=SHORTCUT
    Uuid={00000004-0000-0000-0000-000000000004}

    [General]
    Id={KDE_SHORTCUTS_GENERAL}

    [Gestures]
    Disabled=true

    [Main]
    AlreadyImported=defaults
    Disabled=false
    Version=2
  '';

  # KRunner 配置 - 类似 noctalia launcher 的体验
  xdg.configFile."krunnerrc".text = ''
    [General]
    FreeFloating=true
    RetainPriorSearch=false

    [Plugins]
    appstreamEnabled=true
    applicationsEnabled=true
    calculatorEnabled=true
    desktopsessionsEnabled=true
    kaboraEnabled=false
    killEnabled=true
    kwinEnabled=true
    locationsEnabled=true
    plasma-searchEnabled=true
    recentdocumentsEnabled=true
    servicesEnabled=true
    shellEnabled=true
    unitconverterEnabled=true
    webshortcutsEnabled=true
    windowsEnabled=true

    [Plugins][Favorites]
    plugins=krunner_services,krunner_systemsettings,krunner_sessions,krunner_powerdevil,krunner_calculator
  '';

  # Klipper 剪贴板配置
  xdg.configFile."klipperrc".text = ''
    [General]
    IgnoreImages=false
    KeepClipboardContents=true
    MaxClipItems=50
    NoNullClipboard=true
    PopupInfoMessageShown=true
    Synchronize=false
  '';
}
