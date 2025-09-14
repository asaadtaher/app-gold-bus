import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../models/user_model.dart';
import '../../../../models/student_model.dart';
import '../../../../models/absence_model.dart';
import '../../../../services/firestore_service.dart';

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  DateTime _selectedDate = DateTime.now();
  String _selectedReportType = 'overview';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير والإحصائيات'),
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.calendar),
            onPressed: () => _selectDate(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildReportTypeSelector(),
          Expanded(
            child: _buildReportContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildReportTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildReportTypeChip('overview', 'نظرة عامة', FontAwesomeIcons.chartPie),
            const SizedBox(width: 8),
            _buildReportTypeChip('users', 'المستخدمون', FontAwesomeIcons.users),
            const SizedBox(width: 8),
            _buildReportTypeChip('students', 'الطلاب', FontAwesomeIcons.userGraduate),
            const SizedBox(width: 8),
            _buildReportTypeChip('absences', 'الغياب', FontAwesomeIcons.userXmark),
            const SizedBox(width: 8),
            _buildReportTypeChip('buses', 'الحافلات', FontAwesomeIcons.bus),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTypeChip(String type, String title, IconData icon) {
    final isSelected = _selectedReportType == type;
    
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(title),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedReportType = type;
        });
      },
      selectedColor: Colors.amber[100],
      checkmarkColor: Colors.amber[700],
    );
  }

  Widget _buildReportContent() {
    switch (_selectedReportType) {
      case 'overview':
        return _buildOverviewReport();
      case 'users':
        return _buildUsersReport();
      case 'students':
        return _buildStudentsReport();
      case 'absences':
        return _buildAbsencesReport();
      case 'buses':
        return _buildBusesReport();
      default:
        return _buildOverviewReport();
    }
  }

  Widget _buildOverviewReport() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStatsCard(
            'إجمالي المستخدمين',
            FontAwesomeIcons.users,
            Colors.blue,
            () => _getTotalUsers(),
          ),
          const SizedBox(height: 16),
          _buildStatsCard(
            'إجمالي الطلاب',
            FontAwesomeIcons.userGraduate,
            Colors.green,
            () => _getTotalStudents(),
          ),
          const SizedBox(height: 16),
          _buildStatsCard(
            'بلاغات الغياب اليوم',
            FontAwesomeIcons.userXmark,
            Colors.red,
            () => _getTodayAbsences(),
          ),
          const SizedBox(height: 16),
          _buildStatsCard(
            'المستخدمون في الانتظار',
            FontAwesomeIcons.clock,
            Colors.orange,
            () => _getPendingUsers(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(String title, IconData icon, Color color, Future<int> Function() getCount) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  FutureBuilder<int>(
                    future: getCount(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          '${snapshot.data}',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersReport() {
    return StreamBuilder<List<UserModel>>(
      stream: FirestoreService().streamUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('خطأ: ${snapshot.error}'));
        }
        
        final users = snapshot.data ?? [];
        final roleCounts = _getRoleCounts(users);
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildRoleStatsCard('أولياء الأمور', roleCounts[UserRole.parent] ?? 0, Colors.blue),
              const SizedBox(height: 16),
              _buildRoleStatsCard('السائقون', roleCounts[UserRole.driver] ?? 0, Colors.green),
              const SizedBox(height: 16),
              _buildRoleStatsCard('المشرفات', roleCounts[UserRole.supervisor] ?? 0, Colors.purple),
              const SizedBox(height: 16),
              _buildRoleStatsCard('الإدارة', roleCounts[UserRole.admin] ?? 0, Colors.red),
              const SizedBox(height: 24),
              _buildUsersList(users),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoleStatsCard(String role, int count, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getRoleIcon(role),
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$count مستخدم',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsersList(List<UserModel> users) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'آخر المستخدمين المسجلين',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...users.take(5).map((user) => ListTile(
              leading: CircleAvatar(
                backgroundColor: _getRoleColor(user.role),
                child: Icon(
                  _getRoleIcon(_getRoleDisplayName(user.role)),
                  color: Colors.white,
                  size: 16,
                ),
              ),
              title: Text(user.name),
              subtitle: Text(_getRoleDisplayName(user.role)),
              trailing: Text(
                user.createdAt.toString().split(' ')[0],
                style: Theme.of(context).textTheme.bodySmall,
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentsReport() {
    return StreamBuilder<List<StudentModel>>(
      stream: FirestoreService().streamStudents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('خطأ: ${snapshot.error}'));
        }
        
        final students = snapshot.data ?? [];
        final absentStudents = students.where((s) => s.isAbsent).length;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildStatsCard(
                'إجمالي الطلاب',
                FontAwesomeIcons.userGraduate,
                Colors.blue,
                () async => students.length,
              ),
              const SizedBox(height: 16),
              _buildStatsCard(
                'الطلاب الغائبون',
                FontAwesomeIcons.userXmark,
                Colors.red,
                () async => absentStudents,
              ),
              const SizedBox(height: 16),
              _buildStatsCard(
                'الطلاب الحاضرون',
                FontAwesomeIcons.userCheck,
                Colors.green,
                () async => students.length - absentStudents,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAbsencesReport() {
    return StreamBuilder<List<AbsenceModel>>(
      stream: FirestoreService().streamAbsences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('خطأ: ${snapshot.error}'));
        }
        
        final absences = snapshot.data ?? [];
        final todayAbsences = absences.where((a) => 
          a.date.day == _selectedDate.day &&
          a.date.month == _selectedDate.month &&
          a.date.year == _selectedDate.year
        ).length;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildStatsCard(
                'بلاغات الغياب اليوم',
                FontAwesomeIcons.calendarDay,
                Colors.red,
                () async => todayAbsences,
              ),
              const SizedBox(height: 16),
              _buildStatsCard(
                'إجمالي بلاغات الغياب',
                FontAwesomeIcons.userXmark,
                Colors.orange,
                () async => absences.length,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBusesReport() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.bus,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'تقرير الحافلات قيد التطوير',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  Future<int> _getTotalUsers() async {
    final users = await FirestoreService().getUsersByRole(UserRole.parent);
    return users.length;
  }

  Future<int> _getTotalStudents() async {
    final students = await FirestoreService().getAllStudents();
    return students.length;
  }

  Future<int> _getTodayAbsences() async {
    final absences = await FirestoreService().getAbsences();
    return absences.where((a) => 
      a.date.day == DateTime.now().day &&
      a.date.month == DateTime.now().month &&
      a.date.year == DateTime.now().year
    ).length;
  }

  Future<int> _getPendingUsers() async {
    final users = await FirestoreService().getUsersByRole(UserRole.parent);
    return users.where((u) => !u.approved).length;
  }

  Map<UserRole, int> _getRoleCounts(List<UserModel> users) {
    Map<UserRole, int> counts = {};
    for (final user in users) {
      counts[user.role] = (counts[user.role] ?? 0) + 1;
    }
    return counts;
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

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'ولي أمر':
        return FontAwesomeIcons.user;
      case 'سائق':
        return FontAwesomeIcons.car;
      case 'مشرفة':
        return FontAwesomeIcons.userTie;
      case 'إدارة':
        return FontAwesomeIcons.userShield;
      default:
        return FontAwesomeIcons.user;
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





