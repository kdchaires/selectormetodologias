module Data.Questions.Evaluation exposing (Evaluation, decoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (custom, decode, required)


type alias Evaluation =
    { idQuestion : String
    , value : Int
    }


decoder : Decoder Evaluation
decoder =
    decode Evaluation
        |> required "idQuestion" Decode.string
        |> required "value" Decode.int
