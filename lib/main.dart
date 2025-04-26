import 'dart:convert';
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(MaterialApp(
    home: SplashScreen(),
    debugShowCheckedModeBanner: false, // Remove debug banner
  ));
}

/*
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to TodoApp after 2 seconds
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => TodoApp()),
      );
    });

    // Change the color of the system status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xFFEEEEEE), // Set status bar color to match list tile color
      statusBarIconBrightness: Brightness.dark, // Set icons color to dark
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
          SvgPicture.asset(
            'assets/background.svg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 70,
                  width: 70,
                  child: Image.asset(
                    'assets/checklist.png',
                  ),
                ),
                Text(
                  "ToDo",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Version : 1.0",
              ),
            ),
          ),
        ]));
  }
}

class Todo {
  int id;
  String title;
  String description;
  String createdAt;
  String status;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'created_at': createdAt,
    'status': status,
  };

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: json['created_at'],
      status: json['status'],
    );
  }
}

class TodoApp extends StatefulWidget {
  @override
  _TodoAppState createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<Todo> todos = [];
  List<Todo> searchResults = [];
  int _currentIndex = 0; // To track the selected tab (New, Pending, Completed)
  bool isSearching = false; // Flag to track if search mode is active

  @override
  void initState() {
    super.initState();
    _loadTodosFromPreferences(); // Load tasks from SharedPreferences
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

  Future<void> _loadTodos() async {
    final file = await _getLocalFile();
    if (!file.existsSync()) return;
    final csvString = await file.readAsString();
    List<List<dynamic>> rows = const CsvToListConverter().convert(csvString);
    setState(() {
      todos = rows.map((row) => Todo(
        id: int.parse(row[0].toString()),
        title: row[1],
        description: row[2],
        createdAt: row[3],
        status: row[4],
      )).toList();
    });
  }

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/todos.csv');
  }

  Future<void> _loadTodosFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTodos = prefs.getString('todos'); // Retrieve tasks as a JSON string
    if (savedTodos != null) {
      final List<dynamic> decodedTodos = jsonDecode(savedTodos); // Decode JSON
      setState(() {
        todos = decodedTodos.map((todo) => Todo.fromJson(todo)).toList();
      });
    }
  }

  Future<void> _saveTodosToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedTodos = jsonEncode(todos.map((todo) => todo.toJson()).toList());
    await prefs.setString('todos', encodedTodos); // Save as a JSON string
  }

  Future<void> _saveTodos() async {
    final file = await _getLocalFile();
    List<List<dynamic>> rows = todos.map((todo) => [
      todo.id,
      todo.title,
      todo.description,
      todo.createdAt,
      todo.status
    ]).toList();
    String csv = const ListToCsvConverter().convert(rows);
    await file.writeAsString(csv);
  }

  void _addTodo(String title, String description) {
    if (title.isEmpty || description.isEmpty) {
      Fluttertoast.showToast(
        msg: "Title and Description cannot be empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
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
      _saveTodosToPreferences(); // Save to SharedPreferences
      Fluttertoast.showToast(
        msg: "Successfully added",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }

  void _editTodo(int id, String newTitle, String newDescription) {
    if (newTitle.isEmpty || newDescription.isEmpty) {
      Fluttertoast.showToast(
        msg: "Title and Description cannot be empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }
    setState(() {
      final index = todos.indexWhere((todo) => todo.id == id);
      if (index != -1) {
        todos[index].title = newTitle;
        todos[index].description = newDescription;
        _saveTodosToPreferences(); // Save changes to SharedPreferences
        Fluttertoast.showToast(
          msg: "Successfully edited",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    });
  }

  void _showEditTodoDialog(Todo todo) {
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
                decoration: InputDecoration(labelText: 'Title')),
            TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _editTodo(
                  todo.id, titleController.text, descriptionController.text);
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteTodoDialog(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Warning !'),
        content: Text('Once you delete, you cannot get it back.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No',
              style: TextStyle(fontSize: 16),
            ),
          ),
          TextButton(
            onPressed: () {
              _deleteTodoWithConfirmation(id);
              Navigator.pop(context);
            },
            child: Text(
              'Yes',
              style: TextStyle(fontSize: 16,color:Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteTodoWithConfirmation(int id) {
    setState(() {
      todos.removeWhere((todo) => todo.id == id);
      _saveTodosToPreferences(); // Save changes to SharedPreferences
      Fluttertoast.showToast(
        msg: "Successfully deleted",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }

  void _showAddTodoDialog() {
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
                decoration: InputDecoration(labelText: 'Title')),
            TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _addTodo(titleController.text, descriptionController.text);
              if (titleController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty) {
                Navigator.pop(context);
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showShareBottomSheet(Todo todo) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Share Task",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.title),
                title: Text("Title"),
                subtitle: Text(todo.title),
              ),
              ListTile(
                leading: Icon(Icons.description),
                title: Text("Description"),
                subtitle: Text(todo.description),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.share),
                label: Text("Share"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // Share the title and description
                  Share.share("Task: ${todo.title}\n\nDescription: ${todo.description}");
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSearchTodoDialog() {
    TextEditingController searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Search Todo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: searchController,
                decoration: InputDecoration(labelText: 'Search')),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _searchTodos(searchController.text);
              Navigator.pop(context);
            },
            child: Text('Search'),
          ),
        ],
      ),
    );
  }

  void _searchTodos(String query) {
    setState(() {
      // Get tasks only from the current tab
      final filteredTabTasks = _getFilteredTodos();

      // Filter the tasks of the current tab based on the title and description
      searchResults = filteredTabTasks.where((todo) {
        return todo.title.toLowerCase().contains(query.toLowerCase()) ||
            todo.description.toLowerCase().contains(query.toLowerCase());
      }).toList();

      // If no match is found, show a toast message
      if (searchResults.isEmpty) {
        Fluttertoast.showToast(
          msg: "Nothing found in this tab",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        isSearching = true; // Enable search mode
      }
    });
  }

  void _changeTaskStatus(Todo todo, String newStatus) {
    setState(() {
      todo.status = newStatus;
      _saveTodosToPreferences(); // Save changes to SharedPreferences
      Fluttertoast.showToast(
        msg: "Task status changed to $newStatus",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }

  void _showChangeStatusDialog(Todo todo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Change Task Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                _changeTaskStatus(todo, 'new'); // Change status to "New"
                Navigator.pop(context);
              },
              child: Text('New'),
            ),
            TextButton(
              onPressed: () {
                _changeTaskStatus(todo, 'pending'); // Change status to "Pending"
                Navigator.pop(context);
              },
              child: Text('Pending'),
            ),
            TextButton(
              onPressed: () {
                _changeTaskStatus(todo, 'completed'); // Change status to "Completed"
                Navigator.pop(context);
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
  Future<bool> _onWillPop() async {
    if (isSearching) {
      setState(() {
        isSearching = false; // Exit search mode
        searchResults.clear(); // Clear search results
      });
      return false; // Do not exit the app
    } else {
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
  }

  @override
  Widget build(BuildContext context) {
    // Determine the tasks to display based on the current state
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
                  Container(
                    margin: EdgeInsets.only(right: 4), // Add margin to the right
                    child: IconButton(
                      icon: Icon(Icons.search, size: 27),
                      onPressed: _showSearchTodoDialog,
                    ),
                  ),
                ],
                backgroundColor: Color(0xFFEEEEEE), // Set background color to match list tile color
                elevation: 4, // Set elevation
                shadowColor: Colors.black26, // Set shadow color
              ),
              body: tasksToDisplay.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/no-task.png', // Replace with your image path
                      width: 100, // Set the width of the image
                      height: 100, // Set the height of the image
                    ),
                    SizedBox(height: 16),
                    Text(
                      isSearching ? "No tasks found in this tab" : "No tasks available",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ) : ListView.builder(
                itemCount: tasksToDisplay.length,
                itemBuilder: (context, index) {
                  final todo = tasksToDisplay[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    */
/*padding: EdgeInsets.all(5),*//*

                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onLongPress: () => _showChangeStatusDialog(todo),
                      child: Container(
                        child: ListTile(
                          */
/*contentPadding: EdgeInsets.symmetric(horizontal: 12),*//*

                          leading: Container(
                            alignment: Alignment.center,
                            width: 20,
                            child: Text(
                              todo.id.toString(),
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                todo.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                todo.description,
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Created: ${todo.createdAt}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          trailing: Transform.translate(
                            offset: Offset(16, 0), // Move 10 pixels to the right (X-axis)
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _showEditTodoDialog(todo),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _showDeleteTodoDialog(todo.id),
                                ),
                                IconButton(
                                  icon: Icon(Icons.share),
                                  onPressed: () {
                                    Share.share("Task: ${todo.title}\n\nDescription: ${todo.description}");
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: _showAddTodoDialog,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                    isSearching = false; // Exit search mode when switching tabs
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.fiber_new),
                    label: 'New',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.pending),
                    label: 'Pending',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.done),
                    label: 'Completed',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoAppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TodoApp();
  }
}*/
