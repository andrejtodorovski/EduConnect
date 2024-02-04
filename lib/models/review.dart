class Review {
  final String id;
  final int rating;
  final String comment;
  final String courseId;
  final String userId;
  final DateTime timestamp;

  Review({
    required this.id,
    required this.rating,
    required this.comment,
    required this.courseId,
    required this.userId,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rating': rating,
      'comment': comment,
      'courseId': courseId,
      'userId': userId,
      'timestamp': timestamp,
    };
  }

  static Review fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      rating: json['rating'],
      comment: json['comment'],
      courseId: json['courseId'],
      userId: json['userId'],
      timestamp: (json['timestamp']).toDate(),
    );
  }
}
