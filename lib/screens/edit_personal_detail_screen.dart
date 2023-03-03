import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homestay_raya/services/firestore_methods.dart';

import 'package:homestay_raya/utils/app_theme.dart';
import 'package:homestay_raya/utils/utils.dart';
import 'package:homestay_raya/widgets/loading_indicator.dart';
import 'package:homestay_raya/widgets/primary_app_bar.dart';
import 'package:homestay_raya/widgets/primary_button.dart';
import 'package:homestay_raya/widgets/text_field_input.dart';



class EditPersonalDetailScreen extends StatefulWidget {
  const EditPersonalDetailScreen({super.key});

  @override
  State<EditPersonalDetailScreen> createState() => _EditPersonalDetailScreenState();
}

class _EditPersonalDetailScreenState extends State<EditPersonalDetailScreen> {
  bool isLoading = false;
  var userData = {};

  TextEditingController phoneController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  String phoneErrorMsg = "";
  String usernameErrorMsg = "";

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
      usernameController = TextEditingController(text: userData["username"]);
      phoneController = TextEditingController(text:
      userData["phoneNumber"].replaceAll(
          RegExp(r'[^0-9]'), ''));

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

  updateProfileSubmit() async {
    setState(() {
      isLoading = true;
      usernameErrorMsg = "";
      phoneErrorMsg = "";
    });

    bool usernameFormatCorrected = false;
    bool phoneFormatCorrected = false;

    if (usernameController.text == "") {
      setState(() {
        usernameErrorMsg = "The Username cannot be empty.";
      });
    } else {
      usernameFormatCorrected = true;
    }

    String phoneNumberOnlyNum = phoneController.text.replaceAll(
        RegExp(r'[^0-9]'), '');
    String formattedPhoneNumber = "";

    if (
    ((phoneNumberOnlyNum.length == 10
        || phoneNumberOnlyNum.length == 11)
        && phoneNumberOnlyNum.startsWith("0")) ||
        ((phoneNumberOnlyNum.length == 11
            || phoneNumberOnlyNum.length == 12)
            && phoneNumberOnlyNum.startsWith("6"))
    ) {
      if (phoneNumberOnlyNum.startsWith("6")) {
        formattedPhoneNumber =
        "+(${phoneNumberOnlyNum.substring(0,2)}) ${phoneNumberOnlyNum.substring(2, 4)}-${phoneNumberOnlyNum.substring(4, 8)} ${phoneNumberOnlyNum.substring(8)}";
      } else {
        formattedPhoneNumber =
        "+(6${phoneNumberOnlyNum.substring(0,1)}) ${phoneNumberOnlyNum.substring(1, 3)}-${phoneNumberOnlyNum.substring(3, 7)} ${phoneNumberOnlyNum.substring(7)}";
      }
      phoneFormatCorrected = true;
    } else {
      setState(() {
        phoneErrorMsg = "Incorrect Phone Number Format.\n"
            "E.g. The correct phone number format is as follows: "
            "0123456789 / 60123456789";
      });
    }

    if ( usernameFormatCorrected && phoneFormatCorrected ) {
      try {
        String res = await FireStoreMethods().updatePersonalDetail(
          FirebaseAuth.instance.currentUser!.uid,
          usernameController.text,
          formattedPhoneNumber,
        );
        if (res == "success") {
          setState(() {
            isLoading = false;
          });
          showSnackBar(
            context,
            'Updated!',
          );
        } else {
          showSnackBar(context, res);
        }
      } catch (err) {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          err.toString(),
        );
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppBar(
          title: "Edit Personal Detail"
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
                const SizedBox(height: 30,),
                TextFieldInput(
                  textEditingController: usernameController,
                  hintText: "Username",
                  textInputType: TextInputType.text,
                  errorMsg: usernameErrorMsg,
                ),
                const SizedBox(height: 20,),
                TextFieldInput(
                  textEditingController: phoneController,
                  hintText: "Phone Number",
                  textInputType: TextInputType.phone,
                  errorMsg: phoneErrorMsg,
                ),
                const SizedBox(height: 30,),
                PrimaryButton(
                  onPressed: updateProfileSubmit,
                  childText: "Update",
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}