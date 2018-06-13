module Request.Questions.Question exposing (list)

import Data.Questions as Questions exposing (Questions)
import Data.Questions.Question as Question exposing (Question)
import Http
import HttpBuilder exposing (RequestBuilder, withExpect, withQueryParams)
import Json.Decode as Decode
import Request.Helpers exposing (apiUrll)
import Util exposing ((=>))


-- LIST --


list : Http.Request (List Question)
list =
    Decode.field "question" (Decode.list Question.decoder)
        |> Http.get (apiUrll "/questions")
