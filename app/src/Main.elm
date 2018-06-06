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
import Html.Lazy exposing (lazy, lazy2)
import Json.Encode as Encode
import Json.Decode


main : Program Config Model Msg
main =
    Html.programWithFlags
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }


init : Config -> ( Model, Cmd Msg )
init config =
    ( initialModel config, questionsRequest config )


initialModel : Config -> Model
initialModel config =
    { index = 0
    , questions = []
    , answers = []
    , score = ""
    , mdl = Material.model
    , errorMessage = Nothing
    , config = config
    }



-- API
-- Consumir recurso questions para mostrar preguntas para realizar la evaluacion


questionListDecoder : Json.Decode.Decoder (List Questions)
questionListDecoder =
    Json.Decode.list questionDecoder


questionDecoder : Json.Decode.Decoder Questions
questionDecoder =
    Json.Decode.Pipeline.decode Questions
        |> Json.Decode.Pipeline.required "id" Json.Decode.string
        |> Json.Decode.Pipeline.required "question" Json.Decode.string
        |> Json.Decode.Pipeline.required "criteria" Json.Decode.string


questionsRequest : Config -> Cmd Msg
questionsRequest config =
    let
        url =
            config.api_url ++ "/questions"
    in
        Http.send ProcessQuestionRequest
            (Http.get url questionListDecoder)


encodeNewAnswers : List Evaluation -> Encode.Value
encodeNewAnswers listsAnswers =
    Encode.list (List.map encodeNewAnswer listsAnswers)


encodeNewAnswer : Evaluation -> Encode.Value
encodeNewAnswer evaluation =
    let
        object =
            [ ( "question", Encode.string evaluation.idQuestion )
            , ( "value", Encode.int evaluation.value )
            ]
    in
        Encode.object object


saveSuggestRequest : Config -> List Evaluation -> Http.Request String
saveSuggestRequest config listEvaluation =
    Http.request
        { --body = encodeNewAnswers listEvaluation |> Http.jsonBody
          body = Http.emptyBody
        , expect = Http.expectString
        , headers = []
        , method = "POST"
        , timeout =
            Nothing
        , url =
            config.api_url ++ "/suggest"
            --, url = "https://private-anon-7a05ca6d76-selectormetodologias1.apiary-mock.com/suggest"
        , withCredentials = False
        }


createdSuggestMsg : Config -> List Evaluation -> Cmd Msg
createdSuggestMsg config listEvaluation =
    Http.send CreatedSuggestMsg (saveSuggestRequest config listEvaluation)



-- MODEL
--Estado de la aplicacion


type alias Model =
    { index : Int
    , questions : List Questions
    , answers : List Evaluation
    , score : String
    , mdl : Material.Model
    , errorMessage : Maybe String
    , config : Config
    }


type alias Questions =
    { id : String
    , question : String
    , criteria : String
    }


type alias Evaluation =
    { idQuestion : String
    , value : Int
    }


type alias Mdl =
    Material.Model


type alias Config =
    { api_url : String
    }


type alias Links =
    { href : String
    , rel : String
    , tipo : String
    }


newAnswer : String -> Int -> Evaluation
newAnswer idQuestion value =
    { idQuestion = idQuestion
    , value = value
    }



-- UPDATE
{- Los usuarios de la aplicacion pueden enviar el mensaje
   seleccionando la respuesta, esta accion alimenta el update mostrando la
   siguiente pregunta a responder
-}


type Msg
    = Mdl (Material.Msg Msg)
    | ProcessQuestionRequest (Result Http.Error (List Questions))
    | CheckAnswer String
    | CreatedSuggestMsg (Result Http.Error String)
    | Suggest (List Evaluation)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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
                            model.answers
                }
            , Cmd.none
            )

        Suggest respuestas ->
            ( model, createdSuggestMsg model.config respuestas )

        CreatedSuggestMsg (Ok a) ->
            { model | score = a } ! []

        CreatedSuggestMsg (Err error) ->
            { model
                | errorMessage = Just (createErrorMessage error)
            }
                ! []

        ProcessQuestionRequest (Ok questions) ->
            { model | questions = questions } ! []

        ProcessQuestionRequest (Err error) ->
            { model
                | errorMessage = Just (createErrorMessage error)
            }
                ! []

        Mdl msg_ ->
            Material.update Mdl msg_ model



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



--VIEW


view : Model -> Html Msg
view model =
    Material.Scheme.topWithScheme
        Color.Grey
        Color.Indigo
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
            , main = [ viewErrorMessage model.errorMessage, viewBody model ]
            }



-- Vista del contenido principal la pregunta y la respuesta


viewBody : Model -> Html Msg
viewBody model =
    let
        question =
            currentQuestion (List.head model.questions)
    in
        if question.question /= "" then
            div []
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
                , h1 [] [ text (toString model.score) ]
                ]



-- Mostrar la siguiente pregunta


currentQuestion : Maybe Questions -> Questions
currentQuestion question =
    case question of
        Just question ->
            question

        Nothing ->
            { id = ""
            , question = ""
            , criteria = ""
            }



-- Boton pregunta


answer : String -> Html Msg
answer answer =
    button [ onClick (CheckAnswer answer) ] [ text answer ]



-- Vista provisional para mostrar las id pregunta y su respuesta


viewKeyedAnswer : Evaluation -> Html Msg
viewKeyedAnswer evaluations =
    (lazy viewAnswer evaluations)


viewAnswer : Evaluation -> Html Msg
viewAnswer evaluations =
    li [] [ text (evaluations.idQuestion ++ "==" ++ (toString evaluations.value)) ]



-- Vista para mostrar el mensaje de error


viewErrorMessage : Maybe String -> Html msg
viewErrorMessage errorMessage =
    case errorMessage of
        Just message ->
            div [ class "error" ] [ text message ]

        Nothing ->
            text ""
