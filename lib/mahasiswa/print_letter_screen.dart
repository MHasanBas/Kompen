import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PrintLetterScreen extends StatelessWidget {
  final Map<String, dynamic> data = {
    'pemberi_tugas': 'Septian Enggar',
    'nip_pemberi': '87654321',
    'nama_mahasiswa': 'M. Hasan Basri',
    'nim': '2030456789',
    'semester': '5',
    'pekerjaan': 'Membuat Aplikasi Flutter',
    'jumlah_jam': 10,
    'tanggal': '14 December 2024',
    'qrCode': 'QR CODE CONTENT HERE',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Berita Acara Kompensasi",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      "KEMENTERIAN PENDIDIKAN, KEBUDAYAAN, RISET, DAN TEKNOLOGI",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "POLITEKNIK NEGERI MALANG",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "JL. Soekarno-Hatta No. 9 Malang 65141 Telepon (0341) 404424 Pes. 101-105, 0341-404420, Fax. (0341) 404420",
                      style: TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "BERITA ACARA KOMPENSASI PRESENSI",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
              _buildInfoRow("Nama Pemberi Pekerjaan", data['pemberi_tugas']),
              _buildInfoRow("NIP", data['nip_pemberi']),
              _buildInfoRow("Nama Mahasiswa", data['nama_mahasiswa']),
              _buildInfoRow("NIM", data['nim']),
              _buildInfoRow("Semester", data['semester']),
              _buildInfoRow("Pekerjaan", data['pekerjaan']),
              _buildInfoRow("Jumlah Jam", "${data['jumlah_jam']}"),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTandaTangan("Ka Program Studi", data['nip_pemberi']),
                  _buildTandaTangan(
                      "Yang Memberikan Rekomendasi", data['nip_pemberi']),
                ],
              ),
              SizedBox(height: 32),
              Center(
                child: Column(
                  children: [
                    Text("Scan QR Code untuk validasi:",
                        style: TextStyle(fontSize: 12)),
                    SizedBox(height: 8),
                    Icon(
                      Icons.qr_code_2,
                      size: 150,
                      color: Colors.black87,
                    ),
                    SizedBox(height: 8),
                    Text(
                      "NB: Form ini wajib disimpan untuk kepentingan bebas tanggungan.",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    _printForm(context);
                  },
                  child: Text(
                    "Cetak Surat",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$title:",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTandaTangan(String title, String nip) {
    return Column(
      children: [
        Text(
          "($title)",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 40),
        Text(
          "........................................",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 4),
        Text(
          "NIP: $nip",
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  void _printForm(BuildContext context) {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      "KEMENTERIAN PENDIDIKAN, KEBUDAYAAN, RISET, DAN TEKNOLOGI",
                      style: pw.TextStyle(
                          fontSize: 12, fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      "POLITEKNIK NEGERI MALANG",
                      style: pw.TextStyle(
                          fontSize: 16, fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      "JL. Soekarno-Hatta No. 9 Malang 65141 Telepon (0341) 404424 Pes. 101-105, 0341-404420, Fax. (0341) 404420",
                      style: pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 16),
                    pw.Text(
                      "BERITA ACARA KOMPENSASI PRESENSI",
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        decoration: pw.TextDecoration.underline,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.SizedBox(height: 24),
                  ],
                ),
              ),
              _buildPdfInfoRow("Nama Pemberi Pekerjaan", data['pemberi_tugas']),
              _buildPdfInfoRow("NIP", data['nip_pemberi']),
              _buildPdfInfoRow("Nama Mahasiswa", data['nama_mahasiswa']),
              _buildPdfInfoRow("NIM", data['nim']),
              _buildPdfInfoRow("Semester", data['semester']),
              _buildPdfInfoRow("Pekerjaan", data['pekerjaan']),
              _buildPdfInfoRow("Jumlah Jam", "${data['jumlah_jam']}"),
              pw.SizedBox(height: 24),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  _buildPdfTandaTangan("Ka Program Studi", data['nip_pemberi']),
                  _buildPdfTandaTangan(
                      "Yang Memberikan Rekomendasi", data['nip_pemberi']),
                ],
              ),
              pw.SizedBox(height: 32),
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text("Scan QR Code untuk validasi:",
                        style: pw.TextStyle(fontSize: 12)),
                    pw.SizedBox(height: 8),
                    pw.BarcodeWidget(
                      data: data['qrCode'],
                      barcode: pw.Barcode.qrCode(),
                      width: 150,
                      height: 150,
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      "NB: Form ini wajib disimpan untuk kepentingan bebas tanggungan.",
                      style: pw.TextStyle(color: PdfColors.red, fontSize: 12),
                      textAlign: pw.TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.Widget _buildPdfInfoRow(String title, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            flex: 2,
            child: pw.Text(
              "$title:",
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Expanded(
            flex: 3,
            child: pw.Text(
              value,
              style: pw.TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPdfTandaTangan(String title, String nip) {
    return pw.Column(
      children: [
        pw.Text(
          "($title)",
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 40),
        pw.Text(
          "........................................",
          style: pw.TextStyle(fontSize: 14),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          "NIP: $nip",
          style: pw.TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
