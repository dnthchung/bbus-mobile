import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    _fullNameController.dispose();
    _relationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16, 12, 18, 12),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: _fullNameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Your full name',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: TColors.textSecondary,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: TColors.primary,
                        prefixIcon: Icon(Icons.person),
                      ),
                      cursorColor: TColors.textPrimary,
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: _relationController,
                      decoration: InputDecoration(
                        labelText: 'Relation with student',
                        hintText: 'Your relationship',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: TColors.textSecondary,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: TColors.primary,
                        prefixIcon: Icon(Icons.groups),
                      ),
                      cursorColor: TColors.textPrimary,
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Your phone number',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: TColors.textSecondary,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: TColors.primary,
                        prefixIcon: Icon(Icons.call),
                      ),
                      cursorColor: TColors.textPrimary,
                    ),
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Your email address',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: TColors.textSecondary,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: TColors.primary,
                        prefixIcon:
                            Icon(Icons.mail, color: TColors.lightPrimary),
                      ),
                      cursorColor: TColors.textPrimary,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print('Full Name: ${_fullNameController.text}');
                      print('Relation: ${_relationController.text}');
                      print('Phone: ${_phoneController.text}');
                      print('Email: ${_emailController.text}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      fixedSize:
                          Size(MediaQuery.of(context).size.width * 0.7, 40),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        color: Colors.white,
                        letterSpacing: 0.0,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
