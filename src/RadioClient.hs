{-# LANGUAGE DeriveGeneric, DeriveAnyClass #-}
module RadioClient (
    --getResult,
    --postRequestByGenreSample
    ) where
    
    import Control.Applicative
    import Data.Aeson
    import GHC.Generics

    import Network.HTTP.Client
    import Network.HTTP.Simple

    import Network.HTTP
    import Network.Stream
    --import qualified Network.HTTP.simpleHTTP as simpleHTTP
    import Text.ParserCombinators.Parsec

    import Constants

    getStationList' :: IO [String]
    getStationList' = undefined

    -- Two types of format has been used, as far as I know ...
    data AudioFormat = AAC | MP3 deriving (Show, Generic)

    -- This will be replaced by cartesian product data type.
    type Genre = String

    data StationInfo = StationInfo {
        id :: Int,
        name :: String,
        format :: AudioFormat,
        bitrate :: Int,
        genre :: Genre,
        currentTrack:: String,
        listeners :: Int,
        isRadioOnly :: Bool,
        iceURL :: String,
        isPlaying :: Bool
    } deriving (Show, Generic)

    -- not case-sensitive
    sampleGenre :: Genre
    sampleGenre = "Alternative"

    -- | Post genre to shoutcast.com then parse json response and get list of stations.
    requestListByGenre ::  Genre -> IO [StationInfo]
    requestListByGenre = undefined

    {-postRequestByGenre :: Genre -> Request_String
    postRequestByGenre g = postRequestWithBody shoutCastBrowseGenre contentTypeBrowseByGenre ("genrename="++ g)

    postRequestByGenreSample :: Request_String
    postRequestByGenreSample = postRequestByGenre sampleGenre

    getResult :: IO String
    getResult = do 
        res <- Network.HTTP.simpleHTTP (postRequestByGenre sampleGenre)
        case res of 
            Left e -> return ("Error"++(show e))
            Right r -> return (show r)--getResponseBody res
            -}
        