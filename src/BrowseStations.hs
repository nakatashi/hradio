{-# LANGUAGE DeriveGeneric, DeriveAnyClass, OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module BrowseStations (
    browseByGenre,
    browseByGenre'
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
    import Types

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

    browseByGenre :: Genre -> IO (Either JSONException [StationInfo])
    browseByGenre genre = do
        req' <- parseRequest ("POST "++shoutCastURL ++ browseGenreTail)
        --response <- httpLBS (request req')
        response <- httpJSONEither (request req')
        case (getResponseBody response :: Either JSONException [StationInfo] ) of
            Left err -> return (Left err)
            Right b -> return (Right b)
        where request r = setRequestMethod "POST"
                    $ setRequestHeader "Accept" ["*/*"]
                    $ setRequestHeader "Expect" ["100-continue"]
                    $ setRequestHeader "Content-Type" ["multipart/form-data"]
                    $ setRequestQueryString (simpleQueryToQuery [("genrename", genre)])
                    $ r

    browseByGenre' :: S.ByteString -> IO ()
    browseByGenre' genre = do
      res <- browseByGenre genre
      case res of
        Left err -> putStrLn $ show err
        Right j -> putStrLn $ show j
  
