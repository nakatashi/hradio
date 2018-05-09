{-# LANGUAGE DeriveGeneric, DeriveAnyClass, OverloadedStrings #-}
module RadioClient (
    testFunc,
    testFunc2,
    testFunc3
    ) where
    
    import Control.Applicative
    import Control.Monad.IO.Class (liftIO)
    import Data.Aeson
    import qualified Data.ByteString as S
    import qualified Data.ByteString.Lazy.Char8 as S8
    import qualified Data.Conduit.List as CL
    import GHC.Generics

    import Network.HTTP.Client
    import Network.HTTP.Simple
    import Network.HTTP.Types.URI
    
    import System.IO (stdout)

    --import Network.HTTP
    --import Network.Stream
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

    myRequest :: Request -> Request
    myRequest req = setRequestBodyLBS ("genrename=alternative")
                $  setRequestHeader "Content-Type" ["multipart/form-data"]
                $ req


    testFunc :: IO()
    testFunc = do
        request' <- parseRequest ("POST http://shoutcast.com/Home/BrowseByGenre")
        let request
                = setRequestMethod "POST"
                $ setRequestHeader "Accept" ["*/*"]
                $ setRequestHeader "Expect" ["100-continue"]
                $ setRequestHeader "Content-Type" ["multipart/form-data"]                
                $ setRequestQueryString (simpleQueryToQuery [("genrename", "alternative")])
                $ request'
        response <- httpLBS request
        
        putStrLn $ show request
        putStrLn $ show response

    testFunc2 :: IO()
    testFunc2 = do
        request' <- parseRequest ("POST http://shoutcast.com/Home/BrowseByGenre")
        let request
                = --setRequestMethod "POST"
                -- $ setRequestPath "/Home/BrowseByGenre"
                -- $ setRequestHeader "HOST" ["www.shoutcast.com"]
                 setRequestHeader "Accept" ["*/*"]
                $ setRequestHeader "Expect" ["100-continue"] -- Expect: 100-continue
                $ setRequestHeader "Content-Type" ["multipart/form-data"]                
                $ setRequestBodyLBS "genrename=alternative"
                $ request'

        httpSink request $ \response -> do
                liftIO $ putStrLn
                    $ "The status code was :" ++ show(getResponseStatusCode response)
                CL.mapM_ (S.hPut stdout)



    testFunc3 :: IO ()
    testFunc3 = httpSink "http://httpbin.org/get" $ \response -> do
        liftIO $ putStrLn
            $ "The status code was: "
            ++ show (getResponseStatusCode response)

        CL.mapM_ (S.hPut stdout)