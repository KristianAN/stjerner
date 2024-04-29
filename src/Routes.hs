{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE OverloadedStrings #-}

module Routes (allRoutes) where

import Data.Text.Lazy (pack)
import Lucid
import StjernerService (Stjerner (..))
import StjernerService qualified as SR
import Templates qualified as T
import Web.Scotty

starPage :: (SR.StjerneRepo r IO) => r -> String -> ActionM ()
starPage repo nameParam = do
  stjerner <- liftIO $ SR.get repo nameParam
  html $ case stjerner of
    Just s -> renderText $ T.base $ T.starsForNameHtml (name s) (stars s)
    Nothing -> renderText $ T.base $ T.noStarsFound nameParam

starsEndpoint :: (SR.StjerneRepo r IO) => r -> ScottyM ()
starsEndpoint repo = get "/stars/:name" $ do
  nameParam <- captureParam "name"
  starPage repo nameParam

insertStars :: (SR.StjerneRepo r IO) => r -> ScottyM ()
insertStars repo = post "/stars/:name" $ do
  nameParam <- captureParam "name"
  liftIO $ SR.insert repo nameParam
  html $ renderText $ T.base $ T.starsForNameHtml nameParam 0

updateStars :: (SR.StjerneRepo r IO) => r -> ScottyM ()
updateStars repo = put "/stars/:name/increment" $ do
  nameParam <- captureParam "name"
  stjerner <- liftIO $ SR.incrementAndGet repo nameParam
  html $ case stjerner of
    Just s -> renderText $ T.base $ T.starsForNameHtml (name s) (stars s)
    Nothing -> "No person to increment"

resetStars :: (SR.StjerneRepo r IO) => r -> ScottyM ()
resetStars repo = delete "/stars/:name" $ do
  nameParam <- captureParam "name"
  _ <- liftIO $ SR.reset repo nameParam
  starPage repo nameParam

allRoutes :: (SR.StjerneRepo r IO) => r -> ScottyM ()
allRoutes repo =
  starsEndpoint repo
    <> insertStars repo
    <> updateStars repo
    <> resetStars repo
