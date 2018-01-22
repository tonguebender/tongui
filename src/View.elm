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
            tongueForm id

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
                [ text "Data"
                , div [] (List.map (\t -> simpleLink ("tongue/" ++ t) t) data)
                ]

        RemoteData.Failure error ->
            text ("Error" ++ toString error)


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


courseForm : Models.CourseForm -> Html Msg
courseForm formData =
    form []
        [ div []
            [ text "id"
            , input [ name "id", onInput Msgs.OnInputId ] []
            ]
        , div []
            [ text "description"
            , textarea [ name "desc", onInput Msgs.OnInputDesc ] []
            ]
        , div []
            [ text "tags"
            , input [ name "tags", onInput Msgs.OnInputDesc ] []
            ]
        , div []
            [ text "Content"
            , div []
                (List.map (\t -> courseTaskItem t) formData.content)
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


courseTaskItem task =
    div []
        [ div []
            [ text "tongue"
            , input [ value task.tongue ] []
            ]
        , div []
            [ text "id"
            , input [] []
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
