import 'package:flutter/material.dart';
import '../services/todo_service.dart';

class AddToDoPage extends StatefulWidget {
  final Map<String, dynamic>? todo;

  const AddToDoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddToDoPage> createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController =
      TextEditingController();
  final TextEditingController descriptionController =
      TextEditingController();

  bool isLoading = false;

  bool get isEdit => widget.todo != null;

  @override
  void initState() {
    super.initState();

    if (isEdit) {
      titleController.text =
          widget.todo!['title']?.toString() ?? '';
      descriptionController.text =
          widget.todo!['description']?.toString() ?? '';
    }
  }

  Future<void> saveTodo() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final body = <String, dynamic>{
      'title': titleController.text.trim(),
      'description': descriptionController.text.trim(),
      'is_completed':
          widget.todo?['is_completed'] ?? false,
    };

    bool success;

    if (isEdit) {
      final id = widget.todo!['id']?.toString() ??
          widget.todo!['_id']?.toString() ??
          '';

      if (id.isEmpty) {
        success = false;
      } else {
        success = await ToDoService.updateToDo(id, body);
      }
    } else {
      success = await ToDoService.addToDo(body);
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEdit
                ? 'Data berhasil diperbarui'
                : 'Data berhasil ditambahkan',
          ),
        ),
      );

      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Gagal menyimpan data. Periksa koneksi dan API.',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit ToDo' : 'Tambah ToDo',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : saveTodo,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          isEdit
                              ? 'Simpan Perubahan'
                              : 'Tambah Data',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}