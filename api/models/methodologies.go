package models

import (
	"errors"
	"reflect"

	"github.com/globalsign/mgo/bson"
)

// Hateoas is a helper useful to create nested JSON object "links" while
// listing the methodologies. An array of this struct is held inside the
// SimplifiedMethodology struct type.
type Hateoas struct {
	Href string `json:"href"`
	Rel  string `json:"rel"`
	Type string `json:"type"`
}

// SimplifiedMethodology is a short struct containing only main fields of the
// /questions resource. When reading data from the "methodologies" collection is
// instantiated in this type so that it can be handled from Go code.
type SimplifiedMethodology struct {
	ID    bson.ObjectId `json:"id" bson:"_id,omitempty"`
	Name  string        `json:"name"`
	Links []*Hateoas    `json:"links"`
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
