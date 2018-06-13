module Request.Helpers exposing (apiUrl, apiUrll)


apiUrl : String -> String
apiUrl str =
    "https://conduit.productionready.io/api" ++ str


apiUrll : String -> String
apiUrll str =
    "http://192.168.10.11:8088" ++ str
