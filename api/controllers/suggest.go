package controllers

import (
	"encoding/json"
	"net/http"

	"github.com/kdchaires/selectormetodologias/api/models"
)

// SuggestHandler generates a server response as specified by
// https://selectormetodologias1.docs.apiary.io/#reference/sugerencia/coleccion-de-recomendacion/generar-una-recomendacion
// TODO Optimize function calls and loops with pass by reference
func (app *App) SuggestHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "applicaton/json")

	methodologies, err := app.Database.EvaluatedMethodologies()
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(err.Error())
		return
	}

	questions, err := app.Database.AllQuestions()
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(err.Error())
		return
	}

	matrix := loadEvaluationMatrix(questions, methodologies)

	// Retrieve the user's answers from the request
	decoder := json.NewDecoder(r.Body)
	var vector []models.VectorCell

	err = decoder.Decode(&vector)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(err.Error())
		return
	}

	// Computing answers matrix in a simple map
	// TODO Improve types so references to methodologies objects are not lost
	// and there will be no need to re-find methodologies with the loops bellow
	result := matrixMultiplication(matrix, vector)
	var suggestMethodology int
	var suggestScore int

	// Finding highest score
	for m, score := range result {
		if score > suggestScore {
			suggestScore = score
			suggestMethodology = m
		}
	}

	var methodology models.EvaluatedMethodology

	// Retrieving methodology with highest score
	for _, m := range methodologies {
		if m.Methodology == suggestMethodology {
			methodology = *m
		}
	}

	link := &models.Hateoas{
		Href: "methodologies/" + methodology.ID.Hex(),
		Rel:  "self",
		Type: "GET",
	}

	// Process result by building the expected json answer
	suggestion := models.Suggestion{
		Name:  methodology.Name,
		Score: suggestScore,
		Links: []*models.Hateoas{link},
	}

	json.NewEncoder(w).Encode(suggestion)
}

func matrixMultiplication(matrix []*models.MatrixCell, vector []models.VectorCell) map[int]int {
	var result = make(map[int]int)

	for _, r := range matrix {
		if r == nil {
			continue
		}

		for _, v := range vector {
			if (*r).Question == v.Question {
				score := (*r).Evaluation * v.Answer
				result[(*r).Methodology] += score
			}
		}
	}

	return result
}

func loadEvaluationMatrix(
	questions []*models.Question,
	methodologies []*models.EvaluatedMethodology) []*models.MatrixCell {

	var matrix = make([]*models.MatrixCell, len(questions)*len(methodologies))

	for _, m := range methodologies {
		for _, q := range questions {
			for _, ev := range q.Evaluations {
				if m.Methodology == ev.Methodology {
					matrix = append(matrix, &models.MatrixCell{
						Question:    q.ID,
						Methodology: ev.Methodology,
						Evaluation:  ev.Evaluation,
					})
				}
			}
		}
	}

	return matrix
}
