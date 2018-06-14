module Data.Suggest exposing (Suggest, suggestDecoder, empty)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipe


type alias Hateoas =
    { href : String
    , type_ : String
    , rel : String
    }


type alias Suggest =
    { name : String
    , score : Int
    , links : List Hateoas
    }


empty : Suggest
empty =
    Suggest "" 0 []



-- SERIALIZATION --


suggestDecoder : Decode.Decoder Suggest
suggestDecoder =
    Pipe.decode Suggest
        |> Pipe.required "name" Decode.string
        |> Pipe.required "score" Decode.int
        |> Pipe.required "links" (Decode.list hateoasDecoder)


hateoasDecoder : Decode.Decoder Hateoas
hateoasDecoder =
    Pipe.decode Hateoas
        |> Pipe.required "href" Decode.string
        |> Pipe.required "type" Decode.string
        |> Pipe.required "rel" Decode.string
