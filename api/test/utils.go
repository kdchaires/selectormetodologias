package test

import (
	"bytes"
	"encoding/json"
	"io/ioutil"
	"path/filepath"
	"testing"
	"time"

	"github.com/kdchaires/selectormetodologias/api/models"
)

type mockDB struct{}

func loadFixture(t *testing.T, name string) string {
	path := filepath.Join("testdata", name) // relative path

	bs, err := ioutil.ReadFile(path)
	if err != nil {
		t.Fatalf("While loading \"%s\" fixture: %s", name, err.Error())
	}

	// Removes new lines and extra spaces from json fixture
	var bcontents bytes.Buffer
	err = json.Compact(&bcontents, bs)
	if err != nil {
		t.Fatalf("While pruning \"%s\" fixture: %s", name, err.Error())
	}

	return bcontents.String() + "\n" // Responses have \n appendend
}

func (mdb *mockDB) SaveFeedback(f *models.Feedback) error {
	// Set a fake "created_at" date
	str := "2018-06-01T13:04:27.688581055-05:00"
	t, err := time.Parse(time.RFC3339, str)

	if err != nil {
		return err
	}

	f.CreatedAt = t

	return nil
}

func (mdb *mockDB) AllQuestions() ([]*models.Question, error) {
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

	return questions, nil
}

func (mdb *mockDB) AllMethodologies() ([]*models.SimplifiedMethodology, error) {
	methodologies := []*models.SimplifiedMethodology{
		&models.SimplifiedMethodology{
			ID:   "0b160f960cbf7fb48ebbf4f8",
			Name: "scrum",
			Links: []*models.Hateoas{
				&models.Hateoas{
					Href: "methodologies/0b160f960cbf7fb48ebbf4f8",
					Rel:  "self",
					Type: "GET",
				},
			},
		},
		&models.SimplifiedMethodology{
			ID:   "8f4fbbe84bf7fbc069f061b0",
			Name: "xp",
			Links: []*models.Hateoas{
				&models.Hateoas{
					Href: "methodologies/8f4fbbe84bf7fbc069f061b0",
					Rel:  "self",
					Type: "GET",
				},
			},
		},
	}

	return methodologies, nil
}
