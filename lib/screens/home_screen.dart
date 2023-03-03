import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homestay_raya/screens/search_screen.dart';

import 'package:homestay_raya/utils/app_theme.dart';
import 'package:homestay_raya/widgets/homestay_card.dart';
import 'package:homestay_raya/widgets/loading_indicator.dart';
import 'package:homestay_raya/widgets/primary_app_bar.dart';
import 'package:homestay_raya/widgets/primary_button.dart';
import 'package:homestay_raya/widgets/text_field_input.dart';
import 'package:firebase_pagination/firebase_pagination.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;

  TextEditingController searchController = TextEditingController();
  String searchText = '';

  List<Object> homestayData = <Object>[];

  @override
  void initState() {
    super.initState();
    getDataFromFireStore();
  }

  Future<void> getDataFromFireStore() async {
    setState(() {
      isLoading = true;
    });

    var instantSnapShotsValue =
    await FirebaseFirestore.instance.collection("homestays")
        .get();

    List<Object> homestayList = instantSnapShotsValue.docs
        .map((e) => Object()).toList();

    setState(() {
      homestayData = homestayList;
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
        title: "Homestay Raya",
        rightButton: Icons.search,
        function: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SearchScreen(),
          ),
        ),
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
              const SizedBox(height: 10,),
              Text(
                "Total ${homestayData.length.toString()} homestays were found.",

              ),
              const SizedBox(height: 10,),
              Expanded(
                child: FirestorePagination(
                  limit: 5, // Defaults to 10.
                  viewType: ViewType.list,
                  bottomLoader: const LoadingIndicator(),
                  query: FirebaseFirestore.instance
                      .collection('homestays').orderBy('modifiedDate', descending: true),
                  itemBuilder: (context, documentSnapshot, index) {
                    final data = documentSnapshot.data() as Map<String, dynamic>;

                    // Do something cool with the data
                    if (data.isEmpty) {
                      return const Text("There are currently no homestay records");
                    }

                    return Container(
                      padding: EdgeInsets.only(bottom: 20),
                      child: HomestayCard(
                        snap: data,
                      ),
                    );
                  },
                ),
              ),

              // Expanded(
              //   child: StreamBuilder(
              //
              //     stream: homestayCollection
              //         .orderBy('modifiedDate', descending: true)
              //         .snapshots(),
              //
              //     builder: (context, streamSnapshot) {
              //       if (streamSnapshot.hasData) {
              //         homestayDocuments = streamSnapshot.data!.docs;
              //
              //         // homestayDocuments = homestayDocuments.where((element) {
              //         //   return element
              //         //       .get('ownerId')
              //         //       .contains(FirebaseAuth.instance.currentUser!.uid);
              //         // }).toList();
              //         if (searchText.isNotEmpty) {
              //           homestayDocuments = homestayDocuments.where((element) {
              //             return element
              //                 .get('title')
              //                 .toLowerCase()
              //                 .contains(searchText.toLowerCase());
              //           }).toList();
              //         }
              //       }
              //       return ListView.builder(
              //         itemCount: homestayDocuments.length,
              //         // shrinkWrap: true,
              //         // scrollDirection: Axis.horizontal,
              //         itemBuilder: (ctx, index) =>
              //             Container(
              //               padding: EdgeInsets.only(bottom: 20),
              //               child: HomestayCard(
              //                 snap: homestayDocuments[index].data(),
              //               ),
              //             ),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

}