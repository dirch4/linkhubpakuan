import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:linkhubpakuan/pages/dashboard.dart';
import 'package:linkhubpakuan/services/firestore.dart';


class FullHistoryPage extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Lengkap'),
      ),
      body: RecentlyAddedList(limit: 0)
    );
  }
}
