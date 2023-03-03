import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:homestay_raya/screens/login_screen.dart';
import 'package:homestay_raya/screens/update_homestay_screen.dart';
import 'package:homestay_raya/services/firestore_methods.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:homestay_raya/utils/app_theme.dart';
import 'package:homestay_raya/utils/utils.dart';
import 'package:homestay_raya/widgets/dialogs.dart';
import 'package:homestay_raya/widgets/image_full_screen.dart';
import 'package:homestay_raya/widgets/loading_indicator.dart';
import 'package:homestay_raya/widgets/primary_app_bar.dart';
import 'package:homestay_raya/widgets/primary_button.dart';

import 'package:intl/intl.dart';

class HomestayDetailScreen extends StatefulWidget {
  final snap;

  const HomestayDetailScreen({
    Key? key,
    required this.snap,
  }) : super(key: key);
  @override
  State<HomestayDetailScreen> createState() => _HomestayDetailScreenState();
}

class _HomestayDetailScreenState extends State<HomestayDetailScreen> {
  bool isLoading = false;
  var ownerData = {};

  @override
  void initState() {
    super.initState();
    getData();
    _getAddressFromLatLng();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var ownerSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.snap["ownerId"])
          .get();

      ownerData = ownerSnap.data()!;
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _makePhoneCall(String url) async {
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }



  Widget getTextWidgets(List<String> strings)
  {
    List<Widget> list = <Widget>[];
    for(var i = 0; i < strings.length; i++){
      list.add(new Text(strings[i]));
    }
    return new Row(children: list);
  }

  delete() async {

    final action = await Dialogs.yesAbortDialog(
        context, 'Confirm to delete?',
        'Once confirmed, it cannot be modified anymore',
        'Delete');

    if (action == DialogAction.yes) {
      String res = await FireStoreMethods().deleteHomeStay(widget.snap["homestayId"]);

      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
        showSnackBar(context, "Homestay removed successfully");
      } else {
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, res);
      }
    }
  }

  Widget splitView(String title, String content) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(title),
        ),
        Expanded(
          flex: 6,
          child: Text(content),
        ),
      ],
    );
  }

  final DateFormat formatter = DateFormat('dd MMM y');

  String? _currentAddress;

  Future<void> _getAddressFromLatLng() async {
    await placemarkFromCoordinates(
        widget.snap["latitude"], widget.snap["longitude"])
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return isLoading
        ? const LoadingIndicator() : Scaffold(
      appBar: PrimaryAppBar(
          title: "Details"
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  // color: Theme.of(context).colorScheme.secondaryContainer,
                ),
                child: GestureDetector(
                  child: Hero(
                    tag: 'imageHero',
                    child: Image(
                      height: 200,
                      width: double.infinity,
                      // width: double.infinity - 20,
                      image: NetworkImage(widget.snap["photoUrl"]),
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes !=
                                null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) {
                          return ImageFullScreen(
                            imageUrl: widget.snap["photoUrl"],
                          );
                        }));
                  },
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF),
                ),
                padding: EdgeInsets.symmetric(horizontal: 25,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
                    Text(
                      widget.snap["title"],
                      maxLines: null,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    Divider(),
                    Text("Homestay Details"),
                    Divider(),
                    splitView("Description", widget.snap["description"]),
                    Divider(),
                    splitView("Price Per Day", "RM ${widget.snap["pricePerDay"].toStringAsFixed(2)}"),
                    Divider(),
                    splitView("Address", _currentAddress ?? "Invalid longitude and latitude"),
                    Divider(),
                    splitView("Date", formatter.format(widget.snap["modifiedDate"].toDate())),
                    const SizedBox(height: 20,),

                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).colorScheme.shadow,
                              offset: const Offset( 0.0, 1.0, ),
                              blurRadius: 10.0,
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 20,),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                                child: Image(
                                  width: 240,
                                  height: 190,
                                  fit: BoxFit.fitHeight,
                                  image: NetworkImage(ownerData["photoUrl"]),
                                  loadingBuilder: (BuildContext context, Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 20,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ownerData["username"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Theme.of(context).colorScheme.onBackground,
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                SizedBox(
                                  width: screenWidth - 210,
                                  child: Text(
                                    FirebaseAuth.instance.currentUser?.uid == null ?
                                    "Please log in to view the contact information" :
                                    ownerData["phoneNumber"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Theme.of(context).colorScheme.onBackground,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10,),
                                SizedBox(
                                  height: 40,
                                  width: screenWidth - 210,
                                  child: FirebaseAuth.instance.currentUser?.uid == null ?
                                  PrimaryButton(
                                      onPressed: () => Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => const LoginScreen(),
                                        ),
                                      ),
                                      childText: "Login"
                                  )
                                  : FirebaseAuth.instance.currentUser!.uid != ownerData["uid"] ?
                                  PrimaryButton(
                                      onPressed: ()
                                      {
                                        setState(() {
                                          _makePhoneCall('tel:0597924917');
                                        });
                                      },
                                      childText: "Call"
                                  ) : Container(),
                                ),

                              ],
                            ),

                          ],
                        )
                    ),

                    const SizedBox(height: 30,),


                    FirebaseAuth.instance.currentUser?.uid != null ?
                    FirebaseAuth.instance.currentUser!.uid == ownerData["uid"] ?
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            offset: const Offset( 0.0, 1.0, ),
                            blurRadius: 10.0,
                            spreadRadius: 0.5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            child: PrimaryButton(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => UpdateHomestayScreen(
                                    snap: widget.snap,
                                  ),
                                ),
                              ),
                              childText: "Update",
                            ),
                          ),
                          const SizedBox(height: 20,),
                          SizedBox(
                            child: PrimaryButton(
                              onPressed: delete,
                              childText: "Delete",
                            ),
                          ),

                        ],
                      ),
                    ) : Container() : Container(),

                    const SizedBox(height: 50,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}