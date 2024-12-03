import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkhubpakuan/pages/add_category.dart';
import 'package:linkhubpakuan/pages/detail_link.dart';
import 'package:linkhubpakuan/services/firestore.dart';

class DashboardPage extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();
  DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UnpakLink.'),
        leading: Icon(Icons.menu),
        actions: [Icon(Icons.search)],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Ketik judul link',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Kategori',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              StreamBuilder<QuerySnapshot>(
                stream: firestoreService.getCategoriesStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List categories = snapshot.data!.docs;

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: categories.length + 1,
                      itemBuilder: (context, index) {
                        if (index < categories.length) {
                          DocumentSnapshot category = categories[index];
                          String categoryId = category.id;
                          Map<String, dynamic> data =
                              category.data() as Map<String, dynamic>;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LinksPage(
                                      categoryId: categoryId,
                                      title: data['name']),
                                ),
                              );
                            },
                            child: CategoryTile(
                              color: data['color'] != null
                                  ? Color(int.parse(
                                          data['color'].substring(1, 7),
                                          radix: 16) +
                                      0xFF000000)
                                  : Colors.grey,
                              label: data['name'],
                            ),
                          );
                        } else {
                          return Container(
                            color: Colors.white,
                            child: Center(
                              child: IconButton(
                                icon: Icon(Icons.add,
                                    size: 36, color: Colors.black),
                                onPressed: () {
                                  Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddCategoryPage(),
                                  ),
                                  );
                                },
                              ),
                            ),
                          );
                        }
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
              SizedBox(height: 24.0),
              Text(
                'Baru Ditambahkan',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              // Placeholder tiles for "Baru Ditambahkan"
              RecentlyAddedTile(
                color: Color(0xFFd9998e),
                title: 'Zoom Teksim P9',
                date: '2 Desember 2024 - 13.00 WIB',
                category: 'Zoom Perkuliahan',
                addedDate: '1 Desember 2024',
              ),
              RecentlyAddedTile(
                color: Color(0xFF55b545),
                title: 'Pengumpulan Tugas Teksim',
                date: '10 Desember 2024 - 23.59 WIB',
                category: 'Gdrive Tugas',
                addedDate: '29 November 2024',
              ),
              RecentlyAddedTile(
                color: Color(0xFF44253e),
                title: 'Absen MobPro',
                date: '4 Desember 2024 - 15.00 WIB',
                category: 'Absensi',
                addedDate: '29 November 2024',
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Handle open full history
                },
                child: Text('Buka Riwayat Lengkap'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: BorderSide(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final Color color;
  final String label;

  CategoryTile({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class RecentlyAddedTile extends StatelessWidget {
  final Color color;
  final String title;
  final String date;
  final String category;
  final String addedDate;

  RecentlyAddedTile({
    required this.color,
    required this.title,
    required this.date,
    required this.category,
    required this.addedDate,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 10,
        color: color,
      ),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(date),
          Text('Kategori $category ditambahkan pada $addedDate'),
        ],
      ),
    );
  }
}
