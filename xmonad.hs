    -- Base
import XMonad
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W
    -- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks, ToggleStruts(..))
    -- Layouts and modifiers
import XMonad.Layout.ResizableTile
import XMonad.Layout.LayoutModifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.Spacing
   -- Utilities
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.NamedScratchpad

myFont :: String
myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=9:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask

disp0 :: String
disp0 = "eDP-1"

disp1 :: String
disp1 = "DP1"

myTerminal :: String
myTerminal = "alacritty"

scriptPath :: String
scriptPath = "/home/marc/working/dotfiles/scripts/"

scrotPath :: String
scrotPath = "/home/marc/working/screenshots/screenshot.jpg"

myBrowser :: String
myBrowser = "qutebrowser "

myBorderWidth :: Dimension
myBorderWidth = 2           -- Sets border width for windows

myNormColor :: String
myNormColor   = "#222222"   -- Border color of normal windows

myFocusColor :: String
myFocusColor  = "#0087D7"   -- Border color of focused windows

myStartupHook :: X ()
myStartupHook = do
    spawnOnce "bash /home/marc/working/dotfiles/backgrounds/feh.sh &"
    spawnOnce "picom --backend glx &"
    spawnOnce "dunst &"
    spawnOnce "dropbox start &"
    spawnOnce "tmux new-session -d"
    spawnOnce "/usr/bin/emacs --daemon=0 &" --emacs daemon for default
    spawnOnce "xsetroot -cursor_name left_ptr" --set cursor shape
    spawnOnce "xset r rate 220 40" --keyboard speed
    -- spawnOnce "protonmail-bridge --noninteractive &" --protonmail-bridge for mu4e

--Layouts
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

tall     = renamed [Replace "T"]
           $ mySpacing 4
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "M"]
           $ Full

myLayoutHook = avoidStruts
             $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
             myDefaultLayout = withBorder myBorderWidth tall
                           ||| noBorders monocle

--Workspaces
myWorkspaces = ["  1  ", "  2  ", "  3  ", "  4  ", "  5  ", "  6  ", "  7  ", "  8  ", "  9  "]
myManageHook = composeAll
     [ className =? "zoom"                   --> doShift(myWorkspaces !! 6)
     , className =? "Slack"                  --> doShift(myWorkspaces !! 7)
     , className =? "firefox"                --> doShift(myWorkspaces !! 8)
     , className =? "vlc"                    --> doShift(myWorkspaces !! 8)
     ] <+> namedScratchpadManageHook myScratchpads

--Scratchpads
myScratchpads :: [NamedScratchpad]
myScratchpads = [ NS "terminalScratch" spawnTerm findTerm manageTerm
                , NS "ncspotScratch" spawnNcspot findNcspot manageNcspot
                , NS "ncpamixerScratch" spawnNcpamixer findNcpamixer manageNcpamixer
                , NS "emacsScratch" spawnEmacsClient findEmacsClient manageEmacsClient
                , NS "thunderScratch" spawnThunderScratch findThunderScratch manageThunderScratch]
    where
        spawnTerm  = myTerminal ++ " -t 'Terminal Scratchpad' -e tmux attach-session -t 0"
        findTerm   = title =? "Terminal Scratchpad"
        manageTerm = customFloating $ W.RationalRect 0.025 0.025 0.95 0.95

        spawnNcspot  = myTerminal ++ " -t 'ncspot Scratchpad' -e ncspot"
        findNcspot   = title =? "ncspot Scratchpad"
        manageNcspot = customFloating $ W.RationalRect 0.025 0.025 0.95 0.95

        spawnEmacsClient  = "emacsclient -s 0 -a='' --no-wait -c -F '(quote (name . \"emacs-scratch\"))'"
        findEmacsClient   = title =? "emacs-scratch"
        manageEmacsClient = customFloating $ W.RationalRect 0.025 0.025 0.95 0.96

        spawnNcpamixer  = myTerminal ++ " -t 'ncpamixer Scratchpad' -e ncpamixer"
        findNcpamixer   = title =? "ncpamixer Scratchpad"
        manageNcpamixer = customFloating $ W.RationalRect 0.025 0.025 0.95 0.95

        spawnThunderScratch  = "thunderbird"
        findThunderScratch   = className =? "thunderbird"
        manageThunderScratch = customFloating $ W.RationalRect 0.025 0.025 0.95 0.95

