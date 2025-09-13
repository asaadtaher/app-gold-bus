import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/app_theme.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _darkMode = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // General Settings
            _buildSettingsSection(
              context,
              'General',
              [
                _buildLanguageSetting(),
                _buildThemeSetting(),
                _buildNotificationSetting(),
              ],
            ),
            const SizedBox(height: 16),

            // Privacy & Security
            _buildSettingsSection(
              context,
              'Privacy & Security',
              [
                _buildLocationSetting(),
                _buildPrivacySetting(),
                _buildSecuritySetting(),
              ],
            ),
            const SizedBox(height: 16),

            // App Settings
            _buildSettingsSection(
              context,
              'App Settings',
              [
                _buildDataUsageSetting(),
                _buildCacheSetting(),
                _buildUpdateSetting(),
              ],
            ),
            const SizedBox(height: 16),

            // About
            _buildSettingsSection(
              context,
              'About',
              [
                _buildAboutItem('Version', '1.0.0'),
                _buildAboutItem('Build', '2024.01.01'),
                _buildAboutItem('Developer', 'Gold Bus Team'),
              ],
            ),
            const SizedBox(height: 24),

            // Reset Settings
            Card(
              child: ListTile(
                leading: const Icon(Icons.restore, color: Colors.orange),
                title: const Text('Reset Settings'),
                subtitle: const Text('Reset all settings to default'),
                onTap: () {
                  _showResetDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, String title, List<Widget> children) {
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

  Widget _buildLanguageSetting() {
    return ListTile(
      leading: const Icon(Icons.language, color: AppTheme.primaryColor),
      title: const Text('Language'),
      subtitle: Text(_selectedLanguage),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        _showLanguageDialog();
      },
    );
  }

  Widget _buildThemeSetting() {
    return SwitchListTile(
      secondary: const Icon(Icons.dark_mode, color: AppTheme.primaryColor),
      title: const Text('Dark Mode'),
      subtitle: const Text('Enable dark theme'),
      value: _darkMode,
      onChanged: (value) {
        setState(() {
          _darkMode = value;
        });
      },
    );
  }

  Widget _buildNotificationSetting() {
    return SwitchListTile(
      secondary: const Icon(Icons.notifications, color: AppTheme.primaryColor),
      title: const Text('Notifications'),
      subtitle: const Text('Enable push notifications'),
      value: _notificationsEnabled,
      onChanged: (value) {
        setState(() {
          _notificationsEnabled = value;
        });
      },
    );
  }

  Widget _buildLocationSetting() {
    return SwitchListTile(
      secondary: const Icon(Icons.location_on, color: AppTheme.primaryColor),
      title: const Text('Location Services'),
      subtitle: const Text('Allow location tracking'),
      value: _locationEnabled,
      onChanged: (value) {
        setState(() {
          _locationEnabled = value;
        });
      },
    );
  }

  Widget _buildPrivacySetting() {
    return ListTile(
      leading: const Icon(Icons.privacy_tip, color: AppTheme.primaryColor),
      title: const Text('Privacy Policy'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // TODO: Navigate to privacy policy
      },
    );
  }

  Widget _buildSecuritySetting() {
    return ListTile(
      leading: const Icon(Icons.security, color: AppTheme.primaryColor),
      title: const Text('Security Settings'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // TODO: Navigate to security settings
      },
    );
  }

  Widget _buildDataUsageSetting() {
    return ListTile(
      leading: const Icon(Icons.data_usage, color: AppTheme.primaryColor),
      title: const Text('Data Usage'),
      subtitle: const Text('Manage data consumption'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // TODO: Navigate to data usage
      },
    );
  }

  Widget _buildCacheSetting() {
    return ListTile(
      leading: const Icon(Icons.storage, color: AppTheme.primaryColor),
      title: const Text('Clear Cache'),
      subtitle: const Text('Free up storage space'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        _showClearCacheDialog();
      },
    );
  }

  Widget _buildUpdateSetting() {
    return ListTile(
      leading: const Icon(Icons.update, color: AppTheme.primaryColor),
      title: const Text('Check for Updates'),
      subtitle: const Text('App is up to date'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // TODO: Check for updates
      },
    );
  }

  Widget _buildAboutItem(String title, String value) {
    return ListTile(
      title: Text(title),
      trailing: Text(
        value,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: AppTheme.accentColor,
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.of(context).pop();
              },
            ),
            RadioListTile<String>(
              title: const Text('العربية'),
              value: 'Arabic',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Settings'),
        content: const Text('Are you sure you want to reset all settings to default?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Reset settings
              setState(() {
                _notificationsEnabled = true;
                _locationEnabled = true;
                _darkMode = false;
                _selectedLanguage = 'English';
              });
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear all cached data. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Clear cache
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

