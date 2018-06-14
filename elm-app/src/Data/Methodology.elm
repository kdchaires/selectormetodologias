module Data.Methodology exposing (Methodology, decoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, required)
import Data.Methodology.Diagrams as Diagrams exposing (Diagrams)
import Data.Methodology.Description as Description exposing (Description)


type alias Methodology =
    { id : String
    , name :
        String
    , abstract :
        String
    , quality_features :
        String
    , info :
        String
    , types :
        String
    , model :
        String
    , diagrams :
        Diagrams
    , description : Description
    }


decoder : Decoder Methodology
decoder =
    decode Methodology
        |> required "id" Decode.string
        |> required "name" Decode.string
        |> required "abstract" Decode.string
        |> required "quality_features" Decode.string
        |> required "info" Decode.string
        |> required "type" Decode.string
        |> required "model" Decode.string
        |> required "diagrams" Diagrams.decoderDiagrams
        |> required "description" Description.decoderDescription
