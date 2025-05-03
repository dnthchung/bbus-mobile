import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/features/contact/boarding_screen.dart';
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
                      "Cần giúp đỡ?",
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
            "Liên hệ với chúng tôi",
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
          const SizedBox(height: 40),
          const Text(
            "Câu hỏi thường gặp",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildQASection(),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BoardingScreen()),
                );
              },
              icon: const Icon(Icons.info_outline),
              label: const Text("Hướng dẫn sử dụng ứng dụng"),
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildQASection() {
  return Column(
    children: const [
      ExpansionTile(
        title: Text("Làm thế nào để đăng ký tài khoản?"),
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
                "Bạn có thể đăng ký bằng số điện thoại hoặc email từ màn hình chính."),
          )
        ],
      ),
      ExpansionTile(
        title: Text("Tôi quên mật khẩu, phải làm sao?"),
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
                "Sử dụng chức năng 'Quên mật khẩu' để đặt lại mật khẩu qua email."),
          )
        ],
      ),
      ExpansionTile(
        title: Text(
            "Ứng dụng có hỗ trợ theo dõi xe buýt theo thời gian thực không?"),
        children: [
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
                "Có, bạn có thể theo dõi vị trí xe buýt từ mục 'Theo dõi'."),
          )
        ],
      ),
    ],
  );
}
