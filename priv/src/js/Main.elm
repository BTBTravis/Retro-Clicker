port module Main exposing (main)

import Browser
import Html exposing (Html, button, div, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Decode exposing (Value, decodeValue, field, int)
import Json.Encode as E


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { clicks : Int }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { clicks = 0 }, Cmd.none )



-- UPDATE


type Msg
    = UpdateClicks Int
    | ReciveClicks E.Value


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReciveClicks value ->
            case decodeValue (field "clicks" int) value of
                Ok num ->
                    ( { model | clicks = num }, Cmd.none )

                Err e ->
                    ( model, Cmd.none )

        UpdateClicks c ->
            ( { model | clicks = c }, clickPort () )


click : Model -> Msg
click model =
    UpdateClicks (model.clicks + 1)



-- PORTS


port clickPort : () -> Cmd msg


port inboudClickPort : (E.Value -> msg) -> Sub msg



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    inboudClickPort ReciveClicks



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ p [] [ text ("Clicks:" ++ String.fromInt model.clicks) ]
        , button [ class "btn", onClick (click model) ] [ text "Click" ]
        ]
