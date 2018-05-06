{-# LANGUAGE DeriveGeneric, DeriveAnyClass #-}
module RadioClient where
    
    import Control.Applicative
    import Data.Aeson
    import GHC.Generics
    import Network.HTTP
    import Text.ParserCombinators.Parsec

    import Constants

    getStationList' :: IO [String]
    getStationList' = undefined

    data AudioFormat = AAC | MP3 deriving (Show, Generic)

    data StationInfo = StationInfo {
        id :: Int,
        name :: String,
        format :: AudioFormat,
        bitrate :: Int,
        genre :: String, -- そのうちデータ型にしたい
        currentTrack:: String,
        listeners :: Int,
        isRadioOnly :: Bool,
        iceURL :: String,
        isPlaying :: Bool
    } deriving (Show, Generic)