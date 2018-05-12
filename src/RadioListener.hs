{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric, DeriveAnyClass #-}
{-# LANGUAGE TemplateHaskell #-}

module RadioListener (
  getCurrentTrack',
  getStreamUrl,
  openConnection,
  openConnectionTestURL
  ) where

import Control.Applicative
import Control.Monad.IO.Class (liftIO)
import Data.Aeson
import Data.Aeson.TH
import qualified Data.ByteString.Char8 as B8
import qualified Data.ByteString as S
import qualified Data.ByteString.Lazy as LB
import qualified Data.Conduit.List as CL

import GHC.Generics

import Network.HTTP.Client
import Network.HTTP.Simple
import Network.HTTP.Types.URI

import System.IO (stdout)

import Text.ParserCombinators.Parsec

import Constants
import Types

type StationURL = S.ByteString

data CurrentStationInfo = CurrentStationInfo {
  statCallbackDelay :: Int,
  statStation :: StationInfo
  } deriving (Show, Generic)

$(deriveJSON defaultOptions {
     fieldLabelModifier = drop 4
     } ''CurrentStationInfo)

getCurrentTrack :: Int -> IO (Either JSONException CurrentStationInfo)
getCurrentTrack id = do
  req' <- parseRequest ("POST "++shoutCastURL ++ "/Player/GetCurrentTrack")
    --response <- httpLBS (request req')
  response <- httpJSONEither (request req')
  case (getResponseBody response :: Either JSONException CurrentStationInfo) of
    Left err -> return (Left err)
    Right b -> return (Right b)
    where request r = setRequestMethod "POST"
            $ setRequestHeader "Accept" ["*/*"]
            $ setRequestHeader "Expect" ["100-continue"]
            $ setRequestHeader "Content-Type" ["multipart/form-data"]
            $ setRequestQueryString (simpleQueryToQuery [("stationID", B8.pack (show id))])
            $ r

getCurrentTrack' :: Int -> IO()
getCurrentTrack' id = do
  res <- getCurrentTrack id
  case res of
    Left err -> putStrLn $ show err
    Right j -> putStrLn $ show j


getStreamUrl :: Int -> IO LB.ByteString
getStreamUrl id  = do
  req' <- parseRequest ("POST" ++ shoutCastURL ++ "/Player/GetStreamUrl")
  response <- httpLBS (request req')
  return $ (getResponseBody response)
  where request r = setRequestMethod "POST"
                    $ setRequestHeader "Accept" ["*/*"]
                    $ setRequestHeader "Expect" ["100-continue"]
                    $ setRequestHeader "Content-Type" ["multipart/form-data"]
                    $ setRequestQueryString (simpleQueryToQuery [("station", B8.pack (show id))])
                    $ r

-- http://162.211.86.137:8000/stream?icy=http
testStationUrl = "http://162.211.86.137:8000/stream?icy=http"

openConnection :: String -> IO()
openConnection url = do
  req' <- parseRequest ("GET " ++ url)
  httpSink (request req') $ \response -> do
    liftIO $ putStrLn
      $ "the status code was : " ++ show (getResponseStatusCode response)

    CL.mapM_ (S.hPut stdout)
  where request r = setRequestMethod "GET"
                    $ setRequestHeader "Connection" ["keep-alive"]
                    $ setRequestHeader "Accept" ["*/*"]
                    $ setRequestHeader "Referer" ["http://www.shoutcast.com/"]
                    $ setRequestQueryString (simpleQueryToQuery [("icy", "http")])
                    $ r
    
  
  

openConnectionTestURL :: IO()
openConnectionTestURL = openConnection testStationUrl

