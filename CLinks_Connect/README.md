# NSUT Connect 🎓

NSUT Connect is an iOS application designed to help students connect with their college community. It provides a shared feed for student posts, likes, and comments, along with a timetable to keep track of classes.

Built using SwiftUI and Supabase, the project combines native iOS development with a cloud-backed database and authentication system.

## ✨ Features

### 🏠 Student Feed
- View posts shared by students.
- Create and publish new posts.
- Attach images to posts.
- Like and unlike posts.
- View post details and comments.

### 💬 Comments
- Add comments to posts.
- View comments and their authors.
- Store comments in a cloud database so they persist across sessions.

### 🔐 Authentication
- Sign in using email-based authentication.
- Manage the authenticated user's session.
- Sign out from the application.

### 📅 Timetable
- View the timetable organized by day.
- Select a day to see its scheduled classes.
- View the next scheduled class.

### 👤 Profile
- View basic student profile information.
- Access account-related actions, including signing out.

## 🛠️ Tech Stack

| Technology | Purpose |
|---|---|
| Swift | Core application programming language |
| SwiftUI | User interface development |
| Supabase | Backend services and database |
| PostgreSQL | Cloud data storage |
| Supabase Auth | User authentication |
| Supabase Storage | Image storage for posts |
| Xcode | Development and testing |

## 🏗️ Architecture

NSUT Connect uses SwiftUI for its native iOS interface and Supabase for backend functionality.

The application communicates with Supabase to authenticate users and manage posts, likes, comments, profiles, and uploaded images.

The timetable currently uses local dummy data, allowing it to function independently of the backend.

## 🚀 Getting Started

### Prerequisites

- A Mac with Xcode installed.
- A compatible iPhone or iOS Simulator.
- A Supabase account and project.
- The Supabase Swift SDK.

### Setup

1. Clone this repository:

   ```bash
   git clone <repository-url>
   ```

2. Open the `.xcodeproj` or `.xcworkspace` file in Xcode, depending on the project setup.

3. Configure the Supabase project URL and publishable key in the application's Supabase configuration.

4. Ensure the required Supabase database tables, authentication settings, and storage bucket are configured.

5. Build and run the application on an iOS Simulator or a connected iPhone.

> **Note:** Do not commit private API keys, service-role keys, or other secrets to the repository.

## 🗄️ Backend

Supabase provides the cloud infrastructure for the application.

The backend includes:
- User profiles
- Student posts
- Post likes
- Post comments
- Image storage

Database access policies help control which operations authenticated users can perform.

## 🎯 Project Goals

NSUT Connect was developed to explore practical iOS application development, including:

- Building multi-screen applications with SwiftUI.
- Managing state and navigation.
- Integrating a cloud backend.
- Implementing authentication.
- Performing asynchronous database operations.
- Uploading and displaying images.
- Managing persistent user-generated content.

## 🔮 Future Improvements

- Real-time feed updates across devices.
- Real-time synchronization of likes and comments.
- Student email-domain restrictions.
- Nested comment replies.
- Push notifications for relevant college updates.
- A fully integrated, cloud-backed timetable.

## 📌 Project Status

NSUT Connect is a student project developed to demonstrate iOS development and backend integration.

Some features, including the timetable, currently use dummy data. The application is intended for demonstration and testing rather than production deployment.

## 👨‍💻 Built With

Made with SwiftUI, Supabase, and a focus on learning through building.
