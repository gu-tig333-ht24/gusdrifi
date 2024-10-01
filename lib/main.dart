// Flutter project created by Filip Drincic, task for Course TIG-333-VT at GU
// Step-1: ToDo is a simple application using layouts and widgets. 
// Step-2: StatefulWidget for handling of states. Additional snackbar used for add and remove "ToDo" tasks
// Step-3: Using simple API from https://todoapp-api.apps.k8s.gu.se/ to fetch and modify data (ToDo items)
// Use Flutter secure storage instead for shared preferences due to better security (to save API keys)

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'todo.dart';

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
  List<Todo> _todos = [];
  final FlutterSecureStorage storage = FlutterSecureStorage();
  String _apiKey = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  // Fetch API-key and todo-s
  Future<void> _initializeData() async {
    // Try to load saved API key from Secure Storage
    _apiKey = await storage.read(key: 'api_key') ?? '';
    print('Loaded API key from secure storage: $_apiKey');   //for troubleshooting purpose

    if (_apiKey.isNotEmpty) {
      try {
        _todos = await fetchTodos(_apiKey);
      } catch (e) {
        print('Error fetching todos: $e');
        _todos = _getFallbackTodos();
      }
    } else {
      // If no key is saved,fetch and save a new one from the API
      print('No API key found, fetching a new one...');
      _apiKey = await getApiKey();
      await storage.write(key: 'api_key', value: _apiKey);
      print('Fetched and saved new API key: $_apiKey');
      _todos = await fetchTodos(_apiKey);  // Fetch Todo-items with API-key
    }

    setState(() {});
  }
  // If failed to fetch from API, use fallback-data
  List<Todo> _getFallbackTodos() {
    return [
      Todo(id: '1', title: 'Write a book', done: false),
      Todo(id: '2', title: 'Do homework', done: false),
      Todo(id: '3', title: 'Tidy room', done: true),
      Todo(id: '4', title: 'Watch TV', done: false),
      Todo(id: '5', title: 'Nap', done: false),
      Todo(id: '6', title: 'Shop groceries', done: false),
      Todo(id: '7', title: 'Have fun', done: false),
      Todo(id: '8', title: 'Meditate', done: false),
    ];
  }

  // Function for getting the API key
  Future<String> getApiKey() async {
    try {
      final response = await http.get(Uri.parse('https://todoapp-api.apps.k8s.gu.se/register')).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Failed to fetch API key: Timeout');
        },
      );

      print('API response body: ${response.body}');

      if (response.statusCode == 200) {
        return response.body.trim(); // Trim to remove extra space
      } else {
        throw Exception('Failed to fetch API key');
      }
    } catch (e) {
      _showErrorSnackbar('Failed to fetch API key: $e');
      throw Exception('Error fetching API key: $e');
    }
  }

  // Function to get Todos
  Future<List<Todo>> fetchTodos(String apiKey) async {
    try {
      final response = await http.get(
        Uri.parse('https://todoapp-api.apps.k8s.gu.se/todos?key=$apiKey'),
      ).timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Failed to fetch todos: Timeout');
        },
      );

      print('Todo API response body: ${response.body}');  //For troubleshooting purpose, to be removed
      print('Status code: ${response.statusCode}'); //For troubleshooting purpose, to be removed

      if (response.statusCode == 200) {
        List todosJson = jsonDecode(response.body);
        return todosJson.map((json) => Todo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load todos');
      }
    } catch (e) {
      _showErrorSnackbar('Error fetching todos: $e');
      throw Exception('Error fetching todos: $e');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 5),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Function to add a new Todo
  Future<void> addTodo(String title) async {
    final response = await http.post(
      Uri.parse('https://todoapp-api.apps.k8s.gu.se/todos?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'done': false}),
    );

    if (response.statusCode == 200) {
      _todos = await fetchTodos(_apiKey); // Update the list by getting all the Todos again
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Todo "$title" added')),
      );
    } else {
      throw Exception('Failed to add todo');
    }
  }

  // Function for updating an existing Todo
  Future<void> updateTodo(String id, String title, bool done) async {
    final response = await http.put(
      Uri.parse('https://todoapp-api.apps.k8s.gu.se/todos/$id?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'done': done}),
    );

    if (response.statusCode == 200) {
      _todos = await fetchTodos(_apiKey); // Update the list
      setState(() {});
    } else {
      throw Exception('Failed to update todo');
    }
  }

  // Function for removing a Todo
  Future<void> deleteTodo(String id) async {
    final response = await http.delete(
      Uri.parse('https://todoapp-api.apps.k8s.gu.se/todos/$id?key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      _todos = await fetchTodos(_apiKey); // Updates the list
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Todo removed')),
      );
    } else {
      throw Exception('Failed to delete todo');
    }
  }

  // Build Todo-list
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          'TIG333 TODO',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: _todos.isEmpty
          ? Center(
              child: _apiKey.isEmpty
                  ? CircularProgressIndicator() // Show loading indicator if no Todos exist
                  : Text('No todos found. Add your first task!'), // Show a message if the list is empty
            )
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                return _buildTodoItem(_todos[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayAddTodoDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Create a Todo-item
  Widget _buildTodoItem(Todo todo) {
    return ListTile(
      leading: Checkbox(
        value: todo.done,
        onChanged: (value) {
          updateTodo(todo.id, todo.title, value!);
        },
      ),
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.done ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          deleteTodo(todo.id);
        },
      ),
    );
  }

  // Show a dialogue to add a new Todo
  Future<void> _displayAddTodoDialog(BuildContext context) async {
    TextEditingController _textFieldController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Todo'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Enter new todo"),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('ADD'),
              onPressed: () async {
                if (_textFieldController.text.isNotEmpty) {
                  await addTodo(_textFieldController.text);
                  Navigator.of(context).pop(); // Close the dialogue box after the Todo has been added
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Todo title cannot be empty'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}