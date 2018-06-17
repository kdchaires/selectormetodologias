package models

import (
	"errors"
	"reflect"
	"strconv"

	"github.com/globalsign/mgo/bson"
)

// SimplifiedMethodology is a short struct containing only main fields of the
// /questions resource. When reading data from the "methodologies" collection is
// instantiated in this type so that it can be handled from Go code.
type SimplifiedMethodology struct {
	ID    int        `json:"id" bson:"id,omitempty"`
	Name  string     `json:"name"`
	Links []*Hateoas `json:"links"`
}

// Methodology Documentar
// TODO Documentar
type Methodology struct {
	ID          string       `json:"id"`
	Name        string       `json:"name"`
	Abstract    string       `json:"abstract"`
	Quality     string       `json:"quality_features"`
	Info        string       `json:"info"`
	Type        string       `json:"type"`
	Model       string       `json:"model"`
	Diagrams    *Diagrams    `json:"diagrams"`
	Description *Description `json:"description"`
}

// Diagrams Documentar
// TODO Documentar
type Diagrams struct {
	Process   string `json:"process"`
	Roles     string `json:"roles"`
	Artifacts string `json:"artifacts"`
	Practices string `json:"practices"`
}

// Description Documentar
// TODO Documentar
type Description struct {
	Process   []*Process   `json:"process"`
	Roles     []*Roles     `json:"roles"`
	Artifacts []*Artifacts `json:"artifacts"`
	Practices []*Practices `json:"practices"`
	Tips      []string     `json:"tips"`
	Tools     []*Tools     `json:"tools"`
}

// Process Documentar
// TODO Documentar
type Process struct {
	Stage       int    `json:"stage"`
	Name        string `json:"name"`
	Description string `json:"description"`
	Image       string `json:"image"`
}

// Roles Documentar
// TODO Documentar
type Roles struct {
	Name        string `json:"name"`
	Description string `json:"description"`
	Image       string `json:"image"`
}

// Artifacts Documentar
// TODO Documentar
type Artifacts struct {
	Name        string `json:"name"`
	Description string `json:"description"`
	Image       string `json:"image"`
}

// Practices Documentar
// TODO Documentar
type Practices struct {
	Name        string `json:"name"`
	Description string `json:"description"`
	Image       string `json:"image"`
}

// Tools Documentar
// TODO Documentar
type Tools struct {
	Name        string `json:"name"`
	Description string `json:"description"`
	Website     string `json:"website"`
}

// EvaluatedMethodology is variant of SimplifiedMethodology that adds an extra
// "id" attribute used while retrieving evaluations from questions.
type EvaluatedMethodology struct {
	SimplifiedMethodology `bson:",inline"`
	Methodology           int `bson:"id"` // Corresponds to "id" in mongo (the int one)
}

// EvaluatedMethodologies is a slightly modified version of AllMethodologies
// that returns an extra field from the database "id".
// TODO It should be possible to reuse SimplifiedMethodology type if proper
//      consumers are modified or using interface{} as return type?
func (db *DB) EvaluatedMethodologies() ([]*EvaluatedMethodology, error) {
	var methodologies []EvaluatedMethodology

	c := db.C("methodologies")
	err := c.Find(bson.M{}).All(&methodologies)

	if err != nil {
		return nil, errors.New(
			"Can't read database, check permissions or resource names")
	}

	// TODO When used multiple-times move it to a utils/shared package
	// Used to convert from "*[]SimplifiedMethodology" to "[]*SimplifiedMethodology"
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

	return pointersOf(methodologies).([]*EvaluatedMethodology), nil
}

// AllMethodologies uses the existing database connection to read all documents
// from the "methodologies" collection and returns them as an array of pointers
// to SimplifiedMethodology instances.
func (db *DB) AllMethodologies() ([]*SimplifiedMethodology, error) {
	var methodologies []SimplifiedMethodology

	c := db.C("methodologies")
	err := c.Find(bson.M{}).All(&methodologies)

	if err != nil {
		return nil, errors.New(
			"Can't read database, check permissions or resource names")
	}

	// TODO When used multiple-times move it to a utils/shared package
	// Used to convert from "*[]SimplifiedMethodology" to "[]*SimplifiedMethodology"
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

	return pointersOf(methodologies).([]*SimplifiedMethodology), nil
}

// Methodology uses the existing database connection to read a document
// from the "methodologies" collection and returns the methodology data by id.
func (db *DB) Methodology(sid string) (*Methodology, error) {
	var methodology Methodology
	c := db.C("methodologies")

	id, err := strconv.Atoi(sid)
	if err != nil {
		return nil, errors.New(
			"Invalid format for resource ID, see API spec document")
	}

	err = c.Find(bson.M{"id": id}).One(&methodology)
	if err != nil {
		return nil, errors.New(
			"Can't read database, check permissions or resource name")
	}

	return &methodology, nil
}
