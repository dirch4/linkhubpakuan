import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkhubpakuan/pages/add_category.dart';
import 'package:linkhubpakuan/pages/detail_link.dart';
import 'package:linkhubpakuan/pages/full_history.dart';
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
        //actions: [Icon(Icons.search)],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TextField(
              //   decoration: InputDecoration(
              //     hintText: 'Ketik judul link',
              //     prefixIcon: Icon(Icons.search),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(8.0),
              //     ),
              //   ),
              // ),
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
              SizedBox(
                height: 500.0, // Sesuaikan tinggi
                child: RecentlyAddedList(limit: 5), // Batasi hanya 5 data
              ),

              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FullHistoryPage()),
                  );
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

class RecentlyAddedList extends StatelessWidget {
  final int limit;

  RecentlyAddedList({this.limit = 5}); // Default limit 5

  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: firestoreService.getCategories(),
      builder: (context, categorySnapshot) {
        if (categorySnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (categorySnapshot.hasError) {
          return Center(child: Text('Error: ${categorySnapshot.error}'));
        }

        final categories = categorySnapshot.data ?? {};

        return StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getRecentlyAddedLinks(
              limit: limit > 0 ? limit : null),
          builder: (context, linkSnapshot) {
            if (linkSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (linkSnapshot.hasError) {
              return Center(child: Text('Error: ${linkSnapshot.error}'));
            }

            if (!linkSnapshot.hasData || linkSnapshot.data!.docs.isEmpty) {
              return Center(child: Text('Tidak ada data.'));
            }

            return ListView(
              shrinkWrap: true,
              physics: limit > 0 ? NeverScrollableScrollPhysics() : null,
              children: linkSnapshot.data!.docs.map((doc) {
                var linkData = doc.data() as Map<String, dynamic>;

                // Pastikan categoryId tidak null
                String categoryId = linkData['categoryId'] ?? 'default';
                String? colorHex = categories[categoryId]?['color'];

                // Gunakan warna default jika colorHex null
                Color color = colorHex != null
                    ? Color(int.parse(colorHex.substring(1, 7), radix: 16) +
                        0xFF000000)
                    : Colors.grey;

                // Pastikan properti lainnya tidak null
                String title = linkData['judul'] ?? 'Judul Tidak Tersedia';
                String date = (linkData['timestamp'] as Timestamp?)
                        ?.toDate()
                        .toString() ??
                    'Tanggal Tidak Tersedia';
                String categoryName = categories[categoryId]?['name'] ??
                    'Kategori Tidak Diketahui';
                String addedDate = (linkData['timestamp'] as Timestamp?)
                        ?.toDate()
                        .toString() ??
                    'Tanggal Tidak Tersedia';

                return RecentlyAddedTile(
                  color: color,
                  title: title,
                  date: date,
                  category: categoryName,
                  addedDate: addedDate,
                );
              }).toList(),
            );
          },
        );
      },
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
