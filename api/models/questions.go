package models

import (
	"log"
	"reflect"

	"github.com/globalsign/mgo/bson"
)

// Evaluation is a helper useful to create nested JSON object "evaluations"
// while listing the questions or details for a question.
type Evaluation struct {
	Methodology int `json:"methodology"`
	Evaluation  int `json:"evaluation"`
}

// Question is the struct corresponding to the /questions resource. Once data
// has been read from the database it's instantiated in this type so that it
// can be handled in Go code.
type Question struct {
	ID          bson.ObjectId `json:"id" bson:"_id,omitempty"`
	Question    string        `json:"question"`
	Criteria    string        `json:"criteria"`
	Evaluations []Evaluation  `json:"evaluations"`
}

// AllQuestions uses the existing database connection to read all documents from
// the "questions" collection and returns them as an array of pointers to
// Question instances.
func (db *DB) AllQuestions() []*Question {
	var questions []Question

	c := db.C("questions")
	err := c.Find(bson.M{}).All(&questions)

	// TODO Handle the error better so the web service can return HTTP 500
	if err != nil {
		log.Fatal("Can't read database, check permissions or resource names")
	}

	// TODO When used multiple-times move it to a utils/shared package
	// Used to convert from "*[]Question" to "[]*Question"
	pointersOf := func(v interface{}) interface{} {
		in := reflect.ValueOf(v)
		out := reflect.MakeSlice(
			reflect.SliceOf(reflect.PtrTo(in.Type().Elem())),
			in.Len(),
			in.Len())

		for i := 0; i < in.Len(); i++ {
			out.Index(i).Set(in.Index(i).Addr())
		}

		return out.Interface()
	}

	return pointersOf(questions).([]*Question)
}
