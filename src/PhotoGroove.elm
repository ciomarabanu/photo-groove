module PhotoGroove exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


urlPrefix =
    "http://elm-in-action.com/"


view model =
    div [ class "content" ]
        [ h1 [] [ text "Photo Groove" ]
        , div [ id "thumbnails" ] (List.map (viewThumbnail model.selectedThumbnail) model.thumbnails)
        , img [ class "large", src (urlPrefix ++ "large/" ++ model.selectedThumbnail) ] []
        ]


viewThumbnail selectedThumbnail thumb =
    img
        [ src (urlPrefix ++ thumb.fileName)
        , classList [ ( "selected", selectedThumbnail == thumb.fileName ) ]
        , onClick { action = constants.clickedThumbnailAction, thumbnail = thumb.fileName }
        ]
        []


initialModel =
    { thumbnails =
        [ { fileName = "1.jpeg" }
        , { fileName = "2.jpeg" }
        , { fileName = "3.jpeg" }
        ]
    , selectedThumbnail =
        "1.jpeg"
    }


update msg model =
    if msg.action == constants.clickedThumbnailAction then
        { model | selectedThumbnail = msg.thumbnail }

    else
        model


constants =
    { clickedThumbnailAction = "wtf"
    }


main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
