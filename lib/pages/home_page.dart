import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkhubpakuan/pages/detail_link.dart';
import 'package:linkhubpakuan/services/firestore.dart';

class HomePage extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("LinkHub Pakuan")),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getCategoriesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List categories = snapshot.data!.docs;

            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
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
                            categoryId: categoryId, title: data['name']),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 2,
                    color: data['color'] != null
                        ? Color(int.parse(data['color'].substring(1, 7),
                                radix: 16) +
                            0xFF000000)
                        : Colors.grey,
                    child: Center(
                      child: Text(
                        data['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
    ;
  }
}
