module Request.Methodology exposing (methodologyRequest)

import Data.Methodology as Methodology exposing (Methodology)
import Data.Methodology.Description as Description exposing (Description)
import Data.Methodology.Diagrams as Diagrams exposing (Diagrams)
import Http
import HttpBuilder exposing (RequestBuilder, withExpect, withQueryParams)
import Json.Encode as Encode exposing (Value)
import Json.Decode exposing (int, string, float, nullable, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Request.Helpers exposing (apiUrl)
import Util exposing ((=>))


methodologyDecoder : Json.Decode.Decoder Methodology
methodologyDecoder =
    Json.Decode.Pipeline.decode Methodology
        |> Json.Decode.Pipeline.required "id" Json.Decode.int
        |> Json.Decode.Pipeline.required "name" Json.Decode.string
        |> Json.Decode.Pipeline.required "abstract" Json.Decode.string
        |> Json.Decode.Pipeline.required "quality_features" Json.Decode.string
        |> Json.Decode.Pipeline.required "info" Json.Decode.string
        |> Json.Decode.Pipeline.required "types" Json.Decode.string
        |> Json.Decode.Pipeline.required "model" Json.Decode.string
        |> Json.Decode.Pipeline.required "diagrams" Diagrams.decoderDiagrams
        |> Json.Decode.Pipeline.required "description" Description.decoderDescription


methodologyRequest : Http.Request (Methodology)
methodologyRequest =
    let
        url =
            "https://private-15cfb8-selectormetodologias1.apiary-mock.com/methodologies/1"
    in
        Http.get url methodologyDecoder
