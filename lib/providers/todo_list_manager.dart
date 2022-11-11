import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo2/models/todo_model.dart';
import 'package:uuid/uuid.dart';

class TodoListManager extends StateNotifier<List<TodoModel>> {
  TodoListManager([List<TodoModel>? initialTodos]) : super(initialTodos ?? []);

  void addTodo(String description) {
    var eklenecekTodo = TodoModel(id: Uuid().v4(), description: description);
    state = [
      ...state,
      eklenecekTodo
    ]; // ilk baştaki elemanları tut, sonradan girin değeri gir.
  }

  void toggle(String id) {
    state = [
      for (var todo in state)
        if (todo.id == id)
          TodoModel(
              id: todo.id,
              description: todo.description,
              completed: !todo
                  .completed // true ise false - false ise true çevirir. yepyeni bir todo model eklenicek.

              )
        else
          todo
    ];
  }

  void edit({required String id, required String newDescription}) {
    state = [
      for (var todo in state)
        if (todo.id == id)
          TodoModel(
              id: todo.id,
              completed: todo.completed,
              description: newDescription)
        else
          todo
    ];
  }

  void remove(TodoModel silinecekTodo) {
    state = state.where((element) => element.id != silinecekTodo.id).toList();
  }

  int onCompletedToDoCount() {
    return state.where((element) => !element.completed).length;
  }
}
