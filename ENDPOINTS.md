# API Endpoints Documentation

This document lists all the available endpoints for the Course Registration System. 
All responses follow a standardized JSON format:
```json
{
  "success": true,
  "data": {},
  "message": "string"
}
```

## Student APIs
**Base Path:** `/api/registration`

| Method | Endpoint | Description | Request Body / Params |
| :--- | :--- | :--- | :--- |
| **GET** | `/api/registration/periods/active` | Retrieves a list of currently active and open registration periods. | None |
| **GET** | `/api/registration/me` | Retrieves all course registrations for the currently authenticated student. | None |
| **POST** | `/api/registration` | Registers the authenticated student for a specific course within an active registration period. | `CourseRegistrationRequest` |
| **PATCH** | `/api/registration/{id}/cancel` | Cancels a specific course registration for the student, provided it has not been paid for. | Path: `id` (UUID) |


## Admin APIs
**Base Path:** `/api/admin/registration`

### Registration Periods Management
| Method | Endpoint | Description | Request Body / Params |
| :--- | :--- | :--- | :--- |
| **GET** | `/api/admin/registration/periods` | Retrieves all registration periods. | None |
| **POST** | `/api/admin/registration/periods` | Creates a new course registration period. | `RegistrationPeriodRequest` |
| **GET** | `/api/admin/registration/periods/{id}` | Retrieves a specific registration period by its ID. | Path: `id` (UUID) |
| **PUT** | `/api/admin/registration/periods/{id}` | Updates an existing registration period. | Path: `id` (UUID), `RegistrationPeriodRequest` |
| **DELETE**| `/api/admin/registration/periods/{id}` | Deletes a registration period by ID. | Path: `id` (UUID) |

### Equivalent Courses Management
| Method | Endpoint | Description | Request Body / Params |
| :--- | :--- | :--- | :--- |
| **GET** | `/api/admin/registration/equivalent-courses` | Retrieves all equivalent course relationships. | None |
| **POST** | `/api/admin/registration/equivalent-courses` | Defines a new equivalent course relationship. | `EquivalentCourseRequest` |
| **GET** | `/api/admin/registration/equivalent-courses/{id}`| Retrieves a specific equivalent course relationship by its ID. | Path: `id` (UUID) |
| **PUT** | `/api/admin/registration/equivalent-courses/{id}`| Updates an existing equivalent course relationship. | Path: `id` (UUID), `EquivalentCourseRequest` |
| **DELETE**| `/api/admin/registration/equivalent-courses/{id}`| Deletes an equivalent course relationship by ID. | Path: `id` (UUID) |

### Course Registrations Management
| Method | Endpoint | Description | Request Body / Params |
| :--- | :--- | :--- | :--- |
| **GET** | `/api/admin/registration/course-registrations` | Retrieves all course registrations made by all students. | None |
| **POST** | `/api/admin/registration/course-registrations` | Allows admins to register a student for a course, bypassing normal validations (force=true). | `CourseRegistrationRequest` |
