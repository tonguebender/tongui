module Update exposing (..)

import Commands exposing (fetchTongues, fetchTongueEntities, postTongueEntity, postCourse)
import Models exposing (Model)
import Msgs exposing (Msg)
import Routing exposing (parseLocation)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                case newRoute of
                    Models.TonguesRoute ->
                        ( { model | route = newRoute }, fetchTongues )

                    Models.TongueRoute tongue ->
                        ( { model | route = newRoute }, fetchTongueEntities tongue )

                    _ ->
                        ( { model | route = newRoute }, Cmd.none )

        -- fetch tongues
        Msgs.OnFetchTongues response ->
            ( { model | tongues = response }, Cmd.none )

        Msgs.OnFetchTongueEntities response ->
            ( { model | tongueEntities = response }, Cmd.none )

        -- tongue form inputs
        Msgs.OnInputId idValue ->
            let
                formValue =
                    case model.tongueForm of
                        Nothing ->
                            Models.TongueForm idValue ""

                        Just value ->
                            value

                newFormValue =
                    { formValue | idValue = idValue }
            in
                ( { model | tongueForm = Just newFormValue }, Cmd.none )

        Msgs.OnInputDesc descValue ->
            let
                formValue =
                    case model.tongueForm of
                        Nothing ->
                            Models.TongueForm "" descValue

                        Just value ->
                            value

                newFormValue =
                    { formValue | descValue = descValue }
            in
                ( { model | tongueForm = Just newFormValue }, Cmd.none )

        Msgs.OnAdd tongue ->
            let
                form =
                    model.tongueForm

                tongueEntity =
                    case form of
                        Nothing ->
                            Models.TongueEntity "" ""

                        Just value ->
                            Models.TongueEntity value.idValue value.descValue
            in
                ( model, postTongueEntity tongue tongueEntity )

        Msgs.OnTongueEntitySave a ->
            ( model, fetchTongueEntities (Models.getTongue model.route) )

        -- courses form
        Msgs.OnInputCourseField name idValue ->
            ( Models.updateCourseFormField name idValue model, Cmd.none )

        Msgs.OnInputCourseTaskField index name idValue ->
            ( Models.updateCourseTaskFormField index name idValue model, Cmd.none )

        Msgs.OnCourseTaskAdd a ->
            let
                form =
                    model.courseForm

                taskList =
                    model.courseForm.content

                newList =
                    List.append taskList [ (Models.CourseTask "" "" "") ]

                newForm =
                    { form | content = newList }
            in
                ( { model | courseForm = newForm }, Cmd.none )

        Msgs.OnCourseAdd a ->
            ( model, postCourse model.courseForm )

        Msgs.OnCourseSave a ->
            ( model, Cmd.none )
