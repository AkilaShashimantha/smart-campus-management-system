package routes

import (
	"smart-campus-backend/controllers"
	"github.com/gin-gonic/gin"
)

func SetupRoutes(r *gin.Engine) {
	api := r.Group("/api/v1")
	{
		// Course Routes
		api.GET("/courses", controllers.GetAllCourses)
		api.POST("/courses", controllers.CreateCourse)
		api.PUT("/courses/:id", controllers.UpdateCourse)
		api.DELETE("/courses/:id", controllers.DeleteCourse)

		// Student Routes
		api.GET("/students", controllers.GetAllStudents)
		api.POST("/students", controllers.CreateStudent)
		api.GET("/students/:id", controllers.GetStudentByID)
	}
}