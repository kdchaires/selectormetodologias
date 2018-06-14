package models

type Suggestion struct {
	Name  string     `json:"name"`
	Score int        `json:"score"`
	Links []*Hateoas `json:"links"`
}
