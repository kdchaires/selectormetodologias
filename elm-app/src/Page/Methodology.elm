module Page.Methodology exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes as Html
import Http
import Http exposing (get, Error, Response, Error(..))
import Html.Lazy exposing (lazy, lazy2)
import Data.Methodology as Methodology exposing (Methodology)
import Data.Methodology.Description as Description exposing (Description)
import Data.Methodology.Diagrams as Diagrams exposing (Diagrams)
import Request.Methodology
import Task exposing (Task)
import Util exposing ((=>), pair, viewIf)
import Page.Errored exposing (PageLoadError, pageLoadError)
import Views.Page as Page
import Material
import Material.Scheme
import Material.Color as Color
import Material.Layout as Layout
import Material.Elevation as Elevation
import Material.Grid as Grid exposing (..)
import Material.Options as Options exposing (css)
import Json.Encode
import Html.Attributes exposing (..)


--import Views.Methodology
-- MODEL
--Estado de la aplicacion


type alias Model =
    { errors : List String
    , index : Int
    , mdl : Material.Model
    , activePage : Int
    , selectedTab : Int
    , methodology : Methodology
    }


init : Task PageLoadError Model
init =
    let
        methodologySelected =
            Request.Methodology.methodologyRequest
                |> Http.toTask

        handleLoadError _ =
            pageLoadError Page.Other "Methodology is currently unavailable."
    in
        Task.map (Model [] 0 Material.model 0 0) methodologySelected
            |> Task.mapError handleLoadError



--VIEW


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
            { header =
                [ h2 [Html.Attributes.align "center"] [ text model.methodology.name ] ]
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
                --  [ Views.Methodology.viewBody model ]
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

        -- 6 ->
        --     viewTips model
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
            [ Grid.size All 6, offset All 3 ]
            [ Options.div
                [ Elevation.e6
                , css "margin-bottom" "20px"
                , css "padding" "20px"
                ]
                [ h1 [Html.Attributes.align "center"] [ text "Resumen" ]
                , textHtml model.methodology.abstract
                ]
            ]
        ]


viewProcess : Model -> Html Msg
viewProcess model =
    grid []
        [ cell
            [ Grid.size All 6, offset All 3 ]
            [ Options.div
                [ Elevation.e6
                , css "margin-bottom" "20px"
                , css "padding" "20px"
                ]
                (renderProcesses model.methodology.description.process)
            ]
        ]


renderProcesses : List Description.Process -> List (Html msg)
renderProcesses t =
    List.map processHtml t


processHtml : Description.Process -> Html msg
processHtml t =
    let
        val =
            [ h1
                [ Json.Encode.string t.name
                    |> Html.Attributes.property "innerHTML"
                  , Html.Attributes.align "center"
                ]
                []
            , span
                [ Json.Encode.string t.description
                    |> Html.Attributes.property "innerHTML"
                ]
                []
            , img
                [ src t.image
                , style [ ( "width", "100%" )]
                ]
                []
            ]
    in
        div [] (val)


viewRoles : Model -> Html Msg
viewRoles model =
    grid []
        [ cell
            [ Grid.size All 6, offset All 3 ]
            [ Options.div
                [ Elevation.e6
                , css "margin-bottom" "20px"
                , css "padding" "20px"
                ]
                (renderRoles model.methodology.description.roles)
            ]
        ]


renderRoles : List Description.Roles -> List (Html msg)
renderRoles t =
    List.map rolesHtml t


rolesHtml : Description.Roles -> Html msg
rolesHtml t =
    let
        val =
            [ h1
                [ Json.Encode.string t.name
                    |> Html.Attributes.property "innerHTML"
                  , Html.Attributes.align "center"
                ]
                []
            , span
                [ Json.Encode.string t.description
                    |> Html.Attributes.property "innerHTML"
                ]
                []
            , img
                [ src t.image
                , style [ ( "width", "100%" )]
                ]
                []
            ]
    in
        div [] (val)


