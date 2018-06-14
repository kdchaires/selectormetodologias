module Data.ListMethodologies exposing (ListMethodologies, methodologiesListDecoder)

import Json.Decode as Decode exposing (Decoder)
import Data.Methodologies.SimplifiedMethodology as SimplifiedMethodology exposing (SimplifiedMethodology)


type alias ListMethodologies =
    { index : Int
    , activePage : Int
    , methodologies : List SimplifiedMethodology
    }


methodologiesListDecoder : Decoder (List SimplifiedMethodology)
methodologiesListDecoder =
    Decode.list SimplifiedMethodology.decoder
