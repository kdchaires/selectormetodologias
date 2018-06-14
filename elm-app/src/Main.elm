module Main exposing (main)

import Html exposing (..)
import Json.Decode as Decode exposing (Value)
import Navigation exposing (Location)
import Page.Errored as Errored exposing (PageLoadError)
import Page.NotFound as NotFound
import Page.Welcome as Welcome
import Page.Questions as Questions
import Page.ListMethodologies as ListMethodologies
import Ports
import Route exposing (Route)
import Task
import Util exposing ((=>))
import Views.Page as Page exposing (ActivePage)


-- WARNING: Based on discussions around how asset management features
-- like code splitting and lazy loading have been shaping up, I expect
-- most of this file to become unnecessary in a future release of Elm.
-- Avoid putting things in here unless there is no alternative!


type Page
    = Blank
    | NotFound
    | Errored PageLoadError
    | Welcome Welcome.Model
    | Questions Questions.Model
    | ListMethodologies ListMethodologies.Model


type PageState
    = Loaded Page
    | TransitioningFrom Page



-- MODEL --


type alias Model =
    { pageState : PageState
    }


init : Value -> Location -> ( Model, Cmd Msg )
init val location =
    setRoute (Route.fromLocation location)
        { pageState = Loaded initialPage
        }


initialPage : Page
initialPage =
    Blank



-- VIEW --


view : Model -> Html Msg
view model =
    case model.pageState of
        Loaded page ->
            viewPage False page

        TransitioningFrom page ->
            viewPage True page


viewPage : Bool -> Page -> Html Msg
viewPage isLoading page =
    let
        frame =
            Page.frame isLoading
    in
        case page of
            NotFound ->
                NotFound.view
                    |> frame Page.Other

            Blank ->
                -- This is for the very initial page load, while we are loading
                -- data via HTTP. We could also render a spinner here.
                Html.text ""
                    |> frame Page.Other

            Errored subModel ->
                Errored.view subModel
                    |> frame Page.Other

            Welcome subModel ->
                Welcome.view subModel
                    |> frame Page.Other
                    |> Html.map WelcomeMsg

            Questions subModel ->
                Questions.view subModel
                    |> frame Page.Other
                    |> Html.map QuestionsMsg

            ListMethodologies subModel ->
                ListMethodologies.view subModel
                    |> frame Page.Other
                    |> Html.map ListMethodologiesMsg



-- SUBSCRIPTIONS --
-- Note: we aren't currently doing any page subscriptions, but I thought it would
-- be a good idea to put this in here as an example. If I were actually
-- maintaining this in production, I wouldn't bother until I needed this!


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ pageSubscriptions (getPage model.pageState)
        ]


getPage : PageState -> Page
getPage pageState =
    case pageState of
        Loaded page ->
            page

        TransitioningFrom page ->
            page


pageSubscriptions : Page -> Sub Msg
pageSubscriptions page =
    case page of
        Blank ->
            Sub.none

        Errored _ ->
            Sub.none

        NotFound ->
            Sub.none

        Welcome _ ->
            Sub.none

        Questions _ ->
            Sub.none

        ListMethodologies _ ->
            Sub.none



--
-- UPDATE --


type Msg
    = SetRoute (Maybe Route)
    | WelcomeLoaded (Result PageLoadError Welcome.Model)
    | QuestionsLoaded (Result PageLoadError Questions.Model)
    | ListMethodologiesLoaded (Result PageLoadError ListMethodologies.Model)
    | WelcomeMsg Welcome.Msg
    | QuestionsMsg Questions.Msg
    | ListMethodologiesMsg ListMethodologies.Msg


setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    let
        transition toMsg task =
            { model | pageState = TransitioningFrom (getPage model.pageState) }
                => Task.attempt toMsg task

        errored =
            pageErrored model
    in
        case maybeRoute of
            Nothing ->
                { model | pageState = Loaded NotFound } => Cmd.none

            Just (Route.Root) ->
                model => Route.modifyUrl Route.Welcome

            Just (Route.Welcome) ->
                { model | pageState = Loaded (Welcome Welcome.initialModel) } => Cmd.none

            Just (Route.Questions) ->
                transition QuestionsLoaded (Questions.init)

            Just (Route.ListMethodologies) ->
                transition ListMethodologiesLoaded (ListMethodologies.init)


pageErrored : Model -> ActivePage -> String -> ( Model, Cmd msg )
pageErrored model activePage errorMessage =
    let
        error =
            Errored.pageLoadError activePage errorMessage
    in
        { model | pageState = Loaded (Errored error) } => Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updatePage (getPage model.pageState) msg model


updatePage : Page -> Msg -> Model -> ( Model, Cmd Msg )
updatePage page msg model =
    let
        toPage toModel toMsg subUpdate subMsg subModel =
            let
                ( newModel, newCmd ) =
                    subUpdate subMsg subModel
            in
                ( { model | pageState = Loaded (toModel newModel) }, Cmd.map toMsg newCmd )

        errored =
            pageErrored model
    in
        case ( msg, page ) of
            ( SetRoute route, _ ) ->
                setRoute route model

            ( WelcomeLoaded (Ok subModel), _ ) ->
                { model | pageState = Loaded (Welcome subModel) } => Cmd.none

            ( WelcomeLoaded (Err error), _ ) ->
                { model | pageState = Loaded (Errored error) } => Cmd.none

            ( QuestionsLoaded (Ok subModel), _ ) ->
                { model | pageState = Loaded (Questions subModel) } => Cmd.none

            ( QuestionsLoaded (Err error), _ ) ->
                { model | pageState = Loaded (Errored error) } => Cmd.none

            ( ListMethodologiesLoaded (Ok subModel), _ ) ->
                { model | pageState = Loaded (ListMethodologies subModel) } => Cmd.none

            ( ListMethodologiesLoaded (Err error), _ ) ->
                { model | pageState = Loaded (Errored error) } => Cmd.none

            ( WelcomeMsg subMsg, Welcome subModel ) ->
                toPage Welcome WelcomeMsg (Welcome.update) subMsg subModel

            ( QuestionsMsg subMsg, Questions subModel ) ->
                toPage Questions QuestionsMsg (Questions.update) subMsg subModel

            ( _, NotFound ) ->
                -- Disregard incoming messages when we're on the
                -- NotFound page.
                model => Cmd.none

            ( _, _ ) ->
                -- Disregard incoming messages that arrived for the wrong page
                model => Cmd.none



-- MAIN --


main : Program Value Model Msg
main =
    Navigation.programWithFlags (Route.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
