{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE GADTs #-}

module StjernerService (Stjerner (..), StjerneRepo (..), LiveStjerneRepo (..)) where

import Data.IORef (IORef, atomicModifyIORef, atomicModifyIORef', readIORef)
import Data.Map as Map

data Stjerner = Stjerner
  { name :: String,
    stars :: Int
  }
  deriving (Show)

class StjerneRepo r m | r -> m where
  insert :: r -> String -> m ()
  get :: r -> String -> m (Maybe Stjerner)
  incrementAndGet :: r -> String -> m (Maybe Stjerner)
  reset :: r -> String -> m ()

data LiveStjerneRepo where
  LiveStjerneRepo :: (IORef (Map String Stjerner)) -> LiveStjerneRepo

instance StjerneRepo LiveStjerneRepo IO where
  insert (LiveStjerneRepo state) n =
    atomicModifyIORef' state $ \sMap ->
      let updatedMap = Map.insert n Stjerner {name = n, stars = 0} sMap
       in (updatedMap, ())

  get (LiveStjerneRepo state) n = do
    stjernerMap <- readIORef state
    return $ Map.lookup n stjernerMap

  incrementAndGet (LiveStjerneRepo state) n =
    atomicModifyIORef' state $ \sMap ->
      let updatedMap = Map.alter (fmap (\s -> s {stars = stars s + 1})) n sMap
       in (updatedMap, Map.lookup n updatedMap)

  reset (LiveStjerneRepo state) n =
    atomicModifyIORef' state $ \sMap ->
      let updatedMap = Map.alter (fmap (\s -> s {stars = 0})) n sMap
       in (updatedMap, ())
