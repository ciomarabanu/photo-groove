module PhotoGroove exposing (main)

import Array exposing (Array)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


type alias UrlPrefix =
    String


urlPrefix : UrlPrefix
urlPrefix =
    "http://elm-in-action.com/"


view : Model -> Html OnClickMessage
view model =
    div [ class "content" ]
        [ h1 [] [ text "Photo Groove" ]
        , div [ id "thumbnails" ] (List.map (viewThumbnail model.selectedThumbnail) model.thumbnails)
        , img [ class "large", src (urlPrefix ++ "large/" ++ model.selectedThumbnail.fileName) ] []
        ]


type alias Action =
    String


type alias OnClickMessage =
    { action : Action, thumbnail : Thumbnail }


viewThumbnail : Thumbnail -> Thumbnail -> Html OnClickMessage
viewThumbnail selectedThumb thumb =
    img
        [ src (urlPrefix ++ thumb.fileName)
        , classList [ ( "selected", selectedThumb == thumb ) ]
        , onClick { action = actions.clickedThumbnailAction, thumbnail = thumb }
        ]
        []


type alias FileName =
    String


type alias Thumbnail =
    { fileName : FileName }


type alias Model =
    { thumbnails : List Thumbnail, selectedThumbnail : Thumbnail }


initialModel : Model
initialModel =
    { thumbnails =
        [ { fileName = "1.jpeg" }
        , { fileName = "2.jpeg" }
        , { fileName = "3.jpeg" }
        ]
    , selectedThumbnail =
        { fileName = "1.jpeg" }
    }


thumbnailArray : Array Thumbnail
thumbnailArray =
    Array.fromList initialModel.thumbnails


update : OnClickMessage -> Model -> Model
update msg model =
    if msg.action == actions.clickedThumbnailAction then
        { model | selectedThumbnail = msg.thumbnail }

    else
        model


actions : { clickedThumbnailAction : Action }
actions =
    { clickedThumbnailAction = "wtf"
    }


main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }
