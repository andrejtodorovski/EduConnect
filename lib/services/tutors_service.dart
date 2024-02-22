import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educonnect/models/user.dart';

import '../models/course.dart';

class TutorsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<MyUser>> getUsersStream() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => MyUser.fromJson(doc.data())).toList();
    });
  }

  Future<MyUser> getUser(String userId) async {
    var userDocSnapshot = await _firestore.collection('users').doc(userId).get();
    if (userDocSnapshot.exists) {
      return MyUser.fromJson(userDocSnapshot.data() as Map<String, dynamic>);
    } else {
      throw Exception('User not found');
    }
  }

  Future<Map<String, MyUser>> prefetchTutorNames(List<Course> courses) async {
    Map<String, MyUser> tutors = {};
    for (var course in courses) {
      if (!tutors.containsKey(course.userId)) {
        tutors[course.userId] = await getUser(course.userId);
      }
    }
    return tutors;
  }

  Future<List<MyUser>> getTopRatedUsersStream() async {
    Map<String, List<double>> userRatings = {};
    CollectionReference courses = FirebaseFirestore.instance.collection('courses');
    QuerySnapshot querySnapshot = await courses.get();

    for (var doc in querySnapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      String userId = data['userId'];
      double rating = data['averageRating'];

      if (!userRatings.containsKey(userId)) {
        userRatings[userId] = [rating, 1];
      } else {
        userRatings[userId]![0] += rating;
        userRatings[userId]![1] += 1;
      }
    }
    Map<String, double> userAverages = {};
    userRatings.forEach((userId, ratings) {
      userAverages[userId] = ratings[0] / ratings[1];
    });

    var sortedUsers = userAverages.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    List<MyUser> topRatedUsers = [];
    for (var user in sortedUsers) {
      var userDoc = await users.doc(user.key).get();
      topRatedUsers.add(MyUser.fromJson(userDoc.data() as Map<String, dynamic>));
    }

    return topRatedUsers;
  }
}
