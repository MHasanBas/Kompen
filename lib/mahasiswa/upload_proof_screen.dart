import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart'; // For file picking
import 'package:intl/intl.dart'; // Import intl for date formatting

class UploadProofScreen extends StatefulWidget {
  final String tugasId;
  final String applyID; // Assuming this is the applyId you need to pass

  UploadProofScreen({required this.tugasId, required this.applyID});

  @override
  _UploadProofScreenState createState() => _UploadProofScreenState();
}

class _UploadProofScreenState extends State<UploadProofScreen> {
  late Future<Map<String, dynamic>> taskDetails;

  @override
  void initState() {
    super.initState();
    taskDetails = fetchTaskDetails(widget.tugasId); // Fetch task details based on tugasId
  }

  String formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);  // Parsing the string into DateTime object
      return DateFormat('dd MMM yyyy').format(date);  // Format the date to your desired format
    } catch (e) {
      return dateString;  // Return the original string if parsing fails
    }
  }

  Future<Map<String, dynamic>> fetchTaskDetails(String tugasId) async {
    Dio dio = Dio();

    try {
      final response = await dio.post(
        'https://kompen.kufoto.my.id/api/show_tugas', // Replace with the correct API URL
        data: {'tugas_id': tugasId}, // Send tugasId in the request body
      );

      if (response.statusCode == 200) {
        return response.data; // Return task data
      } else {
        throw Exception('Failed to load task');
      }
    } catch (e) {
      throw Exception('Failed to fetch task details: $e');
    }
  }

  // Function to upload file
  void uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      List<int> fileBytes = result.files.single.bytes ?? [];
      String fileName = result.files.single.name;

      // Log the file type and size for debugging
      print('Selected file: $fileName');
      print('File size: ${result.files.single.size} bytes');
      print('File type: ${result.files.single.extension}');

      // Check file size
      if (result.files.single.size > 5120000) {
        print('File is too large, must be less than 5MB');
        return;
      }

      // Check file type
      List<String> allowedExtensions = ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx'];
      if (!allowedExtensions.contains(result.files.single.extension)) {
        print('Invalid file type');
        return;
      }

      FormData formData = FormData.fromMap({
        'file_mahasiswa': MultipartFile.fromBytes(fileBytes, filename: fileName),
        'apply_id': widget.applyID, // Ensure applyId is valid
      });

      Dio dio = Dio();
      try {
        final response = await dio.post(
          'http://192.168.31.139:8000/api/upload', // Replace with your actual API URL
          data: formData,
        );

        if (response.statusCode == 200) {
          var responseData = response.data;
          String message = responseData['message'] ?? 'Berhasil Mengirim Pekerjaan';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      } catch (e) {
        print('Error during file upload: $e');
      }
    }
  }

  // Function to send the task to API (kirim)
  void sendTaskToApi() async {
    Dio dio = Dio();
    try {
      print('Sending apply_id: ${widget.applyID}');
      
      final response = await dio.post(
        'http://192.168.31.139:8000/api/kirim', // Correct API URL
        data: {
          'apply_id': widget.applyID, // Adjust to match the parameter in your controller
        },
      );

      if (response.statusCode == 200) {
        // Handle success
        print('Response data: ${response.data}');
        var responseData = response.data;
        String message = responseData['message'] ?? 'Berhasil Mengirim Pekerjaan';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } else {
        // Handle failure
        print('Failed to send task: ${response.statusCode}');
        print('Response body: ${response.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal Mengirim Pekerjaan')),
        );
      }
    } catch (e) {
      print('Error during task submission: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Gagal mengirim tugas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Bukti Pekerjaan"),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: taskDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Data not found'));
          }

          // Retrieve task data
          var task = snapshot.data!;

          // Ensure data is not null before using
          String tugasNama = task['tugas_nama'] ?? 'Nama Tugas Tidak Tersedia';
          String tugasTipe = task['tugas_tipe'] ?? 'Tipe Tugas Tidak Diketahui';
          String tugasDeskripsi = task['tugas_deskripsi'] ?? 'Deskripsi Tidak Tersedia';
          String tugasTenggat = task['tugas_tenggat'] ?? 'Tanggal Tenggat Tidak Diketahui';
          String tugasAlpha = task['tugas_alpha'] ?? 'Tidak Diketahui'; // Set a default value if not present

          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text(
                                tugasNama,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                tugasTipe == 'Online' ? "Online" : "Offline",
                                style: TextStyle(color: Colors.green),
                              ),
                              SizedBox(height: 8),
                              Icon(
                                Icons.task,
                                size: 100,
                                color: Colors.blueAccent,
                              ),
                              SizedBox(height: 8),
                              Text(
                                "By Septain Enggar",
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              SizedBox(height: 8),
                              Text(
                                tugasDeskripsi,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.assignment, color: Colors.blue),
                          title: Text(task['file_tugas'] ?? 'Tidak Ada File Tugas'),
                          trailing: Icon(Icons.download),
                          onTap: () {
                            // Add file download logic if needed
                          },
                        ),
                        Divider(),
                        SizedBox(height: 8),
                        Text(
                          "Suka Kompen.",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: uploadFile, // Call the uploadFile function
                          icon: Icon(Icons.upload_file),
                          label: Text("Upload File"),
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.access_time, color: Colors.grey),
                                SizedBox(width: 4),
                                Text(formatDate(tugasTenggat)), // Format tanggal
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.arrow_downward, color: Colors.red),
                                SizedBox(width: 4),
                                Text(tugasAlpha, style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Button color
                    foregroundColor: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    sendTaskToApi(); // Call the sendTaskToApi function
                  },
                  child: Text(
                    "Kirim Pekerjaan",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}