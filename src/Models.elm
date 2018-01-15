module Models exposing (..)

import RemoteData exposing (WebData)


type alias Model =
    { route : Route
    , tongues : WebData (List TongueId)
    }


initialModel : Route -> Model
initialModel route =
    { route = route
    , tongues = RemoteData.NotAsked
    }

type alias Tongue =
    { id: TongueId
    }

type alias TongueId =
    String

type alias CourseId =
    String

type Route
    = HomeRoute
    | TonguesRoute
    | TongueRoute TongueId
    | CoursesRoute
    | CourseRoute CourseId
    | NotFoundRoute
