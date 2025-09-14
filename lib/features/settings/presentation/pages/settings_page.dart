import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../models/user_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../../services/auth_service.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
      ),
      body: userData.when(
        data: (user) {
          if (user == null) return const Center(child: Text('خطأ في تحميل البيانات'));
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserProfileSection(user),
                const SizedBox(height: 24),
                _buildAppSettingsSection(),
                const SizedBox(height: 24),
                _buildSupportSection(),
                const SizedBox(height: 24),
                _buildAboutSection(),
                const SizedBox(height: 24),
                _buildLogoutSection(),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('خطأ: $error')),
      ),
    );
  }

  Widget _buildUserProfileSection(UserModel user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: _getRoleColor(user.role),
              child: Icon(
                _getRoleIcon(user.role),
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _getRoleDisplayName(user.role),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: user.approved ? Colors.green[100] : Colors.orange[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                user.approved ? 'موافق عليه' : 'في الانتظار',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: user.approved ? Colors.green[600] : Colors.orange[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppSettingsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إعدادات التطبيق',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('التنبيهات'),
              subtitle: const Text('استقبال التنبيهات والإشعارات'),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
              secondary: const Icon(FontAwesomeIcons.bell),
            ),
            SwitchListTile(
              title: const Text('الموقع'),
              subtitle: const Text('تتبع الموقع لمتابعة الحافلة'),
              value: _locationEnabled,
              onChanged: (value) {
                setState(() {
                  _locationEnabled = value;
                });
              },
              secondary: const Icon(FontAwesomeIcons.locationDot),
            ),
            SwitchListTile(
              title: const Text('الوضع المظلم'),
              subtitle: const Text('استخدام الوضع المظلم'),
              value: _darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = value;
                });
              },
              secondary: const Icon(FontAwesomeIcons.moon),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الدعم والمساعدة',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(FontAwesomeIcons.phone),
              title: const Text('اتصل بنا'),
              subtitle: const Text('01204746897 - 01203935169'),
              onTap: () => _callSupport(),
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.envelope),
              title: const Text('راسلنا'),
              subtitle: const Text('support@goldbus.com'),
              onTap: () => _sendEmail(),
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.questionCircle),
              title: const Text('الأسئلة الشائعة'),
              onTap: () => _showFAQ(),
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.bug),
              title: const Text('الإبلاغ عن مشكلة'),
              onTap: () => _reportBug(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'حول التطبيق',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(FontAwesomeIcons.infoCircle),
              title: const Text('إصدار التطبيق'),
              subtitle: const Text('1.0.0'),
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.fileContract),
              title: const Text('شروط الاستخدام'),
              onTap: () => _showTermsOfService(),
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.shield),
              title: const Text('سياسة الخصوصية'),
              onTap: () => _showPrivacyPolicy(),
            ),
            ListTile(
              leading: const Icon(FontAwesomeIcons.copyright),
              title: const Text('حقوق الطبع والنشر'),
              subtitle: const Text('© 2024 Gold Bus. جميع الحقوق محفوظة.'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutDialog(),
                icon: const Icon(FontAwesomeIcons.rightFromBracket),
                label: const Text('تسجيل الخروج'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _callSupport() async {
    const phoneNumber = '01204746897';
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يمكن الاتصال بالرقم')),
      );
    }
  }

  Future<void> _sendEmail() async {
    const email = 'support@goldbus.com';
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=دعم فني - Gold Bus',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يمكن فتح تطبيق البريد الإلكتروني')),
      );
    }
  }

  void _showFAQ() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الأسئلة الشائعة'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'كيف يمكنني متابعة حافلة طفلي؟',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('يمكنك متابعة الحافلة من خلال شاشة الخريطة الحية.'),
              SizedBox(height: 16),
              Text(
                'كيف يمكنني إبلاغ غياب طفلي؟',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('اضغط على زر "إبلاغ الغياب" في الصفحة الرئيسية.'),
              SizedBox(height: 16),
              Text(
                'متى سيتم تفعيل حسابي؟',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('سيتم التواصل معك خلال 24-48 ساعة لتفعيل حسابك.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _reportBug() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('الإبلاغ عن مشكلة'),
        content: const Text('يرجى التواصل معنا عبر الهاتف أو البريد الإلكتروني للإبلاغ عن أي مشكلة تواجهها.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showTermsOfService() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('شروط الاستخدام'),
        content: const SingleChildScrollView(
          child: Text(
            'هذه شروط استخدام تطبيق Gold Bus:\n\n'
            '1. يجب استخدام التطبيق لأغراض متابعة النقل المدرسي فقط\n'
            '2. يحظر استخدام التطبيق لأي أغراض غير قانونية\n'
            '3. يجب الحفاظ على سرية بيانات الحساب\n'
            '4. يحظر مشاركة بيانات المستخدمين الآخرين\n'
            '5. يمكن تعديل هذه الشروط في أي وقت\n\n'
            'باستخدام التطبيق، فإنك توافق على هذه الشروط.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('سياسة الخصوصية'),
        content: const SingleChildScrollView(
          child: Text(
            'سياسة الخصوصية لتطبيق Gold Bus:\n\n'
            '1. نحن نحترم خصوصيتك ونحمي بياناتك الشخصية\n'
            '2. نستخدم البيانات فقط لتقديم خدمات النقل المدرسي\n'
            '3. لا نشارك بياناتك مع أطراف ثالثة بدون موافقتك\n'
            '4. نحتفظ ببياناتك طالما كان حسابك نشطاً\n'
            '5. يمكنك طلب حذف بياناتك في أي وقت\n\n'
            'للمزيد من التفاصيل، يرجى التواصل معنا.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('موافق'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    try {
      await AuthService().signOut();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تسجيل الخروج بنجاح')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في تسجيل الخروج: $e')),
        );
      }
    }
  }

  Color _getRoleColor(UserRole role) {
    switch (role) {
      case UserRole.parent:
        return Colors.blue;
      case UserRole.driver:
        return Colors.green;
      case UserRole.supervisor:
        return Colors.purple;
      case UserRole.admin:
        return Colors.red;
    }
  }

  IconData _getRoleIcon(UserRole role) {
    switch (role) {
      case UserRole.parent:
        return FontAwesomeIcons.user;
      case UserRole.driver:
        return FontAwesomeIcons.car;
      case UserRole.supervisor:
        return FontAwesomeIcons.userTie;
      case UserRole.admin:
        return FontAwesomeIcons.userShield;
    }
  }

  String _getRoleDisplayName(UserRole role) {
    switch (role) {
      case UserRole.parent:
        return 'ولي أمر';
      case UserRole.driver:
        return 'سائق';
      case UserRole.supervisor:
        return 'مشرفة';
      case UserRole.admin:
        return 'إدارة';
    }
  }
}