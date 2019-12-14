import XMonad hiding (Tall(..))
import qualified XMonad.StackSet as W
import XMonad.Actions.CopyWindow
import XMonad.Layout.Tabbed
import XMonad.Layout.HintedTile
import XMonad.Layout.NoBorders
import XMonad.Layout.ThreeColumns
import XMonad.Util.NamedScratchpad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Prompt
import XMonad.Actions.SpawnOn
import XMonad.Util.SpawnOnce
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(removeKeys, additionalKeys)
import Graphics.X11.ExtraTypes.XF86
import System.IO


import XMonad.Layout.LayoutScreens
import XMonad.Layout.TwoPane

import Data.List (isPrefixOf)

import qualified Data.Map as M

main = do
  xmproc <- spawnPipe "@xmobar@ ~/.config/xmobar/xmobar.conf"
  xmonad $ docks $ ewmh $ defaultConfig
    { terminal = "kitty"
    , workspaces = ["src", "web"] ++ map show [3 .. 8 :: Int] ++ ["tv"]
    , mouseBindings = \(XConfig {modMask = modm}) -> M.fromList $
            [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w))
            , ((modm, button2), (\w -> focus w >> windows W.swapMaster))
            , ((modm.|. shiftMask, button1), (\w -> focus w >> mouseResizeWindow w)) ]
    , keys = \c -> mykeys c `M.union` keys defaultConfig c
    , layoutHook = modifiers layouts
    , focusedBorderColor = "#586e75"
    , normalBorderColor = "#000000"
    , startupHook = myStartupHook
    , logHook = dynamicLogWithPP . namedScratchpadFilterOutWorkspacePP $ sjanssenPP
         { ppOutput = hPutStrLn xmproc
         , ppLayout = const ""
         }
    , manageHook = manageHook defaultConfig
                <+> manageSpawn
                <+> (isFullscreen --> doFullFloat)
                <+> (className =? "Kodi" --> doShift "tv")
                <+> namedScratchpadManageHook myScratchPads
    } `removeKeys` [(mod1Mask, xK_space)]
 where
    tiled     = HintedTile 1 0.03 0.5 TopLeft
    layouts   = (tiled Tall ||| (tiled Wide ||| Full)) ||| ThreeColMid 1 (3/100) (3/4)
    modifiers = avoidStruts . smartBorders
    myStartupHook = spawn "@albert@"
    myScratchPads =
        [
        NS "ranger" "kitty ranger"        (title =? "ranger") defaultFloating
        ]
    mykeys (XConfig {modMask = modm}) = M.fromList $
        [((modm .|. shiftMask, xK_Return), spawnHere =<< asks (terminal . config))
        ,((modm .|. shiftMask, xK_c     ), kill1)
        ,((modm .|. shiftMask .|. controlMask, xK_c     ), kill)
        ,((modm .|. shiftMask, xK_0     ), windows $ copyToAll)
        ,((modm,               xK_c     ), layoutScreens 3 $ ThreeColMid 1 (3/100) (70/100))
        ,((modm,               xK_x     ), layoutScreens 3 $ ThreeColMid 1 (3/100) (27/64))
        ,((modm,               xK_z     ), layoutScreens 3 $ ThreeColMid 1 (3/100) (8/100))
        ,((modm .|. shiftMask, xK_z     ), rescreen)
        ,((modm .|. controlMask, xK_l   ), spawn "@lockCmd@")
        ,((modm,               xK_b     ), sendMessage ToggleStruts)
        ,((0, xF86XK_MonBrightnessDown  ), spawn "xbacklight -dec 5")
        ,((0, xF86XK_MonBrightnessUp    ), spawn "xbacklight -inc 5")
        ,((0, xF86XK_AudioMute          ), spawn "amixer set Master toggle")
        ,((0, xF86XK_AudioLowerVolume   ), spawn "amixer set Master 5%- unmute")
        ,((0, xF86XK_AudioRaiseVolume   ), spawn "amixer set Master 5%+ unmute")
        ,((modm,                 xK_o   ), namedScratchpadAction myScratchPads "dot")
        ,((modm,            xK_Return   ), namedScratchpadAction myScratchPads "ranger")
        ,((modm .|. controlMask, xK_m   ), spawn "amixer -q set Master toggle")
        ,((modm .|. controlMask, xK_j   ), spawn "amixer -q set Master 5%-")
        ,((modm .|. controlMask, xK_k   ), spawn "amixer -q set Master 5%+")
        ,((modm, xK_n                   ), sendMessage NextLayout)
        ] ++
        [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
            | (key, sc) <- zip [xK_w, xK_q, xK_e] [0..]
            , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]

