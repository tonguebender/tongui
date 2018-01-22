module Models exposing (..)

import RemoteData exposing (WebData)


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
    { idValue : String
    , descValue : String
    , tags : String
    , content : List CourseTask
    }


type alias CourseTask =
    { id : String
    , tongue : String
    , taskType : String
    }


type Route
    = HomeRoute
    | TonguesRoute
    | TongueRoute TongueId
    | CoursesRoute
    | CourseRoute CourseId
    | NotFoundRoute
