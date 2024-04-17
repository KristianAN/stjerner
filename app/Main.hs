{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}

module Main (main) where

import Control.Monad.IO.Class (liftIO)
import Data.IORef (newIORef)
import Data.Map as Map
import Data.Text.Lazy (pack)
import StjernerService (Stjerner (..))
import qualified StjernerService as SR
import Web.Scotty

starsEndpoint :: (SR.StjerneRepo r IO) => r -> ScottyM ()
starsEndpoint repo = get "/stars/:name" $ do
  nameParam <- captureParam "name"
  stjerner <- liftIO $ SR.get repo nameParam
  html $ case stjerner of
    Just star -> mconcat ["<h1>", pack nameParam, " has ", pack . show $ stars star, " stars</h1>"]
    Nothing -> "<h1>Stjerne not found</h1>"

main :: IO ()
main = do
  stjerneRepo <- newIORef Map.empty
  let liveRepo = SR.LiveStjerneRepo stjerneRepo
  scotty 3000 $ do
    get "/hello/:name" $ do
      nameParam <- captureParam "name"
      html $ mconcat ["<h1>Hello ", nameParam, "!</h1>"]
    get "/healthy" $ html "<h1>I am healthy </h1>"
    put "/stars/:name/increment" $ do
      nameParam <- captureParam "name"
      stjerner <- liftIO $ SR.incrementAndGet liveRepo nameParam
      html $ case stjerner of
        Just star -> mconcat [pack . show $ name star, " has ", pack . show $ stars star, " stars"]
        Nothing -> "No person to increment"

    post "/stars/:name" $ do
      nameParam <- captureParam "name"
      liftIO $ SR.insert liveRepo nameParam
      text "Star inserted successfully"
    starsEndpoint liveRepo
