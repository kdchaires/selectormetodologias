module SampleResponses exposing (..)


artifactResponse =
    """
{
    "id": 223
    "name": "Rup",
    "abstract": "Bla bla bla bla",
    "quality_features": "Bla bla bla bla",
    "info": "http://..../rup.html",
    "type": "tradicional",
    "model": "espiral",
    "diagrams": {
        "process": "http://....../rup/process.png",
        "roles": "http://......../rup/roles.jpg",
        "artifacts": "http://......../rup/artifacts.jpeg",
        "practices": "http://......../rup/practices.jpeg"
    },
    "description": {
        "process": [
            {
                "stage": 1,
                "name": "Inception",
                "description": "The idea for the project is stated. The development team determines...",
                "image": "http://...../rup/stage/1/inception.jpg"
            },
            {
                "stage": 2,
                "name": "Elaboration",
                "description": "The project's architecture and required resources are further evaluated...",
                "image": "http://...../rup/stage/2/elaboration.jpg"
            },
            {
                "stage": 3,
                "name": "Construction",
                "description": "The project is developed and completed.",
                "image": "http://...../rup/stage/3/construction.jpg"
            },
            {
                "stage": 4,
                "name": "Transition",
                "description": "The software is released to the public",
                "image": "http://...../rup/stage/4/transition.jpg"
            }
        ],
        "roles": [
            {
                "name": "Senior developer",
                "description": "Bla bla bla bla",
                "image": "http://...../rup/role/1/avatar.jpg"
            },
            {
                "name": "Team leader",
                "description": "Bla bla bla bla",
                "image": "http://...../rup/role/2/avatar.jpg"
            }
        ],
        "artifacts": [
            {
                "name": "Code documentation",
                "description": "Bla bla bla",
                "image": "http://..../rup/artifact/1/documentation.jpg"
            }
        ],
        "practices": [
            {
                "name": "Pair programming",
                "description": "Bla bla bla",
                "image": "http://....../rup/practices/1/ppg.png",
                "produces_artifacts": [
                    "Pruebas automatizadas"
                ]
            },
            {
                "tdd": "Test driven development",
                "description": "Bla bla bla",
                "image": "http://...../rup/practices/2/tdd.jpeg",
                "produces_artifacts": []
            }
        ],
        "tips": [
            "Bla bla bla"
        ],
        "tools": [
            {
                "name": "Trello",
                "description": "Bla bla bla",
                "website": "http://trello.com/"
            },
        ]
    }
}
"""
