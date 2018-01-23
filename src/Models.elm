module Models exposing (..)

import RemoteData exposing (WebData)


type Route
    = HomeRoute
    | TonguesRoute
    | TongueRoute TongueId
    | CoursesRoute
    | CourseRoute CourseId
    | NotFoundRoute


type alias Model =
    { route : Route
    , tongues : WebData (List TongueId)
    , tongueForm : Maybe TongueForm
    , courseForm : CourseForm
    }


initialModel : Route -> Model
initialModel route =
    { route = route
    , tongues = RemoteData.NotAsked
    , tongueForm = Nothing
    , courseForm = CourseForm "" "" "" [ CourseTask "" "" "" ]
    }


type alias Tongue =
    { id : TongueId
    }


type alias TongueId =
    String


type alias CourseId =
    String


type alias TongueForm =
    { idValue : String
    , descValue : String
    }


type alias TongueEntity =
    { id : String
    , desc : String
    }


type alias CourseForm =
    { id : String
    , desc : String
    , tags : String
    , content : List CourseTask
    }


type alias CourseTask =
    { id : String
    , tongue : String
    , taskType : String
    }

type alias CourseObj =
    { id : String
    , description : String
    }



-- helpers


updateCourseFormField : String -> String -> Model -> Model
updateCourseFormField name value model =
    let
        formValue =
            model.courseForm

        newFormValue =
            case name of
                "id" ->
                    { formValue | id = value }

                "desc" ->
                    { formValue | desc = value }

                "tags" ->
                    { formValue | tags = value }

                _ ->
                    formValue
    in
        { model | courseForm = newFormValue }


updateCourseTaskFormField : Int -> String -> String -> Model -> Model
updateCourseTaskFormField indexToUpdate name value model =
    let
        fromValue =
            model.courseForm

        tasks =
            model.courseForm.content

        changeTaskValue task =
            case name of
                "id" ->
                    { task | id = value }

                "tongue" ->
                    { task | tongue = value }

                _ ->
                    task

        changeValue index task =
            if index == indexToUpdate then
                changeTaskValue task
            else
                task

        newTasks =
            List.indexedMap changeValue tasks

        newFormValue =
            { fromValue | content = newTasks }
    in
        { model | courseForm = newFormValue }
