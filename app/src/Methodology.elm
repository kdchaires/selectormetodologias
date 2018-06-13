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




--TODO investigar si hay un tipo para las url
type alias Diagrams =
    { process : String
    , roles : String
    , artifacts : String
    , practices : String
    }

type alias Process =
    { stage : Int
    , name : String
    , descrription : String
    , image : String
    }

type alias Roles  =
    { name : String
    , descrription : String
    , image : String
    }

type alias Artifacts  =
    { name : String
    , descrription : String
    , image : String
    , producesArtifacts : List String
    }

type alias Practices  =
    { name : String
    , descrription : String
    , image : String
    }

type alias Tips = String

type alias Tools  =
    { name : String
    , descrription : String
    , website : String
    }

type alias Description =
    { process : List Process
    , roles : List Roles
    , artifacts : List Artifacts
    , practices : List Practices
    , tips : List Tips
    , tools : List Tools
    }
--TODO rellenar diagrams y description
type alias Methodology =
    { id : Int
    , name : String
    , abstract : String
    , quality_features : String
    , info : String
    , types : String
    , model : String
    , diagrams : Diagrams
    --, description : Description
    }
type alias Model =
    { index : Int
    , mdl : Material.Model
    , methodology : Methodology
    , activePage : Int
    , selectedTab : Int
    }
--TODO rellenar el modelo inicial con una metodologia
methodologySelected : Methodology
methodologySelected =
    { id = 1
    , name = "Scrum"
    , abstract = "<p> Scrum es un marco de trabajo dentro del cual las personas pueden abordar complejos problemas de adaptación, mientras que ofrecen productiva y creativamente productos del más alto valor posible. </p> <p> Scrum es un marco de trabajo simple para la colaboración eficaz en equipo en productos complejos. La definición de Scrum consiste en los roles, eventos, artefactos y las reglas de Scrum que los unen. </P> <p> Scrum es: </p> <ul> <li> Ligero </ li> <li> Simple para comprender </ li> <li> Difícil de dominar </li> </ ul>"
    , quality_features = "La definición de Done"
    , info = "https://www.scrum.org/resources/what-is-scrum"
    , types = "Ágil"
    , model = "Iterativo incremental"
    , diagrams = [

    ]
    }


initialModel : Model
initialModel =
    { index = 0
    , mdl = Material.model
    , methodology = methodologySelected
    , activePage = 0
    , selectedTab = 0
    }


type Msg
    = SelectTab Int
    | Mdl (Material.Msg Msg)
--TODO definir decoder y encoder para el get de metogologia, tambien la funcion para hacer la peticion get
{-
feedbackDecoder : Json.Decode.Decoder Feedback
feedbackDecoder =
    Pipe.decode Feedback
        |> Pipe.required "email" Json.Decode.string
        |> Pipe.required "institution" Json.Decode.string
        |> Pipe.required "created_at" Json.Decode.string
        |> Pipe.required "finished" Json.Decode.bool
        |> Pipe.required "description" Json.Decode.string



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
-}

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SelectTab k ->
            ( { model | selectedTab = k } , Cmd.none )
        Mdl msg_ ->
            Material.update Mdl msg_ model




view : Model -> Html Msg
view model =
    Material.Scheme.topWithScheme Color.Brown Color.DeepOrange <|
        Layout.render Mdl
            model.mdl
            [ Layout.selectedTab model.selectedTab
            , Layout.onSelectTab SelectTab
            , Layout.fixedHeader
            , Layout.fixedTabs
            ]
            { header = [ h3 [] [ text model.methodology.name ] ]

            -- [ Options.styled p
            --     [ Typo.display3 ]
            --     [ text "Bienvenido" ]
            -- ]
            , drawer = []
            , tabs = ( [ text "Resumen"
                       , text "Proceso"
                       , text "Roles"
                       , text "Artefactos"
                       , text "Prácticas"
                       , text "Herramientas"
                       , text "Tips"
                       ], [] )
            , main =
                [ viewBody model ]
            }


viewBody : Model -> Html Msg
viewBody model =
    case model.selectedTab of
        0 ->
            viewAbstract model
        1 ->
            viewProcess model
        2 ->
            viewRoles model
        3 ->
            viewArtifacts model
        4 ->
            viewPractices model
        5 ->
            viewTools model
        6 ->
            viewTips model
        _ ->
            h1 [] [ text "404 Not Found" ]

textHtml: String -> Html msg
textHtml t =
    span
        [ Json.Encode.string t
            |> Html.Attributes.property "innerHTML"
        ]
        []

viewAbstract : Model -> Html Msg
viewAbstract model =
    grid []
    [ cell
      [ Grid.size All 6, offset All 1 ]
      [ Options.div
          [ Elevation.e6
          , css "margin-bottom" "20px"
          , css "padding" "20px"
          ]
          [ h3 [] [ text "Resumen" ]
          , textHtml model.methodology.abstract
          ]
       ]
    ]

viewProcess : Model -> Html Msg
viewProcess model =
    grid []
    [ cell
      [ Grid.size All 6, offset All 1 ]
      [ h3 [] [ text "Proceso" ] ]
    ]

viewRoles : Model -> Html Msg
viewRoles model =
    grid []
    [ cell
      [ Grid.size All 6, offset All 1 ]
      [ h3 [] [ text "Roles" ] ]
    ]

viewArtifacts : Model -> Html Msg
viewArtifacts model =
    grid []
    [ cell
      [ Grid.size All 6, offset All 1 ]
      [ h3 [] [ text "Artefactos" ] ]
    ]

viewPractices : Model -> Html Msg
viewPractices model =
    grid []
    [ cell
      [ Grid.size All 6, offset All 1 ]
      [ h3 [] [ text "Prácticas" ] ]
    ]

viewTools : Model -> Html Msg
viewTools model =
    grid []
    [ cell
      [ Grid.size All 6, offset All 1 ]
      [ h3 [] [ text "Herramientas" ] ]
    ]

viewTips : Model -> Html Msg
viewTips model =
    grid []
    [ cell
      [ Grid.size All 6, offset All 1 ]
      [ h3 [] [ text "Tips" ] ]
    ]
{-
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
-}

main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = ( initialModel, Cmd.none )
        , update = update
        , subscriptions = \_ -> Sub.none
        }
