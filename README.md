# 🏥 CAQM - Clinic Appointment & Queue Management System

## 📘 Overview
**CAQM (Clinic Appointment & Queue Management)** is a smart system designed to manage **appointments and patient queues** for clinics and medical centers.  
It helps reduce waiting times, improve patient experience, and organize doctor schedules through a modern Flutter + Firebase architecture.

---

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

---

## 🧰 Tech Stack

| Layer | Technology |
|-------|-------------|
| **Frontend** | Flutter (Android / iOS) |
| **Backend / DB** | Firebase Firestore |
| **Authentication** | Firebase Auth (Email / Google Login) |
| **Notifications** | Firebase Cloud Messaging (FCM) |
| **Hosting** | Firebase Hosting |
| **Team Collaboration** | Microsoft Teams, Telegram |

---

## 🧠 System Architecture
- **Modular OOP design** following SOLID principles.  
- **Low coupling / High cohesion** for scalability and maintainability.  
- **Real-time updates** via Firestore Streams and FCM.  
- **Role-based access control (RBAC)** for secure user management.

---

## 🗄️ Firestore Database Structure

### 🔹 Collections Overview
