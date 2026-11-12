import 'package:flutter/material.dart';
import '../services/todo_service.dart';
import '../widget/todo_card.dart';
import 'add_page.dart';

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  List<dynamic> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  // Mengambil data dari API
  Future<void> fetchTodo() async {
    setState(() {
      isLoading = true;
    });

    final response = await ToDoService.fetchTodo();

    if (!mounted) return;

    setState(() {
      items = response ?? [];
      isLoading = false;
    });

    if (response == null) {
      showMessage('Gagal mengambil data dari server');
    }
  }

  // Membuka halaman tambah data
  Future<void> navigateToAddPage() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddToDoPage(),
      ),
    );

    if (result == true) {
      await fetchTodo();
    }
  }

  // Membuka halaman edit data
  Future<void> navigateToEditPage(
    Map<String, dynamic> item,
  ) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => AddToDoPage(todo: item),
      ),
    );

    if (result == true) {
      await fetchTodo();
    }
  }

  // Menghapus data berdasarkan ID
  Future<void> deleteById(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus ToDo'),
        content: const Text(
          'Apakah kamu yakin ingin menghapus data ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await ToDoService.deleteById(id);

    if (!mounted) return;

    if (success) {
      showMessage('Data berhasil dihapus');
      await fetchTodo();
    } else {
      showMessage('Gagal menghapus data');
    }
  }

  // Menampilkan pesan
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Note - ToDo List'),
        actions: [
          IconButton(
            onPressed: fetchTodo,
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat ulang',
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : items.isEmpty
              ? const Center(
                  child: Text('Belum ada data ToDo'),
                )
              : RefreshIndicator(
                  onRefresh: fetchTodo,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = Map<String, dynamic>.from(
                        items[index] as Map,
                      );

                      final id = item['id']?.toString() ??
                          item['_id']?.toString() ??
                          '';

                      return ToDoCard(
                        index: index,
                        item: item,
                        navigateEdit: () {
                          navigateToEditPage(item);
                        },
                        deleteById: () {
                          if (id.isEmpty) {
                            showMessage(
                              'ID data tidak ditemukan',
                            );
                          } else {
                            deleteById(id);
                          }
                        },
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        icon: const Icon(Icons.add),
        label: const Text('Tambah ToDo'),
      ),
    );
  }
}