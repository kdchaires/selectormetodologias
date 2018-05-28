package test

import "github.com/kdchaires/selectormetodologias/api/models"

type mockDB struct{}

func (mdb *mockDB) AllQuestions() []*models.Question {
	evaluations := []models.Evaluation{
		models.Evaluation{Methodology: 1, Evaluation: 3},
		models.Evaluation{Methodology: 2, Evaluation: 1},
		models.Evaluation{Methodology: 3, Evaluation: 5},
	}

	questions := []*models.Question{
		&models.Question{
			ID:          "5b0593",
			Question:    "is a test?",
			Criteria:    "some",
			Evaluations: evaluations,
		},
		&models.Question{
			ID:          "6c1482",
			Question:    "is it?",
			Criteria:    "thing",
			Evaluations: evaluations,
		},
		&models.Question{
			ID:          "7d2371",
			Question:    "it could be?",
			Criteria:    "sure",
			Evaluations: evaluations,
		},
	}

	return questions
}
