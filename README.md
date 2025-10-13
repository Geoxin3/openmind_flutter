# 🌿 OpenMind

openMind is a mentorship + mental wellness platform with three roles: Admin, Mentor, and User. Admins manage mentor profiles and content, mentors run sessions and assign reflective tasks with ML-based emotion insights, and users book sessions, write daily diaries, and track progress all with privacy in mind.

&nbsp;

## 💫 Core Features

- Emotion analysis using an ML model
- Daily diary writing
- Psychologist session booking
- Personalized dashboard
- Real-time reminders
- Feedback and ratings 

> Future: expand ML capabilities, add more mental-health tools (e.g., sleep/activity tracking), and explore voice/vision inputs for emotion analysis.

&nbsp;

## ⚡ Tech Stack

- Frontend: Flutter
- Backend: Django, FastAPI, Firebase
- ML: Pretrained model from Hugging Face
- Databases: PostgreSQL, Firestore 

---

# 📱 Flutter App – OpenMind Mobile Client

The Flutter application is the front-end interface for the OpenMind Mental Health Platform. It allows Users and Mentors to connect, chat, and access AI-based mental health assistance.

&nbsp;

## 👤 User Features

- ***AI Chatbot*** - Interact with the mental health AI assistant powered by FastAPI + Transformers.
- ***Register & Login*** - Secure authentication with Django backend.
- ***Real-Time Chat*** – Chat with human mentors for personalized support.
- ***Emotion Detection*** - Sentiment analysis and emotional insights using ML API.
- ***Profile Management*** – Update personal details, track past chats.

&nbsp;

## 🧑‍🏫 Mentor Features
- ***Mentor Dashboard*** – View user queries and provide guidance.
- ***Real-Time Chat with Users*** – Two-way communication via WebSockets.
- ***Notifications*** – Get notified when users request a session.
- ***Profile & Availability*** – Update availability for chat sessions.

&nbsp;

## 🖼️ Screenshots

<img src="" alt="Flutter UI" width="200"/>
&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

<img src="" alt="Flutter UI" width="200"/>
&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

<img src="" alt="Flutter UI" width="200"/>
&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

&nbsp;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="" alt="Flutter UI" width="200"/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="" alt="Flutter UI" width="200"/>

&nbsp;


# 🚀 How to Run the Project

### Prerequisites

   Make sure you have the following installed:

   - Flutter SDK (latest stable)
   - Dart (comes with Flutter)
   - Android Studio / Xcode (for emulators)
   - Firebase Console account
   - Python 3.9+ (for backend setup)

   ⚠️ **Note for experienced devs:**
   If you’re already comfortable with Flutter APK building and Firebase integration, you can skip directly to **Step 5 (Backend IP configuration)** and proceed to build the APK.

   ⚠️ **Important:** This Flutter app requires the backend service to be running for full functionality.  
   Make sure you’ve set up the backend first → [OpenMind Backend Repository](https://github.com/Geoxin3/openMind-Django-FastApi.git).


## 📱Flutter Frontend Setup

1. Open Terminal & Navigate

   ```bash
   cd Desktop
   ```
&nbsp;

2. Create a Project Folder

   ```bash
      mkdir openMind
      cd openMind
   ```
&nbsp;

3. Clone the Repository

   ```bash
      git clone https://github.com/Geoxin3/openmind_flutter.git
      cd openmind_flutter
   ```
&nbsp;

4. Install Dependencies

   ```bash
      flutter pub get
   ```
&nbsp;

5. Configure Backend IP
   - Open  the Flutter project in a code editor
   - Go to - ```lib/State_Provider_All/Base_url.dart```
   - Change the 192.168.1.21:8000 of baseUrl, baseUrl2, baseUrl3 to
   - Your local ipv4

   **To find your local ipv4**
   - Open a new terminal
   ```bash
      ipconfig
   ```

   - Change it to your ipv4, Then save the file

&nbsp;

6. Firebase Setup
   - You have must set up firebase before building the app without google-services.json, the build will fail
   - Create a new firebase project (Refer to official Firebase Flutter setup documentation or any beginner-friendly YouTube tutorial. "**Flutter Firebase Setup**")
   - Add an android app to firebase and download google-services.json
   - place the file in - android/app/google-services.json
   
   **Note:** If you want to build the app without Firebase, you’ll need to make Firebase initialization optional in **main.dart.**

   If you’re unsure how to do this, you can ask ChatGPT with the following prompt:

   ```bash
   I have a Flutter app where Firebase is initialized in main.dart.  
   How can I make Firebase optional so the app still builds if google-services.json is missing?  
   provide clean code for this.
   ```
   And update your main function

&nbsp;

7. RazorPay Setup **(Optional)**

   The app supports payment integration using Razorpay. This step is optional — the app will still build and run without it, but you won’t be able to test the payment feature.

   - Go to Razorpay Dashboard and create an account.
   - Get your Test API Key from the dashboard (Refer to official Razorpay Flutter setup documentation or any beginner-friendly YouTube tutorial. "**Flutter Razorpay test key integration**")
   - Add the API Key in - ```lib/State_Porvider_All/Payment_Screen.dart```
   - Replace with your razorpay test key

&nbsp;

8. Build the APK  

   Once you have completed the setup, you can build the APK
   ```bash
      flutter build apk
   ```
   APK will be located at : ```build/app/output/flutter-apk/app-release.apk```
   
   Install the apk on your device or emulator.

&nbsp;

## 🔗 Backend Repository

   This project requires a backend service.
  
   👉 Set up the backend here: [OpenMind Backend Repository](https://github.com/Geoxin3/openMind-Django-FastApi.git).

&nbsp;

## 📜 License
This project is licensed under the MIT License.  

![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)

