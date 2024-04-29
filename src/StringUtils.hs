module StringUtils (capitalize) where

import Data.Char qualified as Char

capitalize :: String -> String
capitalize (h : t) = Char.toUpper h : map Char.toLower t
capitalize [] = []
