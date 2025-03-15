import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:flutter/material.dart';

class SchoolContactPage extends StatelessWidget {
  const SchoolContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            spacing: 20,
            children: [
              Expanded(
                flex: 1,
                child: Image(
                  image: AssetImage("assets/logos/logo.png"),
                  height: 140,
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 12,
                  children: [
                    Text(
                      "Need Help?",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Lô T1, khu Đô thị Trung Hòa, Nhân Chính, quận Thanh Xuân, Hà Nội",
                      style:
                          TextStyle(fontSize: 16, color: TColors.textSecondary),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 60,
          ),
          Text(
            "Connect Us",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            spacing: 20,
            children: [
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.call,
                  color: TColors.primary,
                ),
              ),
              Expanded(
                flex: 8,
                child: Text(
                  "+84 987 654 3210",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            spacing: 20,
            children: [
              Expanded(
                flex: 1,
                child: Icon(
                  Icons.mail,
                  color: TColors.primary,
                ),
              ),
              Expanded(
                flex: 8,
                child: Text(
                  "helpschool@gmail.com",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
