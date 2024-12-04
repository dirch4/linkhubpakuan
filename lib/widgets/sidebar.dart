import 'package:flutter/material.dart';
import 'package:linkhubpakuan/pages/add_category.dart';
import 'package:linkhubpakuan/pages/add_link.dart';
import 'package:linkhubpakuan/pages/author.dart';
import 'package:linkhubpakuan/pages/dashboard.dart';
import 'package:linkhubpakuan/pages/full_history.dart';
import 'package:linkhubpakuan/pages/howtouse.dart';
import 'package:linkhubpakuan/pages/notfound.dart';
import 'package:linkhubpakuan/widgets/theme_provider.dart';
import 'package:provider/provider.dart';
//import 'package:linkhubpakuan/pages/history.dart';
// import 'package:linkhubpakuan/pages/howto.dart';
// import 'package:linkhubpakuan/pages/author.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    return Drawer(
      child: Container(
        color: Colors.blue[900], // Warna latar belakang sidebar
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[900],
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.category, color: Colors.white),
              title: Text(
                'Dashboard',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: Colors.white),
              title: Text(
                'Riwayat',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FullHistoryPage()),
                );
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.link, color: Colors.white),
            //   title: Text(
            //     'Tambah Link',
            //     style: TextStyle(color: Colors.white),
            //   ),
            //   onTap: () {
            //     Navigator.pop(context);
            //     // Navigator.push(
            //     //   context,
            //     //   MaterialPageRoute(builder: (context) => AddLinkPage()),
            //     // );
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.category, color: Colors.white),
              title: Text(
                'Tambah Kategori',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddCategoryPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.language, color: Colors.white),
              title: Text(
                'Bahasa',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Notfound()),
                );
                // Navigasi ke halaman yang diinginkan
              },
            ),
            ListTile(
              leading: Icon(Icons.nightlight_round, color: Colors.white),
              title: Text(
                'Mode Malam',
                style: TextStyle(color: Colors.white),
              ),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  themeProvider.toggleTheme(value);
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_2, color: Colors.white),
              title: Text(
                'Authors',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuthorPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.help, color: Colors.white),
              title: Text(
                'Cara Penggunaan',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HowToPage()),
                );
              },
            ),
            // Spacer untuk memberikan jarak fleksibel
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'UnpakLink. V1.0',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}