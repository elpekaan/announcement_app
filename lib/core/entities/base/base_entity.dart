import 'package:equatable/equatable.dart';

abstract class BaseEntity extends Equatable {
  final int id;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const BaseEntity({required this.id, required this.createdAt, this.updatedAt});
}
