module Page.Welcome exposing (Model, Msg, initialModel, update, view)

import Data.Feedback exposing (Feedback)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing (Decoder, decodeString, field, string)
import Json.Decode.Pipeline exposing (decode, optional)
import Request.Feedback exposing (postFeedback)
import Route exposing (Route)
import Util exposing ((=>))
import Validate exposing (Validator, ifBlank, validate)
import Views.Form as Form


-- MODEL --


type alias Model =
    { errors : List Error
    , email : String
    , institution :
        String

    -- TODO Make createdAt a Date rather than a String
    , createdAt : String
    , finished : Bool
    , description : String
    }


initialModel : Model
initialModel =
    { errors = []
    , email = ""
    , institution = ""
    , createdAt = ""
    , finished = True
    , description = ""
    }



-- VIEW --


view : Model -> Html Msg
view model =
    div [ class "auth-page" ]
        [ div [ class "container page" ]
            [ div [ class "row" ]
                [ div [ class "col-md-6 offset-md-3 col-xs-12" ]
                    [ h1 [ class "text-xs-center" ] [ text "Bienvenido" ]
                    , Form.viewErrors model.errors
                    , welcomeMessage
                    , viewForm
                    ]
                ]
            ]
        ]


welcomeMessage : Html Msg
welcomeMessage =
    article []
        [ p []
            [ text """
                   El selector de metodologías te permite recibir una
                   recomendación sobre que metodología de desarrollo de software
                   utilizar según las necesidades de tu proyecto.
                   """
            ]
        , p []
            [ text """
                   Esta herramienta es de libre acceso. Para fines de obtener
                   retroalimentación de la utilización de la herramienta
                   solicitamos tu institución de origen y un correo electrónico.
                   """
            ]
        ]


viewForm : Html Msg
viewForm =
    Html.form [ onSubmit SubmitForm ]
        [ Form.input
            [ class "form-control-lg"
            , placeholder "institution"
            , onInput SetFeedbackInstitute
            ]
            []
        , Form.input
            [ class "form-control-lg"
            , placeholder "Email"
            , onInput SetFeedbackEmail
            ]
            []
        , button [ class "btn btn-lg btn-primary pull-xs-right" ]
            [ text "Comenzar cuestionario" ]
        ]



-- UPDATE --


type Msg
    = SubmitForm
    | SetFeedbackInstitute String
    | SetFeedbackEmail String
    | HandlePostFeedbackResponse (Result Http.Error Feedback)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmitForm ->
            case validate modelValidator model of
                [] ->
                    { model | errors = [] }
                        => Http.send HandlePostFeedbackResponse (Request.Feedback.postFeedback model)

                errors ->
                    { model | errors = errors }
                        => Cmd.none

        SetFeedbackEmail email ->
            { model | email = email }
                => Cmd.none

        SetFeedbackInstitute institution ->
            { model | institution = institution }
                => Cmd.none

        HandlePostFeedbackResponse (Err error) ->
            let
                errorMessages =
                    case error of
                        Http.BadStatus response ->
                            response.body
                                |> decodeString (field "errors" errorsDecoder)
                                |> Result.withDefault []

                        _ ->
                            [ "unable to process" ]
            in
                { model | errors = List.map (\errorMessage -> Form => errorMessage) errorMessages }
                    => Cmd.none

        HandlePostFeedbackResponse (Ok _) ->
            model => Route.modifyUrl Route.Questions



-- VALIDATION --


type Field
    = Form
    | Institution
    | Email


type alias Error =
    ( Field, String )


modelValidator : Validator Error Model
modelValidator =
    Validate.all
        [ ifBlank .institution (Institution => "institute can't be blank.")
        , ifBlank .email (Email => "email can'tr be blank.")
        ]


errorsDecoder : Decoder (List String)
errorsDecoder =
    decode (\institution email -> List.concat [ institution, email ])
        |> optionalError "institution"
        |> optionalError "email"


optionalError : String -> Decoder (List String -> a) -> Decoder a
optionalError fieldName =
    let
        errorToString errorMessage =
            String.join " " [ fieldName, errorMessage ]
    in
        optional fieldName (Decode.list (Decode.map errorToString string)) []
