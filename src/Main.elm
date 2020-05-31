module Main exposing (main)

import Browser
import Html exposing (Html, button, div, h1, img, main_, p, text)
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
    { currentDogUrl : String }


getRandomDog : Cmd Msg
getRandomDog =
    Http.get
        { url = "https://dog.ceo/api/breeds/image/random"
        , expect = Http.expectJson GotRandomDog (JD.field "message" JD.string)
        }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { currentDogUrl = "" }, getRandomDog )



-- UPDATE


type Msg
    = GotRandomDog (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotRandomDog result ->
            case result of
                Ok dogUrl ->
                    ( { model | currentDogUrl = dogUrl }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    main_ [ class "dogs-layout" ]
        [ img [ src model.currentDogUrl ] []
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
