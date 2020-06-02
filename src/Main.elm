module Main exposing (main)

import Browser
import Html exposing (Html, button, div, img, li, main_, text, ul)
import Html.Attributes exposing (class, src)
import Html.Events exposing (onClick)
import Http
import Json.Decode as JD



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { currentDogUrl : String
    , favoriteDogs : List String
    }


getRandomDog : Cmd Msg
getRandomDog =
    Http.get
        { url = "https://dog.ceo/api/breeds/image/random"
        , expect = Http.expectJson GotRandomDog (JD.field "message" JD.string)
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { currentDogUrl = "", favoriteDogs = [] }, getRandomDog )



-- UPDATE


type Msg
    = NextDog
    | GotRandomDog (Result Http.Error String)
    | AddFavoriteDogs
    | RemoveDog String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NextDog ->
            ( model, getRandomDog )

        GotRandomDog result ->
            case result of
                Ok dogUrl ->
                    ( { model | currentDogUrl = dogUrl }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        AddFavoriteDogs ->
            if not <| List.member model.currentDogUrl model.favoriteDogs then
                ( { model | favoriteDogs = model.currentDogUrl :: model.favoriteDogs }, Cmd.none )

            else
                ( model, Cmd.none )

        RemoveDog removeDog ->
            ( { model | favoriteDogs = List.filter (\dog -> removeDog /= dog) model.favoriteDogs }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    main_ [ class "dogs-layout" ]
        [ div []
            [ img [ src model.currentDogUrl ] []
            , button [ onClick AddFavoriteDogs ] [ text "❤️" ]
            , button [ onClick NextDog ] [ text "=>️" ]
            ]
        , div []
            [ ul [] <|
                List.map
                    (\dogUrl ->
                        li []
                            [ img [ src dogUrl ] []
                            , button [ onClick <| RemoveDog dogUrl ] [ text "🗑" ]
                            ]
                    )
                    (List.reverse model.favoriteDogs)
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
