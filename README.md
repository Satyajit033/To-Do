# ToDo App

A simple and elegant Flutter-based ToDo application to manage your daily tasks with ease.

## Features

- **Task Management**: Create, edit, and delete tasks
- **Task Status**: Mark tasks as New, Pending, or Completed
- **Search Functionality**: Find tasks quickly with search
- **Data Persistence**: Tasks are saved locally using SharedPreferences
- **Sharing**: Share tasks with others
- **Beautiful UI**: Clean interface with SVG background
- **Responsive Design**: Works on both mobile and tablet devices

## Installation

1. Ensure you have Flutter installed on your machine. If not, follow the [official installation guide](https://flutter.dev/docs/get-started/install).
2. Clone this repository:
   ```bash
   git clone https://github.com/Satyajit033/To-Do.git
   ```
3. Navigate to the project directory:
   ```bash
   cd todo-app
   ```
4. Install dependencies:
   ```bash
   flutter pub get
   ```
5. Run the app:
   ```bash
   flutter run
   ```

## Usage

### Adding a Task
1. Tap the floating action button (+) at the bottom right
2. Enter task title and description
3. Tap "Save"

### Editing a Task
1. Tap the edit icon (pencil) on any task
2. Modify the title or description
3. Tap "Save"

### Deleting a Task
1. Tap the delete icon (trash can) on any task
2. Confirm deletion by tapping "Yes"

### Changing Task Status
1. Long-press on any task
2. Select the new status (New, Pending, or Completed)

### Searching Tasks
1. Tap the search icon in the app bar
2. Enter your search query
3. Tap "Search"

### Sharing Tasks
1. Tap the share icon on any task
2. Choose your preferred sharing method

## Technical Details

- **State Management**: Uses basic Flutter state management (setState)
- **Data Storage**: SharedPreferences for persistent storage
- **Dependencies**:
  - flutter_svg: For SVG rendering
  - shared_preferences: For local data persistence
  - csv: For CSV operations (though currently not used as primary storage)
  - fluttertoast: For showing toast messages
  - share_plus: For task sharing functionality


## Folder Structure

```
assets/
├── background.svg
├── checklist.png
└── no-task.png

lib/
├── models/
│   └── todo.dart
├── screens/
│   ├── splash_screen.dart
│   └── todo_app.dart
├── utils/
│   └── local_storage.dart
├── widgets/
│   ├── todo_dialogs.dart
│   └── todo_list.dart
└── main.dart
```


## Screens

1. **Splash Screen**: Shows app logo and version
2. **Main Screen**: Displays tasks in three tabs (New, Pending, Completed)
   - Floating action button for adding new tasks
   - Search functionality in app bar

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Support

If you encounter any issues or have suggestions, please open an issue on GitHub.

**Version**: 1.0  


Screenshots:

![image](https://github.com/user-attachments/assets/71688581-1333-4d3f-8cf8-cd64df22818d)
![image](https://github.com/user-attachments/assets/d39d6835-4f48-4188-9729-9fbea6508d81)
![image](https://github.com/user-attachments/assets/71ff7e63-2b8a-4059-85a0-db2ca17daa3d)
![image](https://github.com/user-attachments/assets/5cf7456f-c7f1-4ef9-96c2-8218518730c0)
![image](https://github.com/user-attachments/assets/509bc8d3-48db-4593-9f09-af31500ab60c)
![image](https://github.com/user-attachments/assets/7f03bc75-03a9-4145-9cca-bf294c26650b)
![image](https://github.com/user-attachments/assets/b92f9199-0752-4422-9d57-8f7ec140d070)
![image](https://github.com/user-attachments/assets/46f09815-fdde-4542-a14e-0f175a3aa74f)
![image](https://github.com/user-attachments/assets/52e6390f-3736-4709-aecd-c97dbf2162c3)


