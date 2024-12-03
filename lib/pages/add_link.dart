import 'package:flutter/material.dart';
import 'package:linkhubpakuan/services/firestore.dart';

class AddLinkPage extends StatelessWidget {
  final String categoryId;
  final FirestoreService firestoreService = FirestoreService();

  AddLinkPage({required this.categoryId});

  final TextEditingController judulController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Link")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: judulController,
              decoration: const InputDecoration(
                labelText: "Judul",
                hintText: "Masukkan judul link",
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: linkController,
              decoration: const InputDecoration(
                labelText: "Link",
                hintText: "Masukkan URL link",
              ),
            ),
            
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                final judul = judulController.text.trim();
                final link = linkController.text.trim();

                if (judul.isNotEmpty && link.isNotEmpty) {
                  firestoreService.addLink(judul, link, categoryId);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Link berhasil ditambahkan")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Judul dan Link tidak boleh kosong")),
                  );
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
