import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/review.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Review>> getReviewsStream(String courseId) {
    return _firestore.collection('reviews')
        .where('courseId', isEqualTo: courseId)
        .snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Review.fromJson(doc.id,doc.data())).toList();
    });
  }

  Future<void> createReview(Review review) async {
    Map<String, dynamic> reviewData = review.toJson();
    reviewData.remove('id');
    await _firestore.collection('reviews').add(reviewData).then((docRef) {});
  }

  Future<List<Review>> getReviewsForUser(String userId) {
    return _firestore
        .collection('reviews')
        .where('userId', isEqualTo: userId)
        .get()
        .then((snapshot) {
      return snapshot.docs
          .map((doc) => Review.fromJson(doc.id, doc.data()))
          .toList();
    });
  }
}
