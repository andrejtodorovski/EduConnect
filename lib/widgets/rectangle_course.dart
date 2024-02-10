import 'package:educonnect/helpers/colors.dart';
import 'package:flutter/material.dart';

Widget rectangleCourse(double rating, String courseName, String authorName,
    bool showFavoritesButton) {
  return Container(
    padding: const EdgeInsets.all(8),
    width: 250,
    decoration: BoxDecoration(
      color: grey,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 3,
          offset: const Offset(0, 1),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.star, color: green, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                      color: green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                courseName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                authorName,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        if (showFavoritesButton) ...[
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // Bookmark action
            },
          ),
        ],
      ],
    ),
  );
}
