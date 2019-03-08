import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.NoBorders
import XMonad.Util.EZConfig(additionalKeys)
import System.IO


main = do
  xmproc <- spawnPipe "/usr/bin/xmobar /home/mindaugas/.xmobarrc"
  xmonad $ ewmh def
    { borderWidth = 3
    , terminal = "urxvtc"
    , modMask = mod4Mask
    , normalBorderColor = "#111111"
    , focusedBorderColor = "#444488"
    , manageHook = manageDocks 
    , layoutHook = avoidStruts $ smartBorders $ layoutHook def
    , handleEventHook = fullscreenEventHook <+> docksEventHook
    , logHook = dynamicLogWithPP def
                { ppOutput = hPutStrLn xmproc
                }
    }
