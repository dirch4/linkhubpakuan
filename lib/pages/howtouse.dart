import 'package:flutter/material.dart';
import 'package:linkhubpakuan/widgets/sidebar.dart';

class HowToPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UnpakLink.'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Sidebar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul
              Text(
                'Cara Penggunaan',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Text(
                'Menambahkan Kategori Link :',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // Langkah-langkah penggunaan
              Text(
                '1. Buka menu di kiri atas lalu pilih “Tambah Kategori”.\n'
                '2. Buat kategori baru sesuai kebutuhan.\n'
                '3. Atau Masuk ke dalam Dashboard dan langsung klik +.\n'
                '4. Masukkan data kategori.\n'
                '5. Selesai, kategori ditambahkan.',
                style: TextStyle(fontSize: 16),
              ),
                            SizedBox(height: 16.0),
              Text(
                'Menambahkan Link :',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // Langkah-langkah penggunaan
              Text(
                '1. Buka menu di kiri atas lalu pilih “Dashboard”.\n'
                '2. Klik pada Kategori Link yang akan dibuat.\n'
                '3. Setelah itu klik tombol +.\n'
                '4. Masukan Data Link yang akan ditambahkan\n'
                '5. Selesai, Link ditambahkan.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24.0),
              // Catatan
              Text(
                'Catatan :',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Text(
                '1. Selalu buat kategori baru untuk link dengan kategori berbeda guna mengurangi kebingungan di masa depan.\n'
                '2. Ubah bahasa sesuai kenyamanan Anda.\n'
                '3. Bedakan warna antar kategori agar mempermudah identifikasi.\n'
                '4. Jadi anak rajin, sholeh, baik hati, dan rajinlah menabung.\n'
                '5. Support kami melalui Dana: 081271388599 A.N Muhammad Falleryan.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24.0),
              // Contact Person
              Text(
                'Contact Person :',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Text(
                '1. Falleryan 081271388599\n'
                '2. Dimas 0895613165087\n'
                '3. Axel 082246077010',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}