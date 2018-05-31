module Main exposing (..)

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
    }


initialModel : Model
initialModel =
    { index = 0
    , mdl = Material.model
    , activePage = 0
    }


type Msg
    = Mdl (Material.Msg Msg)
    | SetUserInstitute String
    | SetUserEmail String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model

        SetUserInstitute _ ->
            ( model, Cmd.none )

        SetUserEmail _ ->
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
            , tabs = ( [ text "Inicio", text "Metodologías" ], [] )
            , main =
                [ grid []
                    [ cell
                        [ Grid.size All 6, offset All 3 ]
                        [ viewBody model ]
                    ]
                ]
            }


viewBody : Model -> Html Msg
viewBody model =
    case model.activePage of
        0 ->
            viewWelcome model

        _ ->
            h1 [] [ text "404 Not Found" ]


viewWelcome : Model -> Html Msg
viewWelcome model =
    Options.div
        [ Elevation.e6
        , css "margin-bottom" "20px"
        , css "padding" "20px"
        ]
        [ h3 [] [ text "Bienvenido!" ]
        , welcomeMessage
        , inputUserInstitute model
        , inputUserEmail model
        , hr [] []
        , Button.render Mdl
            [ 0 ]
            model.mdl
            [ Button.colored

            -- , Options.onClick (ReadEntry idx)
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
