module Commands exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode
import Msgs exposing (Msg)
import Models
import RemoteData


fetchTongues : Cmd Msg
fetchTongues =
    Http.get fetchTonguesUrl tonguesDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchTongues


fetchTonguesUrl : String
fetchTonguesUrl =
    "http://localhost:4000/tongues"

tonguesDecoder : Decode.Decoder (List Models.TongueId)
tonguesDecoder =
    Decode.list Decode.string

