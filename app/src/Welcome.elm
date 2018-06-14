module Main exposing (..)

import Http
import Json.Encode
import Json.Decode
import Json.Decode.Pipeline as Pipe
import Html exposing (..)
import Html.Attributes exposing (..)
import Material
import Material.Scheme
import Material.Color as Color
import Material.Button as Button
import Material.Layout as Layout
import Material.Elevation as Elevation
import Material.Grid as Grid exposing (..)
import Material.Options as Options exposing (css)
import Material.Typography as Typo
import Material.Textfield as Textfield


type alias Model =
    { index : Int
    , mdl : Material.Model
    , activePage : Int
    , feedback : Feedback
    }


type alias Feedback =
    { email : String
    , institution : String

    -- TODO Make createdAt a Date rather than a String
    , createdAt : String
    , finished : Bool
    , description : String
    }


initialModel : Model
initialModel =
    { index = 0
    , mdl = Material.model
    , activePage = 0
    , feedback = Feedback "" "" "" False ""
    }


type Msg
    = Mdl (Material.Msg Msg)
    | SetUserInstitute String
    | SetUserEmail String
    | CreateFeedback
      -- TODO Organize these Msg separately like Mdl does?
    | HandlePostFeedbackResponse (Result Http.Error Feedback)


feedbackDecoder : Json.Decode.Decoder Feedback
feedbackDecoder =
    Pipe.decode Feedback
        |> Pipe.required "email" Json.Decode.string
        |> Pipe.required "institution" Json.Decode.string
        |> Pipe.required "created_at" Json.Decode.string
        |> Pipe.required "finished" Json.Decode.bool
        |> Pipe.required "description" Json.Decode.string



-- TODO Define Encoders and Decoders for custom types in its own module


feedbackEncoder : Feedback -> Json.Encode.Value
feedbackEncoder feedback =
    Json.Encode.object <|
        [ ( "email", Json.Encode.string feedback.email )
        , ( "institution", Json.Encode.string feedback.institution )
        ]


postFeedback : Feedback -> Cmd Msg
postFeedback feedback =
    let
        url =
            "http://localhost:8000/feedback"
    in
        Http.send HandlePostFeedbackResponse <|
            Http.post url (Http.jsonBody (feedbackEncoder feedback)) feedbackDecoder


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model

        SetUserInstitute institute ->
            let
                feedback =
                    model.feedback

                newFeedback =
                    { feedback | institution = institute }
            in
                { model | feedback = newFeedback } ! []

        SetUserEmail email ->
            let
                feedback =
                    model.feedback

                newFeedback =
                    { feedback | email = email }
            in
                { model | feedback = newFeedback } ! []

        CreateFeedback ->
            ( model
            , postFeedback model.feedback
            )

        HandlePostFeedbackResponse result ->
            case result of
                Ok savedFeedback ->
                    { model | feedback = savedFeedback } ! []

                Err err ->
                    let
                        _ =
                            Debug.log "Couldn't post feedback!" err
                    in
                        ( model, Cmd.none )


view : Model -> Html Msg
view model =
    Material.Scheme.topWithScheme Color.Brown Color.DeepOrange <|
        Layout.render Mdl
            model.mdl
            [ Layout.fixedHeader
            ]
            { header = [ h3 [] [ text "Selector de Metodologías" ] ]

            -- [ Options.styled p
            --     [ Typo.display3 ]
            --     [ text "Bienvenido" ]
            -- ]
            , drawer = []
            , tabs = ( [], [] )
            , main =
                [ grid []
                    [ cell
                        [ Grid.size Tablet 8
                        , offset Tablet 2
                        , Grid.size Desktop 8
                        , offset Desktop 2
                        , Grid.size Phone 12
                        , offset Phone 0
                        ]
                        [ viewWelcome model ]
                    ]
                ]
            }


viewWelcome : Model -> Html Msg
viewWelcome model =
    Options.div
        [ Elevation.e6
        , css "margin-bottom" "20px"
        , css "padding" "20px"
        ]
        [ h3 [] [ text "Bienvenido!" ]
        , welcomeMessage
        , grid []
            [ cell
                [ Grid.size Desktop 6
                , Grid.size Tablet 6
                , Grid.size Phone 12
                ]
                [ inputUserInstitute model
                , inputUserEmail model
                ]
            ]
        , hr [] []
        , Button.render Mdl
            [ 0 ]
            model.mdl
            [ Button.colored
            , Options.onClick CreateFeedback
            ]
            [ text "Comenzar cuestionario" ]
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
                   solicitamos tu institución de origen y un correo electronico.
                   """
            ]
        ]


inputUserInstitute : Model -> Html Msg
inputUserInstitute model =
    Textfield.render Mdl
        [ 2 ]
        model.mdl
        [ Textfield.label "Institución de Origen"
        , Textfield.floatingLabel
        , Textfield.text_
        , Options.onInput SetUserInstitute
        , Options.attribute (required True)
        ]
        []


inputUserEmail : Model -> Html Msg
inputUserEmail model =
    Textfield.render Mdl
        [ 2 ]
        model.mdl
        [ Textfield.label "Correo electrónico"
        , Textfield.floatingLabel
        , Textfield.text_
        , Options.onInput SetUserEmail
        , Options.attribute (required True)
        ]
        []


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = ( initialModel, Cmd.none )
        , update = update
        , subscriptions = \_ -> Sub.none
        }
