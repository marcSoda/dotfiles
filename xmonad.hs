    -- Base
import XMonad
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W
    -- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
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
disp0 = "eDP1"

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
    spawnOnce "feh --no-fehbg --bg-scale '/home/marc/working/save/backgrounds/melty.jpg' &"
    spawnOnce "compton --fade-in-step=1 --fade-out-step=1 --fade-delta=0 &" --fade workaround because --no-fading-openclose was not working
    spawnOnce "dunst &"
    spawnOnce "dropbox start &"
    spawnOnce "protonmail-bridge --noninteractive &" --protonmail-bridge for mu4e
    spawnOnce "/usr/bin/emacs --daemon=default &" -- emacs daemon for default

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
     -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
     [ className =? "zoom"                   --> doShift(myWorkspaces !! 6) --this might not work...
     , className =? "Slack"                  --> doShift(myWorkspaces !! 7)
     , className =? "Google-chrome"   --> doShift(myWorkspaces !! 8)
     , className =? "vlc"                    --> doShift(myWorkspaces !! 8)]

--Scratchpads
myScratchpads :: [NamedScratchpad]
myScratchpads = [ NS "terminalScratch" spawnTerm findTerm manageTerm
                , NS "ncspotScratch" spawnNcspot findNcspot manageNcspot]
    where
        spawnTerm  = myTerminal ++ " -t 'Terminal Scratchpad'"
        findTerm   = title =? "Terminal Scratchpad"
        manageTerm = customFloating $ W.RationalRect 0.025 0.025 0.95 0.95

        spawnNcspot  = myTerminal ++ " -t 'ncspot Scratchpad' -e ncspot"
        findNcspot   = title =? "ncspot Scratchpad"
        manageNcspot = customFloating $ W.RationalRect 0.025 0.025 0.95 0.95

--Keybindings
myKeys :: [(String, X ())]
myKeys =
    -- Xmonad
        [ ("M-S-q", io exitSuccess)         -- Quit xmonad
    -- Applications
        , ("M-S-<Return>", spawn (myTerminal))
        , ("M-S-b", spawn (myBrowser))
        , ("M-p", spawn "rofi -show run")
        , ("M-S-p", spawn "rofi-pass")
        , ("M-S-e", spawn "/usr/bin/emacsclient -c -s default")
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
    -- Scrot
        , ("M-s", spawn ("scrot " ++ scrotPath))
        , ("M-S-s", spawn ("scrot -s " ++ scrotPath))
    -- Multimedia Keys
        , ("<XF86AudioPlay>", spawn (scriptPath ++ "spotify play-pause"))
        , ("S-<XF86AudioPlay>", spawn (scriptPath ++ "smart_vlc_control"))
        , ("<XF86AudioPrev>", spawn (scriptPath ++ "spotify previous"))
        , ("<XF86AudioNext>", spawn (scriptPath ++ "spotify next"))
        , ("<XF86AudioMute>", spawn (scriptPath ++ "volume mute"))
        , ("<XF86AudioLowerVolume>", spawn (scriptPath ++ "volume down"))
        , ("<XF86AudioRaiseVolume>", spawn (scriptPath ++ "volume up"))
        , ("M-<Up>", spawn (scriptPath ++ "brightness pixel " ++ disp0 ++ " up"))
        , ("M-<Down>", spawn (scriptPath ++ "brightness pixel " ++ disp0 ++ " down"))
        , ("M-S-<Up>", spawn (scriptPath ++ "brightness pixel " ++ disp1 ++ " up"))
        , ("M-S-<Down>", spawn (scriptPath ++ "brightness pixel " ++ disp1 ++ " down"))
        , ("M-C-<Up>", spawn (scriptPath ++ "brightness backlight up"))
        , ("M-C-<Down>", spawn (scriptPath ++ "brightness backlight down"))
        ]

main :: IO ()
main = do
    xmproc <- spawnPipe "xmobar -x 0 /home/marc/.config/xmobar/xmobarrc"
    xmonad $ def
        { manageHook         = myManageHook <+> namedScratchpadManageHook myScratchpads
        , handleEventHook    = docksEventHook
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
