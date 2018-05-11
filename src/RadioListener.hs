 {-# LANGUAGE DeriveGeneric, DeriveAnyClass, OverloadedStrings #-}
 {-# LANGUAGE TemplateHaskell #-}

 module RadioListener () where

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

type StationURL = S.ByteString

connectTo :: StationURL -> IO()
connectTo = undefined
