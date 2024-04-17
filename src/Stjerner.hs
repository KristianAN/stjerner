{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE GADTs #-}

module Stjerner (Stjerner, StjerneRepo) where

import Data.IORef (IORef, atomicModifyIORef', modifyIORef, readIORef)
import Data.Map as Map

data Stjerner = Stjerner
  { name :: String
  , stars :: Int
  }

class StjerneRepo r m | r -> m where
  get :: r -> String -> m (Maybe Stjerner)
  incrementAndGet :: r -> String -> m (Maybe Stjerner)

data LiveStjerneRepo where
  LiveStjerneRepo :: (IORef (Map String Stjerner)) -> LiveStjerneRepo

instance StjerneRepo LiveStjerneRepo IO where
  get (LiveStjerneRepo state) n = do
    stjernerMap <- readIORef state
    return $ Map.lookup n stjernerMap
  incrementAndGet (LiveStjerneRepo state) n =
    atomicModifyIORef' state $ \sMap ->
      let updatedMap = Map.alter (fmap (\s -> s{stars = stars s + 1})) n sMap
       in (updatedMap, Map.lookup n updatedMap)
