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
myFont = "xft:Ubuntu:weight=bold:pixelsize=12:antialias=true:hinting=true"

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

-- Colors. Also used in xmobarrc. If you change a color here, you should probably change the corresponding color in xmobarrc to keep theme consistent
myLightGrey :: String
myLightGrey = "#666666"
myDarkGrey  :: String
myDarkGrey  = "#222222"
myPurple    :: String
myPurple    = "#DE02F2"
myYellow    :: String
myYellow    = "#fff700"
myOrange    :: String
myOrange    = "#FFA500"
myGreen     :: String
myGreen     = "#20D68A"
myWhite     :: String
myWhite     = "#eeeeee"
myBlue      :: String
myBlue      = "#1c90fc"
myRed       :: String
myRed       = "#ff0800"

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myStartupHook :: X ()
myStartupHook = do
    spawnOnce "bash /home/marc/working/dotfiles/backgrounds/feh.sh &"
    -- spawnOnce "picom --backend glx &"
    -- NOTE: YOU NEED TO USE `paru -S picom-arian8j2-git` instead of normal `picom` for window edge radius
    spawnOnce "picom &"
    spawnOnce "dunst &"
    spawnOnce "dropbox start &"
    spawnOnce "tmux new-session -t main"
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
     [ className =? "zoom"                       --> doShift(myWorkspaces !! 6)
     , className =? "Microsoft Teams - Preview"  --> doShift(myWorkspaces !! 6)
     , className =? "Slack"                      --> doShift(myWorkspaces !! 7)
     , className =? "firefox"                    --> doShift(myWorkspaces !! 8)
     , className =? "vlc"                        --> doShift(myWorkspaces !! 8)
     ] <+> namedScratchpadManageHook myScratchpads

--Scratchpads
myScratchpads :: [NamedScratchpad]
myScratchpads = [ NS "terminalScratch" spawnTerm findTerm manageTerm
                , NS "ncspotScratch" spawnNcspot findNcspot manageNcspot
                , NS "ncpamixerScratch" spawnNcpamixer findNcpamixer manageNcpamixer
                , NS "chatGptScratch" spawnChatGpt findChatGpt manageChatGpt
                , NS "emacsScratch" spawnEmacsClient findEmacsClient manageEmacsClient
                , NS "thunderScratch" spawnThunderScratch findThunderScratch manageThunderScratch]
    where
        spawnTerm  = myTerminal ++ " -t 'Terminal Scratchpad' -e tmux new-session -t main"
        findTerm   = title =? "Terminal Scratchpad"
        manageTerm = customFloating $ W.RationalRect 0.025 0.025 0.95 0.95

        spawnNcspot  = myTerminal ++ " -t 'ncspot Scratchpad' -e ncspot"
        findNcspot   = title =? "ncspot Scratchpad"
        manageNcspot = customFloating $ W.RationalRect 0.025 0.025 0.95 0.95

        spawnEmacsClient  = "emacsclient -s 0 -a='' --no-wait -c -F '(quote (name . \"emacs-scratch\"))'"
        findEmacsClient   = title =? "emacs-scratch"
        manageEmacsClient = customFloating $ W.RationalRect 0.025 0.025 0.95 0.95

        spawnNcpamixer  = myTerminal ++ " -t 'ncpamixer Scratchpad' -e ncpamixer"
        findNcpamixer   = title =? "ncpamixer Scratchpad"
        manageNcpamixer = customFloating $ W.RationalRect 0.025 0.025 0.95 0.95

        spawnThunderScratch  = "thunderbird"
        findThunderScratch   = className =? "thunderbird"
        manageThunderScratch = customFloating $ W.RationalRect 0.025 0.025 0.95 0.95

        spawnChatGpt  = "chat-gpt"
        findChatGpt   = className =? "Chat-gpt"
        manageChatGpt = customFloating $ W.RationalRect 0.025 0.025 0.95 0.95

