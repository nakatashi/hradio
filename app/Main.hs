{-# LANGUAGE DeriveGeneric, DeriveAnyClass, OverloadedStrings #-}
module Main where
    import BrowseStations

    main :: IO()
    main = browseByGenre "rock"