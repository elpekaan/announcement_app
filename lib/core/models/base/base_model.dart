abstract class BaseModel<T> {
  final int id;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const BaseModel({required this.id, required this.createdAt, this.updatedAt});

  T toEntity();

  Map<String, dynamic> toJson();
}
