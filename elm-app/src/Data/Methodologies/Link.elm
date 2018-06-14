module Data.Methodologies.Link exposing (Link, decoder)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipe


type alias Link =
    { href : String
    , rel : String
    , type_ : String
    }


decoder : Decode.Decoder Link
decoder =
    Pipe.decode Link
        |> Pipe.required "href" Decode.string
        |> Pipe.required "rel" Decode.string
        |> Pipe.required "type" Decode.string
