class Chat {
  final String id;
  final String tutorId;
  final String tutorName;
  final String studentId;
  final String studentName;

  Chat({
    required this.id,
    required this.tutorId,
    required this.tutorName,
    required this.studentId,
    required this.studentName
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tutorId': tutorId,
      'tutorName': tutorName,
      'studentId': studentId,
      'studentName': studentName
    };
  }

  static Chat fromJson(String id, Map<String, dynamic> json) {
    return Chat(
      id: id,
      tutorId: json['tutorId'],
      tutorName: json['tutorName'],
      studentId: json['studentId'],
      studentName: json['studentName']
    );
  }
}
