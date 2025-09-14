import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/audit_service.dart';

// Audit Service Provider
final auditServiceProvider = Provider<AuditService>((ref) {
  return AuditService();
});
