port module Main exposing (main)

import Browser
import Debug exposing (log)
import Html exposing (Html, button, div, p, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as E


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Clicker =
    { description : String
    , name : String
    , price : Int
    , rate : Int
    , sku : String
    }


type alias GameUpdate =
    { store : Store
    , clickers : List Clicker
    }


type alias Store =
    { clickers : List Clicker }


emptyStore =
    { clickers = []
    }


type alias Model =
    { clicks : Int
    , store : Store
    , clickers : List Clicker
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { clicks = 0
      , clickers = []
      , store =
            { clickers = []
            }
      }
    , Cmd.none
    )



-- Decoders


decodeGameUpdate : E.Value -> GameUpdate
decodeGameUpdate payload =
    case Decode.decodeValue gameUpdateDecoder payload of
        Ok val ->
            val

        Err message ->
            let
                x =
                    log "failed" message
            in
            { store = { clickers = [] }
            , clickers = []
            }


gameUpdateDecoder : Decode.Decoder GameUpdate
gameUpdateDecoder =
    Decode.map2 GameUpdate
        (Decode.field "store" storeDecoder)
        (Decode.field "clickers" (Decode.list clickerDecoder))


storeDecoder : Decode.Decoder Store
storeDecoder =
    Decode.map Store (Decode.field "clickers" (Decode.list clickerDecoder))


clickerDecoder : Decode.Decoder Clicker
clickerDecoder =
    Decode.map5 Clicker
        (Decode.field "description" Decode.string)
        (Decode.field "name" Decode.string)
        (Decode.field "price" Decode.int)
        (Decode.field "rate" Decode.int)
        (Decode.field "sku" Decode.string)


type Msg
    = UpdateClicks Int
    | ReciveClicks E.Value
    | ReciveGameUpdates E.Value
    | Buy Clicker


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ReciveClicks value ->
            case Decode.decodeValue (Decode.field "clicks" Decode.int) value of
                Ok num ->
                    ( { model | clicks = num }, Cmd.none )

                Err e ->
                    ( model, Cmd.none )

        ReciveGameUpdates value ->
            let
                decodedVal =
                    decodeGameUpdate value
            in
            ( { model
                | store = decodedVal.store
                , clickers = decodedVal.clickers
              }
            , Cmd.none
            )

        UpdateClicks c ->
            ( { model | clicks = c }, clickPort () )

        Buy c ->
            ( model, buyPort (E.string c.sku) )


click : Model -> Msg
click model =
    UpdateClicks (model.clicks + 1)



-- PORTS


port clickPort : () -> Cmd msg


port buyPort : E.Value -> Cmd msg


port inboudClickPort : (E.Value -> msg) -> Sub msg


port inboudGameUpdatePort : (E.Value -> msg) -> Sub msg



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ inboudClickPort ReciveClicks
        , inboudGameUpdatePort ReciveGameUpdates
        ]



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ p [] [ text ("Clicks:" ++ String.fromInt (clickCountWithDebt model)) ]
        , button [ class "btn", onClick (click model) ] [ text "Click" ]
        , p [ class "mt-8 mb-2" ] [ text "Clickers:" ]
        , div [] (List.map (\c -> viewClicker c) model.clickers)
        , p [ class "mt-8 mb-2" ] [ text "Store:" ]
        , div [] (List.map (\c -> viewStoreClicker c) model.store.clickers)
        ]


clickCountWithDebt : Model -> Int
clickCountWithDebt model =
    model.clicks - List.foldl (\x acc -> x.price + acc) 0 model.clickers


viewClicker : Clicker -> Html Msg
viewClicker c =
    div [ class "flex" ]
        [ p [] [ text (c.name ++ "s:") ]
        , p [ class "ml-2" ] [ text ("clicks / sec: " ++ String.fromInt c.rate) ]
        ]


viewStoreClicker : Clicker -> Html Msg
viewStoreClicker c =
    div [ class "flex" ]
        [ div [ class "mr-4 w-1/4" ]
            [ p [] [ text c.name ]
            , p [ class "text-gray-600 text-sm" ] [ text c.description ]
            ]
        , div [ class "w-32" ] [ p [] [ text ("cost:" ++ String.fromInt c.price) ] ]
        , button [ class "btn mt-0 mb-4", onClick (Buy c) ] [ text "Buy" ]
        ]
