package controllers

import (
	"net/http"
	"smart-campus-backend/config"
	"smart-campus-backend/models"

	"github.com/gin-gonic/gin"
)

// GetAllStudents retrieves all students with their associated courses.
func GetAllStudents(c *gin.Context) {
	var students []models.Student

	// Preload the "Courses" relationship
	if err := config.DB.Preload("Courses").Find(&students).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, students)
}

// CreateStudent creates a new student and optionally associates courses.
func CreateStudent(c *gin.Context) {
	// Define a struct to capture fileds + course_ids
	var input struct {
		Name      string `json:"name" binding:"required"`
		Email     string `json:"email" binding:"required,email"`
		Age       int    `json:"age" binding:"required"`
		CourseIDs []uint `json:"course_ids"` // List of Course IDs
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Create Student instance
	student := models.Student{
		Name:  input.Name,
		Email: input.Email,
		Age:   input.Age,
	}

	// Start a transaction (optional but good practice) or just simple flow
	tx := config.DB.Begin()

	// 1. Create the Student
	if err := tx.Create(&student).Error; err != nil {
		tx.Rollback()
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create student"})
		return
	}

	// 2. Associate Courses if IDs are provided
	if len(input.CourseIDs) > 0 {
		var courses []models.Course
		if err := tx.Find(&courses, input.CourseIDs).Error; err != nil {
			tx.Rollback()
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to find courses"})
			return
		}

		// Update the association
		if err := tx.Model(&student).Association("Courses").Replace(&courses); err != nil {
			tx.Rollback()
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to associate courses"})
			return
		}
	}

	tx.Commit()

	// Reload student with courses to return full object
	config.DB.Preload("Courses").First(&student, student.ID)

	c.JSON(http.StatusCreated, student)
}

// එක් ශිෂ්‍යයෙකුගේ විස්තර ලබාගැනීම (ID එක අනුව)
func GetStudentByID(c *gin.Context) {
	var student models.Student
	id := c.Param("id")

	if err := config.DB.Preload("Courses").First(&student, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "ශිෂ්‍යයා සොයාගත නොහැක!"})
		return
	}

	c.JSON(http.StatusOK, student)
}

// ශිෂ්‍යයෙක් මකා දැමීම
func DeleteStudent(c *gin.Context) {
	id := c.Param("id")
	config.DB.Delete(&models.Student{}, id)
	c.JSON(200, gin.H{"message": "Student deleted"})
}

// ශිෂ්‍යයෙකුට අලුත් Course එකක් ඇතුළත් කිරීම
func EnrollStudent(c *gin.Context) {
	var input struct {
		StudentID uint `json:"student_id"`
		CourseID  uint `json:"course_id"`
	}

	if err := c.ShouldBindJSON(&input); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	var student models.Student
	var course models.Course

	// ශිෂ්‍යයා සහ Course එක සොයා ගැනීම
	if err := config.DB.First(&student, input.StudentID).Error; err != nil {
		c.JSON(404, gin.H{"error": "Student not found"})
		return
	}
	if err := config.DB.First(&course, input.CourseID).Error; err != nil {
		c.JSON(404, gin.H{"error": "Course not found"})
		return
	}

	// Association එකක් මගින් එකතු කිරීම (Many-to-Many)
	config.DB.Model(&student).Association("Courses").Append(&course)

	c.JSON(200, gin.H{"message": "Enrolled successfully!"})
}
