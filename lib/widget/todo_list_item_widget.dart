import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo2/models/todo_model.dart';
import 'package:todo2/providers/all_providers.dart';

class TodoListItemWidget extends ConsumerStatefulWidget {
  const TodoListItemWidget({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TodoListItemWidgetState();
}

class _TodoListItemWidgetState extends ConsumerState<TodoListItemWidget> {
  late FocusNode _textFocusNode;
  late TextEditingController _textController;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _textFocusNode = FocusNode();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTodoItem = ref.watch(currentTodoProvider);
    return Focus(
      onFocusChange: ((isFocused) {
        if (!isFocused) {
          setState(() {
            _hasFocus = false;
          });
          ref.read(todoListProvider.notifier).edit(
              id: currentTodoItem.id, newDescription: _textController.text);
        }
      }),
      child: ListTile(
        onTap: () {
          setState(() {
            _hasFocus = true;
            _textFocusNode.requestFocus();
            _textController.text = currentTodoItem.description;
          });
          _textFocusNode.requestFocus();
        },
        leading: Checkbox(
          activeColor: Colors.orange,
          value: currentTodoItem.completed,
          onChanged: (value) {
            ref.read(todoListProvider.notifier).toggle(currentTodoItem.id);
          },
        ),
        title: _hasFocus
            ? TextField(
                controller: _textController,
                focusNode: _textFocusNode,
              )
            : Text(currentTodoItem.description,style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),),
      ),
    );
  }
}
