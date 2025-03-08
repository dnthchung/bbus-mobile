import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/core/utils/image_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  Uint8List? _image;
  @override
  void dispose() {
    _fullNameController.dispose();
    _relationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _selectImage() async {
    Uint8List img = pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16, 12, 18, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 36,
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 64,
                            backgroundImage:
                                AssetImage('assets/images/default_avatar.png'),
                          ),
                          Positioned(
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.add_a_photo),
                            ),
                            top: -10,
                            left: 80,
                          )
                        ],
                      ),
                      _buildTextField(
                          _fullNameController, 'Full Name', Icons.person,
                          capitalization: TextCapitalization.words),
                      _buildTextField(_relationController,
                          'Relation with student', Icons.groups),
                      _buildTextField(
                          _phoneController, 'Phone Number', Icons.call),
                      _buildTextField(_emailController, 'Email', Icons.mail),
                      SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          print('Full Name: ${_fullNameController.text}');
                          print('Relation: ${_relationController.text}');
                          print('Phone: ${_phoneController.text}');
                          print('Email: ${_emailController.text}');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.darkPrimary,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          fixedSize:
                              Size(MediaQuery.of(context).size.width * 0.7, 50),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white, fontSize: 24),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: TColors.borderColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: TColors.darkPrimary, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: TColors.fillColor,
      prefixIcon: Icon(icon, color: TColors.primary),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {TextCapitalization capitalization = TextCapitalization.none}) {
    return TextFormField(
      controller: controller,
      textCapitalization: capitalization,
      decoration: _inputDecoration(label, icon),
      cursorColor: TColors.textPrimary,
    );
  }
}
