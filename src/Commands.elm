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


fetchTongueEntities : String -> Cmd Msg
fetchTongueEntities tongue =
    Http.get (fetchTongueEntitiesUrl tongue) tongueEntitiesDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchTongueEntities


fetchTonguesUrl : String
fetchTonguesUrl =
    "http://localhost:9090/tongues"


fetchTongueEntitiesUrl : String -> String
fetchTongueEntitiesUrl tongue =
    "http://localhost:9090/tongue/" ++ tongue


tonguesDecoder : Decode.Decoder (List Models.TongueId)
tonguesDecoder =
    Decode.at [ "data" ] (Decode.list Decode.string)


tongueEntitiesDecoder : Decode.Decoder (List String)
tongueEntitiesDecoder =
    Decode.at [ "data" ] (Decode.list Decode.string)



-- tongueEntities


postTongueEntityRequest : String -> Models.TongueEntity -> Http.Request Models.TongueEntity
postTongueEntityRequest tongue tongueEntity =
    Http.request
        { body = tongueEntityEncoder tongueEntity |> Http.jsonBody
        , expect = Http.expectJson tongueEntityDecoder
        , headers = []
        , method = "POST"
        , timeout = Nothing
        , url = tongueEntityUrl tongue tongueEntity.id
        , withCredentials = False
        }


postTongueEntity : String -> Models.TongueEntity -> Cmd Msg
postTongueEntity tongue tongueEntity =
    postTongueEntityRequest tongue tongueEntity
        |> Http.send Msgs.OnTongueEntitySave


tongueEntityUrl : String -> String -> String
tongueEntityUrl tongue id =
    "http://localhost:9090/tongue" ++ "/" ++ tongue ++ "/" ++ id


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



-- courses


postCourseRequest : Models.CourseForm -> Http.Request Models.CourseObj
postCourseRequest courseData =
    Http.request
        { body = courseEncoder courseData |> Http.jsonBody
        , expect = Http.expectJson courseDecoder
        , headers = []
        , method = "POST"
        , timeout = Nothing
        , url = courseUrl courseData.id
        , withCredentials = False
        }


postCourse : Models.CourseForm -> Cmd Msg
postCourse courseData =
    postCourseRequest courseData
        |> Http.send Msgs.OnCourseSave


courseUrl courseId =
    "http://localhost:9090/course/" ++ courseId


courseDecoder : Decode.Decoder Models.CourseObj
courseDecoder =
    decode Models.CourseObj
        |> required "id" Decode.string
        |> required "description" Decode.string


courseEncoder : Models.CourseForm -> Encode.Value
courseEncoder courseData =
    let
        attributes =
            [ ( "id", Encode.string courseData.id )
            , ( "description", Encode.string courseData.desc )
            , ( "tags", Encode.string courseData.tags )
            , ( "content", Encode.list (List.map taskEncoder courseData.content) )
            ]
    in
        Encode.object attributes


taskEncoder task =
    let
        attributes =
            [ ( "id", Encode.string task.id )
            , ( "tongue", Encode.string task.tongue )
            , ( "type", Encode.string task.taskType )
            ]
    in
        Encode.object attributes
