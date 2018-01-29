module View exposing (..)

import Html exposing (Html, div, text, ul, li, a, form, input, textarea, button)
import Html.Attributes exposing (class, href, name, type_, value)
import Html.Events exposing (onInput, onClick, onWithOptions)
import Models exposing (Model)
import Msgs exposing (Msg)
import Json.Decode as Decode
import RemoteData


view : Model -> Html Msg
view model =
    div []
        [ page model ]


page : Model -> Html Msg
page model =
    case model.route of
        Models.HomeRoute ->
            div [] [ mainMenu ]

        Models.TonguesRoute ->
            div [] [ tonguesList model.tongues ]

        Models.TongueRoute id ->
            tonguePage id model.tongueEntities

        Models.CoursesRoute ->
            courseForm model.courseForm

        Models.CourseRoute id ->
            notFoundView

        Models.NotFoundRoute ->
            notFoundView


mainMenu : Html msg
mainMenu =
    ul []
        [ li [] [ simpleLink "tongues" "tongues" ]
        , li [] [ simpleLink "courses" "courses" ]
        ]


tonguesList : RemoteData.WebData (List Models.TongueId) -> Html msg
tonguesList tongues =
    case tongues of
        RemoteData.NotAsked ->
            text "?"

        RemoteData.Loading ->
            text "Loading"

        RemoteData.Success data ->
            div []
                [ text "Tongues"
                , ul [] (List.map (\t -> li [] [ (simpleLink ("tongue/" ++ t) t) ]) data)
                ]

        RemoteData.Failure error ->
            text ("Error" ++ toString error)


tonguePage : String -> RemoteData.WebData (List Models.TongueEntityId) -> Html Msg
tonguePage id entities =
    div []
        [ tongueForm id
        , tongueEntitiesList id entities
        ]


tongueForm : String -> Html Msg
tongueForm id =
    form []
        [ div []
            [ text "id"
            , input [ name "id", onInput Msgs.OnInputId ] []
            ]
        , div []
            [ text "definitions"
            , textarea [ name "definitions", onInput Msgs.OnInputDesc ] []
            ]
        , div []
            [ button
                [ onWithOptions
                    "click"
                    { stopPropagation = True
                    , preventDefault = True
                    }
                    (Decode.succeed (Msgs.OnAdd id))
                ]
                [ text "add" ]
            ]
        ]


tongueEntitiesList id entities =
    div []
        [ text "List"
        , case entities of
            RemoteData.NotAsked ->
                text "?"

            RemoteData.Loading ->
                text "Loading"

            RemoteData.Success data ->
                div []
                    [ text "Entities"
                    , ul [] (List.map (\t -> li [] [ text t ]) data)
                    ]

            RemoteData.Failure error ->
                text ("Error" ++ toString error)
        ]


courseForm : Models.CourseForm -> Html Msg
courseForm formData =
    form []
        [ div []
            [ text "id"
            , input [ name "id", onInput (Msgs.OnInputCourseField "id") ] []
            ]
        , div []
            [ text "description"
            , textarea [ name "desc", onInput (Msgs.OnInputCourseField "desc") ] []
            ]
        , div []
            [ text "tags"
            , input [ name "tags", onInput (Msgs.OnInputCourseField "tags") ] []
            ]
        , div []
            [ text "Content"
            , div []
                (List.indexedMap (\i t -> courseTaskItem i t) formData.content)
            , button [ type_ "button", onClick (Msgs.OnCourseTaskAdd "add") ]
                [ text "+" ]
            ]
        , div []
            [ button
                [ onWithOptions
                    "click"
                    { stopPropagation = True
                    , preventDefault = True
                    }
                    (Decode.succeed (Msgs.OnCourseAdd "add"))
                , type_ "button"
                ]
                [ text "add" ]
            ]
        ]


courseTaskItem index task =
    div []
        [ div []
            [ text "tongue"
            , input [ value task.tongue, onInput (Msgs.OnInputCourseTaskField index "tongue") ] []
            ]
        , div []
            [ text "id"
            , input [ onInput (Msgs.OnInputCourseTaskField index "id") ] []
            ]
        ]


simpleLink : String -> String -> Html msg
simpleLink hrefVal textVal =
    a [ href ("#" ++ hrefVal) ] [ text textVal ]


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]
