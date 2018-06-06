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
    , methodologies : List SimplifiedMethodology
    }


type alias Link =
    { href : String
    , rel : String
    , type_ : String
    }


type alias SimplifiedMethodology =
    { id : String
    , name : String
    , links : List Link
    }


initialModel : Model
initialModel =
    { index = 0
    , mdl = Material.model
    , activePage = 0
    , methodologies = []
    }


type Msg
    = Mdl (Material.Msg Msg)
      -- TODO Organize these Msg separately like Mdl does?
    | HandleGetMethodologiesResponse (Result Http.Error (List SimplifiedMethodology))
    | WantMethodologyDetails String


linkDecoder : Json.Decode.Decoder Link
linkDecoder =
    Pipe.decode Link
        |> Pipe.required "href" Json.Decode.string
        |> Pipe.required "rel" Json.Decode.string
        |> Pipe.required "type" Json.Decode.string


methodologyDecoder : Json.Decode.Decoder SimplifiedMethodology
methodologyDecoder =
    Pipe.decode SimplifiedMethodology
        |> Pipe.required "id" Json.Decode.string
        |> Pipe.required "name" Json.Decode.string
        |> Pipe.required "links" (Json.Decode.list linkDecoder)


getMethodologies : Cmd Msg
getMethodologies =
    let
        url =
            "http://localhost:8000/methodologies"
    in
        Http.send HandleGetMethodologiesResponse <|
            Http.get url (Json.Decode.list methodologyDecoder)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model

        WantMethodologyDetails methodologyId ->
            -- Send to the details page
            ( model, Cmd.none )

        HandleGetMethodologiesResponse result ->
            case result of
                Ok methodologies ->
                    { model | methodologies = methodologies } ! []

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
            , drawer = []
            , tabs = ( [], [] )
            , main =
                [ grid []
                    (List.map (viewMethodology model) model.methodologies)
                ]
            }


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
            , Button.render Mdl
                [ 0 ]
                model.mdl
                [ Button.colored
                , Options.onClick <| WantMethodologyDetails methodology.id
                ]
                [ text "Ver detalles" ]
            ]
        ]


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = ( initialModel, getMethodologies )
        , update = update
        , subscriptions = \_ -> Sub.none
        }
