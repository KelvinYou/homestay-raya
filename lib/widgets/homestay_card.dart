import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:homestay_raya/screens/homestay_detail_screen.dart';

import 'package:homestay_raya/utils/app_theme.dart';
// import 'package:homestay_raya/screens/car_detail_screen.dart';
import 'package:homestay_raya/widgets/image_full_screen.dart';
import 'package:intl/intl.dart';

class HomestayCard extends StatefulWidget {
  final snap;

  const HomestayCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<HomestayCard> createState() => _HomestayCardState();
}

class _HomestayCardState extends State<HomestayCard> {
  @override
  void initState() {
    super.initState();
  }

  final DateFormat formatter = DateFormat('dd MMM y');

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomestayDetailScreen(
              snap: widget.snap,
            ),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,

              height: 190,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                color: Color(0xFFF1F8FF),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Image(
                  height: 190,
                  fit: BoxFit.fitHeight,
                  image: NetworkImage(widget.snap["photoUrl"]),
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
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xFFF1F8FF),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.snap["title"],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "RM ${widget.snap["pricePerDay"].toStringAsFixed(2)} / Day",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
