module Request.Questions exposing (questionsRequest)

import Data.Questions as Questions exposing (Questions)
import Data.Questions.Question as Question exposing (Question)
import Data.AuthToken exposing (AuthToken, withAuthorization)
import Http
import HttpBuilder exposing (RequestBuilder, withExpect, withQueryParams)
import Json.Encode as Encode exposing (Value)
import Json.Decode exposing (int, string, float, nullable, Decoder)
import Json.Decode.Pipeline exposing (decode, required, optional, hardcoded)
import Request.Helpers exposing (apiUrl)
import Util exposing ((=>))


questionListDecoder : Json.Decode.Decoder (List Question)
questionListDecoder =
    Json.Decode.list questionDecoder


questionDecoder : Json.Decode.Decoder Question
questionDecoder =
    Json.Decode.Pipeline.decode Question
        |> Json.Decode.Pipeline.required "id" Json.Decode.string
        |> Json.Decode.Pipeline.required "question" Json.Decode.string
        |> Json.Decode.Pipeline.required "criteria" Json.Decode.string


questionsRequest : Http.Request (List Question)
questionsRequest =
    let
        url =
            "http://192.168.10.11:8088/questions"
    in
        Http.get url questionListDecoder
