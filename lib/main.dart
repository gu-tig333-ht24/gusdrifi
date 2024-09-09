// Flutter project created by Filip Drincic, TIG333 course at GU, application: ToDo
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
        scaffoldBackgroundColor: Colors.grey[200], // Ändra bakgrundsfärgen här
      ),
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatelessWidget {
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
              // Placeholder för filterknapp (ingen funktionalitet i Steg 1)
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildTodoItem('Write a book', false),
          _buildTodoItem('Do homework', false),
          _buildTodoItem('Tidy room', true), // Visuellt klar
          _buildTodoItem('Watch TV', false),
          _buildTodoItem('Nap', false),
          _buildTodoItem('Shop groceries', false),
          _buildTodoItem('Have fun', false),
          _buildTodoItem('Meditate', false),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodoScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildTodoItem(String title, bool isDone) {
    return ListTile(
      leading: Checkbox(
        value: isDone,
        activeColor: Colors.lightBlue, // Ändra checkboxens färg till blå
        onChanged: (value) {
          // Ingen funktionalitet i Steg 1
        },
      ),
      title: Text(
        title,
        style: TextStyle(
          decoration: isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          // Ingen funktionalitet i Steg 1
        },
      ),
    );
  }
}

class AddTodoScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

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
                  // Ingen funktionalitet i Steg 1
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
