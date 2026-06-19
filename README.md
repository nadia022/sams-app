<div align="center">

<img width="100%" src="https://capsule-render.vercel.app/api?type=waving&height=200&color=0:0EA5E9,50:14B8A6,100:22C55E&height=180&section=header&text=academiaX&fontSize=58&fontColor=ffffff&animation=fadeIn&fontAlignY=35&desc=Graduation%20Project&descAlignY=55&descSize=18"/>

<br/>

<img src="https://img.shields.io/badge/Flutter-0EA5E9?style=flat-square&logo=flutter&logoColor=white"/>
<img src="https://img.shields.io/badge/Web%20%26%20Mobile-14B8A6?style=flat-square"/>
<img src="https://img.shields.io/badge/Graduation%20Project-22C55E?style=flat-square"/>

</div>

<br/>

## Overview

academiaX is a cross-platform academic management platform that centralizes learning, assessment, live instruction, grading, and academic integrity into a single, unified system. Built using Flutter, the platform supports both **Web and Mobile** environments with role-based access for students and instructors.

<br/>

<div align="center">
<img src="assets/images/auth_home.png" width="45%" alt="Auth & Home Screen"/>
&nbsp;
<img src="assets/images/course.png" width="45%" alt="Course Screen"/>
</div>

<br/>

## Roles & Access

| Role | Capabilities |
|---|---|
| **Instructor** | Create courses, create quizzes, upload Excel grade sheets, configure the grading structure, enable/review AI plagiarism detection, manage profile |
| **Student** | Take quizzes, submit assignments, view announcements & comment on them, view grades, manage profile |

<br/>

## Core Features

- **Authentication** — secure login for both instructors and students
- **Course Creation** — instructors create and manage their own courses
- **Quizzes** — instructors create quizzes; students take them online
- **Assignments** — students upload assignment submissions per course
- **Announcements** — instructors post announcements; students can comment on them
- **Profiles** — dedicated profile views for both instructors and students
- **Dynamic Grading Table** — auto-generated based on the instructor's grading configuration (quizzes, assignments, midterm, etc.)
- **Excel Grade Import** — instructors upload an Excel sheet of grades, parsed and mapped directly into the dynamic grading table

<br/>

## AI-Powered Plagiarism Detection

One of academiaX's key differentiators is its built-in academic integrity layer:

- When creating a course, the instructor decides whether **AI plagiarism detection** is enabled for that course
- If enabled, every assignment submission is automatically cross-checked against other students' submissions
- The system calculates a **similarity percentage** between submissions
- Grades are **not** pushed to the grading table automatically — the instructor must first **review the similarity report and approve** the submission
- If the feature is **disabled** for a course, assignments are graded and reflected normally without any AI check

This ensures instructors stay fully in control of how academic integrity is enforced, course by course.

<br/>

## How Grading Works

1. Instructor creates a course and defines the **grading configuration** (e.g. weight/structure for quizzes, assignments, midterm)
2. Quizzes and assignments are completed by students throughout the course
3. For courses with AI detection **enabled**, the instructor reviews flagged assignments and approves them before grades are finalized
4. Instructor uploads the **Excel sheet** with grades (or grades are calculated from quizzes/assignments directly)
5. All scores are automatically organized into a **dynamic table** per student, structured according to the course's configuration

<br/>

## Tech Stack

<div align="center">

<img src="https://img.shields.io/badge/Flutter-0EA5E9?style=flat-square&logo=flutter&logoColor=white"/>
<img src="https://img.shields.io/badge/Dart-14B8A6?style=flat-square&logo=dart&logoColor=white"/>
<img src="https://img.shields.io/badge/Web-22C55E?style=flat-square&logo=googlechrome&logoColor=white"/>
<img src="https://img.shields.io/badge/Mobile-0EA5E9?style=flat-square&logo=android&logoColor=white"/>
<img src="https://img.shields.io/badge/AI%20Plagiarism%20Detection-14B8A6?style=flat-square"/>
<img src="https://img.shields.io/badge/Excel%20Import-22C55E?style=flat-square&logo=microsoftexcel&logoColor=white"/>

</div>

<br/>

## Repository

<div align="center">

<a href="https://github.com/nadia022/sams-app">
<img src="https://img.shields.io/badge/GitHub-sams--app-0EA5E9?style=flat-square&logo=github&logoColor=white"/>
</a>

</div>

<br/>

<img width="100%" src="https://capsule-render.vercel.app/api?type=waving&height=130&color=0:22C55E,50:14B8A6,100:0EA5E9&section=footer"/>
