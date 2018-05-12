{-# LANGUAGE DeriveGeneric, DeriveAnyClass, OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Types (
  Genre,
  StationInfo
  ) where

import GHC.Generics
import Data.Aeson
import Data.Aeson.TH
import qualified Data.ByteString as S

type Genre = S.ByteString


data StationInfo = StationInfo {
  statID :: Int,
  statName :: String,
  statFormat :: String,
  statBitrate :: Int,
  statGenre :: String,
  statCurrentTrack:: String,
  statListeners :: Int,
  statIsRadionomy :: Bool,
  statIceUrl :: String,
  statStreamUrl :: Maybe String, -- sometimes null like example above
  statAACEnabled :: Int,
  statIsPlaying :: Bool,
  statIsAACEnabled :: Bool
  } deriving (Show, Generic)
    
$(deriveJSON defaultOptions {
     fieldLabelModifier = drop 4
     } ''StationInfo)
