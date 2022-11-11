import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:todo2/providers/all_providers.dart';
import 'package:todo2/widget/title_widget.dart';
import 'package:todo2/widget/todo_list_item_widget.dart';
import 'package:todo2/widget/toolbar_widget.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  MyHomePage({super.key});

  final newTodoController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var _allTodos = ref.watch(todoListProvider);
    return Scaffold(
      
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.orange.shade400,
        title: Text(
          'To Do',
          style: GoogleFonts.lato(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(100),
            bottomRight: Radius.circular(100),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(150),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(85, 20, 80, 60),
            child: TextField(
              controller: newTodoController,
              decoration: InputDecoration(
                  floatingLabelStyle: GoogleFonts.lato(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  labelText: 'What will you do today?',
                  labelStyle: GoogleFonts.lato(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  hintStyle: GoogleFonts.lato(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  hintText: 'Enter something'),
              onSubmitted: (newTodo) {
                ref.read(todoListProvider.notifier).addTodo(newTodo);
              },
            ),
          ),
        ),
      ),
      body: ToolBarWidget(),
    );
  }
}
