import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MyApp(),
    ),
  );
}

class Task {
  String title;
  bool isDone;

  Task({
    required this.title,
    this.isDone = false,
  });
}

class TaskProvider extends ChangeNotifier {
  List<Task> tasks = [];

  void addTask(String title) {
    tasks.add(Task(title: title));
    notifyListeners();
  }

  void deleteTask(int index) {
    tasks.removeAt(index);
    notifyListeners();
  }

  void toggleTask(int index) {
    tasks[index].isDone = !tasks[index].isDone;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaskScreen(),
    );
  }
}

class TaskScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],

      appBar: AppBar(
        title: Text("Provider Task Manager"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

      body: Column(
        children: [

          SizedBox(height: 15),

          Card(
            margin: EdgeInsets.symmetric(horizontal: 15),
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Tasks",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      provider.tasks.length.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: "Enter your task",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),

                prefixIcon: Icon(Icons.task),

                suffixIcon: IconButton(
                  icon: Icon(Icons.add_circle,
                      color: Colors.blue, size: 35),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      provider.addTask(controller.text);
                      controller.clear();
                    }
                  },
                ),
              ),
            ),
          ),

          Expanded(
            child: provider.tasks.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Icon(
                    Icons.task_alt,
                    size: 100,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 20),

                  Text(
                    "No Tasks Added Yet",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: provider.tasks.length,
              itemBuilder: (context, index) {

                final task = provider.tasks[index];

                return AnimatedContainer(
                  duration: Duration(milliseconds: 400),

                  margin: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 8,
                  ),

                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: ListTile(

                      leading: Checkbox(
                        value: task.isDone,
                        onChanged: (_) {
                          provider.toggleTask(index);
                        },
                      ),

                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 18,
                          decoration: task.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),

                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          provider.deleteTask(index);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}