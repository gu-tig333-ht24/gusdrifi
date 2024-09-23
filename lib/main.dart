// Flutter project created by Filip Drincic, task for Course TIG-333-VT at GU
// ToDo is a simple application using layouts and widgets. Step 2-StatefulWidget for handling of states
// Add additional snackbar for add and remove "ToDo" tasks
// Step 3 using http API 

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

// Modell för en Todo
class Todo {
  String id;
  String title;
  bool done;

  Todo({
    required this.id,
    required this.title,
    required this.done,
  });

  // Från JSON till Todo
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      done: json['done'],
    );
  }
}

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> _todos = [];
  String _apiKey = '';

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  // Hämta API-nyckel och todos
  Future<void> _initializeData() async {
    try {
      _apiKey = await getApiKey();  // Hämta API-nyckeln
      _todos = await fetchTodos(_apiKey);  // Hämta Todo-poster
      setState(() {});
    } catch (e) {
      print('Failed to fetch from API, using fallback todos: $e');
    
    // Använd statiska Todos från Steg 2 om API-anrop misslyckas
    _todos = [
      Todo(id: '1', title: 'Write a book', done: false),
      Todo(id: '2', title: 'Do homework', done: false),
      Todo(id: '3', title: 'Tidy room', done: true),
      Todo(id: '4', title: 'Watch TV', done: false),
      Todo(id: '5', title: 'Nap', done: false),
      Todo(id: '6', title: 'Shop groceries', done: false),
      Todo(id: '7', title: 'Have fun', done: false),
      Todo(id: '8', title: 'Meditate', done: false),
    ];
  } finally {
    setState(() {});  // Uppdatera UI oavsett om anrop lyckas eller ej
    }
  }

  // Funktion för att hämta API-nyckeln
Future<String> getApiKey() async {
  try {
    final response = await http.get(Uri.parse('https://todoapp-api.apps.k8s.gu.se/register')).timeout(
      Duration(seconds: 10),
      onTimeout: () {
        throw Exception('Failed to fetch API key: Timeout');
      },
    );
  // Logga hela responsen för att se vad API:et skickar
    print('API response body: ${response.body}');

    if (response.statusCode == 200) {
      // Returnera strängen direkt eftersom den inte är JSON
      return response.body.trim();  // Trim för att ta bort extra mellanslag eller radbrytningar
    } else {
      throw Exception('Failed to fetch API key');
    }
  } catch (e) {
    _showErrorSnackbar('Failed to fetch API key: $e');
    throw Exception('Error fetching API key: $e');
  }
}

    

  // Funktion för att hämta Todos
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

    if (response.statusCode == 200) {
      List todosJson = jsonDecode(response.body);
      return todosJson.map((json) => Todo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load todos');
    }
  } catch (e) {
     _showErrorSnackbar('Failed to fetch API key');
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

  // Funktion för att lägga till en ny Todo
  Future<void> addTodo(String title) async {
    final response = await http.post(
      Uri.parse('https://todoapp-api.apps.k8s.gu.se/todos?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'done': false}),
    );

    if (response.statusCode == 200) {
      _todos = await fetchTodos(_apiKey);  // Uppdatera listan genom att hämta alla Todos på nytt
      setState(() {});
     // Visa Snackbar för att bekräfta att Todo har lagts till
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Todo "$title" added')),
    );

    } else {
      throw Exception('Failed to add todo');
    }
  }

  // Funktion för att uppdatera en befintlig Todo
  Future<void> updateTodo(String id, String title, bool done) async {
    final response = await http.put(
      Uri.parse('https://todoapp-api.apps.k8s.gu.se/todos/$id?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'done': done}),
    );

    if (response.statusCode == 200) {
      _todos = await fetchTodos(_apiKey);  // Uppdatera listan
      setState(() {});
    } else {
      throw Exception('Failed to update todo');
    }
  }

  // Funktion för att ta bort en Todo
  Future<void> deleteTodo(String id) async {
    final response = await http.delete(
      Uri.parse('https://todoapp-api.apps.k8s.gu.se/todos/$id?key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      _todos = await fetchTodos(_apiKey);  // Uppdatera listan
      setState(() {});
     // Visa Snackbar för att bekräfta att Todo har tagits bort
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Todo removed')),
    ); 
    } else {
      throw Exception('Failed to delete todo');
    }
  }

  // Bygg Todo-listan
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
      ),
      body: _todos.isEmpty
          ? Center(child: CircularProgressIndicator())  // Visa laddningsindikator om inga todos finns
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

  // Bygg en Todo-item
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

  // Visa en dialog för att lägga till en ny Todo
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
                // Lägg till den nya Todo-posten genom att använda addTodo-funktionen
                await addTodo(_textFieldController.text);
                Navigator.of(context).pop(); // Stäng dialogrutan efter att Todo har lagts till
              } else {
                // Visa ett felmeddelande om fältet är tomt
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