{-# LANGUAGE FlexibleContexts #-}

module Main (main) where

import Data.IORef (newIORef)
import Data.Map as Map
import Routes (allRoutes)
import StjernerService qualified as SR
import Web.Scotty

main :: IO ()
main = do
  stjerneRepo <- newIORef Map.empty
  let liveRepo = SR.LiveStjerneRepo stjerneRepo
  scotty 3000 $ do
    allRoutes liveRepo
