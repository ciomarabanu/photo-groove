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


view : Model -> Html Msg
view model =
    div [ class "content" ]
        [ h1 [] [ text "Photo Groove" ]
        , button
            [ onClick ClickedSurpriseMe ]
            [ text "Surprise Me!" ]
        , div [ id "thumbnails", class (sizeToString model.chosenSize) ] (List.map (viewThumbnail model.selectedThumbnail) model.thumbnails)
        , img [ class "large", src (urlPrefix ++ "large/" ++ model.selectedThumbnail.fileName) ] []
        , div [] (List.map (\size -> chooseImgSize size) [ Small, Medium, Large ])
        ]


type alias Action =
    String


viewThumbnail : Thumbnail -> Thumbnail -> Html Msg
viewThumbnail selectedThumb thumb =
    img
        [ src (urlPrefix ++ thumb.fileName)
        , classList [ ( "selected", selectedThumb == thumb ) ]
        , onClick (ClickedThumbnail thumb)
        ]
        []


chooseImgSize : ThumbnailSize -> Html Msg
chooseImgSize size =
    label []
        [ input
            [ type_ "radio"
            , name "size"
            , onClick (ChangeSize size)
            ]
            []
        , text (sizeToString size)
        ]


sizeToString : ThumbnailSize -> String
sizeToString size =
    case size of
        Small ->
            "small"

        Medium ->
            "med"

        Large ->
            "large"


type alias FileName =
    String


type alias Thumbnail =
    { fileName : FileName }


type alias Model =
    { thumbnails : List Thumbnail, selectedThumbnail : Thumbnail, chosenSize : ThumbnailSize }


initialModel : Model
initialModel =
    { thumbnails =
        [ { fileName = "1.jpeg" }
        , { fileName = "2.jpeg" }
        , { fileName = "3.jpeg" }
        ]
    , selectedThumbnail =
        { fileName = "1.jpeg" }
    , chosenSize = Medium
    }


thumbnailArray : Array Thumbnail
thumbnailArray =
    Array.fromList initialModel.thumbnails


type ThumbnailSize
    = Small
    | Medium
    | Large


type Msg
    = ClickedSurpriseMe
    | ClickedThumbnail Thumbnail
    | ChangeSize ThumbnailSize


update : Msg -> Model -> Model
update msg model =
    case msg of
        ClickedSurpriseMe ->
            { model | selectedThumbnail = { fileName = "1.jpeg" } }

        ClickedThumbnail thumb ->
            { model | selectedThumbnail = thumb }

        ChangeSize size ->
            { model | chosenSize = size }


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
