import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'todo.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];
  final FlutterSecureStorage storage = FlutterSecureStorage();
  String _apiKey = '';
  String _filter = 'all'; // Filter-state ("all", "done", "undone")

  List<Todo> get todos {
    if (_filter == 'done') {
      return _todos.where((todo) => todo.done).toList();
    } else if (_filter == 'undone') {
      return _todos.where((todo) => !todo.done).toList();
    }
    return _todos; // "all" returns all todos
  }

  String get filter => _filter;

  // Set the filter and notify listeners
  void setFilter(String newFilter) {
    _filter = newFilter;
    notifyListeners();
  }

  // Initialize data (fetch API key and todos)
  Future<void> initializeData() async {
    print('Initializing data...');
    try {
      // Read API key from secure storage
      _apiKey = await storage.read(key: 'api_key') ?? '';
      print('API Key: $_apiKey');

      if (_apiKey.isNotEmpty) {
        // Fetch todos if API key exists
        try {
          _todos = await fetchTodos(_apiKey);
          print('Todos fetched successfully');
        } catch (e) {
          print('Error fetching todos: $e');
          _todos = _getFallbackTodos();
        }
      } else {
        // Fetch new API key if not found
        print('No API key found. Fetching new API key...');
        _apiKey = await _getApiKey();
        await storage.write(key: 'api_key', value: _apiKey);
        print('New API Key: $_apiKey');
        _todos = await fetchTodos(_apiKey);
      }
    } catch (e) {
      print('Initialization error: $e');
    }

    notifyListeners();
  }

  // Get fallback todos if API fetch fails
  List<Todo> _getFallbackTodos() {
    return [
      Todo(id: '1', title: 'Write a book', done: false),
      Todo(id: '2', title: 'Do homework', done: false),
      Todo(id: '3', title: 'Tidy room', done: true),
      Todo(id: '4', title: 'Watch TV', done: false),
    ];
  }

  // Fetch API key from the server
  Future<String> _getApiKey() async {
    try {
      final response = await http
          .get(Uri.parse('https://todoapp-api.apps.k8s.gu.se/register'))
          .timeout(Duration(seconds: 10), onTimeout: () {
        throw Exception('Failed to fetch API key: Timeout');
      });

      if (response.statusCode == 200) {
        print('API Key fetched successfully');
        return response.body.trim();
      } else {
        throw Exception('Failed to fetch API key');
      }
    } catch (e) {
      print('Error fetching API key: $e');
      throw Exception('Error fetching API key: $e');
    }
  }

  // Fetch todos from the API
  Future<List<Todo>> fetchTodos(String apiKey) async {
    try {
      print('Fetching todos...');
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
        print('Todos fetched: ${todosJson.length}');
        return todosJson.map((json) => Todo.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load todos');
      }
    } catch (e) {
      print('Error fetching todos: $e');
      throw Exception('Error fetching todos: $e');
    }
  }

  // Add a new todo
  Future<void> addTodo(String title) async {
    final response = await http.post(
      Uri.parse('https://todoapp-api.apps.k8s.gu.se/todos?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'done': false}),
    );

    if (response.statusCode == 200) {
      _todos = await fetchTodos(_apiKey);
      notifyListeners();
    } else {
      throw Exception('Failed to add todo');
    }
  }

  // Update an existing todo
  Future<void> updateTodo(String id, String title, bool done) async {
    final response = await http.put(
      Uri.parse('https://todoapp-api.apps.k8s.gu.se/todos/$id?key=$_apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'done': done}),
    );

    if (response.statusCode == 200) {
      _todos = await fetchTodos(_apiKey);
      notifyListeners();
    } else {
      throw Exception('Failed to update todo');
    }
  }

  // Delete a todo
  Future<void> deleteTodo(String id) async {
    final response = await http.delete(
      Uri.parse('https://todoapp-api.apps.k8s.gu.se/todos/$id?key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      _todos = await fetchTodos(_apiKey);
      notifyListeners();
    } else {
      throw Exception('Failed to delete todo');
    }
  }
}

