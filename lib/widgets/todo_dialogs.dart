import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoDialogs {
  static void showAddTodoDialog({
    required BuildContext context,
    required Function(String, String) onAdd,
  }) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
                // Validation for empty fields
                showToast(context, "Title and Description cannot be empty", isError: true);
              } else {
                onAdd(titleController.text, descriptionController.text);
                Navigator.pop(context);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  static void showEditTodoDialog({
    required BuildContext context,
    required Todo todo,
    required Function(String, String) onEdit,
  }) {
    TextEditingController titleController =
    TextEditingController(text: todo.title);
    TextEditingController descriptionController =
    TextEditingController(text: todo.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
                // Validation for empty fields
                showToast(context, "Title and Description cannot be empty", isError: true);
              } else {
                onEdit(titleController.text, descriptionController.text);
                Navigator.pop(context);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  static void showSearchTodoDialog({
    required BuildContext context,
    required Function(String) onSearch,
  }) {
    TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search Todo'),
        content: TextField(
          controller: searchController,
          decoration: InputDecoration(labelText: 'Search', hintText: 'Enter keyword'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (searchController.text.isEmpty) {
                // Validation for empty search query
                showToast(context, "Please insert some text to search", isError: true);
              } else {
                onSearch(searchController.text);
                Navigator.pop(context);
              }
            },
            child: Text('Search'),
          ),
        ],
      ),
    );
  }

  static void showChangeStatusDialog({
    required BuildContext context,
    required Todo todo,
    required Function(String) onChangeStatus,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Task Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                onChangeStatus('new'); // Change status to "New"
                Navigator.pop(context); // Close the dialog automatically
              },
              child: Text('New'),
            ),
            TextButton(
              onPressed: () {
                onChangeStatus('pending'); // Change status to "Pending"
                Navigator.pop(context); // Close the dialog automatically
              },
              child: Text('Pending'),
            ),
            TextButton(
              onPressed: () {
                onChangeStatus('completed'); // Change status to "Completed"
                Navigator.pop(context); // Close the dialog automatically
              },
              child: Text('Completed'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  static void showDeleteTodoDialog({
    required BuildContext context,
    required int id,
    required VoidCallback onDelete,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Warning!'),
        content: Text('Once you delete, you cannot get it back.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              onDelete();
              Navigator.pop(context); // Close the dialog automatically
            },
            child: Text(
              'Yes',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  static void showToast(BuildContext context, String message,
      {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      behavior: SnackBarBehavior.floating, // Makes the snackbar float
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      margin: EdgeInsets.all(16), // Adds margin around the snackbar
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Future<bool> showExitConfirmation(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Do you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    ) ??
        false;
  }

  static Widget showNoTasksMessage(bool isSearching) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/no-task.png',
            width: 100,
            height: 100,
          ),
          SizedBox(height: 16),
          Text(
            isSearching ? "No tasks found in this tab" : "No tasks available",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}