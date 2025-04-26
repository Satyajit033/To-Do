import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/todo.dart';

class LocalStorage {
  static const String _keyTodos = 'todos';

  static Future<List<Todo>?> getTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTodos = prefs.getString(_keyTodos);
    if (savedTodos != null) {
      final List<dynamic> decodedTodos = jsonDecode(savedTodos);
      return decodedTodos.map((todo) => Todo.fromJson(todo)).toList();
    }
    return null;
  }

  static Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedTodos =
    jsonEncode(todos.map((todo) => todo.toJson()).toList());
    await prefs.setString(_keyTodos, encodedTodos);
  }
}