module Request.ListMethodologies exposing (getMethodologies)

import Data.Methodologies.SimplifiedMethodology as SimplifiedMethodology exposing (SimplifiedMethodology)
import Data.Methodologies.Link as Link exposing (Link)
import Http
import Json.Decode exposing (int, string, float, nullable, Decoder)
import Json.Decode.Pipeline as Pipe
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Request.Helpers exposing (apiUrll)


linkDecoder : Json.Decode.Decoder Link
linkDecoder =
    Pipe.decode Link
        |> Pipe.required "href" Json.Decode.string
        |> Pipe.required "rel" Json.Decode.string
        |> Pipe.required "type_" Json.Decode.string


methodologiesListDecoder : Json.Decode.Decoder (List SimplifiedMethodology)
methodologiesListDecoder =
    Json.Decode.list methodologyDecoder


methodologyDecoder : Json.Decode.Decoder SimplifiedMethodology
methodologyDecoder =
    Pipe.decode SimplifiedMethodology
        |> Pipe.required "id" Json.Decode.string
        |> Pipe.required "name" Json.Decode.string



--|> Pipe.required "links" (Json.Decode.list linkDecoder)


getMethodologies : Http.Request (List SimplifiedMethodology)
getMethodologies =
    let
        url =
            apiUrll ("/methodologies")
    in
        Http.get url methodologiesListDecoder
