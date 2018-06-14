module Route exposing (Route(..), fromLocation, href, modifyUrl)

import Html exposing (Attribute)
import Html.Attributes as Attr
import Navigation exposing (Location)
import UrlParser as Url exposing ((</>), Parser, oneOf, parseHash, s, string)


-- ROUTING --


type Route
    = Root
    | Welcome
    | Questions
    | ListMethodologies
    | Methodology


route : Parser (Route -> a) a
route =
    oneOf
        [ Url.map Welcome (s "welcome")
        , Url.map Questions (s "questions")
        , Url.map ListMethodologies (s "listMethodologies")
        , Url.map Methodology (s "methodology")
        ]



-- INTERNAL --


routeToString : Route -> String
routeToString page =
    let
        pieces =
            case page of
                Root ->
                    []

                Welcome ->
                    [ "welcome" ]

                Questions ->
                    [ "questions" ]

                ListMethodologies ->
                    [ "listMethodologies" ]

                Methodology ->
                    [ "methodology" ]
    in
        "#/" ++ String.join "/" pieces



-- PUBLIC HELPERS --


href : Route -> Attribute msg
href route =
    Attr.href (routeToString route)


modifyUrl : Route -> Cmd msg
modifyUrl =
    routeToString >> Navigation.modifyUrl


fromLocation : Location -> Maybe Route
fromLocation location =
    if String.isEmpty location.hash then
        Just Root
    else
        parseHash route location
