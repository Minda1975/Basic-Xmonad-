import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.BinarySpacePartition (emptyBSP)
import XMonad.Layout.Maximize
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
    { terminal = "urxvtc"
    , modMask = mod4Mask
    , manageHook = manageDocks 
    , layoutHook = avoidStruts $ smartBorders $ myLayouts
    , handleEventHook = fullscreenEventHook <+> docksEventHook
    , logHook = dynamicLogWithPP xmobarPP
                { ppOutput = hPutStrLn xmproc
                , ppTitle = xmobarColor "green" "" . shorten 50
                }
    }

     `additionalKeysP` -- Add some extra key bindings:
      [ 
        ("M-S-q",   confirmPrompt myXPConfig "exit" (io exitSuccess))
      , ("M-p",     shellPrompt myXPConfig)
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
  , promptBorderWidth = 0
  , font              = "xft:monospace:size=9"
  }
