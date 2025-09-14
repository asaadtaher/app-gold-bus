import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../services/storage_service.dart';
import '../../../../services/firestore_service.dart';
import '../../../../providers/auth_provider.dart';

class DriverRegistrationPage extends ConsumerStatefulWidget {
  const DriverRegistrationPage({super.key});

  @override
  ConsumerState<DriverRegistrationPage> createState() => _DriverRegistrationPageState();
}

class _DriverRegistrationPageState extends ConsumerState<DriverRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _customVehicleTypeController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedVehicleType;
  XFile? _driverLicenseImage;
  XFile? _vehicleLicenseImage;
  XFile? _personalImage;
  bool _isLoading = false;

  final List<String> _vehicleTypes = [
    'ملاكي',
    'ميكروباص',
    'هاي اس',
    'باص 28',
    'كوستر',
    'ملاكي 7 راكب',
    'H1',
    'باص 50 راكب',
    'آخر',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _vehicleModelController.dispose();
    _customVehicleTypeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل بيانات السائق'),
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
              _buildAddressField(),
              const SizedBox(height: 16),
              _buildVehicleTypeField(),
              if (_selectedVehicleType == 'آخر') ...[
                const SizedBox(height: 16),
                _buildCustomVehicleTypeField(),
              ],
              const SizedBox(height: 16),
              _buildVehicleModelField(),
              const SizedBox(height: 16),
              _buildDriverLicenseField(),
              const SizedBox(height: 16),
              _buildVehicleLicenseField(),
              const SizedBox(height: 16),
              _buildPersonalImageField(),
              const SizedBox(height: 16),
              _buildNotesField(),
              const SizedBox(height: 24),
              _buildActionButtons(),
              const SizedBox(height: 24),
              _buildContactInfo(),
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
        color: Colors.amber[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber[200]!),
      ),
      child: Column(
        children: [
          Icon(
            FontAwesomeIcons.car,
            size: 48,
            color: Colors.amber[700],
          ),
          const SizedBox(height: 8),
          Text(
            'تسجيل بيانات السائق',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.amber[700],
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
        labelText: 'الاسم الثلاثي *',
        prefixIcon: const Icon(FontAwesomeIcons.user),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'يرجى إدخال الاسم الثلاثي';
        }
        return null;
      },
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: InputDecoration(
        labelText: 'مكان السكن *',
        prefixIcon: const Icon(FontAwesomeIcons.locationDot),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'يرجى إدخال مكان السكن';
        }
        return null;
      },
    );
  }

  Widget _buildVehicleTypeField() {
    return DropdownButtonFormField<String>(
      value: _selectedVehicleType,
      decoration: InputDecoration(
        labelText: 'نوع السيارة *',
        prefixIcon: const Icon(FontAwesomeIcons.car),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: _vehicleTypes.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedVehicleType = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'يرجى اختيار نوع السيارة';
        }
        return null;
      },
    );
  }

  Widget _buildCustomVehicleTypeField() {
    return TextFormField(
      controller: _customVehicleTypeController,
      decoration: InputDecoration(
        labelText: 'نوع السيارة (مخصص) *',
        prefixIcon: const Icon(FontAwesomeIcons.car),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (_selectedVehicleType == 'آخر' && (value == null || value.trim().isEmpty)) {
          return 'يرجى إدخال نوع السيارة المخصص';
        }
        return null;
      },
    );
  }

  Widget _buildVehicleModelField() {
    return TextFormField(
      controller: _vehicleModelController,
      decoration: InputDecoration(
        labelText: 'موديل السيارة *',
        prefixIcon: const Icon(FontAwesomeIcons.car),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'يرجى إدخال موديل السيارة';
        }
        return null;
      },
    );
  }

  Widget _buildDriverLicenseField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'صورة رخصة السائق *',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _pickImage(ImageSource.camera, 'driverLicense'),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _driverLicenseImage == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.camera,
                        size: 32,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'اضغط لالتقاط صورة رخصة السائق',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _driverLicenseImage!.path,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.image,
                                size: 32,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'صورة رخصة السائق',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleLicenseField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'صورة رخصة السيارة *',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _pickImage(ImageSource.camera, 'vehicleLicense'),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _vehicleLicenseImage == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.camera,
                        size: 32,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'اضغط لالتقاط صورة رخصة السيارة',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _vehicleLicenseImage!.path,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.image,
                                size: 32,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'صورة رخصة السيارة',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalImageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'صورة شخصية (اختياري)',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _pickImage(ImageSource.camera, 'personal'),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: _personalImage == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.camera,
                        size: 32,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'اضغط لالتقاط صورة شخصية',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      _personalImage!.path,
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                FontAwesomeIcons.image,
                                size: 32,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'صورة شخصية',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return TextFormField(
      controller: _notesController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'ملحوظات (اختياري)',
        prefixIcon: const Icon(FontAwesomeIcons.noteSticky),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
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

  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        children: [
          Icon(
            FontAwesomeIcons.phone,
            size: 32,
            color: Colors.blue[700],
          ),
          const SizedBox(height: 8),
          Text(
            'للاهتمام بالعمل في شركة Gold Bus سيتم التواصل معكم في أقرب وقت لتحديد موعد المقابلة.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.blue[700],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildContactButton('01204746897'),
              _buildContactButton('01203935169'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton(String phoneNumber) {
    return ElevatedButton.icon(
      onPressed: () => _callNumber(phoneNumber),
      icon: const Icon(FontAwesomeIcons.phone),
      label: Text(phoneNumber),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source, String type) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      
      if (image != null) {
        setState(() {
          switch (type) {
            case 'driverLicense':
              _driverLicenseImage = image;
              break;
            case 'vehicleLicense':
              _vehicleLicenseImage = image;
              break;
            case 'personal':
              _personalImage = image;
              break;
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ في اختيار الصورة: $e')),
      );
    }
  }

  Future<void> _callNumber(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('لا يمكن الاتصال بالرقم: $phoneNumber')),
      );
    }
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      // Upload images to Firebase Storage
      String? driverLicenseUrl;
      String? vehicleLicenseUrl;
      String? personalImageUrl;

      if (_driverLicenseImage != null) {
        driverLicenseUrl = await StorageService().uploadFile(
          File(_driverLicenseImage!.path),
          'driver_licenses',
        );
      }

      if (_vehicleLicenseImage != null) {
        vehicleLicenseUrl = await StorageService().uploadFile(
          File(_vehicleLicenseImage!.path),
          'vehicle_licenses',
        );
      }

      if (_personalImage != null) {
        personalImageUrl = await StorageService().uploadFile(
          File(_personalImage!.path),
          'profile_images',
        );
      }

      // Update user data in Firestore
      final currentUser = ref.read(authStateProvider).value;
      if (currentUser != null) {
        await FirestoreService().updateUser(
          currentUser.uid,
          {
            'vehicleType': _selectedVehicleType,
            'customVehicleType': _selectedVehicleType == 'آخر' 
                ? _customVehicleTypeController.text 
                : null,
            'vehicleModel': _vehicleModelController.text,
            'driverLicenseImageUrl': driverLicenseUrl,
            'vehicleLicenseImageUrl': vehicleLicenseUrl,
            'profileImageUrl': personalImageUrl,
            'address': _addressController.text,
            'notes': _notesController.text,
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
    
    if (_driverLicenseImage == null || _vehicleLicenseImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى رفع صور الرخص المطلوبة')),
      );
      return;
    }

    await _saveData();
    
    // Show success message
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تم الإرسال بنجاح'),
        content: const Text(
          'للاهتمام بالعمل في شركة Gold Bus سيتم التواصل معكم في أقرب وقت لتحديد موعد المقابلة.',
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
