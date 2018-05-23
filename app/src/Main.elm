module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes as Html
import Http
import Http exposing (get, Error, Response, Error(..))
import Material
import Material.Scheme
import Material.Options as Options exposing (css)
import Material.Layout as Layout
import Material.Color as Color
import Material.Typography as Typo
import Json.Decode exposing (int, string, float, nullable, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = ( initialModel, questionsRequest )
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- model


type alias Mdl =
    Material.Model


type alias Questions =
    { question : String
    , criteria : String
    }


type alias Model =
    { index : Int
    , questions : List Questions
    , score : Int
    , mdl : Material.Model
    }


initialModel : Model
initialModel =
    { index = 0
    , questions = []
    , score = 0
    , mdl = Material.model
    }


questionListDecoder : Json.Decode.Decoder (List Questions)
questionListDecoder =
    Json.Decode.list questionDecoder


questionDecoder : Json.Decode.Decoder Questions
questionDecoder =
    Json.Decode.Pipeline.decode Questions
        |> Json.Decode.Pipeline.required "question" Json.Decode.string
        |> Json.Decode.Pipeline.required "criteria" Json.Decode.string


questionsRequest : Cmd Msg
questionsRequest =
    let
        url =
            "http://localhost:3000/questions"
    in
        Http.send ProcessQuestionRequest
            (Http.get url questionListDecoder)



-- update


type Msg
    = Mdl (Material.Msg Msg)
    | ProcessQuestionRequest (Result Http.Error (List Questions))
    | CheckAnswer String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CheckAnswer answer ->
            ( let
                question =
                    currentQuestion (List.head model.questions)
              in
                { model
                    | index = model.index + 1
                    , questions = List.drop 1 model.questions
                    , score =
                        if answer == "Si" then
                            model.score + 1
                        else
                            model.score
                }
            , Cmd.none
            )

        ProcessQuestionRequest (Ok questions) ->
            { model | questions = questions } ! []

        ProcessQuestionRequest (Err error) ->
            Debug.crash "" error

        Mdl msg_ ->
            Material.update Mdl msg_ model



--view


view : Model -> Html Msg
view model =
    Material.Scheme.topWithScheme
        Color.Teal
        Color.Red
    <|
        Layout.render Mdl
            model.mdl
            [ Layout.fixedHeader
            , Layout.fixedDrawer
            ]
            { header =
                [ Options.styled p
                    [ Typo.display3 ]
                    [ text "Selector de Metodologías" ]
                ]
            , drawer =
                []
            , tabs = ( [], [] )
            , main = [ viewBody model ]
            }


viewBody : Model -> Html Msg
viewBody model =
    let
        question =
            currentQuestion (List.head model.questions)
    in
        if question.question /= "" then
            div []
                [ h1 [ class "title" ] [ text "Pregunta" ]
                , div [ class "question" ] [ text question.question ]
                , div [] (List.map answer [ "Si", "No" ])
                ]
        else
            div []
                [ h1 [ class "title" ] [ text "Metodología recomendada" ]
                , h3 [ class "title score" ] [ text ("Respuestas positivas " ++ (toString model.score)) ]
                ]


currentQuestion : Maybe Questions -> Questions
currentQuestion question =
    case question of
        Just question ->
            question

        Nothing ->
            { question = ""
            , criteria = ""
            }


answer : String -> Html Msg
answer answer =
    button [ onClick (CheckAnswer answer) ] [ text answer ]
