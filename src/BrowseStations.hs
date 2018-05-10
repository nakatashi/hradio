{-# LANGUAGE DeriveGeneric, DeriveAnyClass, OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module BrowseStations (
    browseByGenre
    ) where
    
    import Control.Applicative
    import Control.Monad.IO.Class (liftIO)
    import Data.Aeson
    import Data.Aeson.TH
    import qualified Data.ByteString as S

    import GHC.Generics

    import Network.HTTP.Client
    import Network.HTTP.Simple
    import Network.HTTP.Types.URI

    import Text.ParserCombinators.Parsec

    import Constants

    -- This will be replaced by cartesian product data type.
    type Genre = String

    data StationInfo = StationInfo {
        statID :: Int,
        statName :: String,
        statFormat :: String,
        statBitrate :: Int,
        statGenre :: Genre,
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

    -- not case-sensitive
    sampleGenre :: Genre
    sampleGenre = "Alternative"

    -- | Post genre to shoutcast.com then parse json response and get list of stations.
    requestListByGenre ::  Genre -> IO [StationInfo]
    requestListByGenre = undefined

    myRequest :: Request -> Request
    myRequest req = setRequestBodyLBS ("genrename=alternative")
                $  setRequestHeader "Content-Type" ["multipart/form-data"]
                $ req
--    browseByGenre :: Genre -> IO [StationInfo]
    browseByGenre :: S.ByteString -> IO ()
    browseByGenre genre = do
        req' <- parseRequest ("POST http://shoutcast.com/Home/BrowseByGenre")
        --response <- httpLBS (request req')
        response <- httpJSONEither (request req')
        case (getResponseBody response :: Either JSONException [StationInfo] ) of
            Left err -> putStrLn (show err)
            Right b -> putStrLn (show b)

        where request r = setRequestMethod "POST"
                    $ setRequestHeader "Accept" ["*/*"]
                    $ setRequestHeader "Expect" ["100-continue"]
                    $ setRequestHeader "Content-Type" ["multipart/form-data"]                
                    $ setRequestQueryString (simpleQueryToQuery [("genrename", genre)])
                    $ r