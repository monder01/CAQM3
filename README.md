# 🏥 CAQM - Clinic Appointment & Queue Management System

## 📘 Overview
**CAQM (Clinic Appointment & Queue Management)** is a smart system designed to manage **appointments and patient queues** for clinics and medical centers. It helps reduce waiting times, improve patient experience, and organize doctor schedules through a modern Flutter + Firebase architecture.

## 🚀 Features

### 👤 User Management
- Register & Login (Email / Google)
- Role-based access: Patient, Doctor, Admin
- Secure authentication via Firebase Auth

### 📅 Appointment Management
- Book, update, or cancel appointments
- View past and upcoming appointments
- Teleconsultation (virtual video appointments)
- Appointment statistics and analytics for admins

### ⏳ Queue Management
- Real-time queue tracking inside clinics
- Dynamic updates for arrivals and absences
- Automatic notification when the patient’s turn approaches

### 🔔 Notification System
- Push notifications for reminders and changes (via Firebase Cloud Messaging)
- Optional Email or SMS alerts
- Supports message status (Read / Unread)

### 📄 Form Management
- Digital medical forms (Insurance, Medical History, Consent)
- Pre-fill and submit before appointment
- Validation and storage in Firestore

## 🧰 Tech Stack
| Layer | Technology |
|-------|-------------|
| **Frontend** | Flutter (Android / iOS) |
| **Backend / DB** | Firebase Firestore |
| **Authentication** | Firebase Auth (Email / Google Login) |
| **Notifications** | Firebase Cloud Messaging (FCM) |
| **Hosting** | Firebase Hosting |
| **Team Collaboration** | Microsoft Teams, Telegram |

## 🧠 System Architecture
- **Modular OOP design** following SOLID principles.  
- **Low coupling / High cohesion** for scalability and maintainability.  
- **Real-time updates** via Firestore Streams and FCM.  
- **Role-based access control (RBAC)** for secure user management.

## 🗄️ Firestore Database Structure

### 🔹 Collections Overview

### 🔸 1. `users`
Contains all user types (Patient, Doctor, Admin) with shared attributes.  
Fields:  
- `name` (String) – Full name  
- `email` (String) – User email  
- `password` (String) – Encrypted password  
- `role` (String) – `Patient`, `Doctor`, or `Admin`  
- `phoneNumber` (String) – Contact number  
- `createdAt` (Timestamp) – Account creation date  

### 🔸 2. `patients`
Stores patient-specific information and related sub-collections.  
Fields:  
- `medicalHistory` (String) – Patient medical history  
- `insuranceNumber` (String) – Insurance ID  
- `userRef` (Reference → /users/{userId}) – Linked user account  
Sub-Collections: `/appointments`, `/forms`, `/tokens`

### 🔸 3. `doctors`
Stores doctor information and schedules.  
Fields:  
- `specialization` (String) – Doctor specialization  
- `availabilitySchedule` (Map) – Working schedule  
- `userRef` (Reference → /users/{userId}) – Linked user account  
Sub-Collections: `/appointments`, `/teleconsultations`

### 🔸 4. `admins`
Contains admin user data for system and queue management.  
Fields:  
- `department` (String) – Admin department  
- `userRef` (Reference → /users/{userId}) – Linked user account  
Sub-Collections: `/queueManagers`, `/reports`

### 🔸 5. `appointments`
Represents appointments between patients and doctors.  
Fields:  
- `patientRef` (Reference → /patients/{patientId}) – Patient reference  
- `doctorRef` (Reference → /doctors/{doctorId}) – Doctor reference  
- `queueRef` (Reference → /queues/{queueId}) – Related queue  
- `date` (DateTime) – Appointment date  
- `time` (String) – Appointment time  
- `status` (String) – `Scheduled`, `Completed`, or `Canceled`

### 🔸 6. `queues`
Manages waiting queues for each clinic or department.  
Fields:  
- `name` (String) – Queue name  
- `location` (String) – Clinic location  
- `currentPosition` (Number) – Current token being served  
- `managerRef` (Reference → /admins/{adminId}) – Queue manager  
Sub-Collections: `/tokens`

### 🔸 7. `tokens`
Represents a patient’s position in the queue.  
Fields:  
- `tokenNumber` (Number) – Queue number  
- `patientRef` (Reference → /patients/{patientId}) – Linked patient  
- `queueRef` (Reference → /queues/{queueId}) – Queue reference  
- `status` (String) – `Waiting`, `Called`, or `Completed`

### 🔸 8. `forms`
Stores electronic medical or insurance forms.  
Fields:  
- `type` (String) – Form type (`Insurance`, `MedicalHistory`, `Consent`)  
- `content` (Map / JSON) – Form data  
- `patientRef` (Reference → /patients/{patientId}) – Linked patient  
- `isValidated` (Boolean) – Validation status  

### 🔸 9. `notifications`
Handles notifications sent to users.  
Fields:  
- `recipientRef` (Reference → /users/{userId}) – Recipient reference  
- `message` (String) – Notification text  
- `timestamp` (Timestamp) – Sent time  
- `status` (String) – `Read` or `Unread`

### 🔸 10. `teleconsultations`
Stores details of virtual consultation sessions.  
Fields:  
- `patientRef` (Reference → /patients/{patientId}) – Patient reference  
- `doctorRef` (Reference → /doctors/{doctorId}) – Doctor reference  
- `startTime` (Timestamp) – Session start time  
- `endTime` (Timestamp) – Session end time  
- `messages` (Array) – Chat or message logs  
- `status` (String) – `Active`, `Completed`, or `Canceled`

### 🔗 Relationships Diagram (Text)
User (1) → Patient / Doctor / Admin  
Patient (1) → Appointments / Forms / Tokens  
Doctor (1) → Appointments / Teleconsultations  
Admin (1) → Queues / Reports  
Appointment (1) → Queue  
Queue (1) → Tokens  
Form (M) → Patient  
Notification (M) → User

## ⚙️ Installation & Run
```bash
git clone https://github.com/<your-username>/CAQM.git
cd CAQM
flutter pub get
flutter run

---

## 🧩 Future Enhancements

- Multi-clinic and multi-branch support
- Integration with health insurance APIs
- AI-based appointment suggestions
- Offline mode and caching
- Admin analytics dashboard

---

## 👨‍💻 Authors
- Milad Al-Azhar Zgheirah
- Monder Massoud Araboub
