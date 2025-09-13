import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Navigate to edit profile
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.primaryColor,
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'John Doe',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'john.doe@example.com',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.accentColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '+1 234 567 8900',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Profile Options
            _buildProfileSection(
              context,
              'Personal Information',
              [
                _buildProfileItem(
                  context,
                  'Edit Profile',
                  Icons.person_outline,
                  () {
                    // TODO: Navigate to edit profile
                  },
                ),
                _buildProfileItem(
                  context,
                  'Change Password',
                  Icons.lock_outline,
                  () {
                    // TODO: Navigate to change password
                  },
                ),
                _buildProfileItem(
                  context,
                  'Phone Number',
                  Icons.phone_outlined,
                  () {
                    // TODO: Navigate to phone settings
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildProfileSection(
              context,
              'Children',
              [
                _buildProfileItem(
                  context,
                  'Manage Children',
                  Icons.child_care_outlined,
                  () {
                    // TODO: Navigate to children management
                  },
                ),
                _buildProfileItem(
                  context,
                  'Add Child',
                  Icons.person_add_outlined,
                  () {
                    // TODO: Navigate to add child
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildProfileSection(
              context,
              'Notifications',
              [
                _buildProfileItem(
                  context,
                  'Notification Settings',
                  Icons.notifications_outlined,
                  () {
                    // TODO: Navigate to notification settings
                  },
                ),
                _buildProfileItem(
                  context,
                  'Emergency Contacts',
                  Icons.emergency_outlined,
                  () {
                    // TODO: Navigate to emergency contacts
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildProfileSection(
              context,
              'Account',
              [
                _buildProfileItem(
                  context,
                  'Privacy Settings',
                  Icons.privacy_tip_outlined,
                  () {
                    // TODO: Navigate to privacy settings
                  },
                ),
                _buildProfileItem(
                  context,
                  'Help & Support',
                  Icons.help_outline,
                  () {
                    // TODO: Navigate to help
                  },
                ),
                _buildProfileItem(
                  context,
                  'About',
                  Icons.info_outline,
                  () {
                    // TODO: Navigate to about
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                icon: const Icon(Icons.logout),
                label: Text(l10n.logout),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context, String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement logout logic
              context.go('/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

