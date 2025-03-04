-- Base
import XMonad
import System.IO (hPutStrLn, readFile)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W
-- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers
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
import XMonad.Actions.PhysicalScreens
-- for switching xmonad config depending if monitor is connected
import System.Directory (doesFileExist)
import Control.Exception (catch, SomeException)
import Data.List (isInfixOf)

myFont :: String
myFont = "xft:Ubuntu:weight=bold:pixelsize=12:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask

disp0 :: String
disp0 = "eDP-1"

disp1 :: String
disp1 = "DP2-2"

myTerminal :: String
myTerminal = "alacritty"

scriptPath :: String
scriptPath = "/home/marc/working/dotfiles/scripts/"

scrotPath :: String
scrotPath = "/home/marc/working/screenshots/screenshot.jpg"

myBorderWidth :: Dimension
myBorderWidth = 1           -- Sets border width for windows

myGaps = 0 -- gaps between tiled windows

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
    spawnOnce "dunst &"
    spawnOnce "nextcloud --background &"
    spawnOnce "tmux new-session -t main"
    spawnOnce "/usr/bin/emacs --daemon=0 &" --emacs daemon for default
    spawnOnce "picom &"
    spawnOnce "xsetroot -cursor_name left_ptr" --set cursor shape

--Layouts
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

tall     = renamed [Replace "T"]
           $ mySpacing myGaps
           $ ResizableTall 1 (3/100) (1/2) []
wide     = renamed [Replace "W"]
           $ mySpacing myGaps
           $ Mirror (ResizableTall 1 (3/100) (1/2) [])
monocle  = renamed [Replace "M"]
           $ Full
myLayoutHook = avoidStruts $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) $ myDefaultLayout
  where
    myDefaultLayout = withBorder myBorderWidth tall ||| withBorder myBorderWidth wide ||| noBorders monocle

myWorkspaces :: [String]
myWorkspaces = ["  1  ", "  2  ", "  3  ", "  4  ", "  5  ", "  6  ", "  7  ", "  8  ", "  9  "]
myManageHook = composeAll
     [ className =? "zoom"       --> doShift (myWorkspaces !! 6)
     , className =? "firefox"    --> doShift (myWorkspaces !! 8)
     , className =? "vlc"        --> doShift (myWorkspaces !! 8)
     , className =? "Nextcloud"  --> doFloat
     , className =? "xfreerdp"   --> doFullFloat
     ] <+> namedScratchpadManageHook myScratchpads

--Scratchpads
myScratchpads :: [NamedScratchpad]
myScratchpads = [ NS "terminalScratch" spawnTerm findTerm manageTerm
                , NS "ncspotScratch" spawnNcspot findNcspot manageNcspot
                , NS "pulsemixerScratch" spawnPulsemixer findPulsemixer managePulsemixer
                , NS "chatGptScratch" spawnChatGpt findChatGpt manageChatGpt
                , NS "emacsScratch" spawnEmacsClient findEmacsClient manageEmacsClient]
    where
        spawnTerm = myTerminal ++ " -t 'Terminal Scratchpad' -e bash -c 'source ~/.bashrc && tm a main'"
        findTerm   = title =? "Terminal Scratchpad"
        manageTerm = customFloating $ W.RationalRect 0.025 0.025 0.95 0.95

        spawnNcspot  = myTerminal ++ " -t 'ncspot Scratchpad' -e ncspot"
        findNcspot   = title =? "ncspot Scratchpad"
        manageNcspot = customFloating $ W.RationalRect 0.025 0.025 0.95 0.95

        spawnEmacsClient  = "emacsclient -s 0 -a='' --no-wait -c -F '(quote (name . \"emacs-scratch\"))'"
        findEmacsClient   = title =? "emacs-scratch"
        manageEmacsClient = customFloating $ W.RationalRect 0.025 0.025 0.95 0.95

        spawnPulsemixer  = myTerminal ++ " -t 'pulsemixer Scratchpad' -e pulsemixer"
        findPulsemixer   = title =? "pulsemixer Scratchpad"
        managePulsemixer = customFloating $ W.RationalRect 0.025 0.025 0.95 0.95

        spawnChatGpt  = "chromium --app='https://chat.openai.com' --class=ChatGPT --name=ChatGPT --user-data-dir=/home/marc/.local/share/ice/profiles/ChatGPT"
        findChatGpt   = className =? "ChatGPT"
        manageChatGpt = customFloating $ W.RationalRect 0.025 0.025 0.95 0.95

