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
import 'package:image_picker/image_picker.dart';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class AddHomestayScreen extends StatefulWidget {
  const AddHomestayScreen({super.key});

  @override
  State<AddHomestayScreen> createState() => _AddHomestayScreenState();
}

class _AddHomestayScreenState extends State<AddHomestayScreen> {
  bool isLoading = false;

  Uint8List? image;

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final pricePerDayController = TextEditingController();

  String titleErrorMsg = "";
  String descriptionErrorMsg = "";
  String pricePerDayErrorMsg = "";

  String? _currentAddress;
  Position? _currentPosition;

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      image = im;
    });
  }

  addHomestaySubmit() async {
    setState(() {
      isLoading = true;
      titleErrorMsg = "";
      descriptionErrorMsg = "";
      pricePerDayErrorMsg = "";
    });

    try {
      String res = await FireStoreMethods().addHomestay(
        FirebaseAuth.instance.currentUser!.uid,
        titleController.text,
        descriptionController.text,
        image,
        double.parse(pricePerDayController.text),
        3.140853,
        101.693207,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Added!',
        );
        Navigator.of(context).pop();
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
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
    return Scaffold(
      appBar: PrimaryAppBar(
          title: "Add Homestay"
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
                const SizedBox( height: 20, ),
                TextFieldInput(
                  textEditingController: titleController,
                  hintText: "Title",
                  textInputType: TextInputType.text,
                ),
                const SizedBox( height: 20, ),

                TextFieldInput(
                  textEditingController: descriptionController,
                  hintText: "Description",
                  textInputType: TextInputType.multiline,
                  maxLines: null,
                ),
                const SizedBox( height: 20, ),

                TextFieldInput(
                  textEditingController: pricePerDayController,
                  hintText: "Price Per Day (RM)",
                  textInputType: TextInputType.text,
                ),
                const SizedBox( height: 20, ),

                Text(
                  "Photo",
                  style: TextStyle(fontSize: 18),
                ),
                PrimaryButton(
                  onPressed: selectImage,
                  childText: image != null ? "Change An Image" : "Select An Image",
                  inverseColor: true,
                ),
                image != null ? Image.memory(
                  image!,
                  height: 200,
                  fit: BoxFit.fitHeight,
                ) : SizedBox(),
                const SizedBox(
                  height: 30,
                ),
                PrimaryButton(
                    onPressed: addHomestaySubmit, childText: "Confirm"
                ),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}