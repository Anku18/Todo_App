class Task {
  final String id;
  final String title;
  final String description;
  final bool completed;
  String createdAt;

  Task({
    this.id = '',
    required this.title,
    this.description = '',
    this.completed = false,
    this.createdAt = '',
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    String? createdAt,
  }) {
    return Task(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        completed: completed ?? this.completed,
        createdAt: createdAt ?? this.createdAt);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'completed': completed,
      'createdAt': createdAt,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      completed: map['completed'],
      createdAt: map['createdAt'],
    );
  }
}
