module Questions exposing (..)


type alias Question =
    { id : Int
    , question : String
    , criteria : String
    , choices : List String
    }


budgetAvailableQuestion : Question
budgetAvailableQuestion =
    { id = 1
    , question = "¿El presupuesto para el proyecto es limitado?"
    , criteria = "Presupuesto disponible"
    , choices = [ "Si", "No" ]
    }


projectDimensionQuestion : Question
projectDimensionQuestion =
    { id = 2
    , question = "¿Se puede considerar grande la dimensión del proyecto?"
    , criteria = "Dimensión del proyecto"
    , choices = [ "Si", "No" ]
    }


deliveryTimeQuestion : Question
deliveryTimeQuestion =
    { id = 3
    , question = "¿Es necesario entregar el proyecto en un corto período de tiempo, en relación con el tamaño del proyecto?"
    , criteria = "El tiempo de entrega"
    , choices = [ "Si", "No" ]
    }


timeBoxingQuestion : Question
timeBoxingQuestion =
    { id = 4
    , question = "¿Están dispuestos a eliminar funciones secundarias de SW para cumplir con el cronograma del proyecto?"
    , criteria = "Time boxing"
    , choices = [ "Si", "No" ]
    }


requiredDocumentationQuestion : Question
requiredDocumentationQuestion =
    { id = 5
    , question = "¿Es necesario que el proyecto genere documentación sólida?"
    , criteria = "Documentos requeridos"
    , choices = [ "Si", "No" ]
    }


developersQuestion : Question
developersQuestion =
    { id = 6
    , question = "¿Se requiere un equipo de desarrollo sólido y completo en el ¿proyecto?"
    , criteria = "Desarrollo"
    , choices = [ "Si", "No" ]
    }


clientsQuestion : Question
clientsQuestion =
    { id = 6
    , question = "¿Es necesario en el proyecto acompañar al cliente en el proceso o varias etapas de eso?"
    , criteria = "Clientes"
    , choices = [ "Si", "No" ]
    }


changesQuestion : Question
changesQuestion =
    { id = 7
    , question = "¿El proyecto a desarrollar puede presentar cambios significativos en cualquier etapa o etapa del proyecto?"
    , criteria = "Habilidad reponder a cambios"
    , choices = [ "Si", "No" ]
    }


iterativeQuestion : Question
iterativeQuestion =
    { id = 8
    , question = "¿Se requiere realizar iteraciones en el desarrollo del proyecto?"
    , criteria = "Iterativo"
    , choices = [ "Si", "No" ]
    }


question : List Question
question =
    [ budgetAvailableQuestion
    , projectDimensionQuestion
    , deliveryTimeQuestion
    , timeBoxingQuestion
    , requiredDocumentationQuestion
    , developersQuestion
    , clientsQuestion
    , changesQuestion
    , iterativeQuestion
    ]
