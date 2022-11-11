import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo2/models/todo_model.dart';
import 'package:todo2/providers/all_providers.dart';
import 'package:todo2/widget/future_provider.dart';
import 'package:todo2/widget/todo_list_item_widget.dart';
import 'package:uuid/uuid.dart';

class ToolBarWidget extends ConsumerWidget {
  ToolBarWidget({super.key});

  var _currentFilter = TodoListFilter.all;

  Color changeTextColor(TodoListFilter filt) {
    return _currentFilter == filt ? Colors.orange : Colors.black;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onCompletedTodoCount = ref.watch(unCompletedTodoCount);
    _currentFilter = ref.watch(todoListFilter);
    // ignore: no_leading_underscores_for_local_identifiers
    var _allTodos = ref.watch(filteredTodoList);
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Text(
                    onCompletedTodoCount == 0
                        ? 'All missions okay'
                        : "$onCompletedTodoCount Task not completed ",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          color: Colors.orange.shade500,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              Tooltip(
                message: 'All todos',
                child: TextButton(
                  style: TextButton.styleFrom(
                      primary: changeTextColor(TodoListFilter.all)),
                  onPressed: () {
                    ref.read(todoListFilter.notifier).state =
                        TodoListFilter.all;
                  },
                  child: Text(
                    'All',
                  ),
                ),
              ),
              Tooltip(
                message: 'Only Uncompleted Todos',
                child: TextButton(
                  style: TextButton.styleFrom(
                      primary: changeTextColor(TodoListFilter.active)),
                  onPressed: () {
                    ref.read(todoListFilter.notifier).state =
                        TodoListFilter.active;
                  },
                  child: const Text('Active'),
                ),
              ),
              Tooltip(
                message: 'Only Completed Todos',
                child: TextButton(
                  style: TextButton.styleFrom(
                      primary: changeTextColor(TodoListFilter.completed)),
                  onPressed: () {
                    ref.read(todoListFilter.notifier).state =
                        TodoListFilter.completed;
                  },
                  child: const Text('Completed'),
                ),
              ),
            ],
          ),
          _allTodos.length == 0
              ? Center(
                  child: Text(
                    'List the things you want to do',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              : const SizedBox(),
          for (var i = 0; i < _allTodos.length; i++)
            Dismissible(
              key: ValueKey(_allTodos[i].id),
              onDismissed: (_) {
                ref.read(todoListProvider.notifier).remove(_allTodos[i]);
              },
              child: ProviderScope(
                overrides: [
                  currentTodoProvider.overrideWithValue(_allTodos[i])
                ],
                child: const TodoListItemWidget(),
              ),
            ),
        ],
      ),
    );
  }
}
