import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // mengambil data link dari database
  final CollectionReference links = 
  FirebaseFirestore.instance.collection('links');

  // CREATE
  //  Future<void> addLink(String judul, String link) async {
  //   try {
  //     print("Menambahkan data ke Firestore...");
  //     await links.add({
  //       'judul': judul,
  //       'link': link,
  //       'timestamp': Timestamp.now(),
  //       //'timestamp': FieldValue.serverTimestamp(),
  //     });
  //     print("Data berhasil ditambahkan.");
  //   } catch (e) {
  //     print("Kesalahan saat menambahkan data: $e");
  //   }
  // }
  
  // READ
  Stream<QuerySnapshot> getLinksStream(){
    final linksStream = links.orderBy('timestamp', descending: true).snapshots();
    return linksStream;
  }
  // UPDATE
  Future<void> updateLink(String docID, String newJudul, String newLink){
    return links.doc(docID).update({
      'judul': newJudul,
      'link': newLink,
      'timestamp': Timestamp.now()
    });
  }
  // DELETE
  // Future<void> deleteLink(String docID){
  //   return links.doc(docID).delete();
  // }
  
  
  final CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
      
  // Mendapatkan semua kategori
  Stream<QuerySnapshot> getCategoriesStream() {
    return categories.snapshots();
  }

  // Mendapatkan links dari kategori tertentu
  Stream<QuerySnapshot> getLinksByCategory(String categoryId) {
    return links.where('categoryId', isEqualTo: categoryId).snapshots();
  }

  // Menambahkan link ke kategori tertentu
 Future<void> addLink(String judul, String link, String categoryId) async {
  try {
    print("Menambahkan data ke Firestore...");
    await links.add({
      'judul': judul,
      'link': link,
      'categoryId': categoryId, // Tambahkan ID Kategori
      'timestamp': Timestamp.now(),
    });
    print("Data berhasil ditambahkan.");
  } catch (e) {
    print("Kesalahan saat menambahkan data: $e");
  }
}

  // Menghapus link
  Future<void> deleteLink(String categoryId, String docId) async {
    try {
      await categories.doc(categoryId).collection('links').doc(docId).delete();
    } catch (e) {
      print("Error deleting link: $e");
    }
  }

  Future<void> addCategories() async {
  final firestore = FirebaseFirestore.instance;
  final categories = [
    {"id": "kuisioner", "name": "Kuisioner"},
    {"id": "beasiswa", "name": "Beasiswa"},
    {"id": "lomba", "name": "Lomba"},
    {"id": "proker", "name": "Proker"},
  ];

  for (var category in categories) {
    await firestore.collection('categories').doc(category['id']).set({
      'name': category['name'],
    });
  }
}
  // Tambah kategori baru
  Future<void> addCategory(String id, String name, String color) async {
    try {
      await categories.doc(id).set({
        'name': name,
        'color': color
      });
      print("Kategori berhasil ditambahkan: $name");
    } catch (e) {
      print("Kesalahan saat menambahkan kategori: $e");
    }
  }
}