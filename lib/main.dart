// Flutter project created by Filip Drincic, task for Course TIG-333-VT at GU
// Step-1: ToDo is a simple application using layouts and widgets. 
// Step-2: Handling of states. 
// Step-3: Using simple API from https://todoapp-api.apps.k8s.gu.se/ to fetch and modify data (ToDo items)
// Use Flutter secure storage instead for shared preferences due to better security (to save API keys)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_provider.dart';  // New provider to handle todo logic
import 'todo_list_screen.dart';  // The current todo screen with todo list
import 'add_todo_screen.dart';  // New view to add a new todo

void main() {
  runApp(
    // Add provider to make todo provider available in the whole app
    ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: MyApp(),
    ),
  );
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
      // Add routing to be able to navigate between different screens
      initialRoute: '/',
      routes: {
        '/': (context) => TodoListScreen(),
        '/add': (context) => AddTodoScreen(),  // New view to add todos
      },
    );
  }
}
