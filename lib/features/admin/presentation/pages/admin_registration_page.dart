import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../services/firestore_service.dart';
import '../../../../providers/auth_provider.dart';

class AdminRegistrationPage extends ConsumerStatefulWidget {
  const AdminRegistrationPage({super.key});

  @override
  ConsumerState<AdminRegistrationPage> createState() => _AdminRegistrationPageState();
}

class _AdminRegistrationPageState extends ConsumerState<AdminRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _organizationController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _jobTitleController.dispose();
    _organizationController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل بيانات الإدارة'),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildNameField(),
              const SizedBox(height: 16),
              _buildJobTitleField(),
              const SizedBox(height: 16),
              _buildOrganizationField(),
              const SizedBox(height: 16),
              _buildPhoneField(),
              const SizedBox(height: 24),
              _buildActionButtons(),
              const SizedBox(height: 24),
              _buildPermissionsInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        children: [
          Icon(
            FontAwesomeIcons.userShield,
            size: 48,
            color: Colors.red[700],
          ),
          const SizedBox(height: 8),
          Text(
            'تسجيل بيانات الإدارة',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.red[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'يرجى ملء جميع البيانات المطلوبة بدقة',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'اسم المسؤول *',
        prefixIcon: const Icon(FontAwesomeIcons.user),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'يرجى إدخال اسم المسؤول';
        }
        return null;
      },
    );
  }

  Widget _buildJobTitleField() {
    return TextFormField(
      controller: _jobTitleController,
      decoration: InputDecoration(
        labelText: 'الوظيفة *',
        prefixIcon: const Icon(FontAwesomeIcons.briefcase),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'يرجى إدخال الوظيفة';
        }
        return null;
      },
    );
  }

  Widget _buildOrganizationField() {
    return TextFormField(
      controller: _organizationController,
      decoration: InputDecoration(
        labelText: 'اسم المؤسسة *',
        prefixIcon: const Icon(FontAwesomeIcons.building),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'يرجى إدخال اسم المؤسسة';
        }
        return null;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'رقم الهاتف *',
        prefixIcon: const Icon(FontAwesomeIcons.phone),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'يرجى إدخال رقم الهاتف';
        }
        if (value.length < 10) {
          return 'رقم الهاتف غير صحيح';
        }
        return null;
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _saveData,
            icon: const Icon(FontAwesomeIcons.floppyDisk),
            label: const Text('حفظ'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isLoading ? null : _submitData,
            icon: const Icon(FontAwesomeIcons.paperPlane),
            label: const Text('إرسال'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionsInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                FontAwesomeIcons.shield,
                size: 24,
                color: Colors.orange[700],
              ),
              const SizedBox(width: 8),
              Text(
                'الصلاحيات المتاحة للإدارة:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.orange[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildPermissionItem('تعديل بيانات أي طالب'),
          _buildPermissionItem('نقل طالب من مكان لآخر'),
          _buildPermissionItem('تعديل اللوكيشن'),
          _buildPermissionItem('عرض كل الحافلات والطلاب'),
          _buildPermissionItem('متابعة الغياب والتقارير'),
          _buildPermissionItem('جميع صلاحيات المشرفة'),
          _buildPermissionItem('إدارة النظام بالكامل'),
        ],
      ),
    );
  }

  Widget _buildPermissionItem(String permission) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.check,
            size: 16,
            color: Colors.green[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              permission,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = ref.read(authStateProvider).value;
      if (currentUser != null) {
        await FirestoreService().updateUser(
          currentUser.uid,
          {
            'jobTitle': _jobTitleController.text,
            'organization': _organizationController.text,
            'phone': _phoneController.text,
            'updatedAt': DateTime.now().toIso8601String(),
          },
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ البيانات بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في حفظ البيانات: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;

    await _saveData();
    
    // Show success message
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تم الإرسال بنجاح'),
        content: const Text(
          'تم تسجيل بيانات الإدارة بنجاح. سيتم مراجعة البيانات وتفعيل الحساب.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }
}
