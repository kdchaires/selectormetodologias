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


methodologyRequest : Http.Request (Methodology)
methodologyRequest =
    let
        url =
            --  "https://private-15cfb8-selectormetodologias1.apiary-mock.com/methodologies/1"
            "http://192.168.10.11:8088/methodologies/1"
    in
        Http.get url Methodology.decoder
