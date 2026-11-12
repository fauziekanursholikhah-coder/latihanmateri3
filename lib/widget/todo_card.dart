import 'package:flutter/material.dart';

class ToDoCard extends StatelessWidget {
  final int index;
  final Map<String, dynamic> item;
  final VoidCallback navigateEdit;
  final VoidCallback deleteById;

  const ToDoCard({
    super.key,
    required this.index,
    required this.item,
    required this.navigateEdit,
    required this.deleteById,
  });

  @override
  Widget build(BuildContext context) {
    final title = item['title']?.toString() ?? 'Tanpa Judul';
    final description =
        item['description']?.toString() ?? '';
    final isCompleted = item['is_completed'] == true;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              child: Text('${index + 1}'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(description),
                  const SizedBox(height: 6),
                  Text(
                    isCompleted ? 'Selesai' : 'Belum selesai',
                    style: TextStyle(
                      color: isCompleted
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        tooltip: 'Edit',
                        onPressed: navigateEdit,
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                      ),
                      IconButton(
                        tooltip: 'Hapus',
                        onPressed: deleteById,
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}