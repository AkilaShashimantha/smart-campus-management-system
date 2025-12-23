package controllers

import (
	"net/http"
	"smart-campus-backend/config"
	"smart-campus-backend/models"
	"github.com/gin-gonic/gin"
)

// සියලුම ශිෂ්‍යයන් ලබාගැනීම (Course විස්තර සමඟ)
func GetAllStudents(c *gin.Context) {
	var students []models.Student
	
	// Preload("Course") මගින් ශිෂ්‍යයාට අදාළ Course එකේ දත්තත් එකවර ලබාගන්නවා
	config.DB.Preload("Course").Find(&students)
	
	c.JSON(http.StatusOK, students)
}

// අලුත් ශිෂ්‍යයෙක් ඇතුළත් කිරීම
func CreateStudent(c *gin.Context) {
	var input models.Student

	// එවන JSON එක Student struct එකට Bind කිරීම
	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Database එකේ Save කිරීම
	if err := config.DB.Create(&input).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "ශිෂ්‍යයා ඇතුළත් කිරීමට නොහැකි වුණා"})
		return
	}

	c.JSON(http.StatusCreated, input)
}

// එක් ශිෂ්‍යයෙකුගේ විස්තර ලබාගැනීම (ID එක අනුව)
func GetStudentByID(c *gin.Context) {
	var student models.Student
	id := c.Param("id")

	if err := config.DB.Preload("Course").First(&student, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "ශිෂ්‍යයා සොයාගත නොහැක!"})
		return
	}

	c.JSON(http.StatusOK, student)
}