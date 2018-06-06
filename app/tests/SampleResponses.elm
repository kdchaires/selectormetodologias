module SampleResponses exposing (..)


questionResponse =
    """
{
  "id": "1",
  "question": "Es el presupuesto para el proyecto limitado?",
  "criteria": "Dimensión del proyecto",
  "evaluations": [
    {
      "methodology": 1,
      "evaluation": 3
    },
    {
      "methodology": 2,
      "evaluation": 1
    },
    {
      "methodology": 3,
      "evaluation": 5
    }
  ]
}
"""


questionsResponse =
    """
[
  {
    "id": "1",
    "question": "Es el presupuesto para el proyecto limitado?",
    "criteria": "Dimensión del proyecto",
    "evaluations": [
      {
        "methodology": 1,
        "evaluation": 3
      },
      {
        "methodology": 2,
        "evaluation": 1
      },
      {
        "methodology": 3,
        "evaluation": 5
      }
    ]
  }
]
"""
