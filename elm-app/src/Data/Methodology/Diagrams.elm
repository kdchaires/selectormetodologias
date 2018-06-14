module Data.Methodology.Diagrams exposing (Diagrams, decoderDiagrams)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipe


type alias Diagrams =
    { process : String
    , roles : String
    , artifacts : String
    , practices : String
    }


decoderDiagrams : Decoder Diagrams
decoderDiagrams =
    Pipe.decode Diagrams
        |> Pipe.required "process" Decode.string
        |> Pipe.required "roles" Decode.string
        |> Pipe.required "artifacts" Decode.string
        |> Pipe.required "practices" Decode.string
