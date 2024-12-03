import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkhubpakuan/services/firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class LinksPage extends StatelessWidget {
  final String categoryId;
  final String title;
  final FirestoreService firestoreService = FirestoreService();

  LinksPage({required this.categoryId, required this.title});

  Future<void> openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print("Gagal membuka link: $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getLinksByCategory(categoryId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List links = snapshot.data!.docs;

            return ListView.builder(
              itemCount: links.length,
              itemBuilder: (context, index) {
                DocumentSnapshot linkDoc = links[index];
                String docId = linkDoc.id;
                Map<String, dynamic> data =
                    linkDoc.data() as Map<String, dynamic>;

                return ListTile(
                  onTap: () => openLink(data['link']),
                  title: Text(data['judul']),
                  subtitle: Text(data['link']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        firestoreService.deleteLink(categoryId, docId),
                  ),
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              final TextEditingController judulController =
                  TextEditingController();
              final TextEditingController linkController =
                  TextEditingController();
              String selectedCategory = categoryId; // Default kategori

              return AlertDialog(
                title: const Text("Tambah Link"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: judulController,
                      decoration: const InputDecoration(
                        labelText: "Judul",
                        hintText: "Masukkan judul link",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: linkController,
                      decoration: const InputDecoration(
                        labelText: "Link",
                        hintText: "Masukkan URL link",
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      final judul = judulController.text.trim();
                      final link = linkController.text.trim();

                      if (judul.isNotEmpty && link.isNotEmpty) {
                        // Panggil FirestoreService untuk menambahkan link dengan kategori
                        FirestoreService()
                            .addLink(judul, link, selectedCategory);

                        judulController.clear();
                        linkController.clear();
                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Link berhasil ditambahkan")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("Judul dan Link tidak boleh kosong")),
                        );
                      }
                    },
                    child: const Text("Simpan"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Batal"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

