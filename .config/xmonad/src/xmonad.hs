{-# LANGUAGE ImportQualifiedPost #-}
{-# OPTIONS_GHC -Wno-incomplete-uni-patterns #-}
{-# OPTIONS_GHC -Wno-missing-signatures #-}

-- import DBus qualified as D
-- import DBus.Client qualified as D

import Control.Monad (liftM2)
import Data.Map qualified as M
import Graphics.X11.ExtraTypes.XF86
import XMonad
import XMonad.Actions.Navigation2D
import XMonad.Actions.SpawnOn
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.InsertPosition
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (doCenterFloat, doFullFloat, doLower, isDialog)
import XMonad.Hooks.SetWMName
import XMonad.Hooks.StatusBar
import XMonad.Hooks.TaffybarPagerHints (pagerHints)
import XMonad.Layout.Accordion
import XMonad.Layout.DecorationMadness
import XMonad.Layout.LayoutModifier (ModifiedLayout)
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.Renamed (Rename (Replace), renamed)
import XMonad.Layout.ResizableTile
import XMonad.Layout.SimpleFloat
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spacing
import XMonad.Layout.Tabbed
import XMonad.Prelude (forM_, join, on, sortBy)
import XMonad.Prompt
import XMonad.Prompt.FuzzyMatch (fuzzyMatch, fuzzySort)
import XMonad.StackSet qualified as W
import XMonad.Util.Loggers
import XMonad.Util.NamedWindows (getName)
import XMonad.Util.Run (safeSpawn)
import XMonad.Util.SpawnOnce (spawnOnOnce, spawnOnce)
import XMonad.Util.Themes

colorScheme = "nord"

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

colorTrayer :: String
colorTrayer = "--tint 0x2E3440"
terminalCommand :: String -> String
terminalCommand command = unwords [myTerminal, "--execute", command]

myStartupHook = do
    -- spawn "setxkbmap -option caps:escape" -- remap caps to escape
    spawn "xsetroot -cursor_name left_ptr" -- cursor active at boot
    spawn "nitrogen --restore" -- wallpaper
    spawnOnce "nm-applet"
    spawnOnce "xfce4-power-manager" -- idk
    spawnOnce "clipmenud" -- clipboard management through dmenu/rofi
    spawnOnce "blueberry-tray" -- bluetooth tray icon
    spawnOnce "picom --config ~/.config/xmonad/scripts/picom.conf" -- compositor
    spawnOnce "dunst" -- notification
    spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1" -- idk
    spawnOnce "xbanish -t 5 -s" -- hide cursor when typing and on inactivity
    spawnOnce "redshift-gtk" -- tint the screen red at night
    spawnOnce "~/.cargo/bin/kanata --cfg ~/.config/kanata/kanata-config.kbd" -- keyboard config
    spawn "sleep 2 && xset r rate 300 30" -- speed up keybaord input, idk why it need sleep but it does
    spawnOnOnce "10" "alacritty -e btm" -- "task manager"
    spawnOnce "llk" -- keylogger "logkeys"
    setWMName "LG3D" -- apparently to make Java GUI programs work

-- colors
normBord = "#4C566A"

focdBord = color15

-- focdBord = "#88C0D0"

-- mod4Mask= super key
-- mod1Mask= alt key
-- controlMask= ctrl key
-- shiftMask= shift key

myModifier :: KeyMask
myModifier = mod4Mask

myBorderWidth :: Dimension
myBorderWidth = 4

-- myWorkspaces    = ["\61612","\61899","\61947","\61635","\61502","\61501","\61705","\61564","\62150","\61872"]
myWorkspaces :: [String]
myWorkspaces = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

myTerminal :: String
myTerminal = "kitty"

myBaseConfig = desktopConfig

-- window manipulations
myManageHook =
    composeAll . concat $
        [ [className =? "filenames" --> insertPosition Below Older]
        , [title =? "Peek preview" --> insertPosition Below Older]
        , [isDialog --> insertPosition Above Newer]
        , --  TODO: for dialogs insert position above newer
          [className =? c --> doCenterFloat | c <- floatAndCenterClasses]
        , [className =? c --> doFullFloat | c <- floatAndFullScreenClasses]
        , [className =? c --> doFloat | c <- floatClasses]
        , [title =? t --> doFloat | t <- floatWithTitles]
        , [resource =? r --> doFloat | r <- floatWithResources]
        , [resource =? i --> doIgnore | i <- myIgnores]
        -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61612" | x <- my1Shifts]
        -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61899" | x <- my2Shifts]
        -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61947" | x <- my3Shifts]
        -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61635" | x <- my4Shifts]
        -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61502" | x <- my5Shifts]
        -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61501" | x <- my6Shifts]
        -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61705" | x <- my7Shifts]
        -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61564" | x <- my8Shifts]
        -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\62150" | x <- my9Shifts]
        -- , [(className =? x <||> title =? x <||> resource =? x) --> doShiftAndGo "\61872" | x <- my10Shifts]
        ]
  where
    -- doShiftAndGo = doF . liftM2 (.) W.greedyView W.shift
    floatAndCenterClasses = ["Arandr", "Arcolinux-calamares-tool.py", "Archlinux-tweak-tool.py", "Arcolinux-welcome-app.py", "Galculator", "Xfce4-terminal"]
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
    floatWithResources = []
    myIgnores = ["desktop_window", "xfce4-notifyd"]

myLayout =
    -- configurableNavigation noNavigateBorders .
    smartBorders
        . mkToggle1 NBFULL
        . avoidStruts
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
        , ((modifier, xK_r), spawn "kill -USR1 $(pgrep redshift-gtk)") -- toggle redshift
        , ((modifier, xK_v), spawn "pavucontrol")
        , ((modifier, xK_x), spawn "rofi -show p -modi \"p:$HOME/.local/bin/rofi-power-menu --choices=reboot/suspend/shutdown/logout --confirm=\" -matching normal -only-match")
        , --  p:rofi-power-menu
          ((modifier, xK_w), spawn "brave")
        , ((modifier, xK_b), spawn "xfce4-power-manager --customize")
        , ((modifier, xK_Escape), spawn "xkill")
        , ((modifier, xK_Return), spawn "cpulimit --limit=90 kitty")
        , ((modifier, xK_h), sendMessage Shrink)
        , ((modifier, xK_l), sendMessage Expand)
        , -- , ((modifier, xK_p), shellPrompt myXPConfig)
          ((modifier, xK_p), spawn "rofi -show drun")
        , -- SUPER + SHIFT KEYS

          ((modifier .|. shiftMask, xK_Return), spawn "thunar") -- file manager
        , ((modifier .|. shiftMask, xK_r), spawn "xmonad --recompile && xmonad --restart && notify-send restarted!")
        , -- CONTROL + ALT KEYS

          ((controlMask .|. mod1Mask, xK_o), spawn "$HOME/.config/xmonad/scripts/picom-toggle.sh") -- toggle picom
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
          ((0, xF86XK_Display), spawn "xinput $(xinput list-props 9 | rg 'Device Enabled' | cut -d':' -f2 | sd '\\s' '' | sd 1 disable | sd 0 enable) 9")
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
        , ((modifier, xK_m), spawn $ terminalCommand "btm")
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

myConfig =
    myBaseConfig
        { startupHook = myStartupHook
        , layoutHook = myLayout
        , manageHook = manageSpawn <+> myManageHook <+> manageHook myBaseConfig
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
        -- , logHook = eventLogHookForPolyBar
        }
  where
    eventLogHookForPolyBar = do
        winset <- gets windowset
        windowTitle <- maybe (return "") (fmap show . getName) . W.peek $ winset
        let currWs = W.currentTag winset
        let wss = map W.tag $ W.workspaces winset

        io $ appendFile "/tmp/.xmonad-title-log" (windowTitle ++ "\n")
        io $ appendFile "/tmp/.xmonad-workspace-log" (wsStr currWs wss ++ "\n")
      where
        fmt currWs ws
            | currWs == ws = "[" ++ ws ++ "]"
            | otherwise = " " ++ ws ++ " "
        wsStr currWs wss = join $ map (fmt currWs) $ sortBy (compare `on` (!! 0)) wss

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

with2DNavigation :: XConfig a -> XConfig a
with2DNavigation = withNavigation2DConfig def

main :: IO ()
main = do
    -- forM_ [".xmonad-workspace-log", ".xmonad-title-log"] $ \file -> safeSpawn "mkfifo" ["/tmp/" ++ file]
    xmonad
        . ewmhFullscreen
        . ewmh
        . pagerHints
        . with2DNavigation
        $ myConfig
