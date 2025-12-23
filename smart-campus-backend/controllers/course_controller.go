package controllers

import (
	"net/http"
	"smart-campus-backend/config"
	"smart-campus-backend/models"
	"github.com/gin-gonic/gin"
)

// සියලුම පාඨමාලා (Courses) ලබාගැනීම
func GetAllCourses(c *gin.Context) {
	var courses []models.Course
	// මෙතනදී ඒ ඒ පාඨමාලාවට අදාළ ශිෂ්‍යයන්ව පවා පෙන්වන්න පුළුවන්
	config.DB.Preload("Students").Find(&courses)
	c.JSON(http.StatusOK, courses)
}

// අලුත් පාඨමාලාවක් ඇතුළත් කිරීම
func CreateCourse(c *gin.Context) {
	var input models.Course
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	config.DB.Create(&input)
	c.JSON(http.StatusCreated, input)
}