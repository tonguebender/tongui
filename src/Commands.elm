module Commands exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode
import Msgs exposing (Msg)
import Models
import RemoteData

-- tongues

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


-- tongueEntities

postTongueEntityRequest : String -> Models.TongueEntity -> Http.Request Models.TongueEntity
postTongueEntityRequest tongue tongueEntity =
    Http.request
        { body = tongueEntityEncoder tongueEntity |> Http.jsonBody
        , expect = Http.expectJson tongueEntityDecoder
        , headers = []
        , method = "POST"
        , timeout = Nothing
        , url = tongueEntityUrl tongue
        , withCredentials = False
        }

postTongueEntity : String -> Models.TongueEntity -> Cmd Msg
postTongueEntity tongue tongueEntity =
    postTongueEntityRequest tongue tongueEntity
        |> Http.send Msgs.OnTongueEntitySave

tongueEntityUrl : String -> String
tongueEntityUrl id =
    "http://localhost:4000/tongues" ++ "/" ++ id

tongueEntityDecoder : Decode.Decoder Models.TongueEntity
tongueEntityDecoder =
    decode Models.TongueEntity
        |> required "id" Decode.string
        |> required "description" Decode.string

tongueEntityEncoder : Models.TongueEntity -> Encode.Value
tongueEntityEncoder tongueEntity =
    let
        attributes =
            [ ( "id", Encode.string tongueEntity.id )
            , ( "description", Encode.string tongueEntity.desc )
            ]
    in
        Encode.object attributes