package config

import (
	"smart-campus-backend/models"
	"github.com/glebarez/sqlite"
	"gorm.io/gorm"
)

var DB *gorm.DB

func ConnectDatabase() {
	db, err := gorm.Open(sqlite.Open("campus.db"), &gorm.Config{})
	if err != nil {
		panic("Failed to connect to database!")
	}

	// Models දෙකම migrate කරමු
	db.AutoMigrate(&models.Course{}, &models.Student{})
	DB = db
}