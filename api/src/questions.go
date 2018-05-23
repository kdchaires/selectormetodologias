package main

import "github.com/globalsign/mgo/bson"

type Evaluation struct {
	Methodology int `json:"methodology"`
	Evaluation  int `json:"evaluation"`
}

type Choice struct {
	Id     int    `json:"id"`
	Choice string `json:"choice"`
}

type Question struct {
	Id          bson.ObjectId `json:"id" bson:"_id,omitempty"`
	Question    string        `json:"question"`
	Criteria    string        `json:"criteria"`
	Evaluations []Evaluation  `json:"evaluations"`
	Choices     []Choice      `json:"choices"`
}
