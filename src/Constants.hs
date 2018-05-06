module Constants (
    testURL,
    shoutCastURL,
    shoutCastBrowseGenre,
    shoutCastTop
) where
    -- SuperRadioTupi
    testURL :: String
    testURL = "http://189.112.0.37:8000"


    -- curl -F "genrename=GENRENAME" http://www.shoutcast.com/Home/BrowseByGenre
    shoutCastURL :: String
    shoutCastURL= "http://www.shoutcast.com"

    shoutCastBrowseGenre :: String
    shoutCastBrowseGenre = "/Home/BrowseByGenre"

    shoutCastTop :: String
    shoutCastTop = "/Home/Top"