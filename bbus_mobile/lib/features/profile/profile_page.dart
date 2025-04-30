import 'package:bbus_mobile/common/cubit/current_user/current_user_cubit.dart';
import 'package:bbus_mobile/common/entities/user.dart';
import 'package:bbus_mobile/common/widgets/result_dialog.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/core/utils/image_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;
  UserEntity? _user;
  bool _isLoading = false;

  Uint8List? _image;
  void _selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
      });

      final currentUser = context.read<CurrentUserCubit>();
      if (currentUser.state is CurrentUserLoggedIn) {
        final user = (currentUser.state as CurrentUserLoggedIn).user;
        context
            .read<CurrentUserCubit>()
            .updateAvatar(img); // <- implement this method
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Update avatar successfully!')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final currentUser = context.read<CurrentUserCubit>();
    if (currentUser.state is CurrentUserLoggedIn) {
      final user = (currentUser.state as CurrentUserLoggedIn).user;
      _user = user;
      _fullNameController.text = user.name ?? '';
      _phoneController.text = user.phone ?? '';
      _emailController.text = user.email ?? '';
      if (user.dob != null) {
        _selectedDate = DateTime.tryParse(user.dob!);
        if (_selectedDate != null) {
          _dobController.text =
              "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
        }
      }
      // Gender
      _selectedGender = user.gender;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.unfocus(); // Dismiss keyboard
          }
        },
        child: BlocListener<CurrentUserCubit, CurrentUserState>(
          listener: (context, state) async {
            if (state is CurrentUserUpdated) {
              await ResultDialog.show(context,
                  title: 'Cập nhật thành công', message: '');
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(16, 12, 18, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 36,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 64,
                              child: ClipOval(
                                child: _image != null
                                    ? Image.memory(
                                        _image!,
                                        width: 128,
                                        height: 128,
                                        fit: BoxFit.cover,
                                      )
                                    : (_user?.avatar != null
                                        ? Image.network(
                                            _user!.avatar!,
                                            width: 128,
                                            height: 128,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                'assets/images/default_avatar.png',
                                                width: 128,
                                                height: 128,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          )
                                        : Image.asset(
                                            'assets/images/default_avatar.png',
                                            width: 128,
                                            height: 128,
                                            fit: BoxFit.cover,
                                          )),
                              ),
                            ),
                            Positioned(
                              top: -10,
                              left: 80,
                              child: IconButton(
                                onPressed: _selectImage,
                                icon: Icon(Icons.add_a_photo),
                              ),
                            )
                          ],
                        ),
                        _buildTextField(
                          _fullNameController,
                          'Tên',
                          Icons.person,
                          capitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Vui lòng nhập tên';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          _phoneController,
                          'Số điện thoại',
                          Icons.call,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Vui lòng nhập số điện thoại';
                            }
                            if (!RegExp(r'^\d{10,11}$').hasMatch(value)) {
                              return 'Số điện thoại không hợp lệ';
                            }
                            return null;
                          },
                        ),
                        _buildTextField(
                          _emailController,
                          'Email',
                          Icons.mail,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Vui lòng nhập email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Email không hợp lệ';
                            }
                            return null;
                          },
                        ),
                        Row(
                          spacing: 4.0,
                          children: [
                            // Date of Birth Field
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _pickDate(context),
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: _dobController,
                                    decoration: _inputDecoration(
                                        "Date of Birth", Icons.cake),
                                  ),
                                ),
                              ),
                            ),
                            // Gender Dropdown
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _selectedGender,
                                decoration:
                                    _inputDecoration("Giới tính", Icons.person),
                                items: ['MALE', 'FEMALE'].map((String gender) {
                                  return DropdownMenuItem<String>(
                                    value: gender,
                                    child:
                                        Text(gender == 'MALE' ? 'Nam' : 'Nữ'),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedGender = newValue;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) return;
                            final currentUser =
                                context.read<CurrentUserCubit>();
                            if (currentUser.state is CurrentUserLoggedIn) {
                              setState(() {
                                _isLoading = true;
                              });
                              final user =
                                  (currentUser.state as CurrentUserLoggedIn)
                                      .user;
                              context.read<CurrentUserCubit>().updateProfile(
                                  user.copyWith(
                                      name: _fullNameController.text,
                                      phone: _phoneController.text,
                                      email: _emailController.text,
                                      dob: _selectedDate
                                          ?.toString()
                                          .split(' ')[0],
                                      gender: _selectedGender));
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.darkPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            fixedSize: Size(
                                MediaQuery.of(context).size.width * 0.7, 50),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Lưu',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
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
    TextEditingController controller,
    String label,
    IconData icon, {
    TextCapitalization capitalization = TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      textCapitalization: capitalization,
      decoration: _inputDecoration(label, icon),
      cursorColor: TColors.textPrimary,
      validator: validator,
    );
  }
}
