package models

import (
	"log"
	"os"

	"github.com/globalsign/mgo"
)

// Datastore is the interface that should be implemented by any other structure
// wanting to be used as database access layer. It's defined because simplifies
// testing of handlers that access the database.
type Datastore interface {
	AllQuestions() ([]*Question, error)
	SaveFeedback(*Feedback) error
}

// DB wraps a reference to the database cursor. It is expected for this struct
// to implement the interface Datastore. It's defined because simplifies testing
// of handlers that acess the database.
type DB struct {
	*mgo.Database
}

// NewDBConnection starts a new session with the database, it access environment
// variables to know which host and port to dial to. It's intended to be called
// once in the bootsraping process unless dedicated extra connections are
// required later on.
// TODO Move to a more general file/package?
func NewDBConnection(databaseName string) (*DB, error) {
	// TODO Take into consideration user, password
	//      See: https://godoc.org/github.com/globalsign/mgo#Dial
	session, err := mgo.Dial(
		os.Getenv("MONGODB_HOST") + ":" + os.Getenv("MONGODB_PORT"))

	if err != nil {
		log.Println("*** Unable to connect to the database ***")
		return nil, err
	}

	if err = session.Ping(); err != nil {
		log.Println("*** Connected to database, but can't ping it ***")
		return nil, err
	}

	return &DB{session.DB(databaseName)}, nil
}
