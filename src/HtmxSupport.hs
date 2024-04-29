{-# LANGUAGE OverloadedStrings #-}

module HtmxSupport where

import Data.String
import Lucid
import Lucid.Base (makeAttributes)

hxPost :: String -> Attributes
hxPost target =
  makeAttributes "hx-post" $ fromString target

hxPut :: String -> Attributes
hxPut target =
  makeAttributes "hx-put" $ fromString target

hxDelete :: String -> Attributes
hxDelete target =
  makeAttributes "hx-delete" $ fromString target

hxSwap :: String -> Attributes
hxSwap swapType =
  makeAttributes "hx-swap" $ fromString swapType

hxSwapOuterHtml :: Attributes
hxSwapOuterHtml = hxSwap "outerHTML"

hxTarget :: String -> Attributes
hxTarget target = makeAttributes "hx-target" $ fromString target
