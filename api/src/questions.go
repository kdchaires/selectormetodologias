package main

type Evaluation struct {
	Methodology int `json:"methodology"`
	Evaluation  int `json:"evaluation"`
}

type Choice struct {
	Id     int    `json:"id"`
	Choice string `json:"choice"`
}

type Question struct {
	Question    string       `json:"question"`
	Criteria    string       `json:"criteria"`
	PublishedAt string       `json:"published_at"`
	Evaluations []Evaluation `json:"evaluations"`
	Choices     []Choice     `json:"choices"`
}

func QuestionsList() []Question {
	choices := []Choice{
		Choice{0, "No"},
		Choice{1, "Si"},
	}

	evaluations := []Evaluation{
		Evaluation{Methodology: 1, Evaluation: 3},
		Evaluation{Methodology: 2, Evaluation: 1},
		Evaluation{Methodology: 3, Evaluation: 5},
	}

	return []Question{
		Question{
			Question:    "¿El presupuesto para el proyecto es limitado?",
			Criteria:    "Presupuesto disponible",
			PublishedAt: "2015-08-05T08:40:51.620Z",
			Evaluations: evaluations,
			Choices:     choices,
		},
		Question{
			Question:    "¿Se puede considerar grande la dimensión del proyecto?",
			Criteria:    "Dimensión del proyecto",
			PublishedAt: "2015-08-05T08:40:51.620Z",
			Evaluations: evaluations,
			Choices:     choices,
		},
		Question{
			Question:    "¿Es necesario entregar el proyecto en un corto período de tiempo, en relación con el tamaño del proyecto?",
			Criteria:    "Tiempo de entrega",
			PublishedAt: "2015-08-05T08:40:51.620Z",
			Evaluations: evaluations,
			Choices:     choices,
		},
		Question{
			Question:    "¿Están dispuestos a eliminar funciones secundarias de SW para cumplir con el cronograma del proyecto?",
			Criteria:    "Ventanas de tiempo",
			PublishedAt: "2015-08-05T08:40:51.620Z",
			Evaluations: evaluations,
			Choices:     choices,
		},
		Question{
			Question:    "¿Es necesario que el proyecto genere documentación sólida?",
			Criteria:    "Documentación requerida",
			PublishedAt: "2015-08-05T08:40:51.620Z",
			Evaluations: evaluations,
			Choices:     choices,
		},
		Question{
			Question:    "¿Se requiere un equipo de desarrollo sólido y completo en el ¿proyecto?",
			Criteria:    "Recursos humanos requeridos: Desarrolladores",
			PublishedAt: "2015-08-05T08:40:51.620Z",
			Evaluations: evaluations,
			Choices:     choices,
		},
		Question{
			Question:    "¿Es necesario en el proyecto acompañar al cliente en el proceso o varias etapas de eso?",
			Criteria:    "Recursos humanos requeridos: Cliente",
			PublishedAt: "2015-08-05T08:40:51.620Z",
			Evaluations: evaluations,
			Choices:     choices,
		},
		Question{
			Question:    "¿El proyecto a desarrollar puede presentar cambios significativos en cualquier etapa o etapa del proyecto?",
			Criteria:    "Adaptabilidad, respuesta al cambio",
			PublishedAt: "2015-08-05T08:40:51.620Z",
			Evaluations: evaluations,
			Choices:     choices,
		},
		Question{
			Question:    "¿Se requiere realizar iteraciones en el desarrollo del proyecto?",
			Criteria:    "Iterativo",
			PublishedAt: "2015-08-05T08:40:51.620Z",
			Evaluations: evaluations,
			Choices:     choices,
		},
	}
}
