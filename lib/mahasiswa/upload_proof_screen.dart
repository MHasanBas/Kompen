import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

// Import the NotificationScreen
import 'notification_screen.dart'; // Make sure to update this import path

class UploadProofScreen extends StatefulWidget {
  final String tugasId;
  final String applyID;

  const UploadProofScreen({
    Key? key,
    required this.tugasId,
    required this.applyID,
  }) : super(key: key);

  @override
  _UploadProofScreenState createState() => _UploadProofScreenState();
}

class _UploadProofScreenState extends State<UploadProofScreen> {
  late Future<Map<String, dynamic>> taskDetails;
  PlatformFile? selectedFile;
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    taskDetails = fetchTaskDetails(widget.tugasId);
  }

  // Format date to more readable format
  String formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  // Fetch task details from API
  Future<Map<String, dynamic>> fetchTaskDetails(String tugasId) async {
    try {
      final response = await dio.post(
        'https://kompen.kufoto.my.id/api/show_tugas',
        data: {'tugas_id': tugasId},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load task');
      }
    } catch (e) {
      throw Exception('Failed to fetch task details: $e');
    }
  }

  // Download file method
  Future<void> downloadFile() async {
    try {
      // Ensure the task details are loaded
      var task = await taskDetails;
      String? fileTaskName = task['file_tugas'];

      if (fileTaskName == null || fileTaskName.isEmpty) {
        showErrorDialog('Tidak ada file tugas untuk diunduh');
        return;
      }

      // Get the device's document directory for saving the file
      Directory directory = await getApplicationDocumentsDirectory();
      String savePath = "${directory.path}/$fileTaskName";

      // Download the file
      await dio.download(
        'https://kompen.kufoto.my.id/api/download_tugas', 
        savePath,
        queryParameters: {'tugas_id': widget.tugasId},
        options: Options(
          method: 'POST', // Explicitly set the method to GET
          responseType: ResponseType.bytes,
        ),
      );

      // Verify file was actually downloaded
      File downloadedFile = File(savePath);
      if (!await downloadedFile.exists() || await downloadedFile.length() == 0) {
        showErrorDialog('Download gagal: File kosong');
        return;
      }

      // Show success dialog and option to open the file
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Download Sukses'),
            content: Text('File berhasil diunduh: $savePath'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  OpenFile.open(savePath);
                },
                child: const Text('Buka File'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('Download error details: $error'); // Add detailed error logging
      showErrorDialog('Gagal mengunduh file: ${error.toString()}');
    }
  }

  // Show error dialog
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // File upload method
  // void uploadFile() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.custom,
  //     allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx'],
  //   );

  //   if (result != null) {
  //     setState(() {
  //       selectedFile = result.files.single;
  //     });

  //     // Validate file size
  //     if (selectedFile!.size > 5120000) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('File terlalu besar. Maksimal 5MB'),
  //           backgroundColor: Colors.red,
  //         ),
  //       );
  //       setState(() {
  //         selectedFile = null;
  //       });
  //       return;
  //     }

  //     // Automatically upload the selected file after choosing it
  //     sendTaskToApi();
  //   }
  // }

 void uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx'],
    );

    if (result != null) {
      // Validate file size
      if (result.files.single.size > 5120000) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File terlalu besar. Maksimal 5MB'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        selectedFile = result.files.single;
      });
    }
  }

  void sendTaskToApi() async {
    if (selectedFile == null) {
      // Show error if no file is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Silakan pilih file bukti terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Dio dio = Dio();
    try {
      // Create file from selected path
      File file = File(selectedFile!.path!);

      // Create FormData for file upload
      FormData formData = FormData.fromMap({
        'file_mahasiswa': await MultipartFile.fromFile(
          file.path, 
          filename: selectedFile!.name
        ),
        'apply_id': widget.applyID,
      });

      // Upload file to server
      final uploadResponse = await dio.post(
        'https://kompen.kufoto.my.id/api/upload',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (uploadResponse.statusCode == 200) {
        // Send task after successful upload
        final submitResponse = await dio.post(
          'https://kompen.kufoto.my.id/api/kirim',
          data: {
            'apply_id': widget.applyID,
          },
        );

        if (submitResponse.statusCode == 200) {
          // Show success dialog
          await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Tugas Berhasil Dikirim',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Tugas Anda telah berhasil diunggah dan dikirim',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to notification screen
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => NotificationScreen(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          'OK',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          // Handle task submission error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal mengirim tugas'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Handle file upload error
        String errorMessage = uploadResponse.data['message'] ?? 'Terjadi kesalahan';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle general errors
      print('Error during task submission: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengunggah dan mengirim tugas'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  Future<void> sendFinalTaskToApi(String uploadMessage) async {
    Dio dio = Dio();
    try {
      final response = await dio.post(
        'https://kompen.kufoto.my.id/api/kirim',
        data: {
          'apply_id': widget.applyID,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$uploadMessage\nTugas berhasil dikirim'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengirim tugas'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error during task submission: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Gagal mengirim tugas'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Bukti Pekerjaan"),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: taskDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Data not found'));
          }

          // Retrieve task data
          var task = snapshot.data!;

          // Ensure data is not null before using
          String tugasNama = task['tugas_nama'] ?? 'Nama Tugas Tidak Tersedia';
          String tugasTipe = task['tugas_tipe'] ?? 'Tipe Tugas Tidak Diketahui';
          String tugasDeskripsi = task['tugas_deskripsi'] ?? 'Deskripsi Tidak Tersedia';
          String tugasTenggat = task['tugas_tenggat'] ?? 'Tanggal Tenggat Tidak Diketahui';
          String tugasAlpha = task['tugas_alpha'] ?? 'Tidak Diketahui';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
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
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                tugasTipe == 'Online' ? "Online" : "Offline",
                                style: const TextStyle(color: Colors.green),
                              ),
                              const SizedBox(height: 8),
                              Image.asset(
                                'assets/description.png',
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                tugasDeskripsi,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.assignment, color: Colors.blue),
                          title: Text(task['file_tugas'] ?? 'Tidak Ada File Tugas'),
                          trailing: const Icon(Icons.download),
                          onTap: downloadFile,
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: Text('Tenggat: ${formatDate(tugasTenggat)}'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.access_time),
                          title: Text('Batas Pengumpulan: $tugasAlpha'),
                        ),
                        const SizedBox(height: 16),
                        
                        // File Selection Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    selectedFile != null 
                                      ? 'Terpilih: ${selectedFile!.name}' 
                                      : 'Belum ada file dipilih',
                                    style: TextStyle(
                                      color: selectedFile != null ? Colors.black : Colors.grey,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton.icon(
                                  onPressed: uploadFile,
                                  icon: const Icon(Icons.upload_file),
                                  label: const Text('Pilih File'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Send Task Button
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: selectedFile != null ? sendTaskToApi : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selectedFile != null ? Colors.green : Colors.grey,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.send),
                                  SizedBox(width: 10),
                                  Text(
                                    'Kirim Tugas',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}