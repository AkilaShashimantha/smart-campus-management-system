package main

import (
	"smart-campus-backend/config"
	"smart-campus-backend/routes"
	"github.com/gin-gonic/gin"
)

func main() {
	config.ConnectDatabase()

	r := gin.Default()

	// Routes setup කිරීම
	routes.SetupRoutes(r)

	r.Run("0.0.0.0:8080")
}