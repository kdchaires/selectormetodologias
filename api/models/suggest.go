package models

import "github.com/globalsign/mgo/bson"

// Suggestion is the struct corresponding to the /suggest resource. Once a
// suitable methodology has been calculated for the user methodology data is
// instantiated in this type so that it can be easily parsed to a JSON response.
type Suggestion struct {
	Name  string     `json:"name"`
	Score int        `json:"score"`
	Links []*Hateoas `json:"links"`
}

// MatrixCell represents a single cell in the criteria & evaluations matrix,
// refering to the "Model for Selecting Software Development Methodology" paper
// this represents a scalar in the matrix A.
type MatrixCell struct {
	Question    bson.ObjectId
	Methodology int
	Evaluation  int
}

// VectorCell represents a single cell in the user's answer vector,
// refering to the "Model for Selecting Software Development Methodology" paper
// this represents a scalar in the vector B.
type VectorCell struct {
	Question bson.ObjectId `json:"question"`
	Answer   int           `json:"value"`
}
