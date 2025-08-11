class TaskTitle {
  final String value;
  const TaskTitle._(this.value);

  static TaskTitle create(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Título não pode ser vazio');
    }
    if (trimmed.length > 40) {
      throw ArgumentError('Título deve ter no máximo 40 caracteres');
    }
    return TaskTitle._(trimmed);
  }
}