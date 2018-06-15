module Page.ListMethodologies exposing (Model, Msg, init, update, view)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Html.Attributes as Html
import Http
import Http exposing (get, Error, Response, Error(..))
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
import Html.Lazy exposing (lazy, lazy2)
import Data.Methodologies.Link as Link exposing (Link)
import Data.Methodologies.SimplifiedMethodology as SimplifiedMethodology exposing (SimplifiedMethodology)
import Data.Methodology exposing (Methodology)
import Request.ListMethodologies
import Request.Methodology
import Task exposing (Task)
import Util exposing ((=>), pair, viewIf)
import Page.Errored exposing (PageLoadError, pageLoadError)
import Views.Page as Page
import Route exposing (Route)
import Json.Decode as Decode exposing (Decoder, decodeString, field, string)


-- MODEL
--Estado de la aplicacion


type alias Model =
    { errors : List String
    , index : Int
    , activePage : Int
    , mdl : Material.Model
    , methodologies : List SimplifiedMethodology
    }


init : Task PageLoadError Model
init =
    let
        loadListMethodologies =
            Request.ListMethodologies.getMethodologies
                |> Http.toTask

        handleLoadError _ =
            pageLoadError Page.Other "ListMethodologies is currently unavailable."
    in
        Task.map (Model [] 0 0 Material.model) loadListMethodologies
            |> Task.mapError handleLoadError



--VIEW


view : Model -> Html Msg
view model =
    div [ class "article-page" ]
        [ div [ class "container page" ]
            [ div [ class "row article-content" ]
                [ grid []
                    (List.map (viewMethodology model) model.methodologies)
                ]
            ]
        ]


viewMethodology : Model -> SimplifiedMethodology -> Cell Msg
viewMethodology model methodology =
    cell
        [ Grid.size All 3 ]
        [ Options.div
            [ Elevation.e6
            , css "margin-bottom" "20px"
            , css "padding" "20px"
            ]
            [ h3 [] [ text methodology.name ]
            , hr [] []
            , h1 [] [ text (toString model.index) ]
            , button
                [ class "btn btn-lg btn-primary pull-xs-right"
                , onClick (WantMethodologyDetails methodology.id)
                ]
                [ text "Ver detalles" ]
              -- , Button.render Mdl
              --     [ 0 ]
              --     model.mdl
              --     [ Button.colored
              --     , Options.onClick <| WantMethodologyDetails methodology.id
              --     ]
              --     [ text "Ver detalles" ]
            ]
        ]



-- UPDATE
{- Los usuarios de la aplicacion pueden enviar el mensaje
   seleccionando la respuesta, esta accion alimenta el update mostrando la
   siguiente pregunta a responder
-}


type Msg
    = DismissErrors
    | Mdl (Material.Msg Msg)
    | WantMethodologyDetails (Int)
    | MethodologyFeedbackResponse (Result Http.Error Methodology)



--  | CreatedSuggestMsg (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DismissErrors ->
            { model | errors = [] } => Cmd.none

        Mdl msg_ ->
            Material.update Mdl msg_ model

        WantMethodologyDetails methodologyId ->
            let
                _ =
                    Debug.log (toString methodologyId) methodologyId
            in
                { model | errors = [] }
                    => Http.send MethodologyFeedbackResponse (Request.Methodology.methodologyRequest methodologyId)

        MethodologyFeedbackResponse (Err error) ->
            { model | errors = [] }
                => Cmd.none

        MethodologyFeedbackResponse (Ok _) ->
            model => Route.modifyUrl Route.Methodology



-- WantMethodologyDetails methodologyId ->
--     { model | index = 3 } => Cmd.none
