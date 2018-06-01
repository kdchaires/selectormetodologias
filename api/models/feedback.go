package models

import (
	"time"

	"github.com/globalsign/mgo/bson"
)

type Feedback struct {
	ID          bson.ObjectId `json:"id" bson:"_id,omitempty"`
	CreatedAt   time.Time     `json:"created_at" bson:"created_at"`
	Institution string        `json:"institution"`
	Email       string        `json:"email"`
	Finished    bool          `json:"finished"`
	Description string        `json:"description"`
}

func (db *DB) SaveFeedback(feedback *Feedback) error {
	c := db.C("feedbacks")
	return c.Insert(feedback)
}
