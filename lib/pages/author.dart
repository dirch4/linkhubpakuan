import 'package:flutter/material.dart';
import 'package:linkhubpakuan/widgets/sidebar.dart';

class AuthorPage extends StatelessWidget {
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
      drawer: Sidebar(), // Sidebar ditambahkan di sini
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul halaman
            Text(
              'Pemilik',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            // Daftar pemilik
            Text(
              '065122185 - Muhammad Falleryan',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            Text(
              '065122199 - Axel Juanito P.S',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16.0),
            Text(
              '065122205 - Dimas Nurcahya',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}