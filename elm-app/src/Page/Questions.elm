module Page.Questions exposing (Model, Msg, init, update, view)

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
import Html.Lazy exposing (lazy, lazy2)
import Data.Questions as Questions exposing (encodeNewAnswers)
import Data.Questions.Evaluation as Evaluation exposing (Evaluation)
import Data.Questions.Question as Question exposing (Question)
import Data.Suggest as Suggest exposing (suggestDecoder, Suggest)
import Request.Questions
import Task exposing (Task)
import Util exposing ((=>), pair, viewIf)
import Page.Errored exposing (PageLoadError, pageLoadError)
import Views.Page as Page


-- MODEL
--Estado de la aplicacion


type alias Model =
    { errors : List String
    , index : Int
    , errorMessage : Maybe String
    , suggestion : Suggest
    , answers : List Evaluation
    , questions : List Question
    }


init : Task PageLoadError Model
init =
    let
        loadQuestions =
            Request.Questions.questionsRequest
                |> Http.toTask

        handleLoadError _ =
            pageLoadError Page.Other "Questions is currently unavailable."
    in
        Task.map (Model [] 0 Nothing Suggest.empty []) loadQuestions
            |> Task.mapError handleLoadError



--VIEW


view : Model -> Html Msg
view model =
    div [ class "article-page" ]
        [ div [ class "container page" ]
            [ div [ class "row article-content" ]
                [ p [] [ text "De acuerdo a tu proyecto" ]
                , viewBody model
                ]
            ]
        ]


viewBody : Model -> Html Msg
viewBody model =
    let
        question =
            currentQuestion (List.head model.questions)
    in
        if question.question /= "" then
            div [ class "form-control-lg" ]
                [ h1 [ class "title" ] [ text question.criteria ]
                , Options.styled p
                    [ Typo.display2 ]
                    [ text question.question ]
                , div [] (List.map answer [ "Si", "No" ])
                ]
        else
            div []
                [ h1 [] [ text "" ]
                , h3 [ class "title" ] [ text "Respuestas" ]
                , div [] (List.map viewKeyedAnswer model.answers)
                , button [ onClick (Suggest model.answers) ] [ text "Sugerir metodología" ]
                , h1 [] [ text (toString model.suggestion.name) ]
                , h2 [] [ text (toString model.suggestion.score) ]
                ]



-- Boton pregunta


answer : String -> Html Msg
answer answer =
    button [ onClick (CheckAnswer answer) ] [ text answer ]



-- Mostrar la siguiente pregunta


currentQuestion : Maybe Question -> Question
currentQuestion question =
    case question of
        Just question ->
            question

        Nothing ->
            { id = ""
            , question = ""
            , criteria = ""
            }



-- Vista provisional para mostrar las id pregunta y su respuesta


viewKeyedAnswer : Evaluation -> Html Msg
viewKeyedAnswer evaluations =
    (lazy viewAnswer evaluations)


viewAnswer : Evaluation -> Html Msg
viewAnswer evaluations =
    li [] [ text (evaluations.idQuestion ++ "==" ++ (toString evaluations.value)) ]


saveSuggestRequest : List Evaluation -> Http.Request Suggest
saveSuggestRequest listEvaluation =
    let
        url =
            "http://localhost:3000/suggest"

        -- "http://192.168.10.11:8088/suggest"
        --, url = "https://private-anon-7a05ca6d76-selectormetodologias1.apiary-mock.com/suggest"
    in
        -- Evaluation: idQuestion String | value Int
        Http.post url (Http.jsonBody (encodeNewAnswers listEvaluation)) Suggest.suggestDecoder


createdSuggestMsg : List Evaluation -> Cmd Msg
createdSuggestMsg listEvaluation =
    Http.send CreatedSuggestMsg (saveSuggestRequest listEvaluation)



-- UPDATE
{- Los usuarios de la aplicacion pueden enviar el mensaje
   seleccionando la respuesta, esta accion alimenta el update mostrando la
   siguiente pregunta a responder
-}


type Msg
    = DismissErrors
      --  | ProcessQuestionRequest (Result Http.Error ())
    | CheckAnswer String
    | CreatedSuggestMsg (Result Http.Error Suggest.Suggest)
    | Suggest (List Evaluation)



--  | CreatedSuggestMsg (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DismissErrors ->
            { model | errors = [] } => Cmd.none

        CheckAnswer answer ->
            ( let
                question =
                    currentQuestion (List.head model.questions)
              in
                { model
                    | questions = List.drop 1 model.questions
                    , answers =
                        if answer == "Si" then
                            model.answers ++ [ newAnswer question.id 1 ]
                        else
                            model.answers ++ [ newAnswer question.id 0 ]
                }
            , Cmd.none
            )

        Suggest respuestas ->
            ( model, createdSuggestMsg respuestas )

        CreatedSuggestMsg (Ok suggest) ->
            { model | suggestion = suggest } ! []

        CreatedSuggestMsg (Err error) ->
            { model
                | errorMessage = Just (createErrorMessage error)
            }
                ! []


newAnswer : String -> Int -> Evaluation
newAnswer idQuestion value =
    { idQuestion = idQuestion
    , value = value
    }



-- Tipificar los mensajes para poder mostrar la causa del error


createErrorMessage : Http.Error -> String
createErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "It appears you don't have an Internjjjet connection right now."

        Http.BadStatus response ->
            response.status.message

        Http.BadPayload message response ->
            message
