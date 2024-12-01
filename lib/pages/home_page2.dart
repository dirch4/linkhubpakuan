import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkhubpakuan/services/firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController judulController = TextEditingController();
  final TextEditingController linkController = TextEditingController();

  // Membuka kotak dialog untuk menambah atau mengedit link
  void openLinkBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(docID == null ? "Tambah Link" : "Edit Link"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: judulController,
              decoration: const InputDecoration(labelText: "Judul"),
            ),
            TextField(
              controller: linkController,
              decoration: const InputDecoration(labelText: "Link"),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final judul = judulController.text.trim();
              final link = linkController.text.trim();

              if (judul.isNotEmpty && link.isNotEmpty) {
                if (docID == null) {
                  firestoreService.addLink(judul, link);
                } else {
                  firestoreService.updateLink(docID, judul, link);
                }
                judulController.clear();
                linkController.clear();
                Navigator.pop(context);
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
    );
  }

  // Menampilkan dialog konfirmasi untuk delete
  void confirmDelete(String docID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Link"),
        content: const Text("Apakah Anda yakin ingin menghapus link ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              firestoreService.deleteLink(docID);
              Navigator.pop(context);
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  // Membuka link di browser
  Future<void> openLink(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      print("Mencoba membuka URL: $url");
      print("Validasi URL berhasil: ${await canLaunchUrl(Uri.parse(url))}");
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal membuka link: $url")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LinkHub Pakuan"),
        backgroundColor: Colors.amberAccent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openLinkBox(),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getLinksStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List listLinks = snapshot.data!.docs;

            return ListView.builder(
              itemCount: listLinks.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = listLinks[index];
                String docID = document.id;
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String judulText = data['judul'];
                String linksText = data['link'];

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: Card(
                    elevation: 2,
                    child: ListTile(
                      onTap: () => openLink(linksText),
                      title: Text(
                        judulText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(linksText, maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => openLinkBox(docID: docID),
                            icon: const Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () => confirmDelete(docID),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Tidak Ada Links"));
          }
        },
      ),
    );
  }
}
