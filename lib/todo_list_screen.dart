import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_provider.dart'; // Import the todo provider
import 'todo.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void initState() {
    super.initState();
    // Start data initialization when the screen is loading
    Provider.of<TodoProvider>(context, listen: false).initializeData();
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context);
    final todos = todoProvider.todos; // Get filtered todos based on selected filter

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('TIG333 TODO', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          // Dropdown menu for filter selection with white color on the three dot menu
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white), // White colour on the three dot icon
            onSelected: (value) {
              todoProvider.setFilter(value); // Update the filter in TodoProvider
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'all',
                  child: Text('All'),
                ),
                PopupMenuItem(
                  value: 'done',
                  child: Text('Done'),
                ),
                PopupMenuItem(
                  value: 'undone',
                  child: Text('Undone'),
                ),
              ];
            },
          ),
        ],
      ),
      body: todos.isEmpty
          ? Center(
              child: Text(
                'No todos found. Add your first task!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return _buildTodoItem(todos[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add'); // Navigate to AddTodoScreen
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Create a Todo row in the list
  Widget _buildTodoItem(Todo todo) {
    return ListTile(
      leading: Checkbox(
        value: todo.done,
        onChanged: (value) {
          Provider.of<TodoProvider>(context, listen: false)
              .updateTodo(todo.id, todo.title, value!); // Update todo-status
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
          Provider.of<TodoProvider>(context, listen: false)
              .deleteTodo(todo.id); // Remove todo
        },
      ),
    );
  }
}
