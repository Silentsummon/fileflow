import 'dart:io';
import 'settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/upload_queue.dart';
import '../models/upload_item.dart';
import '../widgets/drop_zone.dart';
import '../services/api_client.dart';
import '../services/settings_service.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  static const List<String> categories = [
    'Documents',
    'Photos',
    'Videos',
    'Other',
  ];

  String _selectedCategory = categories.first;

  Future<void> _uploadFile(UploadItem item) async {
    final queue = context.read<UploadQueue>();
    final url = await SettingsService.getBackendUrl();
    final apiKey = await SettingsService.getApiKey();
    final client = ApiClient(baseUrl: url, apiKey: apiKey);

    try {
      await client.uploadFile(
        filePath: item.filePath,
        fileName: item.fileName,
        category: item.category,
        onProgress: (sent, total) {
          queue.updateProgress(item.id, sent);
        },
      );
      queue.markSuccess(item.id);
    } catch (e) {
      queue.markFailed(item.id, e.toString());
    }
  }

  void _handleFilesDropped(List<File> files) {
    final queue = context.read<UploadQueue>();
    for (final file in files) {
      final stat = file.statSync();
      final item = UploadItem(
        id: '${DateTime.now().microsecondsSinceEpoch}_${file.path}',
        filePath: file.path,
        fileName: file.uri.pathSegments.last,
        category: _selectedCategory,
        totalBytes: stat.size,
      );
      queue.addItem(item);
      _uploadFile(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    final queue = context.watch<UploadQueue>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('FileFlow'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text('Upload as: '),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedCategory,
                  items: categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedCategory = value);
                    }
                  },
                ),
              ],
            ),
          ),
          DropZone(onFilesDropped: _handleFilesDropped),
          Expanded(
            child: queue.items.isEmpty
                ? const Center(
                    child: Text('No uploads yet. Drag a file above to start.'),
                  )
                : ListView.builder(
                    itemCount: queue.items.length,
                    itemBuilder: (context, index) {
                      final item = queue.items[index];
                      return ListTile(
                        title: Text(item.fileName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${item.status.name} • ${item.category}'),
                            if (item.status == UploadStatus.uploading ||
                                item.status == UploadStatus.success)
                              LinearProgressIndicator(value: item.progress),
                            if (item.status == UploadStatus.failed) ...[
                              Text(
                                item.errorMessage ?? 'Upload failed',
                                style: const TextStyle(color: Colors.redAccent),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  context.read<UploadQueue>().resetForRetry(item.id);
                                  _uploadFile(item);
                                },
                                icon: const Icon(Icons.refresh, size: 18),
                                label: const Text('Retry'),
                              ),
                            ],
                          ],
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
