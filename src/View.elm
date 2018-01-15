module View exposing (..)

import Html exposing (Html, div, text, ul, li, a)
import Html.Attributes exposing (class, href)
import Models exposing (..)
import Msgs exposing (Msg)
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
            notFoundView

        Models.CoursesRoute ->
            notFoundView

        Models.CourseRoute id ->
            notFoundView

        Models.NotFoundRoute ->
            notFoundView

mainMenu: Html msg
mainMenu =
    ul []
        [ li [] [ a [ href "#tongues" ] [ text "tongues" ] ]
        , li [] [ a [ href "#courses" ] [ text "courses" ] ]
        ]

tonguesList: RemoteData.WebData (List TongueId) -> Html msg
tonguesList tongues =
    case tongues of
        RemoteData.NotAsked ->
            text "?"

        RemoteData.Loading ->
            text "Loading"

        RemoteData.Success data ->
            div []
                [ text "Data"
                , div [] (List.map (\t -> text (t ++ " ")) data)
                ]

        RemoteData.Failure error->
            text ("Error" ++ toString error)

notFoundView : Html msg
notFoundView =
    div []
        [ text "Not found"
        ]
