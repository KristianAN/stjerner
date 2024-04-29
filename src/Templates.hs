{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE OverloadedStrings #-}

module Templates (base, greetingHtml, starsForNameHtml, noStarsFound) where

import Data.String
import Data.Text
import HtmxSupport
import Lucid
import Lucid.Base (makeAttributes)
import StringUtils

greetingHtml :: String -> Html ()
greetingHtml name = h1_ $ fromString name

starsForNameHtml :: String -> Int -> Html ()
starsForNameHtml name stars =
  div_ [id_ "star_count"] $
    h1_
      ( fromString $
          mconcat [capitalize name, " har  ", show stars, " stjerner"]
      )
      <> button_
        [ hxTarget "#star_count",
          hxPut $ mconcat [name, "/increment"],
          hxSwapOuterHtml
        ]
        "Legg til stjerne"
      <> button_
        [ hxDelete name,
          hxSwapOuterHtml,
          hxTarget "#star_count"
        ]
        "Nullstill" ::
    Html ()

noStarsFound :: String -> Html ()
noStarsFound name =
  div_ [id_ "no_stars"] $
    h1_
      ( fromString $
          mconcat
            ["Ingen stjerner funnet for ", capitalize name]
      )
      <> button_ [hxPost name, hxSwapOuterHtml, hxTarget "#no_stars"] "Legg til person" ::
    Html ()

-- The base template that must wrap every template
base :: Html () -> Html ()
base content =
  html_ $
    script_
      [ src_ "https://unpkg.com/htmx.org@1.9.12"
          <> integrity_ "sha384-ujb1lZYygJmzgSwoxRggbCHcjc0rB2XoQrxeTUQyRjrOnlCoYta87iKBWq3EsdM2"
          <> crossorigin_ "anonymous"
      ]
      ("" :: Text)
      <> body_
        ( div_ content
        ) ::
    Html ()
