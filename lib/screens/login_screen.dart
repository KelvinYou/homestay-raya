import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:homestay_raya/screens/home_screen.dart';
import 'package:homestay_raya/screens/nav_bar_screen.dart';
import 'package:homestay_raya/screens/register_screen.dart';

import 'package:homestay_raya/utils/app_theme.dart';
import 'package:homestay_raya/widgets/loading_indicator.dart';
import 'package:homestay_raya/widgets/primary_app_bar.dart';
import 'package:homestay_raya/widgets/primary_button.dart';
import 'package:homestay_raya/widgets/text_field_input.dart';
import 'package:homestay_raya/services/auth_methods.dart';
import 'package:homestay_raya/utils/utils.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String emailErrorMsg = "";
  String passwordErrorMsg = "";



  void submitLogin() async {
    setState(() {
      isLoading = true;
      emailErrorMsg = "";
      passwordErrorMsg = "";
    });

    bool emailFormatCorrected = false;
    bool passwordFormatCorrected = false;

    if (emailController.text == "") {
      setState(() {
        emailErrorMsg = "Please enter your email address.";
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
        passwordErrorMsg = "Please enter your password.";
      });
    } else if (passwordController.text.length < 6) {
      setState(() {
        passwordErrorMsg = "Please enter at least 6 or more characters.";
      });
    } else {
      passwordFormatCorrected = true;
    }

    if (emailFormatCorrected && passwordFormatCorrected) {
      String res = await AuthMethods().loginUser(
          email: emailController.text, password: passwordController.text);
      if (res == 'success') {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const NavBarScreen(selectedIndex: 0)
            ),
                (route) => false);

        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
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
                  "LOGIN",
                  style: TextStyle(
                    color: Color(0xFFF2AA4C),
                    fontWeight: FontWeight.bold,
                    fontSize: 48,
                  ),
                ),

                Divider(),

                const SizedBox(height: 20,),

                TextFieldInput(
                  textEditingController: emailController,
                  hintText: "Email",
                  textInputType: TextInputType.emailAddress,
                  iconData: Icons.email_outlined,
                  errorMsg: emailErrorMsg,),

                const SizedBox(height: 20,),

                TextFieldInput(
                  textEditingController: passwordController,
                  hintText: "Password",
                  isPass: true,
                  textInputType: TextInputType.text,
                  iconData: Icons.lock_open_sharp,
                  errorMsg: passwordErrorMsg,),

                const SizedBox(height: 30,),

                PrimaryButton(
                  onPressed: submitLogin,
                  childText: "Login",
                ),

                const SizedBox(height: 20,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Not a member?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      ),
                      child: Text(
                        " Register Now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                  ),
                  child: Text(
                    "Login as a guest",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}