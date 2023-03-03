import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:homestay_raya/utils/app_theme.dart';
import 'package:homestay_raya/widgets/homestay_card.dart';
import 'package:homestay_raya/widgets/loading_indicator.dart';
import 'package:homestay_raya/widgets/primary_app_bar.dart';
import 'package:homestay_raya/widgets/text_field_input.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isLoading = false;

  List<DocumentSnapshot> homestayDocuments = [];
  CollectionReference homestayCollection =
  FirebaseFirestore.instance.collection('homestays');

  TextEditingController searchController = TextEditingController();
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: TextFormField(
          controller: searchController,
          onChanged: (value) {
            setState(() {
              searchText = value;
            });
          },
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,

          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
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
              const SizedBox(height: 20,),
              Expanded(
                child: StreamBuilder(

                  stream: homestayCollection
                      .orderBy('modifiedDate', descending: true)
                      .snapshots(),

                  builder: (context, streamSnapshot) {
                    if (streamSnapshot.hasData) {
                      homestayDocuments = streamSnapshot.data!.docs;

                      if (searchText.isNotEmpty) {
                        homestayDocuments = homestayDocuments.where((element) {
                          return element
                              .get('title')
                              .toLowerCase()
                              .contains(searchText.toLowerCase());
                        }).toList();
                      }
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