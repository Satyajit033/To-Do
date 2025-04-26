import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoList extends StatelessWidget {
  final List<Todo> tasks;
  final Function(Todo) onEdit;
  final Function(int) onDelete;
  final Function(Todo) onShare;
  final Function(Todo) onChangeStatus;

  TodoList({
    required this.tasks,
    required this.onEdit,
    required this.onDelete,
    required this.onShare,
    required this.onChangeStatus,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final todo = tasks[index];
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
            onLongPress: () => onChangeStatus(todo),
            child: Container(
              child: ListTile(
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
                  offset: Offset(16, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => onEdit(todo),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => onDelete(todo.id),
                      ),
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () => onShare(todo),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}