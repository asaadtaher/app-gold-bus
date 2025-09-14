import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final String messageType;
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;
  final String? fileUrl;
  final String? fileName;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.messageType = 'text',
    required this.timestamp,
    this.isRead = false,
    this.imageUrl,
    this.fileUrl,
    this.fileName,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'messageType': messageType,
      'timestamp': Timestamp.fromDate(timestamp),
      'isRead': isRead,
      'imageUrl': imageUrl,
      'fileUrl': fileUrl,
      'fileName': fileName,
    };
  }

  factory ChatMessage.fromFirestore(Map<String, dynamic> data) {
    return ChatMessage(
      id: data['id'] ?? '',
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      message: data['message'] ?? '',
      messageType: data['messageType'] ?? 'text',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isRead: data['isRead'] ?? false,
      imageUrl: data['imageUrl'],
      fileUrl: data['fileUrl'],
      fileName: data['fileName'],
    );
  }

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? message,
    String? messageType,
    DateTime? timestamp,
    bool? isRead,
    String? imageUrl,
    String? fileUrl,
    String? fileName,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      messageType: messageType ?? this.messageType,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
    );
  }
}
