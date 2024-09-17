// Flutter project created by Filip Drincic, task for Course TIG-333-VT at GU
// ToDo is a simple application using layouts and widgets. Step 2- states.
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
        scaffoldBackgroundColor: Colors.grey[200], // Changes background color here
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
              // Placeholder for filter button (no functionality in step 1)
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildTodoItem('Write a book', false),
          _buildTodoItem('Do homework', false),
          _buildTodoItem('Tidy room', true), // Visually done
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
        activeColor: Colors.lightBlue, // Changes the checkbox color to light blue from default
        onChanged: (value) {
          // No functionality in step 1
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
          // No functionality in step 1
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
                  // No functionality in step 1. Will be added later
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
