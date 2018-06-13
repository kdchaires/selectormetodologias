module Data.Questions.Question exposing (Question, decoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (custom, decode, required)


type alias Question =
    { id : String
    , question : String
    , criteria : String
    }


decoder : Decoder Question
decoder =
    decode Question
        |> required "id" Decode.string
        |> required "question" Decode.string
        |> required "criteria" Decode.string



-- tagDecoder : Decoder Tag
-- tagDecoder =
--     Decode.map Tag Decode.string
