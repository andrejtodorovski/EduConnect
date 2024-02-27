import 'dart:typed_data';

import 'package:educonnect/models/course.dart';
import 'package:educonnect/models/review.dart';
import 'package:educonnect/services/auth_service.dart';
import 'package:educonnect/services/message_service.dart';
import 'package:educonnect/services/review_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../helpers/colors.dart';
import '../models/user.dart';
import '../services/course_service.dart';
import '../services/image_service.dart';
import '../widgets/my_courses_view.dart';
import 'add_course.dart';
import 'messages_screen.dart';

class MyProfileScreen extends StatefulWidget {
  static const String id = "myProfileScreen";
  final String? userId;

  const MyProfileScreen({super.key, this.userId});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Uint8List? _image;

  Future<MyUser> getUserData() async {
    return await AuthService()
        .getUserById(widget.userId ?? AuthService().currentUser!.uid);
  }

  Future<MyUser> getCurrentUserData() async {
    return await AuthService().getCurrentUser();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void selectImage() async {
    Uint8List tmp = await pickImage(ImageSource.gallery);
    setState(() {
      _image = tmp;
    });
    saveImage(AuthService().currentUser!.uid, _image!);
  }

  Widget _socialMediaButton(IconData icon) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Информации за профилот'),
      ),
      body: FutureBuilder<MyUser>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            MyUser currentUser = snapshot.data!;
            bool isTutor = currentUser.role == 'tutor';
            bool isUserIdPresent = widget.userId != null;
            return Column(
              children: <Widget>[
                const SizedBox(height: 20),
                Stack(children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 50.0,
                          backgroundColor: Colors.white,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : currentUser.imageUrl != "No image"
                          ? CircleAvatar(
                              radius: 50.0,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage(currentUser.imageUrl),
                            )
                          : const CircleAvatar(
                              radius: 50.0,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                color: green,
                                size: 90.0,
                              )),
                  if (!isUserIdPresent) ...[
                    Positioned(
                      bottom: -10,
                      left: 65,
                      child: IconButton(
                          icon: const Icon(Icons.add_a_photo),
                          onPressed: selectImage),
                    ),
                  ],
                ]),
                const SizedBox(height: 10),
                Text(currentUser.username,
                    style: const TextStyle(fontSize: 20)),
                if (isTutor) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialMediaButton(Icons.facebook),
                      _socialMediaButton(Icons.email),
                    ],
                  ),
                ] else ...[
                  const SizedBox(height: 20),
                ],
                TabBar(
                  controller: _tabController,
                  tabs: [
                    const Tab(text: 'Basic Info'),
                    if (isTutor) ...[
                      if (!isUserIdPresent) ...[
                        const Tab(text: 'My Courses')
                      ] else ...[
                        const Tab(text: 'Tutor Courses')
                      ],
                    ] else ...[
                      if (!isUserIdPresent) ...[
                        const Tab(text: 'My Reviews')
                      ] else ...[
                        const Tab(text: 'Student Reviews')
                      ],
                    ],
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildBasicInfoTab(currentUser, isUserIdPresent),
                      if (isTutor) ...[
                        _buildMyCoursesTab(currentUser, isUserIdPresent),
                      ] else
                        _buildMyReviewsTab(currentUser, isUserIdPresent),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }

  Widget _buildBasicInfoTab(MyUser currentUser, bool isUserIdPresent) {
    return Center(
      child: ListView(children: <Widget>[
        ListTile(
          title: const Text('First Name'),
          subtitle: Text(currentUser.firstName),
        ),
        ListTile(
          title: const Text('Last Name'),
          subtitle: Text(currentUser.lastName),
        ),
        ListTile(
          title: const Text('Email'),
          subtitle: Text(currentUser.username),
        ),
        ListTile(
          title: const Text('Phone Number'),
          subtitle: Text(currentUser.phoneNumber),
        ),
        if (isUserIdPresent) ...[
          FutureBuilder<MyUser>(
            future: getCurrentUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                if (snapshot.data!.role == 'student') {
                  return ElevatedButton(
                    onPressed: () {
                      MessageService().createChatAndSendHelloMessage(
                          currentUser.id, snapshot.data!.id, "${currentUser.firstName} ${currentUser.lastName}", "${snapshot.data!.firstName} ${snapshot.data!.lastName}");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MessagesScreen()));
                    },
                    child: const Text('Contact'),
                  );
                } else {
                  return const Text('');
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ]),
    );
  }

  Widget _buildMyReviewsTab(MyUser currentUser, bool isUserIdPresent) {
    return FutureBuilder<List<Review>>(
        future: ReviewService().getReviewsForUser(currentUser.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нема рецензии'));
          }
          List<Review> reviews = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    Review review = reviews[index];
                    return ListTile(
                      title: StreamBuilder<Course>(
                        stream:
                            CourseService().getCourseStream(review.courseId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            Course course = snapshot.data!;
                            return Text(course.name);
                          } else {
                            return const Text('Нема курсеви');
                          }
                        },
                      ),
                      subtitle: Text(review.comment),
                      trailing: Text(review.rating.toString()),
                    );
                  },
                ),
              ),
            ],
          );
        });
  }

  Widget _buildMyCoursesTab(MyUser currentUser, bool isUserIdPresent) {
    return FutureBuilder<List<Course>>(
      future: CourseService().getUserCoursesStream(currentUser.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Нема курсеви'));
        }
        List<Course> courses = snapshot.data!;
        return Column(
          children: [
            if (!isUserIdPresent) ...[
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddCourseScreen()),
                    );
                  },
                  child: const Text('Add Course')),
            ],
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  Course course = courses[index];
                  return myCoursesView(course);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
