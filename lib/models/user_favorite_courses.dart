class UserFavoriteCourses {
  final String id;
  final String courseId;
  final String userId;

  UserFavoriteCourses({
    required this.id,
    required this.courseId,
    required this.userId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'userId': userId,
    };
  }

  static UserFavoriteCourses fromJson(String id, Map<String, dynamic> json) {
    return UserFavoriteCourses(
      id: id,
      courseId: json['courseId'],
      userId: json['userId'],
    );
  }
}