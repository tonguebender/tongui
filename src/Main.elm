module Main exposing (..)

import Commands exposing (fetchTongues, fetchTongueEntities)
import Models exposing (Model, initialModel)
import Msgs exposing (Msg)
import Navigation exposing (Location)
import Update exposing (update)
import View exposing (view)
import Routing


init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
            Routing.parseLocation location
    in
        case currentRoute of
            Models.TonguesRoute ->
                ( initialModel currentRoute, fetchTongues )

            Models.TongueRoute tongue ->
                ( initialModel currentRoute, fetchTongueEntities tongue )

            _ ->
                ( initialModel currentRoute, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Never Model Msg
main =
    Navigation.program Msgs.OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
