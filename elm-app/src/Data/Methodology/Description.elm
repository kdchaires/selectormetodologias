module Data.Methodology.Description
    exposing
        ( Description
        , decoderDescription
        , Process
        , decoderProcess
        , Roles
        , decoderRoles
        , Artifacts
        , decoderArtifacts
        , Practices
        , decoderPractices
        , Tips
        , decoderTips
        , Tools
        , decoderTools
        )

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline as Pipe


type alias Description =
    { process : List Process
    , roles : List Roles
    , artifacts : List Artifacts
    , practices : List Practices
    , tips : List Tips
    , tools : List Tools
    }


decoderDescription : Decoder Description
decoderDescription =
    Pipe.decode Description
        |> Pipe.required "process" (Decode.list decoderProcess)
        |> Pipe.required "roles" (Decode.list decoderRoles)
        |> Pipe.required "artifacts" (Decode.list decoderArtifacts)
        |> Pipe.required "practices" (Decode.list decoderPractices)
        |> Pipe.required "tips" (Decode.list decoderTips)
        |> Pipe.required "tools" (Decode.list decoderTools)



-- Process --


type alias Process =
    { stage : Int
    , name : String
    , description : String
    , image : String
    }


decoderProcess : Decoder Process
decoderProcess =
    Pipe.decode Process
        |> Pipe.required "stage" Decode.int
        |> Pipe.required "name" Decode.string
        |> Pipe.required "description" Decode.string
        |> Pipe.required "image" Decode.string



-- Roles --


type alias Roles =
    { name : String
    , description : String
    , image : String
    }


decoderRoles : Decoder Roles
decoderRoles =
    Pipe.decode Roles
        |> Pipe.required "name" Decode.string
        |> Pipe.required "description" Decode.string
        |> Pipe.required "image" Decode.string



-- Artifacts--


type alias Artifacts =
    { name : String
    , description : String
    , image : String
    }


decoderArtifacts : Decoder Artifacts
decoderArtifacts =
    Pipe.decode Artifacts
        |> Pipe.required "name" Decode.string
        |> Pipe.required "description" Decode.string
        |> Pipe.required "image" Decode.string



-- Practices--


type alias Practices =
    { name : String
    , description : String
    , image : String
    }


decoderPractices : Decoder Practices
decoderPractices =
    Pipe.decode Practices
        |> Pipe.required "name" Decode.string
        |> Pipe.required "description" Decode.string
        |> Pipe.required "image" Decode.string



-- Tools--


type alias Tools =
    { name : String
    , description : String
    , website : String
    }


decoderTools : Decoder Tools
decoderTools =
    Pipe.decode Tools
        |> Pipe.required "name" Decode.string
        |> Pipe.required "description" Decode.string
        |> Pipe.required "website" Decode.string



-- Tips--
-- type alias Tips =
--     String


type alias Tips =
    String


decoderTips : Decoder Tips
decoderTips =
    Decode.field "tips" Decode.string



-- decoderTips : Decoder Tips
-- decoderTips =
--     Pipe.decode Tips
--         |> Pipe.required "tips" Decode.string
