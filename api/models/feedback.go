package models

import (
	"strings"
	"time"

	"github.com/kdchaires/selectormetodologias/api/utils"
)

// Feedback is the struct corresponding to the /feedback resource. Once data has
// been read from the database it's instantiated in this type so that it can be
// handled in Go code.
type Feedback struct {
	Email       string    `json:"email" bson:"_id"`
	CreatedAt   time.Time `json:"created_at" bson:"created_at"`
	Institution string    `json:"institution"`
	Finished    bool      `json:"finished"`
	Description string    `json:"description"`
}

// SaveFeedback uses the existing database connection to insert a new document
// in the "feedbacks" collection and returns an error if the provided 'feedback'
// struct is not valid or if it couldn't save it.
func (db *DB) SaveFeedback(feedback *Feedback) error {
	// Data validation
	feedback.CreatedAt = time.Now()
	feedback.Institution = strings.TrimSpace(feedback.Institution)

	// Clean and validate email address format
	email, err := utils.CleanAndValidateEmail(feedback.Email)
	if err != nil {
		return err
	}
	feedback.Email = email

	// Save to database
	c := db.C("feedbacks")
	return c.Insert(feedback)
}
