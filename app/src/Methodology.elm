module Main exposing (..)

import Json.Encode
import Json.Decode
import Json.Decode.Pipeline as Pipe
import Html exposing (..)
import Html.Attributes exposing (..)
import Material
import Material.Scheme
import Material.Color as Color
import Material.Layout as Layout
import Material.Elevation as Elevation
import Material.Grid as Grid exposing (..)
import Material.Options as Options exposing (css)


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
    , description : String
    , image : String
    }


type alias Roles =
    { name : String
    , description : String
    , image : String
    }


type alias Artifacts =
    { name : String
    , description : String
    , image : String
    , producesArtifacts : List String
    }


type alias Practices =
    { name : String
    , description : String
    , image : String
    }


type alias Tips =
    String


type alias Tools =
    { name : String
    , description : String
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
    { id : String
    , name : String
    , abstract : String
    , quality_features : String
    , info : String
    , types : String
    , model : String

    --, diagrams : Diagrams
    , description : Description
    }


type alias Model =
    { index : Int
    , mdl : Material.Model
    , activePage : Int
    , methodology : Methodology
    , selectedTab : Int
    }



--TODO rellenar el modelo inicial con una metodologia


methodologySelected : Methodology
methodologySelected =
    { id = "1"
    , name = "Scrum"
    , abstract = "<p> Scrum es un marco de trabajo dentro del cual las personas pueden abordar complejos problemas de adaptación, mientras que ofrecen productiva y creativamente productos del más alto valor posible. </p> <p> Scrum es un marco de trabajo simple para la colaboración eficaz en equipo en productos complejos. La definición de Scrum consiste en los roles, eventos, artefactos y las reglas de Scrum que los unen. </P> <p> Scrum es: </p> <ul> <li> Ligero </ li> <li> Simple para comprender </ li> <li> Difícil de dominar </li> </ ul>"
    , quality_features = "La definición de Done"
    , info = "https://www.scrum.org/resources/what-is-scrum"
    , types = "Ágil"
    , model = "Iterativo incremental"

    --, diagrams = []
    , description = initialDescription
    }


initialDescription : Description
initialDescription =
    { process = initialProcess
    , roles = []
    , artifacts = []
    , practices = []
    , tips = []
    , tools = []
    }


initialProcess : List Process
initialProcess =
    [ { stage = 1
      , name = "Sprint"
      , description = "<p>Un Sprint, un cuadro de tiempo de un mes o menos durante el cual se crea un incremento de producto definido como “Done”, utilizable y potencialmente liberable. Los sprints tienen duraciones consistentes a lo largo de un esfuerzo de desarrollo. Un nuevo Sprint comienza inmediatamente después de la conclusión del Sprint anterior.</p><p>Durante el Sprint:</p><ul><li>No se realizan cambios que puedan poner en peligro las Metas del Sprint;</li><li>Las metas de calidad no decrementan; y,</li><li>El alcance se puede aclarar y renegociar entre el Product Owner y el Development Team a medida que se aprende más.</li></ul><p>Cada Sprint puede considerarse un proyecto con un horizonte no mayor a un mes. Al igual que los proyectos, los Sprints se utilizan para lograr algo. Cada Sprint tiene una meta de lo que se construirá, un diseño y un plan flexible que guiará su construcción, el trabajo y el incremento resultante del producto.</p><p>Los Sprints están limitados a un mes de calendario. Cuando el horizonte de un Sprint es demasiado largo, la definición de lo que se está construyendo puede cambiar, la complejidad puede aumentar y el riesgo puede aumentar. Los Sprints permiten la previsibilidad al garantizar la inspección y la adaptación del progreso hacia un objetivo de Sprint al menos cada mes calendario. Los Sprints también limitan el riesgo a un mes calendario de costo.</p>"
      , image = ""
      }
    , { stage = 2
      , name = "Planificación de Sprint"
      , description = "<p> El trabajo que se realizará en el Sprint está planificado en la Planificación de Sprint. Este plan es creado por el trabajo colaborativo de todo el equipo de Scrum. </ P> <p> La Planificación de Sprint pueden durar un máximo de ocho horas para un Sprint de un mes. Para Sprints más cortos, el evento suele ser más corto. El Scrum Master asegura que el evento tenga lugar y que los asistentes entiendan su propósito. El Scrum Master le enseña al Scrum Team a mantenerlo dentro del tiempo límite. </P> <p> La Planificación de Sprint responde lo siguiente: </ p> <ul> <li> ¿Qué es lo que se puede entregar en el Incremento resultante del próximo Sprint? </ Li> <li> ¿Cómo se logrará el trabajo necesario para lograr el Incremento? </ Li> </ ul> <p> El trabajo se selecciona del Product Backlog y se ingresa al Sprint Backlog. Ahora recuerde que el trabajo en Sprint Backlog no es un compromiso, es un pronóstico. El único contenedor de un Sprint es su cuadro de tiempo, no el trabajo planificado para el Sprint. </ P> Meta de Sprint <p> La Meta de Sprint es un conjunto de objetivos para el Sprint que se puede cumplir a través de la implementación del Product Backlog. Brinda orientación al Equipo de Desarrollo sobre por qué está construyendo el Incremento. Se crea durante la reunión de planificación de Sprint. El objetivo de Sprint le da al equipo de desarrollo cierta flexibilidad con respecto a la funcionalidad implementada dentro del Sprint.  A medida que el equipo de desarrollo trabaja, lo hace con el Sprint Goal siempre en mente. </p>"
      , image = "https://scrumorg-website-prod.s3.amazonaws.com/drupal/inline-images/2017-03/Sprint%20Planning_0.png"
      }
    ]


initialModel : Model
initialModel =
    { index = 0
    , mdl = Material.model
    , activePage = 0
    , methodology = methodologySelected
    , selectedTab = 0
    }


type Msg
    = SelectTab Int
    | Mdl (Material.Msg Msg)



--TODO definir decoder y encoder para el get de metogologia, tambien la funcion para hacer la peticion get


methodologyDecoder : Json.Decode.Decoder Methodology
methodologyDecoder =
    Pipe.decode Methodology
        |> Pipe.required "id" Json.Decode.string
        |> Pipe.required "name" Json.Decode.string
        |> Pipe.required "abstract" Json.Decode.string
        |> Pipe.required "quality_features" Json.Decode.string
        |> Pipe.required "type" Json.Decode.string
        |> Pipe.required "model" Json.Decode.string
        |> Pipe.required "diagrams" diagramsDecoder
        |> Pipe.required "description" descriptionDecoder


diagramsDecoder : Json.Decode.Decoder Diagrams
diagramsDecoder =
    Pipe.decode Diagrams
        |> Pipe.required "process" Json.Decode.string
        |> Pipe.required "roles" Json.Decode.string
        |> Pipe.required "artifacts" Json.Decode.string
        |> Pipe.required "practices" Json.Decode.string


descriptionDecoder : Json.Decode.Decoder Description
descriptionDecoder =
    Pipe.decode Description
        |> Pipe.required "process" (Json.Decode.list processDecoder)
        |> Pipe.required "roles" (Json.Decode.list rolesDecoder)
        |> Pipe.required "artifacts" (Json.Decode.list artifactsDecoder)
        |> Pipe.required "practices" (Json.Decode.list practicesDecoder)
        |> Pipe.required "tips" (Json.Decode.list tipsDecoder)
        |> Pipe.required "tools" (Json.Decode.list toolsDecoder)


processDecoder : Json.Decode.Decoder Process
processDecoder =
    Pipe.decode Process
        |> Pipe.required "stage" Json.Decode.string
        |> Pipe.required "name" Json.Decode.string
        |> Pipe.required "description" Json.Decode.string
        |> Pipe.required "image" Json.Decode.string


rolesDecoder : Json.Decode.Decoder Roles
rolesDecoder =
    Pipe.decode Roles
        |> Pipe.required "name" Json.Decode.string
        |> Pipe.required "description" Json.Decode.string
        |> Pipe.required "image" Json.Decode.string



{-
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
            ( { model | selectedTab = k }, Cmd.none )

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
            , tabs =
                ( [ text "Resumen"
                  , text "Proceso"
                  , text "Roles"
                  , text "Artefactos"
                  , text "Prácticas"
                  , text "Herramientas"
                  , text "Tips"
                  ]
                , []
                )
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


textHtml : String -> Html msg
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
            [ Grid.size All 6, offset All 2 ]
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
            [ Grid.size All 8 ]
            [ Options.div
                [ Elevation.e6
                , css "margin-bottom" "20px"
                , css "padding" "20px"
                ]
                (renderProcesses model.methodology.description.process)
            ]
        ]


renderProcesses : List Process -> List (Html msg)
renderProcesses t =
    List.map processHtml t


processHtml : Process -> Html msg
processHtml t =
    let
        val =
            [ h1
                [ Json.Encode.string t.name
                    |> Html.Attributes.property "innerHTML"
                ]
                []
            , span
                [ Json.Encode.string t.description
                    |> Html.Attributes.property "innerHTML"
                ]
                []
            , img
                [ src t.image ]
                []
            ]
    in
        div [] (val)


viewRoles : Model -> Html Msg
viewRoles model =
    grid []
        [ cell
            [ Grid.size All 6, offset All 1 ]
            [ Options.div
                [ Elevation.e6
                , css "margin-bottom" "20px"
                , css "padding" "20px"
                ]
                (renderRoles model.methodology.description.roles)
            ]
        ]


renderRoles : List Roles -> List (Html msg)
renderRoles t =
    List.map rolesHtml t


rolesHtml : Roles -> Html msg
rolesHtml t =
    let
        val =
            [ h1
                [ Json.Encode.string t.name
                    |> Html.Attributes.property "innerHTML"
                ]
                []
            , span
                [ Json.Encode.string t.description
                    |> Html.Attributes.property "innerHTML"
                ]
                []
            , img
                [ src t.image ]
                []
            ]
    in
        div [] (val)


viewArtifacts : Model -> Html Msg
viewArtifacts model =
    grid []
        [ cell
            [ Grid.size All 6, offset All 1 ]
            [ Options.div
                [ Elevation.e6
                , css "margin-bottom" "20px"
                , css "padding" "20px"
                ]
                (renderArtifacts model.methodology.description.artifacts)
            ]
        ]


renderArtifacts : List Artifacts -> List (Html msg)
renderArtifacts t =
    List.map artifactsHtml t


artifactsHtml : Artifacts -> Html msg
artifactsHtml t =
    let
        val =
            [ h1
                [ Json.Encode.string t.name
                    |> Html.Attributes.property "innerHTML"
                ]
                []
            , span
                [ Json.Encode.string t.description
                    |> Html.Attributes.property "innerHTML"
                ]
                []
            , img
                [ src t.image ]
                []
            ]
    in
        div [] (val)


viewPractices : Model -> Html Msg
viewPractices model =
    grid []
        [ cell
            [ Grid.size All 6, offset All 1 ]
            [ Options.div
                [ Elevation.e6
                , css "margin-bottom" "20px"
                , css "padding" "20px"
                ]
                (renderPractices model.methodology.description.practices)
            ]
        ]


renderPractices : List Practices -> List (Html msg)
renderPractices t =
    List.map practicesHtml t


practicesHtml : Practices -> Html msg
practicesHtml t =
    let
        val =
            [ h1
                [ Json.Encode.string t.name
                    |> Html.Attributes.property "innerHTML"
                ]
                []
            , span
                [ Json.Encode.string t.description
                    |> Html.Attributes.property "innerHTML"
                ]
                []
            , img
                [ src t.image ]
                []
            ]
    in
        div [] (val)


viewTools : Model -> Html Msg
viewTools model =
    grid []
        [ cell
            [ Grid.size All 6, offset All 1 ]
            [ Options.div
                [ Elevation.e6
                , css "margin-bottom" "20px"
                , css "padding" "20px"
                ]
                (renderTools model.methodology.description.tools)
            ]
        ]


renderTools : List Tools -> List (Html msg)
renderTools t =
    List.map toolsHtml t


toolsHtml : Tools -> Html msg
toolsHtml t =
    let
        val =
            [ h1
                [ Json.Encode.string t.name
                    |> Html.Attributes.property "innerHTML"
                ]
                []
            , span
                [ Json.Encode.string t.description
                    |> Html.Attributes.property "innerHTML"
                ]
                []
            , span
                [ Json.Encode.string t.website
                    |> Html.Attributes.property "innerHTML"
                ]
                []
            ]
    in
        div [] (val)


viewTips : Model -> Html Msg
viewTips model =
    grid []
        [ cell
            [ Grid.size All 6, offset All 1 ]
            [ Options.div
                [ Elevation.e6
                , css "margin-bottom" "20px"
                , css "padding" "20px"
                ]
                (renderTips model.methodology.description.tips)
            ]
        ]


renderTips : List Tips -> List (Html msg)
renderTips t =
    List.map tipsHtml t


tipsHtml : Tips -> Html msg
tipsHtml t =
    let
        val =
            [ span
                [ Json.Encode.string t
                    |> Html.Attributes.property "innerHTML"
                ]
                []
            ]
    in
        div [] (val)



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
