module MethodologyTest exposing (..)

import Expect
import Fuzz exposing (int, string)
import Json.Decode exposing (decodeValue)
import Json.Encode as Json
import Data.Methodology.Description as Description exposing (..)
import Test exposing (..)


suite : Test
suite =
    describe "the Methodology Module"
        [ fuzz4 int string string string "ProcessDecoder maps to a Process" <|
            \stage name description image ->
                let
                    json =
                        Json.object
                            [ ( "stage", Json.int stage )
                            , ( "name", Json.string name )
                            , ( "description", Json.string description )
                            , ( "image", Json.string image )
                            ]
                in
                    decodeValue decoderProcess json
                        |> Expect.equal
                            (Ok { stage = stage, name = name, description = description, image = image })
        , fuzz3 string string string "RolesDecoder maps to a Roles" <|
            \name description image ->
                let
                    json =
                        Json.object
                            [ ( "name", Json.string name )
                            , ( "description", Json.string description )
                            , ( "image", Json.string image )
                            ]
                in
                    decodeValue decoderRoles json
                        |> Expect.equal
                            (Ok { name = name, description = description, image = image })
        , fuzz3 string string string "ArtifactsDecoder maps to a Artifacts" <|
            \name description image ->
                let
                    json =
                        Json.object
                            [ ( "name", Json.string name )
                            , ( "description", Json.string description )
                            , ( "image", Json.string image )
                            ]
                in
                    decodeValue decoderArtifacts json
                        |> Expect.equal
                            (Ok { name = name, description = description, image = image })
        , fuzz3 string string string "practicesDecoder maps to a Practices" <|
            \name description image ->
                let
                    json =
                        Json.object
                            [ ( "name", Json.string name )
                            , ( "description", Json.string description )
                            , ( "image", Json.string image )
                            ]
                in
                    decodeValue decoderPractices json
                        |> Expect.equal
                            (Ok { name = name, description = description, image = image })
        , fuzz string "TipsDecoder maps to a Tips" <|
            \tips ->
                let
                    json =
                        Json.object
                            [ ( "tips", Json.string tips )
                            ]
                in
                    decodeValue decoderTips json
                        |> Expect.equal
                            (Ok { tips = tips })
        , fuzz3 string string string "ToolsDecoder maps to a Tools" <|
            \name description website ->
                let
                    json =
                        Json.object
                            [ ( "name", Json.string name )
                            , ( "description", Json.string description )
                            , ( "website", Json.string website )
                            ]
                in
                    decodeValue decoderTools json
                        |> Expect.equal
                            (Ok { name = name, description = description, website = website })
        ]