viewArtifacts : Model -> Html Msg
viewArtifacts model =
    grid []
        [ cell
            [ Grid.size All 6, offset All 3 ]
            [ Options.div
                [ Elevation.e6
                , css "margin-bottom" "20px"
                , css "padding" "20px"
                ]
                (renderArtifacts model.methodology.description.artifacts)
            ]
        ]


renderArtifacts : List Description.Artifacts -> List (Html msg)
renderArtifacts t =
    List.map artifactsHtml t


artifactsHtml : Description.Artifacts -> Html msg
artifactsHtml t =
    let
        val =
            [ h1
                [ Json.Encode.string t.name
                    |> Html.Attributes.property "innerHTML"
                  , Html.Attributes.align "center"
                ]
                []
            , span
                [ Json.Encode.string t.description
                    |> Html.Attributes.property "innerHTML"
                ]
                []
            , img
                [ src t.image
                , style [ ( "width", "100%" )]
                ]
                []
            ]
    in
        div [] (val)


viewPractices : Model -> Html Msg
viewPractices model =
    grid []
        [ cell
            [ Grid.size All 6, offset All 3 ]
            [ Options.div
                [ Elevation.e6
                , css "margin-bottom" "20px"
                , css "padding" "20px"
                ]
                (renderPractices model.methodology.description.practices)
            ]
        ]


renderPractices : List Description.Practices -> List (Html msg)
renderPractices t =
    List.map practicesHtml t


practicesHtml : Description.Practices -> Html msg
practicesHtml t =
    let
        val =
            [ h1
                [ Json.Encode.string t.name
                    |> Html.Attributes.property "innerHTML"
                  , Html.Attributes.align "center"
                ]
                []
            , span
                [ Json.Encode.string t.description
                    |> Html.Attributes.property "innerHTML"
                ]
                []
            , img
                [ src t.image
                , style [ ( "width", "100%" )]
                ]
                []
            ]
    in
        div [] (val)


viewTools : Model -> Html Msg
viewTools model =
    grid []
        [ cell
            [ Grid.size All 6, offset All 3 ]
            [ Options.div
                [ Elevation.e6
                , css "margin-bottom" "20px"
                , css "padding" "20px"
                ]
                (renderTools model.methodology.description.tools)
            ]
        ]


renderTools : List Description.Tools -> List (Html msg)
renderTools t =
    List.map toolsHtml t


toolsHtml : Description.Tools -> Html msg
toolsHtml t =
    let
        val =
            [ h1
                [ Json.Encode.string t.name
                    |> Html.Attributes.property "innerHTML"
                  , Html.Attributes.align "center"
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



-- viewTips : Model -> Html Msg
-- viewTips model =
--     grid []
--         [ cell
--             [ Grid.size All 6, offset All 1 ]
--             [ Options.div
--                 [ Elevation.e6
--                 , css "margin-bottom" "20px"
--                 , css "padding" "20px"
--                 ]
--                 (renderTips model.methodology.description.tips)
--             ]
--         ]
-- renderTips : List Description.Tips -> List (Html msg)
-- renderTips t =
--     List.map tipsHtml t
--
--
-- tipsHtml : Description.Tips -> Html msg
-- tipsHtml t =
--     let
--         val =
--             [ span
--                 [ Json.Encode.string t
--                     |> Html.Attributes.property "innerHTML"
--                 ]
--                 []
--             ]
--     in
--         div [] (val)
-- UPDATE
{- Los usuarios de la aplicacion pueden enviar el mensaje
   seleccionando la respuesta, esta accion alimenta el update mostrando la
   siguiente pregunta a responder
-}


type Msg
    = DismissErrors
    | SelectTab Int
    | Mdl (Material.Msg Msg)



--  | CreatedSuggestMsg (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DismissErrors ->
            { model | errors = [] } => Cmd.none

        SelectTab k ->
            ( { model | selectedTab = k }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model
