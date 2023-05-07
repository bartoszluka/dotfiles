{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-incomplete-uni-patterns #-}
{-# OPTIONS_GHC -Wno-missing-signatures #-}

import Codec.Binary.UTF8.String qualified as UTF8
import Control.Monad (liftM2)
import DBus qualified as D
import DBus.Client qualified as D
import Data.Map qualified as M
import Data.Text qualified as T

import Graphics.X11.ExtraTypes.XF86
import XMonad
import XMonad.Actions.Navigation2D
import XMonad.Actions.SpawnOn
import XMonad.Actions.Submap (submap, visualSubmap)
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.Focus (focusLockOff, focusLockOn, keepFocus, manageFocus, new, switchFocus)
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (composeOne, doCenterFloat, doFullFloat, isDialog, isFullscreen, transience, (-?>))
import XMonad.Hooks.SetWMName
import XMonad.Hooks.StatusBar
import XMonad.Hooks.TaffybarPagerHints (pagerHints)
import XMonad.Hooks.UrgencyHook (FocusHook (FocusHook), RemindWhen (..), SuppressWhen (..), UrgencyConfig (..), withUrgencyHookC)
import XMonad.Layout.Accordion
import XMonad.Layout.DecorationMadness
import XMonad.Layout.LayoutModifier (ModifiedLayout)
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.Renamed (Rename (Replace), renamed)
import XMonad.Layout.ResizableTile
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spacing
import XMonad.Layout.Tabbed
import XMonad.Prompt
import XMonad.Prompt.FuzzyMatch (fuzzyMatch, fuzzySort)
import XMonad.StackSet qualified as W
import XMonad.Util.Loggers
import XMonad.Util.Run (safeRunInTerm)
import XMonad.Util.SpawnOnce (spawnOnOnce, spawnOnce)

colorBack = "#2E3440"
colorFore = "#D8DEE9"

color01 = "#3B4252"
color02 = "#BF616A"
color03 = "#A3BE8C"
color04 = "#EBCB8B"
color05 = "#81A1C1"
color06 = "#B48EAD"
color07 = "#88C0D0"
color08 = "#E5E9F0"
color09 = "#4C566A"
color10 = "#BF616A"
color11 = "#A3BE8C"
color12 = "#EBCB8B"
color13 = "#81A1C1"
color14 = "#B48EAD"
color15 = "#8FBCBB"
color16 = "#ECEFF4"

terminalCommand :: String -> String
terminalCommand command = unwords [myTerminal, "--execute", command]

myStartupHook = do
    -- spawn "setxkbmap -option caps:escape" -- remap caps to escape
    spawn "xsetroot -cursor_name left_ptr" -- cursor active at boot
    -- spawnStatusBar "~/.config/polybar/launch.sh"
    spawn "nitrogen --restore" -- wallpaper
    spawnOnce "nm-applet"
    spawnOnce "udiskie --tray" -- automount removable media
    spawnOnce "xfce4-power-manager" -- idk
    spawnOnce "clipmenud" -- clipboard management through dmenu/rofi
    spawnOnce "blueberry-tray" -- bluetooth tray icon
    spawnOnce "picom --experimental-backends" -- compositor
    spawnOnce "dunst" -- notification
    spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1" -- idk
    spawnOnce "xbanish -t 5 -s" -- hide cursor when typing and on inactivity
    spawnOnce "redshift-gtk" -- tint the screen red at night
    spawnOnce "~/.cargo/bin/kanata --cfg ~/.config/kanata/kanata-config.kbd" -- keyboard config
    spawnOnce "~/.config/xmonad/scripts/touch-screen disable"
    spawn "sleep 2 && xset r rate 300 30" -- speed up keybaord input, idk why it needs sleep but it does
    -- spawnOnOnce "10" "alacritty -e btm" -- "task manager"
    spawnOnOnce "10" "termite -e btm" -- "task manager"
    -- spawnOnOnce "10" "kitty -e btm" -- "task manager"
    -- spawnOn "10" $ terminalCommand "btm" -- "task manager"
    spawnOnce "llk" -- keylogger "logkeys"
    setWMName "LG3D" -- apparently to make Java GUI programs work

-- colors
normBord = "#4C566A"

focdBord = color14

-- focdBord = "#88C0D0"

-- mod4Mask= super key
-- mod1Mask= alt key
-- controlMask= ctrl key
-- shiftMask= shift key

myModifier :: KeyMask
myModifier = mod4Mask

myBorderWidth :: Dimension
myBorderWidth = 3

-- myWorkspaces    = ["\61612","\61899","\61947","\61635","\61502","\61501","\61705","\61564","\62150","\61872"]
myWorkspaces :: [String]
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

myTerminal :: String
myTerminal = "kitty"

myBaseConfig = desktopConfig

myFocusHook =
    composeOne
        [ new (className =? "kitty") -?> keepFocus
        , return True -?> switchFocus
        ]

-- window manipulations
myManageHook =
    composeOne
        -- use only the first mathing rule
        . concat
        $ [ [isDialog -?> insertPosition Above Newer]
          , [title =? "Peek preview" -?> insertPosition Below Older]
          , [transience]
          , [isFullscreen -?> doFullFloat]
          , [className =? c -?> doCenterFloat | c <- floatAndCenterClasses]
          , [className =? c -?> doFullFloat | c <- floatAndFullScreenClasses]
          , [className =? c -?> doFloat | c <- floatClasses]
          , [title =? t -?> doFloat | t <- floatWithTitles]
          , [resource =? i -?> doIgnore | i <- myIgnores]
          , [return True -?> insertPosition Below Newer]
          -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61612" | x <- my1Shifts]
          ]
  where
    -- doShiftAndGo = doF . liftM2 (.) W.greedyView W.shift
    floatAndCenterClasses =
        [ "Arandr"
        , "Arcolinux-calamares-tool.py"
        , "Archlinux-tweak-tool.py"
        , "Arcolinux-welcome-app.py"
        , "Galculator"
        , "Xfce4-terminal"
        , "Blueberry.py"
        , "Pavucontrol"
        ]
    floatAndFullScreenClasses = ["Archlinux-logout.py", "steamwebhelper"]
    floatWithTitles = ["Downloads", "Save As..."]
    floatClasses =
        [ "confirm"
        , "file_progress"
        , "dialog"
        , "download"
        , "error"
        , "Gimp"
        , "notification"
        , "pinentry-gtk-2"
        , "splash"
        , "toolbar"
        ]
    myIgnores = ["desktop_window", "xfce4-notifyd", "Dunst"]

myLayout =
    -- configurableNavigation noNavigateBorders .
    smartBorders
        . avoidStruts
        . mkToggle1 NBFULL
        $ (myTall ||| myMirrorTall ||| myTabbed ||| myFloat ||| myAccordion)
  where
    myTiled' =
        withName "Tall2" $
            tallDefaultResizable shrinkText myTheme
    myTall =
        withName "Tall"
            -- . addTabsAlways shrinkText myTheme
            . smartSpacing 5
            $ ResizableTall nmaster delta ratio []
    myMirrorTall = withName "Wide" $ Mirror myTall
    myTabbed = withName "Tabbed" $ tabbed shrinkText myTheme
    myTheme :: Theme
    myTheme =
        def
            { fontName = "xft:FiraCode Nerd Font Mono:size=13:antialias=true:hinting=true"
            , activeColor = color15
            , inactiveColor = colorBack
            , activeBorderColor = color15
            , inactiveBorderColor = colorBack
            , activeTextColor = colorBack
            , inactiveTextColor = color16
            , -- , decoWidth          = "" -- Maximum width of the decorations (if supported by the 'DecorationStyle')
              decoHeight = 30 -- Height of the decorations
              --    Refer to for a use "XMonad.Layout.ImageButtonDecoration"
              --    Inner @[Bool]@ is a row in a icon bitmap.
            }
    myAccordion = Accordion
    myFloat = simplestFloat

    nmaster = 1 -- Default number of windows in the master pane
    ratio = 3 / 5 -- Default proportion of screen occupied by master pane
    delta = 3 / 100 -- Percent of screen to increment by when resizing panes
    withName :: String -> l a -> ModifiedLayout Rename l a
    withName layout = renamed [Replace layout]

myMouseBindings (XConfig{XMonad.modMask = m}) =
    M.fromList
        [ -- mod-button1 (left), Set the window to floating mode and move by dragging
          ((m, 1), \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)
        , -- mod-button3 (right), Set the window to floating mode and resize by dragging
          ((m, 3), \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)
        ]

-- keys config

myKeys conf@(XConfig{XMonad.modMask = modifier}) =
    M.fromList $
        [ -- Move focus to the next window.
          ((modifier, xK_j), windows W.focusDown)
        , -- Move focus to the previous window.
          ((modifier, xK_k), windows W.focusUp)
        , -- Swap the focused window with the next window.
          ((modifier .|. shiftMask, xK_j), windows W.swapDown)
        , -- Swap the focused window with the previous window.
          ((modifier .|. shiftMask, xK_k), windows W.swapUp)
        , -- Directional navigation of windows
          ((modifier, xK_Right), windowGo R False)
        , ((modifier, xK_Left), windowGo L False)
        , ((modifier, xK_Up), windowGo U False)
        , ((modifier, xK_Down), windowGo D False)
        , ((modifier, xK_f), sendMessage $ Toggle NBFULL)
        , ((modifier, xK_q), kill)
        , ((modifier, xK_r), spawn "pkill -USR1 redshift-gtk") -- toggle redshift
        , ((modifier, xK_v), spawn "pavucontrol")
        , ((modifier, xK_i), spawn "networkmanager_dmenu")
        , ((modifier, xK_x), spawn "rofi -show p -modi \"p:$HOME/.local/bin/rofi-power-menu --choices=reboot/suspend/shutdown/logout --confirm=\" -matching normal -only-match")
        ,
            ( (modifier, xK_d) -- dunst
            , visualSubmap def . M.fromList $
                let lenient key desc action = [((0, key), (desc, spawn action)), ((modifier, key), (desc, spawn action))]
                 in concat
                        [ lenient xK_x "close all notifications" "dunstctl close-all"
                        , lenient xK_d "close all notifications" "dunstctl close-all"
                        , lenient xK_space "action" "dunstctl action"
                        , lenient xK_c "context" "dunstctl context"
                        ]
            )
        , ((modifier, xK_c), spawn "CM_LAUNCHER=rofi clipmenu -i")
        , ((modifier, xK_w), spawn "brave")
        , ((modifier, xK_b), spawn "xfce4-power-manager --customize")
        , ((modifier, xK_Escape), spawn "xkill")
        , ((modifier, xK_Return), spawn "cpulimit --limit=90 kitty")
        , ((modifier, xK_h), sendMessage Shrink)
        , ((modifier, xK_l), sendMessage Expand)
        , ((modifier, xK_y), spawn "polybar-msg cmd toggle")
        , ((modifier, xK_g), sendMessage ToggleStruts)
        , ((modifier, xK_p), spawn "rofi -show run")
        , -- SUPER + SHIFT KEYS

          ((modifier .|. shiftMask, xK_Return), spawn "thunar") -- file manager
        , ((modifier .|. shiftMask, xK_r), spawn "xmonad --recompile && xmonad --restart && notify-send --app-name=xmonad restarted!")
        , -- CONTROL + ALT KEYS

          ((controlMask .|. mod1Mask, xK_o), spawn "~/.config/picom/toggle-picom.fish") -- toggle picom
        , ((0, xK_Print), spawn "flameshot gui")
        , -- Mute microphone
          ((0, xF86XK_AudioMicMute), spawn "amixer -q set Capture toggle")
        , -- Mute volume
          ((0, xF86XK_AudioMute), spawn "amixer -q set Master toggle")
        , -- Decrease volume
          ((0, xF86XK_AudioLowerVolume), spawn "amixer -q set Master 5%-")
        , -- Increase volume
          ((0, xF86XK_AudioRaiseVolume), spawn "amixer -q set Master 5%+")
        , -- Increase brightness
          ((0, xF86XK_MonBrightnessUp), spawn "xbacklight -perceived -inc 3")
        , -- Decrease brightness
          ((0, xF86XK_MonBrightnessDown), spawn "xbacklight -perceived -dec 3")
        , -- toggle touch screen
          ((0, xF86XK_Display), spawn "~/.config/xmonad/scripts/touch-screen toggle")
        , -- Increase brightness
          -- , ((0, xF86XK_MonBrightnessUp),  spawn $ "brightnessctl s 5%+")

          -- Decrease brightness
          -- , ((0, xF86XK_MonBrightnessDown), spawn $ "brightnessctl s 5%-")

          --  , ((0, xF86XK_AudioPlay), spawn $ "mpc toggle")
          --  , ((0, xF86XK_AudioNext), spawn $ "mpc next")
          --  , ((0, xF86XK_AudioPrev), spawn $ "mpc prev")
          --  , ((0, xF86XK_AudioStop), spawn $ "mpc stop")

          --  XMONAD LAYOUT KEYS

          -- Cycle through the available layouts.
          ((modifier, xK_space), sendMessage NextLayout)
        , --  Reset the layouts on the current workspace to default.
          ((modifier .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)
        , -- Push window back into tiling.
          ((modifier, xK_t), withFocused $ windows . W.sink)
        , ((modifier, xK_m), windows W.focusMaster)
        , ((modifier .|. shiftMask, xK_m), windows W.swapMaster)
        ]
            ++
            -- mod-[1..9, 0] Switch to workspace N
            -- mod-shift-[1..9, 0] Move client to workspace N
            [ ((modifier .|. m, key), windows $ f workspace)
            | (workspace, key) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0])
            , (f, m) <-
                [ (W.greedyView, 0) -- move focus to the given workspace
                , let and' = liftM2 (.)
                   in (W.greedyView `and'` W.shift, shiftMask) -- focus the given workspace and move focused window there
                ]
            ]

myConfig bus =
    myBaseConfig
        { startupHook = myStartupHook
        , layoutHook = myLayout
        , manageHook = manageFocus myFocusHook <> manageSpawn <> myManageHook <> manageHook myBaseConfig
        , modMask = myModifier
        , borderWidth = myBorderWidth
        , handleEventHook = handleEventHook myBaseConfig
        , focusFollowsMouse = True
        , workspaces = myWorkspaces
        , focusedBorderColor = focdBord
        , normalBorderColor = normBord
        , keys = myKeys
        , mouseBindings = myMouseBindings
        , terminal = myTerminal
        , logHook = dynamicLogWithPP (myLogHook bus)
        }
  where
    myLogHook :: D.Client -> PP
    myLogHook dbus =
        def
            { ppOutput = dbusOutput dbus
            , ppSep = " : "
            }

    -- Emit a DBus signal on log updates
    dbusOutput :: D.Client -> String -> IO ()
    dbusOutput dbus str = do
        let signal =
                (D.signal objectPath interfaceName memberName)
                    { D.signalBody = [D.toVariant $ T.unpack $ (!! 1) $ T.splitOn " : " $ T.pack $ UTF8.decodeString str]
                    }
        D.emit dbus signal
      where
        objectPath = D.objectPath_ "/org/xmonad/Log"
        interfaceName = D.interfaceName_ "org.xmonad.Log"
        memberName = D.memberName_ "Update"

myXmobarPP :: PP
myXmobarPP =
    def
        { ppSep = magenta " • "
        , ppTitleSanitize = xmobarStrip
        , ppCurrent = lightBlue . wrap " " "" . xmobarBorder "Top" "#5E81AC" 2
        , ppHidden = blue . wrap " " ""
        , ppHiddenNoWindows = lowWhite . wrap " " ""
        , ppUrgent = red . wrap (yellow "!") (yellow "!")
        , ppOrder = \[workspaceNames, layout, _currentWindow, allWindows] -> [workspaceNames, layout, allWindows]
        , ppExtras = [logTitles formatFocused formatUnfocused]
        }
  where
    formatFocused = wrap "[" "]" . lightBlue . ppWindow
    formatUnfocused = wrap "[" "]" . lowWhite . const " "

    -- Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta = xmobarColor "#B48EAD" ""
    blue = xmobarColor "#5E81AC" ""
    white = xmobarColor "#ECEFF4" ""
    lightBlue = xmobarColor "#88C0D0" ""
    yellow = xmobarColor "#EBCB8B" ""
    red = xmobarColor "#BF616A" ""
    lowWhite = xmobarColor "#D8DEE9" ""

myXPConfig =
    def
        { font = "xft:Roboto Regular:size=16"
        , bgColor = "#2E3440"
        , fgColor = "#D8DEE9"
        , bgHLight = "#88C0D0"
        , fgHLight = "#3B4252"
        , borderColor = "#535974"
        , position = CenteredAt{xpCenterY = 0.3, xpWidth = 0.5}
        , height = 40
        , historySize = 256
        , historyFilter = id
        , alwaysHighlight = True
        , promptBorderWidth = 0
        , searchPredicate = fuzzyMatch
        , sorter = fuzzySort
        }

main :: IO ()
main = do
    dbus <- D.connectSession -- Request access to the DBus name
    _ <-
        D.requestName
            dbus
            (D.busName_ "org.xmonad.Log")
            [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
    xmonad
        . ewmhFullscreen
        . ewmh
        . docks
        . withUrgencyHookC FocusHook UrgencyConfig{suppressWhen = Focused, remindWhen = Dont}
        . withSB polybar
        . pagerHints
        . withNavigation2DConfig myNavigation2DConfig
        $ myConfig dbus
  where
    polybar = statusBarGeneric "~/.config/polybar/launch.sh" mempty
    myNavigation2DConfig =
        def
            { layoutNavigation =
                [ ("Full", centerNavigation)
                , ("Tabbed", centerNavigation)
                ]
            , unmappedWindowRect =
                [ ("Full", fullScreenRect)
                , ("Tabbed", singleWindowRect)
                ]
            }
