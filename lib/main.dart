// Flutter project created by Filip Drincic, task for Course TIG-333-VT at GU
// ToDo is a simple application using layouts and widgets. Step 2-StatefulWidget for handling of states

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TIG333 TODO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> _todos = [
    Todo(title: 'Write a book', isDone: false),
    Todo(title: 'Do homework', isDone: false),
    Todo(title: 'Tidy room', isDone: true),
    Todo(title: 'Watch TV', isDone: false),
    Todo(title: 'Nap', isDone: false),
    Todo(title: 'Shop groceries', isDone: false),
    Todo(title: 'Have fun', isDone: false),
    Todo(title: 'Meditate', isDone: false),
  ];

  void _addTodoItem(String title) {
    setState(() {
      _todos.add(Todo(title: title, isDone: false));
    });
  }

  void _toggleTodoDone(int index) {
    setState(() {
      _todos[index].isDone = !_todos[index].isDone;
    });
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          'TIG333 TODO',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Placeholder för filterknapp
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          return _buildTodoItem(_todos[index], index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTodoScreen(onAddTodo: _addTodoItem),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodoItem(Todo todo, int index) {
    return ListTile(
      leading: Checkbox(
        value: todo.isDone,
        activeColor: Colors.lightBlue,
        onChanged: (value) {
          _toggleTodoDone(index);
        },
      ),
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          _removeTodoItem(index);
        },
      ),
    );
  }
}

class AddTodoScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final Function(String) onAddTodo;

  AddTodoScreen({required this.onAddTodo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          'TIG333 TODO',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'What are you going to do?',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    onAddTodo(_controller.text);
                    Navigator.pop(context);
                  }
                },
                child: Text('+ ADD'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Todo {
  String title;
  bool isDone;

  Todo({
    required this.title,
    this.isDone = false,
  });
}


