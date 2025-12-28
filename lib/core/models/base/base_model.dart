abstract class BaseModel<T> {
  Map<String, dynamic> toJson();
  T toEntity();
}