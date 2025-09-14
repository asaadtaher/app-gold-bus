import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../models/absence_model.dart';
import '../../../../models/student_model.dart';
import '../../../../services/firestore_service.dart';
import '../../../../providers/auth_provider.dart';

class AbsenceReportDialog extends ConsumerStatefulWidget {
  final StudentModel? student;
  
  const AbsenceReportDialog({
    super.key,
    this.student,
  });

  @override
  ConsumerState<AbsenceReportDialog> createState() => _AbsenceReportDialogState();
}

class _AbsenceReportDialogState extends ConsumerState<AbsenceReportDialog> {
  AbsenceType _selectedType = AbsenceType.both;
  final _reasonController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            FontAwesomeIcons.userXmark,
            color: Colors.red[600],
          ),
          const SizedBox(width: 8),
          const Text('إبلاغ الغياب'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.student != null) ...[
              _buildStudentInfo(),
              const SizedBox(height: 16),
            ],
            _buildAbsenceTypeSelector(),
            const SizedBox(height: 16),
            _buildReasonField(),
            const SizedBox(height: 16),
            _buildInfoMessage(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitAbsenceReport,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: _isLoading 
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('إرسال البلاغ'),
        ),
      ],
    );
  }

  Widget _buildStudentInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: Icon(
              FontAwesomeIcons.userGraduate,
              color: Colors.blue[700],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.student!.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'المرحلة: ${widget.student!.grade}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAbsenceTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نوع الغياب *',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildAbsenceTypeOption(
          AbsenceType.goingOnly,
          'ذهاب فقط',
          FontAwesomeIcons.arrowRight,
          'الطالب لن يذهب للمدرسة اليوم',
        ),
        const SizedBox(height: 8),
        _buildAbsenceTypeOption(
          AbsenceType.returningOnly,
          'عودة فقط',
          FontAwesomeIcons.arrowLeft,
          'الطالب لن يعود من المدرسة اليوم',
        ),
        const SizedBox(height: 8),
        _buildAbsenceTypeOption(
          AbsenceType.both,
          'ذهاب وعودة',
          FontAwesomeIcons.xmark,
          'الطالب لن يذهب للمدرسة ولن يعود',
        ),
      ],
    );
  }

  Widget _buildAbsenceTypeOption(
    AbsenceType type,
    String title,
    IconData icon,
    String description,
  ) {
    final isSelected = _selectedType == type;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red[50] : Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.red[300]! : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.red[600] : Colors.grey[600],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isSelected ? Colors.red[700] : Colors.grey[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                FontAwesomeIcons.check,
                color: Colors.red[600],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonField() {
    return TextFormField(
      controller: _reasonController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'سبب الغياب (اختياري)',
        prefixIcon: const Icon(FontAwesomeIcons.noteSticky),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: 'مثال: مرض، موعد طبي، ظروف عائلية...',
      ),
    );
  }

  Widget _buildInfoMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.infoCircle,
            color: Colors.orange[600],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'سيتم إشعار السائق والمشرفة فوراً، وسيتم تسجيل الغياب في النظام',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.orange[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submitAbsenceReport() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = ref.read(authStateProvider).value;
      if (currentUser == null) {
        throw Exception('المستخدم غير مسجل الدخول');
      }

      final absence = AbsenceModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        studentId: widget.student?.id ?? 'unknown',
        studentName: widget.student?.name ?? 'طالب غير محدد',
        date: DateTime.now(),
        reason: _reasonController.text.trim().isEmpty 
            ? '' 
            : _reasonController.text.trim(),
        type: _selectedType,
        reportedBy: currentUser.uid,
        reportedByName: currentUser.displayName ?? 'مستخدم',
        createdAt: DateTime.now(),
        isApproved: false,
      );

      await FirestoreService().addAbsence(absence);
      
      // Update student absence status
      if (widget.student != null) {
        await FirestoreService().updateStudentById(widget.student!.id, {
          'isAbsent': true,
          'absenceType': _selectedType.name,
        });
      }

      Navigator.of(context).pop();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم إرسال بلاغ الغياب بنجاح'),
          backgroundColor: Colors.green[600],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في إرسال بلاغ الغياب: $e'),
          backgroundColor: Colors.red[600],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
