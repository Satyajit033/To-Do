import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import '../models/todo.dart';
import '../utils/local_storage.dart';
import '../widgets/todo_list.dart';
import '../widgets/todo_dialogs.dart';

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<Todo> todos = [];
  List<Todo> searchResults = [];
  int _currentIndex = 0;
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadTodosFromPreferences();
  }

  Future<void> _loadTodosFromPreferences() async {
    final loadedTodos = await LocalStorage.getTodos();
    if (loadedTodos != null) {
      setState(() {
        todos = loadedTodos;
      });
    }
  }

  Future<void> _saveTodosToPreferences() async {
    await LocalStorage.saveTodos(todos);
  }

  List<Todo> _getFilteredTodos() {
    if (_currentIndex == 0) {
      return todos.where((todo) => todo.status == 'new').toList();
    } else if (_currentIndex == 1) {
      return todos.where((todo) => todo.status == 'pending').toList();
    } else {
      return todos.where((todo) => todo.status == 'completed').toList();
    }
  }

  void _addTodo(String title, String description) {
    if (title.isEmpty || description.isEmpty) {
      TodoDialogs.showToast(context, "Title and Description cannot be empty", isError: true);
      return;
    }

    setState(() {
      int newId = todos.isEmpty ? 1 : todos.last.id + 1;
      todos.add(Todo(
        id: newId,
        title: title,
        description: description,
        createdAt: DateTime.now().toLocal().toString().split(' ')[0],
        status: 'new',
      ));
      _saveTodosToPreferences();
      TodoDialogs.showToast(context, "Successfully added");
    });
  }

  void _editTodo(int id, String newTitle, String newDescription) {
    if (newTitle.isEmpty || newDescription.isEmpty) {
      TodoDialogs.showToast(context, "Title and Description cannot be empty", isError: true);
      return;
    }

    setState(() {
      final index = todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        todos[index].title = newTitle;
        todos[index].description = newDescription;
        _saveTodosToPreferences();
        TodoDialogs.showToast(context, "Successfully edited");
      }
    });
  }

  void _deleteTodoWithConfirmation(int id) {
    setState(() {
      todos.removeWhere((todo) => todo.id == id);
      _saveTodosToPreferences();
      TodoDialogs.showToast(context, "Successfully deleted");
    });
  }

  void _searchTodos(String query) {
    setState(() {
      final filteredTabTasks = _getFilteredTodos();

      searchResults = filteredTabTasks.where((todo) {
        return todo.title.toLowerCase().contains(query.toLowerCase()) ||
            todo.description.toLowerCase().contains(query.toLowerCase());
      }).toList();

      if (searchResults.isEmpty) {
        TodoDialogs.showToast(context, "Nothing found in this tab", isError: true);
      } else {
        isSearching = true;
      }
    });
  }

  void _changeTaskStatus(Todo todo, String newStatus) {
    setState(() {
      todo.status = newStatus;
      _saveTodosToPreferences();
      TodoDialogs.showToast(context, "Task status changed to $newStatus");
    });
  }

  Future<bool> _onWillPop() async {
    if (isSearching) {
      setState(() {
        isSearching = false;
        searchResults.clear();
      });
      return false;
    } else {
      return await TodoDialogs.showExitConfirmation(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasksToDisplay = isSearching ? searchResults : _getFilteredTodos();

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            SvgPicture.asset(
              'assets/background.svg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                title: Text('ToDo'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () => TodoDialogs.showSearchTodoDialog(
                      context: context,
                      onSearch: _searchTodos,
                    ),
                  ),
                ],
                backgroundColor: Color(0xFFEEEEEE),
              ),
              body: tasksToDisplay.isEmpty
                  ? TodoDialogs.showNoTasksMessage(isSearching)
                  : TodoList(
                tasks: tasksToDisplay,
                onEdit: (todo) => TodoDialogs.showEditTodoDialog(
                  context: context,
                  todo: todo,
                  onEdit: (newTitle, newDescription) =>
                      _editTodo(todo.id, newTitle, newDescription),
                ),
                onDelete: (id) => TodoDialogs.showDeleteTodoDialog(
                  context: context,
                  id: id,
                  onDelete: () => _deleteTodoWithConfirmation(id),
                ),
                onShare: (todo) => Share.share(
                  "Task: ${todo.title}\n\nDescription: ${todo.description}",
                ),
                onChangeStatus: (todo) => TodoDialogs.showChangeStatusDialog(
                  context: context,
                  todo: todo,
                  onChangeStatus: (newStatus) =>
                      _changeTaskStatus(todo, newStatus),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () => TodoDialogs.showAddTodoDialog(
                  context: context,
                  onAdd: _addTodo,
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                    isSearching = false;
                  });
                },
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.fiber_new), label: 'New'),
                  BottomNavigationBarItem(icon: Icon(Icons.pending), label: 'Pending'),
                  BottomNavigationBarItem(icon: Icon(Icons.done), label: 'Completed'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}