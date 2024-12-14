import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class UploadProofScreen extends StatefulWidget {
  final String tugasId;
  final String applyID;

  UploadProofScreen({required this.tugasId, required this.applyID});

  @override
  _UploadProofScreenState createState() => _UploadProofScreenState();
}

class _UploadProofScreenState extends State<UploadProofScreen> {
  late Future<Map<String, dynamic>> taskDetails;
  PlatformFile? selectedFile;

  @override
  void initState() {
    super.initState();
    taskDetails = fetchTaskDetails(widget.tugasId);
  }

  String formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  Future<Map<String, dynamic>> fetchTaskDetails(String tugasId) async {
    Dio dio = Dio();

    try {
      final response = await dio.post(
        'https://kompen.kufoto.my.id/api/show_tugas',
        data: {'tugas_id': tugasId},
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

  void downloadFileFromApi(String tugasId) async {
    Dio dio = Dio();

    try {
      final response = await dio.post(
        'https://kompen.kufoto.my.id/api/download_tugas',
        data: {'tugas_id': tugasId},
      );

      if (response.statusCode == 200) {
        String fileUrl = response.data['url'];

        if (fileUrl.isNotEmpty) {
          if (!fileUrl.startsWith('http://') && !fileUrl.startsWith('https://')) {
            fileUrl = 'https://kompen.kufoto.my.id$fileUrl';
          }

          downloadFileFromUrl(fileUrl);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('URL file tidak ditemukan')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghubungi API untuk file tugas')),
        );
      }
    } catch (e) {
      print('Error during API request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Gagal mengambil file')),
      );
    }
  }

  void downloadFileFromUrl(String fileUrl) async {
    Dio dio = Dio();

    try {
      if (!fileUrl.startsWith('http://') && !fileUrl.startsWith('https://')) {
        fileUrl = 'https://kompen.kufoto.my.id/storage/posts/tugas$fileUrl';  
      }

      String fileName = fileUrl.split('/').last;

      final directory = await getApplicationDocumentsDirectory();
      String savePath = '${directory.path}/$fileName';

      final response = await dio.download(
        fileUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print('Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
          }
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File berhasil diunduh! Lokasi: $savePath')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengunduh file')),
        );
      }
    } catch (e) {
      print('Error during file download: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Gagal mengunduh file')),
      );
    }
  }

  void uploadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx'],
    );

    if (result != null) {
      setState(() {
        selectedFile = result.files.single;
      });

      // Validate file size
      if (selectedFile!.size > 5120000) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('File terlalu besar. Maksimal 5MB'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          selectedFile = null;
        });
        return;
      }
    }
  }

  void sendTaskToApi() async {
    // Check if a file is selected
    if (selectedFile == null) {
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
      List<int> fileBytes = selectedFile!.bytes ?? [];
      String fileName = selectedFile!.name;

      FormData formData = FormData.fromMap({
        'file_mahasiswa': MultipartFile.fromBytes(fileBytes, filename: fileName),
        'apply_id': widget.applyID,
      });

      final response = await dio.post(
        'https://kompen.kufoto.my.id/api/upload',
        data: formData,
      );

      if (response.statusCode == 200) {
        var responseData = response.data;
        String message = responseData['message'] ?? 'Berhasil Mengirim Pekerjaan';
        
        // If upload successful, proceed with sending task
        await sendFinalTaskToApi(message);
      }
    } catch (e) {
      print('Error during file upload: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengunggah file'),
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
          String tugasAlpha = task['tugas_alpha'] ?? 'Tidak Diketahui';

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
                              Image.asset(
                                'assets/description.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
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
                            String? fileUrl = task['file_tugas'];
                            if (fileUrl != null && fileUrl.isNotEmpty) {
                              downloadFileFromUrl(fileUrl);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Tidak ada file tugas untuk diunduh')),
                              );
                            }
                          },
                        ),
                        SizedBox(height: 16),
                        Divider(),
                        ListTile(
                          leading: Icon(Icons.calendar_today),
                          title: Text('Tenggat: ${formatDate(tugasTenggat)}'),
                        ),
                        ListTile(
                          leading: Icon(Icons.access_time),
                          title: Text('Batas Pengumpulan: $tugasAlpha'),
                        ),
                        SizedBox(height: 16),
                        
                        // File Selection Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.all(16),
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
                                SizedBox(width: 10),
                                ElevatedButton.icon(
                                  onPressed: uploadFile,
                                  icon: Icon(Icons.upload_file),
                                  label: Text('Pilih File'),
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