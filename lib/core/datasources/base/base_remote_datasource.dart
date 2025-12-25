abstract class BaseRemoteDatasource<T> {
  Future<List<T>> getAll();

  Future<T> getById(int id);

  Future<T> create(Map<String, dynamic> data);

  Future<T> update(int id, Map<String, dynamic> data);

  Future<void> delete(int id);
}
