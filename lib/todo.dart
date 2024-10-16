class Todo {
  String id;
  String title;
  bool done;

  Todo({
    required this.id,
    required this.title,
    required this.done,
  });

  // From JSON to Todo
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
     title: json['title'],
      done: json['done'],
    );
  }
}