--Keybindings
myKeys :: [(String, X ())]
myKeys =
    -- Xmonad
        [ ("M-S-q", io exitSuccess)         -- Quit xmonad
    -- Applications
        , ("M-S-<Return>", spawn (myTerminal ++ " -e tmux attach-session -t 0"))
        , ("M-S-b", spawn (myBrowser))
        , ("M-p", spawn "rofi -show run")
        , ("M-S-p", spawn "rofi-pass")
        , ("M-S-c", spawn "/usr/bin/emacsclient -a='' --no-wait -c -s 0")
    -- Kill windows
        , ("M-S-x", kill)                 -- Kill the currently focused client
    -- Windows navigation
        , ("M-j", windows W.focusDown)    -- Move focus to the next window
        , ("M-k", windows W.focusUp)      -- Move focus to the prev window
        , ("M-S-m", windows W.swapMaster) -- Swap the focused window and the master window
    -- Layouts
        , ("M-<Space>", sendMessage NextLayout)      -- Switch to next layout
        , ("M-b", sendMessage ToggleStruts)          -- Toggles noborder
        , ("M-t", withFocused $ windows . W.sink)    -- Push floating window back to tile
    -- Window resizing
        , ("M-h", sendMessage Shrink)                -- Shrink horiz window width
        , ("M-l", sendMessage Expand)                -- Expand horiz window width
    -- Scratchpads
        , ("M-<Return>", namedScratchpadAction myScratchpads "terminalScratch")
        , ("M-m", namedScratchpadAction myScratchpads "ncspotScratch")
        , ("M-c", namedScratchpadAction myScratchpads "emacsScratch")
        , ("M-a", namedScratchpadAction myScratchpads "ncpamixerScratch")
        , ("M-e", namedScratchpadAction myScratchpads "thunderScratch")
    -- Multimedia Keys
        , ("M-s", spawn ("scrot " ++ scrotPath))
        , ("M-S-s", spawn ("scrot -s " ++ scrotPath))
        , ("<XF86AudioPlay>", spawn (scriptPath ++ "spotify play-pause"))
        , ("M-.", spawn (scriptPath ++ "spotify next")) -- >
        , ("M-,", spawn (scriptPath ++ "spotify previous")) -- <
        , ("S-<XF86AudioPlay>", spawn (scriptPath ++ "smart_vlc_control"))
        , ("<XF86AudioPrev>", spawn (scriptPath ++ "spotify previous"))
        , ("<XF86AudioNext>", spawn (scriptPath ++ "spotify next"))
        , ("<XF86AudioMute>", spawn (scriptPath ++ "volume mute"))
        , ("<XF86AudioLowerVolume>", spawn (scriptPath ++ "volume down"))
        , ("<XF86AudioRaiseVolume>", spawn (scriptPath ++ "volume up"))
        , ("<XF86MonBrightnessUp>", spawn (scriptPath ++ "brightness backlight up"))
        , ("<XF86MonBrightnessDown>", spawn (scriptPath ++ "brightness backlight down"))
        , ("M-<XF86MonBrightnessUp>", spawn (scriptPath ++ "brightness pixel " ++ disp0 ++ " up"))
        , ("M-<XF86MonBrightnessDown>", spawn (scriptPath ++ "brightness pixel " ++ disp0 ++" down"))
        , ("M-S-<XF86MonBrightnessUp>", spawn (scriptPath ++ "brightness pixel " ++ disp1 ++ " up"))
        , ("M-S-<XF86MonBrightnessDown>", spawn (scriptPath ++ "brightness pixel " ++ disp1 ++" down"))
        , ("M-<Up>", spawn (scriptPath ++ "brightness backlight up"))
        , ("M-<Down>", spawn (scriptPath ++ "brightness backlight down"))
        , ("M-S-<Up>", spawn (scriptPath ++ "brightness pixel " ++ disp0 ++ " up"))
        , ("M-S-<Down>", spawn (scriptPath ++ "brightness pixel " ++ disp0 ++ " down"))
        , ("M-C-<Up>", spawn (scriptPath ++ "brightness pixel " ++ disp1 ++ " up"))
        , ("M-C-<Down>", spawn (scriptPath ++ "brightness pixel " ++ disp1 ++ " down"))
        ]

main :: IO ()
main = do
    xmproc <- spawnPipe "xmobar -x 0 /home/marc/.config/xmobar/xmobarrc"
    xmonad $ docks $ def
        -- { manageHook         = myManageHook <+> manageDocks
        { manageHook         = myManageHook
        -- , handleEventHook    = docks
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = avoidStruts $ myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
        , logHook = dynamicLogWithPP $ xmobarPP
              { ppOutput = hPutStrLn xmproc
              , ppCurrent = xmobarColor "#0087D7" "" . wrap "[" "]"           -- Current workspace
              , ppVisible = xmobarColor "#0087D7" ""                          -- Visible but not current workspace
              , ppHidden = xmobarColor "#a4a4a4" "" . wrap "*" ""             -- Hidden workspaces
              , ppHiddenNoWindows = xmobarColor "#EEEEEE" ""                  -- Hidden workspaces (no windows)
              , ppTitle = xmobarColor "#0087D7" "" . shorten 60               -- Title of active window
              , ppSep =  "<fc=#666666> <fn=1>|</fn> </fc>"                    -- Separator character
              , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"            -- Urgent workspace
              , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]                    -- order of things in xmobar
              }
        } `additionalKeysP` myKeys