-- Only allow one scratchpad per window. NB: you can use exclusives to make some scratchpads conflict and some not. Checkout documentation
myExclusives = addExclusives [ [name | NS name _ _ _ <- myScratchpads] ]

--Keybindings
myKeys :: [(String, X ())]
myKeys =
    -- Xmonad
        [
    -- Applications
        ("M-S-<Return>", spawn (myTerminal))
        , ("M-S-b", spawn ("librewolf"))
        , ("M-p", spawn "rofi -show drun")
        , ("M-S-p", spawn (scriptPath ++ "bwmenu"))
        , ("M-S-c", spawn "emacs")
    -- Kill windows
        , ("M-S-x", kill)                 -- Kill the currently focused window
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
        , ("M-a", namedScratchpadAction myScratchpads "pulsemixerScratch")
        , ("M-f", namedScratchpadAction myScratchpads "chatGptScratch")
        , ("M-0", windows $ W.greedyView "NSP") -- set window focus to hidden NSP workspace
    -- monitors
        , ("M-q", viewScreen def 1) -- Switch focus to LeftSide
        , ("M-w", viewScreen def 2) -- Switch focus to Center
        , ("M-e", viewScreen def 3) -- Switch focus to RightSide
        , ("M-r", viewScreen def 0) -- Switch focus to eDP-1
        , ("M-S-q", sendToScreen def 1) -- Move window to LeftSide
        , ("M-S-w", sendToScreen def 2) -- Move window to Center
        , ("M-S-e", sendToScreen def 3) -- Move window to RightSide
        , ("M-S-r", sendToScreen def 0) -- Move window to eDP-1
        -- , ("M-w", viewScreen def 0) -- Switch focus to LeftSide
        -- , ("M-e", viewScreen def 1) -- Switch focus to Center
        -- , ("M-S-w", sendToScreen def 0) -- Move window to LeftSide
        -- , ("M-S-e", sendToScreen def 1) -- Move window to Center
    -- Multimedia Keys
        , ("<Print>", spawn ("scrot " ++ scrotPath))
        , ("S-<Print>", spawn ("scrot -s " ++ scrotPath))
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
    xmproc <- spawnPipe ("xmobar -x 1 /home/marc/working/dotfiles/xmobar/xmobarrc")
    xmonad $ docks $ def
        { manageHook         = myManageHook
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook >> myExclusives
        , layoutHook         = avoidStruts $ myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myDarkGrey
        , focusedBorderColor = myBlue
        , logHook = dynamicLogWithPP $ xmobarPP
            { ppOutput = \x -> hPutStrLn xmproc x  -- Update only xmobar on the center screen
            , ppCurrent = xmobarColor myBlue "" . wrap ("<box type=Bottom width=2 mb=2 color=" ++ myBlue ++ ">") "</box>"
            , ppVisible = xmobarColor myGreen ""
            , ppHidden = xmobarColor myPurple "" . wrap ("<box type=Top width=2 mt=2 color=" ++ myPurple ++ ">") "</box>"
            , ppHiddenNoWindows = xmobarColor myWhite ""
            , ppTitle = xmobarColor myBlue "" . shorten 60
            , ppSep =  "<fc=" ++ myLightGrey ++ "> <fn=1>|</fn> </fc>"
            , ppUrgent = xmobarColor myRed "" . wrap "!" "!"
            , ppExtras  = [windowCount]
            , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
            }
        } `additionalKeysP` myKeys
