import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/user_model.dart';
import '../../../../providers/auth_provider.dart';
import '../../../map/presentation/pages/live_tracking_page.dart';
import '../widgets/role_based_home_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final userRole = ref.watch(userRoleProvider);
    final userData = ref.watch(userDataProvider);
    final isUserApproved = ref.watch(isUserApprovedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gold Bus'),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _showLogoutDialog(context, ref),
          ),
        ],
      ),
      body: userData.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text('خطأ في تحميل بيانات المستخدم'),
            );
          }

          // Show approval pending message if user is not approved
          if (!isUserApproved) {
            return _buildApprovalPendingScreen(user);
          }

          // Show role-based home screen
          return RoleBasedHomeWidget(user: user);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'خطأ في تحميل البيانات: $error',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(userDataProvider);
                },
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApprovalPendingScreen(UserModel user) {
    String message = '';
    String contactInfo = '';

    switch (user.role) {
      case UserRole.driver:
        message = 'للاهتمام بالعمل في شركة Gold Bus سيتم التواصل معكم في أقرب وقت لتحديد موعد المقابلة.';
        contactInfo = 'رقم التواصل: 01204746897 - 01203935169';
        break;
      case UserRole.supervisor:
        message = 'سيتم التواصل معكم لتفعيل الخدمة.';
        contactInfo = 'رقم التواصل: 01204746897 - 01203935169';
        break;
      case UserRole.admin:
        message = 'سيتم مراجعة طلبكم وتفعيل الحساب قريباً.';
        contactInfo = 'رقم التواصل: 01204746897 - 01203935169';
        break;
      case UserRole.parent:
        message = 'تم إنشاء حساب ولي أمر بنجاح. يمكنكم الآن متابعة حافلة طفلكم.';
        break;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getRoleIcon(user.role),
                size: 60,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'مرحباً ${user.name}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getRoleDisplayName(user.role),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 48,
                    color: Colors.blue[600],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (contactInfo.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      contactInfo,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to live tracking page (available for all users)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LiveTrackingPage(),
                  ),
                );
              },
              icon: const Icon(FontAwesomeIcons.map),
              label: const Text('متابعة الحافلات'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
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
              try {
                await ref.read(authControllerProvider).signOut();
                if (context.mounted) {
                  context.go('/login');
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('خطأ في تسجيل الخروج: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('تسجيل الخروج'),
          ),
        ],
      ),
    );
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

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

