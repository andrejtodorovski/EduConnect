class Review {
  final String id;
  final int rating;
  final String comment;
  final String courseId;
  final String userId;
  final String userName;
  final DateTime timestamp;

  Review({
    required this.id,
    required this.rating,
    required this.comment,
    required this.courseId,
    required this.userId,
    required this.userName,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'comment': comment,
      'courseId': courseId,
      'userId': userId,
      'userName': userName,
      'timestamp': timestamp,
    };
  }

  static Review fromJson(String _id, Map<String, dynamic> json) {
    return Review(
      id: _id,
      rating: json['rating'],
      comment: json['comment'],
      courseId: json['courseId'],
      userId: json['userId'],
      userName: json['userName'],
      timestamp: (json['timestamp']).toDate(),
    );
  }
}
