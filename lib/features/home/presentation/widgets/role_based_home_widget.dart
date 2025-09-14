import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../models/user_model.dart';
import '../../../map/presentation/pages/live_tracking_page.dart';
import '../../../students/presentation/pages/student_management_page.dart';
import '../../../chat/presentation/pages/chat_page.dart';
import '../../../absences/presentation/widgets/absence_report_dialog.dart';
import '../../../admin/presentation/pages/user_management_page.dart';
import '../../../admin/presentation/pages/reports_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';

class RoleBasedHomeWidget extends StatelessWidget {
  final UserModel user;

  const RoleBasedHomeWidget({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    switch (user.role) {
      case UserRole.parent:
        return _buildParentHome(context);
      case UserRole.driver:
        return _buildDriverHome(context);
      case UserRole.supervisor:
        return _buildSupervisorHome(context);
      case UserRole.admin:
        return _buildAdminHome(context);
    }
  }

  Widget _buildParentHome(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.amber,
                        child: Icon(
                          FontAwesomeIcons.user,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'مرحباً ${user.name}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text('ولي أمر'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Quick Actions
          const Text(
            'الخدمات المتاحة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildActionCard(
                context,
                'متابعة الحافلة',
                FontAwesomeIcons.map,
                Colors.blue,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LiveTrackingPage(),
                  ),
                ),
              ),
              _buildActionCard(
                context,
                'إبلاغ غياب',
                FontAwesomeIcons.exclamationTriangle,
                Colors.red,
                () => _showAbsenceReportDialog(context),
              ),
              _buildActionCard(
                context,
                'التنبيهات',
                FontAwesomeIcons.bell,
                Colors.orange,
                () => _showNotifications(context),
              ),
              _buildActionCard(
                context,
                'الشات',
                FontAwesomeIcons.comments,
                Colors.green,
                () => _showChat(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDriverHome(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.amber,
                        child: Icon(
                          FontAwesomeIcons.car,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'مرحباً ${user.name}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text('سائق'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Quick Actions
          const Text(
            'الخدمات المتاحة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildActionCard(
                context,
                'متابعة الحافلة',
                FontAwesomeIcons.map,
                Colors.blue,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LiveTrackingPage(),
                  ),
                ),
              ),
              _buildActionCard(
                context,
                'قائمة الطلاب',
                FontAwesomeIcons.users,
                Colors.green,
                () => _showStudentList(context),
              ),
              _buildActionCard(
                context,
                'التنبيهات',
                FontAwesomeIcons.bell,
                Colors.orange,
                () => _showNotifications(context),
              ),
              _buildActionCard(
                context,
                'تحديث الموقع',
                FontAwesomeIcons.locationDot,
                Colors.purple,
                () => _updateLocation(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSupervisorHome(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.amber,
                        child: Icon(
                          FontAwesomeIcons.userTie,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'مرحباً ${user.name}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text('مشرفة'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Quick Actions
          const Text(
            'الخدمات المتاحة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildActionCard(
                context,
                'متابعة الحافلة',
                FontAwesomeIcons.map,
                Colors.blue,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LiveTrackingPage(),
                  ),
                ),
              ),
              _buildActionCard(
                context,
                'إدارة الطلاب',
                FontAwesomeIcons.users,
                Colors.green,
                () => _manageStudents(context),
              ),
              _buildActionCard(
                context,
                'بلاغات الغياب',
                FontAwesomeIcons.exclamationTriangle,
                Colors.red,
                () => _showAbsenceReports(context),
              ),
              _buildActionCard(
                context,
                'الشات',
                FontAwesomeIcons.comments,
                Colors.purple,
                () => _showChat(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdminHome(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.amber,
                        child: Icon(
                          FontAwesomeIcons.userShield,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'مرحباً ${user.name}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text('إدارة'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Quick Actions
          const Text(
            'الخدمات المتاحة',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildActionCard(
                context,
                'متابعة الحافلات',
                FontAwesomeIcons.map,
                Colors.blue,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LiveTrackingPage(),
                  ),
                ),
              ),
              _buildActionCard(
                context,
                'إدارة المستخدمين',
                FontAwesomeIcons.users,
                Colors.green,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserManagementPage(),
                  ),
                ),
              ),
              _buildActionCard(
                context,
                'التقارير',
                FontAwesomeIcons.chartBar,
                Colors.orange,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportsPage(),
                  ),
                ),
              ),
              _buildActionCard(
                context,
                'الإعدادات',
                FontAwesomeIcons.gear,
                Colors.grey,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
                style: const TextStyle(
                  fontSize: 14,
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

  void _showAbsenceReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AbsenceReportDialog(),
    );
  }

  void _showNotifications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('التنبيهات ستكون متاحة قريباً')),
    );
  }

  void _showChat(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChatPage(),
      ),
    );
  }

  void _showStudentList(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('قائمة الطلاب ستكون متاحة قريباً')),
    );
  }

  void _updateLocation(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تحديث الموقع سيكون متاحاً قريباً')),
    );
  }

  void _manageStudents(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StudentManagementPage(),
      ),
    );
  }

  void _showAbsenceReports(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('بلاغات الغياب ستكون متاحة قريباً')),
    );
  }

  void _manageUsers(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('إدارة المستخدمين ستكون متاحة قريباً')),
    );
  }

  void _showReports(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('التقارير ستكون متاحة قريباً')),
    );
  }

  void _showSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('الإعدادات ستكون متاحة قريباً')),
    );
  }
}
