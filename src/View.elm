module View exposing (..)

import Html exposing (Html, div, text, ul, li, a, form, input, textarea, button)
import Html.Attributes exposing (class, href, name)
import Html.Events exposing (onInput, onWithOptions)
import Models exposing (..)
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
            notFoundView

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


tonguesList : RemoteData.WebData (List TongueId) -> Html msg
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


simpleLink : String -> String -> Html msg
simpleLink hrefVal textVal =
    a [ href ("#" ++ hrefVal) ] [ text textVal ]


notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]
