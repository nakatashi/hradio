module Constants (
    testURL,
    shoutCastURL,
    shoutCastBrowseGenre,
    browseGenreTail,
    contentTypeBrowseByGenre,
    shoutCastTop
) where
    -- SuperRadioTupi
    testURL :: String
    testURL = "http://189.112.0.37:8000"


    -- curl -F "genrename=GENRENAME" http://www.shoutcast.com/Home/BrowseByGenre
    shoutCastURL :: String
    shoutCastURL= "http://www.shoutcast.com"

    shoutCastBrowseGenre :: String
    shoutCastBrowseGenre = "http://www.shoutcast.com/Home/BrowseByGenre"

    browseGenreTail :: String
    browseGenreTail = "/Home/BrowseByGenre"

    contentTypeBrowseByGenre :: String
    contentTypeBrowseByGenre = "multipart/form-data"
    --"boundary=------------------------bb5b7e23edfc6098"

    shoutCastTop :: String
    shoutCastTop = "/Home/Top"
