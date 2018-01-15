module Update exposing (..)

import Commands exposing (fetchTongues)
import Models exposing (Model)
import Msgs exposing (Msg)
import Routing exposing (parseLocation)
import RemoteData


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.OnFetchTongues response ->
            ( { model | tongues = response }, Cmd.none )

        Msgs.OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                case newRoute of
                    Models.TonguesRoute ->
                        ( { model | route = newRoute }, fetchTongues )
                    _ ->
                        ( { model | route = newRoute }, Cmd.none )