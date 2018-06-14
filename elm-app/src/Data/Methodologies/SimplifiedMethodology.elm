module Data.Methodologies.SimplifiedMethodology exposing (SimplifiedMethodology, decoder)

import Json.Decode as Decode exposing (Decoder)
import Data.Methodologies.Link as Link exposing (Link)
import Json.Decode.Pipeline as Pipe


type alias SimplifiedMethodology =
    { id : Int
    , name :
        String
        --  , links : List Link
    }


decoder : Decoder SimplifiedMethodology
decoder =
    Pipe.decode SimplifiedMethodology
        |> Pipe.required "id" Decode.int
        |> Pipe.required "name" Decode.string



--  |> Pipe.required "links" (Decode.list Link.decoder)
