package models

import "gorm.io/gorm"

type Course struct {
	gorm.Model
	Name        string    `json:"name"`
	Description string    `json:"description"`
	Lecturer    string    `json:"lecturer"`
	Students    []Student `json:"students" gorm:"many2many:student_courses;"`
}