import 'package:flutter/material.dart';
import 'package:linkhubpakuan/services/firestore.dart';

class AddCategoryPage extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Kategori")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: idController,
              decoration: const InputDecoration(labelText: "ID Kategori"),
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nama Kategori"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final id = idController.text.trim();
                final name = nameController.text.trim();

                if (id.isNotEmpty && name.isNotEmpty) {
                  firestoreService.addCategory(id, name);
                  idController.clear();
                  nameController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Kategori berhasil ditambahkan")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("ID dan Nama tidak boleh kosong")),
                  );
                }
              },
              child: const Text("Tambah Kategori"),
            ),
          ],
        ),
      ),
    );
  }
}
