import 'package:flutter/material.dart';
import 'package:flutter_simple_restful_api/controller/todo_controller.dart';
import 'package:flutter_simple_restful_api/repository/todo_repository.dart';

import '../models/todo.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var todoController = TodoController(TodoRepository());

    // mengecek status
    // todoController.fetchTodoList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Restful API'),
      ),
      body: FutureBuilder<List<Todo>>(
        future: todoController.fetchTodoList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('error'),
            );
          }

          return ListView.separated(
              itemBuilder: (context, index) {
                var todo = snapshot.data?[index];
                return Container(
                  height: 100.0,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(children: [
                    Expanded(flex: 1, child: Text('${todo?.id}')),
                    Expanded(flex: 3, child: Text('${todo?.title}')),
                    Expanded(
                        flex: 3,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                todoController
                                    .updatePatchCompleted(todo!)
                                    .then((value) => {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            content: Text('$value'),
                                          ))
                                        });
                              },
                              child: buildCallContainer('patch', Colors.orange),
                            ),
                            InkWell(
                              onTap: () {
                                todoController.updatePutCompleted(todo!);
                              },
                              child:
                                  buildCallContainer('put', Colors.blueAccent),
                            ),
                            InkWell(
                              onTap: () {
                                todoController
                                    .deleteTodo(todo!)
                                    .then((value) => {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            content: Text('$value'),
                                          ))
                                        });
                              },
                              child: buildCallContainer('del', Colors.teal),
                            ),
                          ],
                        )),
                  ]),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: 0.5,
                  height: 0.5,
                );
              },
              itemCount: snapshot.data?.length ?? 0);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Todo todo =
              Todo(userId: 5, title: 'test post data', completed: false);
          todoController.postTodo(todo);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

Container buildCallContainer(String title, Color color) {
  return Container(
    width: 40.0,
    height: 40.0,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(10.0),
    ),
    child: Center(child: Text('$title')),
  );
}
