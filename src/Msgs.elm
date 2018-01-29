module Msgs exposing (..)

import Http
import Models exposing (Model)
import Navigation exposing (Location)
import RemoteData exposing (WebData)


type Msg
    = OnFetchTongues (WebData (List Models.TongueId))
    | OnFetchTongueEntities (WebData (List Models.TongueEntityId))
    | OnLocationChange Location
    | OnInputId String
    | OnInputDesc String
    | OnAdd String
    | OnTongueEntitySave (Result Http.Error Models.TongueEntity)
    | OnInputCourseField String String
    | OnInputCourseTaskField Int String String
    | OnCourseTaskAdd String
    | OnCourseAdd String
    | OnCourseSave (Result Http.Error Models.CourseObj)
