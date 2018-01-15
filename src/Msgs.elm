module Msgs exposing (..)

import Http
import Models exposing (TongueId)
import Navigation exposing (Location)
import RemoteData exposing (WebData)



type Msg
    = OnFetchTongues (WebData (List TongueId))
    | OnLocationChange Location


{--
type Msg
    = OnFetchPlayers (WebData (List Player))
    | OnLocationChange Location
    | ChangeLevel Player Int
    | OnPlayerSave (Result Http.Error Player)
--}