--Keybindings
myKeys :: [(String, X ())]
myKeys =
    -- Xmonad
        [ ("M-S-q", io exitSuccess)         -- Quit xmonad
    -- Applications
        , ("M-S-<Return>", spawn (myTerminal ++ " -e tmux new-session -t main"))
        , ("M-S-b", spawn (myBrowser))
        , ("M-S-f", spawn "firefox")
        , ("M-p", spawn "rofi -show run")
        , ("M-S-p", spawn "rofi-pass")
        , ("M-S-c", spawn "emacs")
    -- Kill windows
        , ("M-S-x", kill)                 -- Kill the currently focused client
    -- Windows navigation
        , ("M-j", windows W.focusDown)    -- Move focus to the next window
        , ("M-k", windows W.focusUp)      -- Move focus to the prev window
        , ("M-S-m", windows W.swapMaster) -- Swap the focused window and the master window
    -- Layouts
        , ("M-<Space>", sendMessage NextLayout)      -- Switch to next layout
        , ("M-x", sendMessage ToggleStruts)          -- Toggles noborder
        , ("M-t", withFocused $ windows . W.sink)    -- Push floating window back to tile
    -- Window resizing
        , ("M-h", sendMessage Shrink)                -- Shrink horiz window width
        , ("M-l", sendMessage Expand)                -- Expand horiz window width
    -- Scratchpads
        , ("M-<Return>", namedScratchpadAction myScratchpads "terminalScratch")
        , ("M-m", namedScratchpadAction myScratchpads "ncspotScratch")
        , ("M-c", namedScratchpadAction myScratchpads "emacsScratch")
        , ("M-a", namedScratchpadAction myScratchpads "ncpamixerScratch")
        , ("M-g", namedScratchpadAction myScratchpads "thunderScratch")
        , ("M-f", namedScratchpadAction myScratchpads "chatGptScratch")
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
    -- xmproc <- spawnPipe "xmobar -x 0 /home/marc/working/dotfiles/xmobarrc"
    xmproc0 <- spawnPipe ("xmobar -x 0 /home/marc/working/dotfiles/xmobarrc")
    xmproc1 <- spawnPipe ("xmobar -x 1 /home/marc/working/dotfiles/xmobarrc")
    xmproc2 <- spawnPipe ("xmobar -x 2 /home/marc/working/dotfiles/xmobarrc")
    xmonad $ docks $ def
        { manageHook         = myManageHook
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = avoidStruts $ myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myDarkGrey
        , focusedBorderColor = myBlue
        , logHook = dynamicLogWithPP $ xmobarPP
            { ppOutput = \x -> hPutStrLn xmproc0 x   -- xmobar on monitor 1
                            >> hPutStrLn xmproc1 x   -- xmobar on monitor 2
                            >> hPutStrLn xmproc2 x   -- xmobar on monitor 3
            , ppCurrent = xmobarColor myBlue "" . wrap
                        ("<box type=Bottom width=2 mb=2 color=" ++ myBlue ++ ">") "</box>"
            -- Visible but not current workspace
            , ppVisible = xmobarColor myGreen ""
            -- Hidden workspace
            , ppHidden = xmobarColor myPurple "" . wrap
                        ("<box type=Top width=2 mt=2 color=" ++ myPurple ++ ">") "</box>"
            -- Hidden workspaces (no windows)
            , ppHiddenNoWindows = xmobarColor myWhite ""
            -- Title of active window
            , ppTitle = xmobarColor myBlue "" . shorten 60
            -- Separator character
            , ppSep =  "<fc=" ++ myLightGrey ++ "> <fn=1>|</fn> </fc>" -- revisit. color does nothing
            -- Urgent workspace. Not when a workspace becomes urgent
            , ppUrgent = xmobarColor myRed "" . wrap "!" "!"
            -- Adding # of windows on current workspace to the bar
            , ppExtras  = [windowCount]
            -- order of things in xmobar
            , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
            }
        } `additionalKeysP` myKeys
