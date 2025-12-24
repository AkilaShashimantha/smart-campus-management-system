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

// Course එකක් Update කිරීම
func UpdateCourse(c *gin.Context) {
	id := c.Param("id")
	var course models.Course
	if err := config.DB.First(&course, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Course not found"})
		return
	}
	c.ShouldBindJSON(&course)
	config.DB.Save(&course)
	c.JSON(http.StatusOK, course)
}

// Course එකක් Delete කිරීම
func DeleteCourse(c *gin.Context) {
	id := c.Param("id")
	config.DB.Delete(&models.Course{}, id)
	c.JSON(http.StatusOK, gin.H{"message": "Course deleted successfully"})
}
