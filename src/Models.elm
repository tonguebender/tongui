module Models exposing (..)

import RemoteData exposing (WebData)


type alias Model =
    { route : Route
    , tongues : WebData (List TongueId)
    , tongueForm : Maybe TongueForm
    }


initialModel : Route -> Model
initialModel route =
    { route = route
    , tongues = RemoteData.NotAsked
    , tongueForm = Nothing
    }

type alias Tongue =
    { id: TongueId
    }

type alias TongueId =
    String

type alias CourseId =
    String

type alias TongueForm =
    { idValue : String
    , descValue : String
    }

type Route
    = HomeRoute
    | TonguesRoute
    | TongueRoute TongueId
    | CoursesRoute
    | CourseRoute CourseId
    | NotFoundRoute
