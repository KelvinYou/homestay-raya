import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homestay_raya/screens/change_profile_screen.dart';
import 'package:homestay_raya/screens/edit_personal_detail_screen.dart';
import 'package:homestay_raya/screens/login_screen.dart';
import 'package:homestay_raya/services/auth_methods.dart';

import 'package:homestay_raya/utils/app_theme.dart';
import 'package:homestay_raya/utils/utils.dart';
import 'package:homestay_raya/widgets/dialogs.dart';
import 'package:homestay_raya/widgets/loading_indicator.dart';
import 'package:homestay_raya/widgets/primary_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userData = userSnap.data()!;

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

  void logoutSubmit() async {
    await AuthMethods().signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  Widget selectionView(IconData icon, String title) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
          ),
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon),
                  const SizedBox(width: 10.0),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ],
              ),

              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ],
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
          title: "Profile"
      ),
      body: isLoading ? const LoadingIndicator() : Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25,),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20,),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ChangeProfileScreen(),
                    ),
                  ),
                  child: userData["photoUrl"] != "" ? CircleAvatar(
                    radius: 56.0,
                    backgroundImage: NetworkImage(
                      userData["photoUrl"],
                    ),
                    backgroundColor: Colors.grey,
                  ) : CircleAvatar(
                    radius: 56.0,
                    backgroundImage: AssetImage("assets/profile.jpg"),
                    backgroundColor: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10,),
                Text(
                  userData["username"],
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 20,),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      splitView("Email", userData["email"]),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          indent: 0,
                          endIndent: 0,
                          color: AppTheme.lightGrey,
                        ),
                      ),

                      splitView("Phone", userData["phoneNumber"]),


                    ],
                  ),
                ),

                const SizedBox(height: 20,),

                Container(
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
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ChangeProfileScreen(),
                          ),
                        ),
                        child: selectionView(
                            Icons.image_outlined,
                            "Change Profile Picture"
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        indent: 0,
                        endIndent: 0,
                        color: AppTheme.lightGrey,
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const EditPersonalDetailScreen(),
                          ),
                        ),
                        child: selectionView(
                            Icons.person_outline,
                            "Edit Personal Detail"
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 60,),

                GestureDetector(
                  onTap: () async {
                    final action = await Dialogs.yesAbortDialog(
                        context, 'Confirm to logout?', '',
                        'Logout');
                    if (action == DialogAction.yes) {
                      logoutSubmit();
                    }
                  },
                  child: Text(
                      "Logout",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}