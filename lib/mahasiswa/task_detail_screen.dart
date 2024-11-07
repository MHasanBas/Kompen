import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  final String title;
  final String description;

  const TaskDetailScreen({super.key, required this.title, required this.description});

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false, // To manually control the back button
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.indigo[900]), // Back icon
        onPressed: () {
          Navigator.pop(context); // Navigate back to the previous screen
        },
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns the text to the left
        children: [
          Text(
            'Suka Kompen.',
            style: TextStyle(
              color: Colors.indigo[900],
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ],
      ),
    ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Image/Icon placeholder (you can replace with an actual image)
                    const Icon(
                      Icons.task,
                      size: 80,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 16),

                    // Task Title
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),

                    // Task Status (e.g. "Offline")
                    const Text(
                      'Offline',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Byline
                    const Text(
                      'By Bu Titis',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Task Description
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    // Time and Jam Alpha
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.access_time, color: Colors.black54),
                            SizedBox(width: 8),
                            Text(
                              '16:00 PM\n9/14/2025',
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          children: const [
                            Icon(Icons.arrow_downward, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              '- 4 Jam\nAlpha',
                              style: TextStyle(fontSize: 14, color: Colors.red),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Request Task Button
            ElevatedButton(
              onPressed: () {
                // Request task action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700], // Yellow button
                minimumSize: const Size(double.infinity, 50), // Full-width button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Request Pekerjaan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        color: Colors.indigo[900], // Dark blue bottom bar
        child: Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigate to home screen
                },
              ),
              IconButton(
                icon: const Icon(Icons.access_time, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigate to time screen
                },
              ),
              const SizedBox(width: 50), // Space for the FAB
              IconButton(
                icon: const Icon(Icons.mail, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigate to messages screen
                },
              ),
              IconButton(
                icon: const Icon(Icons.person, color: Colors.white, size: 30),
                onPressed: () {
                  // Navigate to profile screen
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 90, // Larger size for the FAB
        height: 90,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent, // Brighter blue for the FAB
        ),
        child: FloatingActionButton(
          elevation: 0, // Remove elevation to flatten the FAB
          backgroundColor: Colors.transparent, // Transparent background
          onPressed: () {
            // Action for the FAB button, navigating to task screen
          },
          child: const Icon(
            Icons.add,
            size: 50, // Larger size for the plus icon
            color: Colors.white, // White color for the plus icon
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
