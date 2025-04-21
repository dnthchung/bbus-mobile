import 'package:bbus_mobile/common/cubit/current_user/current_user_cubit.dart';
import 'package:bbus_mobile/common/entities/child.dart';
import 'package:bbus_mobile/common/entities/user.dart';
import 'package:bbus_mobile/common/widgets/result_dialog.dart';
import 'package:bbus_mobile/config/injector/injector.dart';
import 'package:bbus_mobile/config/theme/colors.dart';
import 'package:bbus_mobile/core/utils/image_utils.dart';
import 'package:bbus_mobile/features/parent/data/datasources/children_datasource.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditChildPage extends StatefulWidget {
  final ChildEntity child;
  const EditChildPage({super.key, required this.child});

  @override
  State<EditChildPage> createState() => _EditChildPageState();
}

class _EditChildPageState extends State<EditChildPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;
  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      // Handle form submission
      final result = await ResultDialog.show(
        context,
        title: 'Xác nhận',
        message: 'Bạn có chắc chắn muốn cập nhật thông tin không?',
        cancelText: 'Hủy',
        confirmText: 'Xác nhận',
      );
      if (result == true) {
        setState(() {
          _isLoading = true;
        });
        try {
          final res =
              await sl<ChildrenDatasource>().updateChild(widget.child.copyWith(
            name: _fullNameController.text,
            address: _addressController.text,
            dob: _selectedDate.toString().split(' ')[0],
            gender: _selectedGender,
          ));
          if (res['status'] == 202) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cập nhật thành công')),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cập nhật thất bại')),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      // Form is not valid, show error messages
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng kiểm tra lại thông tin')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fullNameController.text = widget.child.name ?? '';
    _addressController.text = widget.child.address ?? '';
    if (widget.child.dob != null) {
      _selectedDate = DateTime.tryParse(widget.child.dob!);
      if (_selectedDate != null) {
        _dobController.text =
            "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
      }
      // Gender
      _selectedGender = widget.child.gender;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
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
      appBar: AppBar(
        title: const Text('Chinh sửa thông tin'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.unfocus(); // Dismiss keyboard
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
                              child: (widget.child?.avatar != null
                                  ? Image.network(
                                      widget.child!.avatar!,
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
                        _addressController,
                        'Địa chỉ',
                        Icons.home,
                        capitalization: TextCapitalization.words,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập địa chỉ';
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
                                  child: Text(gender == 'MALE' ? 'Nam' : 'Nữ'),
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
                        onPressed: _onSubmit,
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
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
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
