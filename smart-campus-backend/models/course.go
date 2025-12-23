package models

import "gorm.io/gorm"

type Course struct {
	gorm.Model
	Name        string    `json:"name"`
	Description string    `json:"description"`
	Students    []Student `json:"students"` // Course එකකට ශිෂ්‍යයන් ගොඩක් ඉන්න පුළුවන්
}