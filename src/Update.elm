module Update exposing (..)

import Commands exposing (fetchTongues, postTongueEntity)
import Models exposing (Model)
import Msgs exposing (Msg)
import Routing exposing (parseLocation)
import RemoteData


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
-- fetch tongues
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

-- form inputs
        Msgs.OnInputId idValue ->
            let
                formValue =
                    case model.tongueForm of
                        Nothing -> Models.TongueForm idValue ""
                        Just value -> value
                newFormValue = { formValue | idValue = idValue }
            in
                ( { model | tongueForm = Just newFormValue }, Cmd.none )
        Msgs.OnInputDesc descValue ->
            let
                formValue =
                    case model.tongueForm of
                        Nothing -> Models.TongueForm "" descValue
                        Just value -> value
                newFormValue = { formValue | descValue = descValue }
            in
                ( { model | tongueForm = Just newFormValue }, Cmd.none )

        Msgs.OnAdd tongue ->
            let
                form = model.tongueForm
                tE =
                    case form of
                        Nothing -> Models.TongueEntity "" ""
                        Just value -> Models.TongueEntity value.idValue value.descValue
            in
                ( model, postTongueEntity tongue tE )

        Msgs.OnTongueEntitySave a ->
            ( model, Cmd.none )
