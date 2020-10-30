module PhotoGroove exposing (Msg, main)

import Array exposing (Array)
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Random


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


randomPhotoPicker : Random.Generator Int
randomPhotoPicker =
    Random.int 0 (Array.length thumbnailArray - 1)


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
    | GotSelectedIndex Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedSurpriseMe ->
            ( model, Random.generate GotSelectedIndex randomPhotoPicker )

        ClickedThumbnail thumb ->
            ( { model | selectedThumbnail = thumb }, Cmd.none )

        ChangeSize size ->
            ( { model | chosenSize = size }, Cmd.none )

        GotSelectedIndex index ->
            ( { model | selectedThumbnail = getThumbnail index model.selectedThumbnail }, Cmd.none )


getThumbnail : Int -> Thumbnail -> Thumbnail
getThumbnail index defaultThumbnail =
    let
        maybeThumbnail =
            Array.get index thumbnailArray
    in
    case maybeThumbnail of
        Just thumb ->
            thumb

        Nothing ->
            defaultThumbnail


actions : { clickedThumbnailAction : Action }
actions =
    { clickedThumbnailAction = "wtf"
    }


main : Program () Model Msg
main =
    Browser.element
        { init = \flags -> ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        }
