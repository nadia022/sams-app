class EndPoints {
  EndPoints._();

  //! EndPoints

  //? --- Auth  --- ;
  static String login = 'auth/login';
  static String register = 'auth/register';
  static String refresh = 'auth/refresh';
  static String forgetPassword = 'auth/forgot-password';
  static String verifyOTP = 'auth/verify-otp';
  static String resetPassword = 'auth/reset-password';
  static String resendOTP = 'auth/resend-code';
  static const String logout = 'auth/logout';

  //? --- Home  --- ;
  //* Instructor endpoints
  static const String createCourse = 'instructor/courses';
  static const String getMyCreatedCourses = 'instructor/courses/me';
  static String deleteCourse(String courseId) => 'instructor/courses/$courseId';

  //* Enrollment endpoints
  static const String getMyJoinedCourses = 'enrollments/me';
  static const String joinCourse = 'enrollments';
  static String unenrollCourse(String courseId) =>
      'enrollments/my-courses/$courseId';

  //? --- Profile  --- ;
  static const String getProfile = 'users/profile';
  static const String updateProfile = 'users/profile';
  static const String createUploadUrl = 'users/profile-picture/presigned-url';
  static const String saveProfilePic = 'users/profile-picture';
  //? --- Announcements --- ;
  static String getCourseAnnouncements(String courseId) => 'courses/$courseId/announcements';
  static String getAnnouncementDetails(String announcementId) => 'announcements/$announcementId';
  //* Instructor Announcement Operations
  
  /// Endpoint to create a new announcement for a specific course.
  /// Needs [courseId] to be passed in the URL.
  static String createAnnouncement(String courseId) => 'instructor/courses/$courseId/announcements';
  
  /// Endpoint to update an existing announcement.
  /// Needs [announcementId] to be passed in the URL.
  static String updateAnnouncement(String announcementId) => 'instructor/announcements/$announcementId';
  
  /// Endpoint to delete an existing announcement.
  /// Needs [announcementId] to be passed in the URL.
  static String deleteAnnouncement(String announcementId) => 'instructor/announcements/$announcementId';
}
