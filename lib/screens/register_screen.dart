import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homestay_raya/screens/login_screen.dart';
import 'package:homestay_raya/screens/nav_bar_screen.dart';
import 'package:homestay_raya/services/auth_methods.dart';
import 'package:homestay_raya/utils/utils.dart';
import 'package:homestay_raya/widgets/loading_indicator.dart';

import 'package:homestay_raya/widgets/primary_app_bar.dart';
import 'package:homestay_raya/widgets/primary_button.dart';
import 'package:homestay_raya/widgets/text_field_input.dart';

import 'package:homestay_raya/utils/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isLoading = false;

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final reenterPasswordController = TextEditingController();

  String usernameErrorMsg = "";
  String emailErrorMsg = "";
  String phoneErrorMsg = "";
  String passwordErrorMsg = "";
  String reenterPasswordErrorMsg = "";


  void submitRegister() async {
    setState(() {
      isLoading = true;
      usernameErrorMsg = "";
      emailErrorMsg = "";
      phoneErrorMsg = "";
      passwordErrorMsg = "";
      reenterPasswordErrorMsg = "";
    });

    bool usernameFormatCorrected = false;
    bool emailFormatCorrected = false;
    bool passwordFormatCorrected = false;
    bool reenterPasswordFormatCorrected = false;
    bool phoneFormatCorrected = false;

    if (usernameController.text == "") {
      setState(() {
        usernameErrorMsg = "The field cannot be empty.";
      });
    } else {
      usernameFormatCorrected = true;
    }

    if (emailController.text == "") {
      setState(() {
        emailErrorMsg = "The field cannot be empty.";
      });
    } else if (!RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text)) {
      setState(() {
        emailErrorMsg = "Incorrect email format.\nE.g. correct email: name@email.com.";
      });
    } else {
      emailFormatCorrected = true;
    }

    if (passwordController.text == "") {
      setState(() {
        passwordErrorMsg = "The field cannot be empty.";
      });
    } else if (passwordController.text.length < 6) {
      setState(() {
        passwordErrorMsg = "Please enter at least 6 or more characters.";
      });
    } else {
      passwordFormatCorrected = true;
    }

    if (reenterPasswordController.text == "") {
      setState(() {
        reenterPasswordErrorMsg = "The field cannot be empty.";
      });
    } else if (reenterPasswordController.text.length < 6) {
      setState(() {
        reenterPasswordErrorMsg = "Please enter at least 6 or more characters.";
      });
    } else if (passwordController.text != reenterPasswordController.text) {
      setState(() {
        reenterPasswordErrorMsg = "The password doesn't match the password entered above.";
      });
    } else {
      reenterPasswordFormatCorrected = true;
    }
    String phoneNumberOnlyNum = phoneController.text.replaceAll(
        RegExp(r'[^0-9]'), '');
    String formattedPhoneNumber = "";

    if (
    ((phoneNumberOnlyNum.length == 10
        || phoneNumberOnlyNum.length == 11)
        && phoneNumberOnlyNum.startsWith("0")) ||
        ((phoneNumberOnlyNum.length == 12
            || phoneNumberOnlyNum.length == 13)
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

    if (usernameFormatCorrected && emailFormatCorrected
        && passwordFormatCorrected && reenterPasswordFormatCorrected
        && phoneFormatCorrected) {
      String res = await AuthMethods().signUpUser(
        email: emailController.text,
        password: passwordController.text,
        username: usernameController.text,
        phone: formattedPhoneNumber,
      );

      // if string returned is success, user has been created
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        // navigate to the home screen
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const NavBarScreen(selectedIndex: 0,)
            ),
                (route) => false);
      } else {
        setState(() {
          isLoading = false;
        });
        // show the error
        showSnackBar(context, res);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingIndicator() : Scaffold(
      appBar: PrimaryAppBar(
          title: ""
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40,),
                Text(
                  "REGISTER",
                  style: TextStyle(
                    color: Color(0xFFF2AA4C),
                    fontWeight: FontWeight.bold,
                    fontSize: 48,
                  ),
                ),

                Divider(),

                const SizedBox(height: 20,),

                TextFieldInput(
                  textEditingController: usernameController,
                  hintText: "Username",
                  textInputType: TextInputType.text,
                  errorMsg: usernameErrorMsg,
                  iconData: Icons.person,
                ),

                const SizedBox(height: 20,),

                TextFieldInput(
                  textEditingController: emailController,
                  hintText: "Email",
                  textInputType: TextInputType.emailAddress,
                  iconData: Icons.email_outlined,
                  errorMsg: emailErrorMsg,),

                const SizedBox(height: 20,),

                TextFieldInput(
                  textEditingController: phoneController,
                  hintText: "Phone",
                  textInputType: TextInputType.phone,
                  iconData: Icons.phone_outlined,
                  errorMsg: phoneErrorMsg,),

                const SizedBox(height: 20,),
                TextFieldInput(
                  textEditingController: passwordController,
                  hintText: "Password",
                  isPass: true,
                  textInputType: TextInputType.visiblePassword,
                  iconData: Icons.lock_open_sharp,
                  errorMsg: passwordErrorMsg,),

                const SizedBox(height: 20.0),
                // password textfield
                TextFieldInput(
                  textEditingController: reenterPasswordController,
                  hintText: "Re-enter Password",
                  isPass: true,
                  textInputType: TextInputType.text,
                  errorMsg: reenterPasswordErrorMsg,
                  iconData: Icons.lock_open_sharp,
                ),

                const SizedBox(height: 30,),

                PrimaryButton(
                  onPressed: submitRegister,
                  childText: "Register",
                ),

                const SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Have an account?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      ),
                      child: Text(
                        " Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}