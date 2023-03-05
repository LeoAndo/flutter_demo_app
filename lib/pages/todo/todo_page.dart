import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_app/domain/models/todo.dart';
import 'package:simple_app/pages/todo/todo_viewmodel.dart';

class TodoPage extends HookConsumerWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(todoViewModelProvider);
    useFuture(useMemoized(() => viewModel.fetchTodoList()));
    final textEditingController = ref.watch(textControllerStateProvider);

    final uiState =
        ref.watch(todoViewModelProvider.select((value) => value.uiState));

    final Widget widget = uiState.when(
        (values) => _buildSuccessWidget(
              values,
              editController: textEditingController,
              onTapCardItem: (id) => viewModel.updateTodoData(id: id),
              onPressedAddButton: () => {
                if (textEditingController.text.isNotEmpty)
                  {
                    viewModel.addTodoData(
                        title: textEditingController.text, done: false)
                  }
              },
              onPressedDeleteButton: () => viewModel.deleteTodoItems(),
            ),
        initial: () => Container(),
        error: (error) => Center(child: Text(error)));
    return widget;
  }

  _buildSuccessWidget(
    List<Todo> _todoList, {
    required TextEditingController editController,
    required void Function(int) onTapCardItem,
    required void Function() onPressedAddButton,
    required void Function() onPressedDeleteButton,
  }) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: editController,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'todo memo',
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: _todoList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = _todoList[index];
                    return GestureDetector(
                      child: Card(
                        child: ListTile(
                          title: Text(item.title ?? ""),
                          subtitle: Text('isDone: ${item.done}'),
                        ),
                      ),
                      onTap: () => onTapCardItem(item.id!),
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: () => onPressedAddButton(),
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            height: 16,
          ),
          FloatingActionButton(
            onPressed: () => onPressedDeleteButton(),
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
