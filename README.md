<div align="center">

<img width="100%" src="https://capsule-render.vercel.app/api?type=waving&height=220&color=0:D946EF,50:A855F7,100:6D28D9&height=200&section=header&text=SAMS&fontSize=60&fontColor=ffffff&animation=fadeIn&fontAlignY=35&desc=Smart%20Academic%20Management%20System&descAlignY=55&descSize=20"/>

<img src="https://readme-typing-svg.demolab.com?font=Poppins&weight=600&size=22&duration=3000&pause=800&color=D946EF&center=true&vCenter=true&width=900&lines=Cross-Platform+Academic+Management+Platform;Flutter+%E2%80%A2+Web+%26+Mobile;Role-Based+Access+%E2%80%A2+AI-Powered+Integrity+Checks;Graduation+Project+%F0%9F%8E%93" alt="Typing SVG" />

<br/>

<img src="https://img.shields.io/badge/Platform-Flutter-A855F7?style=for-the-badge&logo=flutter&logoColor=white"/>
<img src="https://img.shields.io/badge/Targets-Web%20%26%20Mobile-D946EF?style=for-the-badge"/>
<img src="https://img.shields.io/badge/Project-Graduation-9333EA?style=for-the-badge"/>

</div>

<br/>

## 🔮 Overview

Smart Academic Management System (**SAMS**) is a cross-platform academic management platform that centralizes learning, assessment, live instruction, grading, and academic integrity into a single, unified system. Built using Flutter, the platform supports both **Web and Mobile** environments with role-based access for students and instructors.

<br/>

<div align="center">
<img src="assets/images/auth_home.png" width="45%" alt="Auth & Home Screen"/>
&nbsp;
<img src="assets/images/course.png" width="45%" alt="Course Screen"/>
</div>

<br/>

## 👥 Roles & Access

The system is built around two core roles, each with a dedicated profile and a tailored set of permissions.

| Role | Capabilities |
|---|---|
| 👨‍🏫 **Instructor** | Create courses, create quizzes, upload Excel grade sheets, configure the grading structure, enable/review AI plagiarism detection, manage profile |
| 🎓 **Student** | Take quizzes, submit assignments, view announcements & comment on them, view grades, manage profile |

<br/>

## ⚙️ Core Features

- 🔐 &nbsp;**Authentication** — secure login for both instructors and students
- 📚 &nbsp;**Course Creation** — instructors create and manage their own courses
- 📝 &nbsp;**Quizzes** — instructors create quizzes; students take them online
- 📎 &nbsp;**Assignments** — students upload assignment submissions per course
- 📣 &nbsp;**Announcements** — instructors post announcements; students can comment on them
- 👤 &nbsp;**Profiles** — dedicated profile views for both instructors and students
- 📊 &nbsp;**Dynamic Grading Table** — auto-generated based on the instructor's grading configuration (quizzes, assignments, midterm, etc.)
- 📥 &nbsp;**Excel Grade Import** — instructors upload an Excel sheet of grades, which is parsed and mapped directly into the dynamic grading table

<br/>

## 🧠 AI-Powered Plagiarism Detection

One of SAMS's key differentiators is its built-in academic integrity layer:

- When creating a course, the instructor decides whether **AI plagiarism detection** is enabled for that course
- If enabled, every assignment submission is automatically cross-checked against other students' submissions
- The system calculates a **similarity percentage** between submissions
- ⚠️ Grades are **not** pushed to the grading table automatically — the instructor must first **review the similarity report and approve** the submission
- If the feature is **disabled** for a course, assignments are graded and reflected normally without any AI check

This ensures instructors stay fully in control of how academic integrity is enforced, course by course.

<br/>

## 🏗️ How Grading Works

1. Instructor creates a course and defines the **grading configuration** (e.g. weight/structure for quizzes, assignments, midterm)
2. Quizzes and assignments are completed by students throughout the course
3. For courses with AI detection **enabled**, the instructor reviews flagged assignments and approves them before grades are finalized
4. Instructor uploads the **Excel sheet** with grades (or grades are calculated from quizzes/assignments directly)
5. All scores are automatically organized into a **dynamic table** per student, structured according to the course's configuration

<br/>

## 🛠️ Tech Stack

<div align="center">

<img src="https://img.shields.io/badge/Flutter-A855F7?style=for-the-badge&logo=flutter&logoColor=white"/>
<img src="https://img.shields.io/badge/Dart-D946EF?style=for-the-badge&logo=dart&logoColor=white"/>
<img src="https://img.shields.io/badge/Web-9333EA?style=for-the-badge&logo=googlechrome&logoColor=white"/>
<img src="https://img.shields.io/badge/Mobile-C026D3?style=for-the-badge&logo=android&logoColor=white"/>
<img src="https://img.shields.io/badge/AI%20Plagiarism%20Detection-7C3AED?style=for-the-badge"/>
<img src="https://img.shields.io/badge/Excel%20Import-CC2DAA?style=for-the-badge&logo=microsoftexcel&logoColor=white"/>

</div>

<br/>

## 🔗 Repository

<div align="center">

<a href="https://github.com/nadia022/sams-app">
<img src="https://img.shields.io/badge/GitHub-sams--app-A855F7?style=for-the-badge&logo=github&logoColor=white"/>
</a>

</div>

<br/>

<img width="100%" src="https://capsule-render.vercel.app/api?type=waving&height=150&color=0:6D28D9,50:A855F7,100:D946EF&section=footer"/>