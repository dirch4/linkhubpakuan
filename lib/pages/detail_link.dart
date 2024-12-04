import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkhubpakuan/pages/add_link.dart';
import 'package:linkhubpakuan/services/firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class LinksPage extends StatefulWidget {
  final String categoryId;
  final String title;

  LinksPage({required this.categoryId, required this.title});

  @override
  State<LinksPage> createState() => _LinksPageState();
}

class _LinksPageState extends State<LinksPage> {
  final FirestoreService firestoreService = FirestoreService();

  Future<void> openLink(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal membuka link: $url")),
      );
    }
  }

  // Menampilkan dialog konfirmasi untuk delete
  void confirmDelete(BuildContext context, docID) {
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

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Link berhasil dihapus."),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  void _showAddLinkDialog(BuildContext context) {
    final TextEditingController judulController = TextEditingController();
    final TextEditingController linkController = TextEditingController();
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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
                ],
              ),
              actions: [
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else ...[
                  ElevatedButton(
                    onPressed: () async {
                      final judul = judulController.text.trim();
                      final link = linkController.text.trim();

                      if (judul.isEmpty || link.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("Judul dan Link tidak boleh kosong")),
                        );
                        return;
                      }

                      final isValidUrl =
                          Uri.tryParse(link)?.hasAbsolutePath ?? false;
                      if (!isValidUrl) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("URL tidak valid")),
                        );
                        return;
                      }

                      setState(() => isLoading = true);

                      try {
                        await firestoreService.addLink(judul, link, widget.categoryId);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Link berhasil ditambahkan")),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Gagal menambahkan link: $e")),
                        );
                      } finally {
                        setState(() => isLoading = false);
                      }
                    },
                    child: const Text("Simpan"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Batal"),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getLinksByCategory(widget.categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada link"));
          }

          List links = snapshot.data!.docs;

          return ListView.builder(
            itemCount: links.length,
            itemBuilder: (context, index) {
              DocumentSnapshot linkDoc = links[index];
              String docId = linkDoc.id;
              Map<String, dynamic> data =
                  linkDoc.data() as Map<String, dynamic>;

              return ListTile(
                onTap: () => openLink(context, data['link']),
                title: Text(data['judul']),
                subtitle: Text(data['link']),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    confirmDelete(context, docId);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddLinkPage(categoryId: widget.categoryId),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => //_showAddLinkDialog(context),
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
