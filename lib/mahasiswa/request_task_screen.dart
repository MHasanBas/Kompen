import 'package:flutter/material.dart';

class RequestTaskScreen extends StatelessWidget {
  const RequestTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Request Tugas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Nama Tugas'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Deskripsi Tugas'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Submit request tugas
            },
            child: const Text('Request Tugas'),
          ),
        ],
      ),
    );
  }
}
