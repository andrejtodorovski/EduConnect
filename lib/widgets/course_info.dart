import 'package:educonnect/services/review_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/course.dart';
import '../models/review.dart';
import '../models/user.dart';
import '../screens/my_profile_screen.dart';
import '../services/auth_service.dart';

class CourseInfoWidget extends StatefulWidget {
  final Course course;

  const CourseInfoWidget({Key? key, required this.course}) : super(key: key);

  @override
  State<CourseInfoWidget> createState() => _CourseInfoWidgetState();
}

class _CourseInfoWidgetState extends State<CourseInfoWidget> {
  final ReviewService _reviewService = ReviewService();
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  var isSignedIn = FirebaseAuth.instance.currentUser != null;

  void _saveReview() async {
    final String rating = _ratingController.text;
    final String comment = _commentController.text;

    MyUser? currentUser = await AuthService().getCurrentUser();
    final currentUserName = '${currentUser.firstName} ${currentUser.lastName}';

    if (rating.isNotEmpty && comment.isNotEmpty) {
      Review review = Review(
        id: '',
        rating: int.parse(rating),
        comment: comment,
        courseId: widget.course.id,
        userId: AuthService().currentUser!.uid,
        userName: currentUserName,
        timestamp: DateTime.now(),
      );
      _reviewService.createReview(review);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Set the background color of the modal
      padding: const EdgeInsets.all(16.0), // Add some padding inside the modal
      child: Column(
        mainAxisSize: MainAxisSize.max,
        // Set the content to be as big as needed
        children: <Widget>[
          Text(
            widget.course.name,
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold), // Set the text style
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.course.tutorName,
                style: const TextStyle(fontSize: 18), // Adjust the text style
              ),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.yellow[600]),
                  // Set the star color
                  Text(widget.course.averageRating.toString(),
                      style: const TextStyle(fontSize: 18)),
                  // Set the rating text style
                ],
              ),
            ],
          ),
          const Divider(height: 20, thickness: 2),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow('Образование', widget.course.educationLevel),
              _infoRow('Факултет', widget.course.schoolName),
              _infoRow('Година', widget.course.yearOfStudy.toString()),
              _infoRow('Локација',
                  '${widget.course.location.latitude}, ${widget.course.location.longitude}'),
            ],
          ),
          const Divider(height: 20, thickness: 2),
          Column(
            children: [
              _infoRow('Времетраење на час', '${widget.course.length} мин.'),
              _infoRow('Цена по час', '${widget.course.price} ден.'),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MyProfileScreen(userId: widget.course.userId),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  // Set the button background color
                  foregroundColor: Colors.white, // Set the button text color
                ),
                child: const Text('Контактирај го туторот'),
              ),
              if (isSignedIn) ...[
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Оцени го курсот'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextField(
                                controller: _ratingController,
                                decoration: const InputDecoration(
                                  labelText: 'Оцена',
                                  hintText: '5',
                                ),
                              ),
                              TextField(
                                controller: _commentController,
                                decoration: const InputDecoration(
                                  labelText: 'Коментар',
                                  hintText: 'Одличен курс!',
                                ),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Откажи'),
                            ),
                            TextButton(
                              onPressed: () {
                                _saveReview();
                                Navigator.of(context).pop();
                              },
                              child: const Text('Зачувај'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Оцени го курсот'),
                ),
              ],
            ],
          ),
          StreamBuilder<List<Review>>(
            stream: _reviewService.getReviewsStream(widget.course.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                List<Review> reviews = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      Review review = reviews[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _reviewCard(review),
                      );
                    },
                  ),
                );
              } else {
                return const Text('No reviews yet');
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _reviewCard(Review review) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      width: 300,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CircleAvatar(
                      radius: 20.0,
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        color: Colors.green,
                        size: 30.0,
                      ),
                    ),
                    Text(review.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(review.timestamp.toLocal().toString().split(' ')[0]),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    review.comment,
                    softWrap: true,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List<Widget>.generate(review.rating, (index) {
                    return const Icon(Icons.star, color: Colors.green);
                  }),
                ),
                const SizedBox(height: 8),
                // Add more review details here
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
