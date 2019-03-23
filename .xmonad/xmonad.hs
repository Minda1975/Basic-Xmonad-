import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.BinarySpacePartition (emptyBSP)
import XMonad.Layout.Maximize
import XMonad.Layout.Spacing
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Column
import XMonad.Util.EZConfig
import System.IO
import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt
import XMonad.Actions.WindowBringer
import XMonad.Prompt.Shell
import System.Exit

main = do
  xmproc <- spawnPipe "/usr/bin/xmobar /home/mindaugas/.xmobarrc"
  xmonad $ ewmh def
    { terminal = "urxvt"
    , modMask = mod4Mask
    , normalBorderColor = "#a4a6ab"
    , focusedBorderColor = "#559a6a"
    , borderWidth = 2
    , manageHook = manageDocks 
    , layoutHook = smartSpacing 7 $ avoidStruts $ smartBorders $ myLayouts
    , handleEventHook = fullscreenEventHook <+> docksEventHook
    , logHook = dynamicLogWithPP xmobarPP
                { ppOutput = hPutStrLn xmproc
                , ppCurrent = xmobarColor "#b577ac" "" . wrap "[" "]"
                , ppUrgent = xmobarColor "#c4756e" "" . wrap "*" "*"
                , ppLayout = xmobarColor "#cab775" ""
                , ppTitle = xmobarColor "#559a6a" "" . shorten 50
                , ppSep = "<fc=#6a8dca> | </fc>"
                }
    }

     `additionalKeysP` -- Add some extra key bindings:
      [ 
        ("M-S-q",   confirmPrompt myXPConfig "exit" (io exitSuccess))
      , ("M-p",     shellPrompt myXPConfig)
      , ("M-S-p", spawn "/home/mindaugas/.scripts/rofia")
      , ("M-<Esc>", withFocused (sendMessage . maximizeRestore))
      , ("M-S-g",   gotoMenu)
      , ("M-S-b",   bringMenu)
      , ("M-w", spawn "/home/mindaugas/.scripts/screeny")
      , ("M-r", spawn "/home/mindaugas/.scripts/shutdown.sh")
      , ("M-x", spawn "/home/mindaugas/.scripts/mpdmenu")
      ]
--------------------------------------------------------------------------------
-- | Customize layouts.
--
-- This layout configuration uses two primary layouts, 'ResizableTall'
-- and 'BinarySpacePartition'.  You can also use the 'M-<Esc>' key
-- binding defined above to toggle between the current layout and a
-- full screen layout.
myLayouts = maximizeWithPadding 10 (Tall 1 (3/100) (1/2)) ||| emptyBSP ||| Column 1.6

myXPConfig = def
  { position          = Top
  , alwaysHighlight   = True
  ,fgColor            = "#a4a6ab"
  , bgColor           = "#2d2c28"
  , bgHLight    = "#a4a6ab"
  , fgHLight    = "#2d2c28"
  , promptBorderWidth = 0
  , font              = "xft:InconsolataGo Nerd Font:size=10"
  }
