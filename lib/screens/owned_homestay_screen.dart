import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homestay_raya/screens/add_homestay_screen.dart';

import 'package:homestay_raya/utils/app_theme.dart';
import 'package:homestay_raya/widgets/homestay_card.dart';
import 'package:homestay_raya/widgets/loading_indicator.dart';
import 'package:homestay_raya/widgets/primary_app_bar.dart';
import 'package:homestay_raya/widgets/primary_button.dart';

class OwnedHomestayScreen extends StatefulWidget {
  const OwnedHomestayScreen({super.key});

  @override
  State<OwnedHomestayScreen> createState() => _OwnedHomestayScreenState();
}

class _OwnedHomestayScreenState extends State<OwnedHomestayScreen> {
  bool isLoading = false;

  List<DocumentSnapshot> homestayDocuments = [];
  CollectionReference homestayCollection =
  FirebaseFirestore.instance.collection('homestays');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
          title: "Your Homestay"
      ),
      body: isLoading ? const LoadingIndicator() : Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20,),
              PrimaryButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddHomestayScreen(),
                  ),
                ),
                childText: "Add",
              ),
              const SizedBox(height: 20,),
              Expanded(
                child: StreamBuilder(
                  stream: homestayCollection
                      .orderBy('modifiedDate', descending: true)
                      .snapshots(),
                  builder: (context, streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      homestayDocuments = streamSnapshot.data!.docs;

                      homestayDocuments = homestayDocuments.where((element) {
                        return element
                            .get('ownerId')
                            .contains(FirebaseAuth.instance.currentUser!.uid);
                      }).toList();

                    }
                    return ListView.builder(
                      itemCount: homestayDocuments.length,
                      // shrinkWrap: true,
                      // scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) =>
                          Container(
                            padding: EdgeInsets.only(bottom: 20),
                            child: HomestayCard(
                              snap: homestayDocuments[index].data(),
                            ),
                          ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}