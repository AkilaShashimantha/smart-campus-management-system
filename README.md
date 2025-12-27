# 🎓 Smart Campus Management System

A robust Full-Stack Academic Management application built with a focus on modern software architecture. The system features a **Golang** backend utilizing a relational database and a **Flutter** mobile frontend with a professional UI.

---

## 🚀 Key Features

### 📱 Mobile Application (Flutter)
- **Student Management:** Full CRUD (Create, Read, Update, Delete) functionality for student records.
- **Course Management:** Dedicated section to manage academic courses and lecturers.
- **Many-to-Many Enrollment:** Implementation of complex relationships allowing students to enroll in multiple courses simultaneously.
- **Advanced Search:** Real-time search functionality to filter students by name instantly.
- **Professional Branding:** Custom-designed logo and native splash screens for a professional feel.
- **Modern UI:** Built with Google Fonts (Poppins), interactive cards, and an Indigo theme.

### ⚙️ Backend (Golang)
- **RESTful API:** Clean and scalable API endpoints using the **Gin Gonic** framework.
- **ORM Integration:** **GORM** utilized for database interactions and automatic migrations.
- **Relational Data:** Implementation of Many-to-Many associations between Students and Courses with a Join Table.
- **Optimized Queries:** Data fetching using GORM Preloading to retrieve nested relational data efficiently.
- **Database:** Reliable data persistence using **SQLite**.

---

## 🛠️ Tech Stack

| Layer | Technology |
| :--- | :--- |
| **Frontend** | Flutter (Dart) |
| **Backend** | Go (Golang) |
| **Web Framework** | Gin Gonic |
| **Database ORM** | GORM |
| **Database** | SQLite |
| **Fonts** | Google Fonts (Poppins) |

---

## 📂 Project Structure

```text
Smart_Campus_Project/
├── backend/                # Golang Source Code
│   ├── config/             # Database connection & configuration
│   ├── controllers/        # Business logic & Request handling
│   ├── models/             # GORM Models (Student, Course)
│   ├── routes/             # API Route definitions
│   └── main.go             # Entry point of the server
├── mobile_app/             # Flutter Source Code
│   ├── lib/
│   │   ├── models/         # Data models & JSON parsing
│   │   ├── screens/        # UI Screens (Home, Details, Add, etc.)
│   │   ├── services/       # API integration (HTTP Client)
│   │   └── main.dart       # App entry point
│   ├── assets/             # Images, Icons & Logos
│   └── pubspec.yaml        # Dependencies & configuration
└── README.md               # Documentation


## 🔧 Installation & Setup

Follow these steps to get the project up and running on your local machine.

### 📋 Prerequisites
- **Go:** [Download Go](https://go.dev/dl/) (v1.20 or later)
- **Flutter:** [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Git:** [Download Git](https://git-scm.com/downloads)

---

### 1. Clone the Repository
Open your terminal and run:
```bash
git clone [https://github.com/AkilaShashimantha/smart-campus-management-system.git](https://github.com/AkilaShashimantha/smart-campus-management-system.git)
cd Smart_Campus_Project
```

### 2. Backend Setup
Navigate to the backend directory:
```bash
cd backend
```
Install dependencies:
```bash
go mod download
```
Run the server:
```bash
go run main.go
```
### 3. Mobile App Setup
Navigate to the mobile app directory:
```bash
cd mobile_app
```
Install dependencies:
```bash
flutter pub get
```

Run the application:
```bash
flutter run
```
### 4. Database Setup
The database is initialized automatically when the server starts. The default SQLite database is created in the root directory of the project.

### 5. Configuration
The server configuration is stored in the config folder. You can modify the database connection settings in the config.go file.

### 6. API Documentation
The API documentation is available at /docs. You can access it by running the server and navigating to /docs in your browser.

### 7. Contributing
Contributions are welcome! Please submit a pull request for any changes you'd like to make.

### 8. License
This project is licensed under the MIT License - see the LICENSE file for details.

### 9. Contact
For any questions or feedback, please contact Akila Shashimantha at akilashashimantha84@gmail.com.
