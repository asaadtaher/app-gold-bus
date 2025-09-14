import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../models/user_model.dart';
import '../../../../services/firestore_service.dart';

class UserManagementPage extends ConsumerStatefulWidget {
  const UserManagementPage({super.key});

  @override
  ConsumerState<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends ConsumerState<UserManagementPage> {
  UserRole? _selectedRoleFilter;
  bool _showOnlyPending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المستخدمين'),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.filter),
            onPressed: () => _showFilterDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: _buildUsersList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        children: [
          FilterChip(
            label: const Text('جميع المستخدمين'),
            selected: _selectedRoleFilter == null,
            onSelected: (selected) {
              setState(() {
                _selectedRoleFilter = null;
              });
            },
          ),
          FilterChip(
            label: const Text('أولياء الأمور'),
            selected: _selectedRoleFilter == UserRole.parent,
            onSelected: (selected) {
              setState(() {
                _selectedRoleFilter = UserRole.parent;
              });
            },
          ),
          FilterChip(
            label: const Text('السائقون'),
            selected: _selectedRoleFilter == UserRole.driver,
            onSelected: (selected) {
              setState(() {
                _selectedRoleFilter = UserRole.driver;
              });
            },
          ),
          FilterChip(
            label: const Text('المشرفات'),
            selected: _selectedRoleFilter == UserRole.supervisor,
            onSelected: (selected) {
              setState(() {
                _selectedRoleFilter = UserRole.supervisor;
              });
            },
          ),
          FilterChip(
            label: const Text('الإدارة'),
            selected: _selectedRoleFilter == UserRole.admin,
            onSelected: (selected) {
              setState(() {
                _selectedRoleFilter = UserRole.admin;
              });
            },
          ),
          const SizedBox(width: 16),
          FilterChip(
            label: const Text('في انتظار الموافقة'),
            selected: _showOnlyPending,
            onSelected: (selected) {
              setState(() {
                _showOnlyPending = selected;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUsersList() {
    return StreamBuilder<List<UserModel>>(
      stream: FirestoreService().streamUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('خطأ: ${snapshot.error}'));
        }
        
        List<UserModel> users = snapshot.data ?? [];
        
        // تطبيق الفلاتر
        if (_selectedRoleFilter != null) {
          users = users.where((user) => user.role == _selectedRoleFilter).toList();
        }
        
        if (_showOnlyPending) {
          users = users.where((user) => !user.approved).toList();
        }
        
        if (users.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.users,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'لا يوجد مستخدمون',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return _buildUserCard(user);
          },
        );
      },
    );
  }

  Widget _buildUserCard(UserModel user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getRoleColor(user.role),
                  child: Icon(
                    _getRoleIcon(user.role),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _getRoleDisplayName(user.role),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildApprovalStatus(user),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.envelope,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    user.email,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.phone,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  user.phone,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            if (user.role == UserRole.driver) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.car,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    user.vehicleType ?? 'غير محدد',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
            if (user.role == UserRole.supervisor) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    FontAwesomeIcons.school,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    user.schoolName ?? 'غير محدد',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showUserDetails(user),
                    icon: const Icon(FontAwesomeIcons.eye),
                    label: const Text('عرض التفاصيل'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _toggleUserApproval(user),
                    icon: Icon(user.approved 
                        ? FontAwesomeIcons.userXmark 
                        : FontAwesomeIcons.userCheck),
                    label: Text(user.approved ? 'إلغاء الموافقة' : 'الموافقة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: user.approved ? Colors.red : Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalStatus(UserModel user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: user.approved ? Colors.green[100] : Colors.orange[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            user.approved ? FontAwesomeIcons.check : FontAwesomeIcons.clock,
            size: 12,
            color: user.approved ? Colors.green[600] : Colors.orange[600],
          ),
          const SizedBox(width: 4),
          Text(
            user.approved ? 'موافق عليه' : 'في الانتظار',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: user.approved ? Colors.green[600] : Colors.orange[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تصفية المستخدمين'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('جميع المستخدمين'),
              leading: Radio<UserRole?>(
                value: null,
                groupValue: _selectedRoleFilter,
                onChanged: (value) {
                  setState(() {
                    _selectedRoleFilter = value;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('أولياء الأمور'),
              leading: Radio<UserRole?>(
                value: UserRole.parent,
                groupValue: _selectedRoleFilter,
                onChanged: (value) {
                  setState(() {
                    _selectedRoleFilter = value;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('السائقون'),
              leading: Radio<UserRole?>(
                value: UserRole.driver,
                groupValue: _selectedRoleFilter,
                onChanged: (value) {
                  setState(() {
                    _selectedRoleFilter = value;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('المشرفات'),
              leading: Radio<UserRole?>(
                value: UserRole.supervisor,
                groupValue: _selectedRoleFilter,
                onChanged: (value) {
                  setState(() {
                    _selectedRoleFilter = value;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            ListTile(
              title: const Text('الإدارة'),
              leading: Radio<UserRole?>(
                value: UserRole.admin,
                groupValue: _selectedRoleFilter,
                onChanged: (value) {
                  setState(() {
                    _selectedRoleFilter = value;
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  void _showUserDetails(UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل ${user.name}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('الاسم', user.name),
              _buildDetailRow('البريد الإلكتروني', user.email),
              _buildDetailRow('رقم الهاتف', user.phone),
              _buildDetailRow('الدور', _getRoleDisplayName(user.role)),
              _buildDetailRow('حالة الموافقة', user.approved ? 'موافق عليه' : 'في الانتظار'),
              _buildDetailRow('تاريخ الإنشاء', user.createdAt.toString().split(' ')[0]),
              if (user.role == UserRole.driver) ...[
                _buildDetailRow('نوع السيارة', user.vehicleType ?? 'غير محدد'),
                _buildDetailRow('موديل السيارة', user.vehicleModel ?? 'غير محدد'),
                _buildDetailRow('العنوان', user.address ?? 'غير محدد'),
              ],
              if (user.role == UserRole.supervisor) ...[
                _buildDetailRow('اسم المدرسة', user.schoolName ?? 'غير محدد'),
                _buildDetailRow('العنوان', user.address ?? 'غير محدد'),
              ],
              if (user.role == UserRole.admin) ...[
                _buildDetailRow('الوظيفة', user.jobTitle ?? 'غير محدد'),
                _buildDetailRow('اسم المؤسسة', user.organization ?? 'غير محدد'),
              ],
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleUserApproval(UserModel user) async {
    try {
      await FirestoreService().updateUser(user.id, {
        'approved': !user.approved,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            user.approved 
                ? 'تم إلغاء موافقة ${user.name}' 
                : 'تم الموافقة على ${user.name}',
          ),
          backgroundColor: user.approved ? Colors.red[600] : Colors.green[600],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في تحديث حالة المستخدم: $e'),
          backgroundColor: Colors.red[600],
        ),
      );
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





