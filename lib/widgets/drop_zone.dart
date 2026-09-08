import 'dart:io';
import 'package:flutter/material.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';

class DropZone extends StatefulWidget {
  final void Function(List<File> files) onFilesDropped;

  const DropZone({super.key, required this.onFilesDropped});

  @override
  State<DropZone> createState() => _DropZoneState();
}

class _DropZoneState extends State<DropZone> {
  bool _isDragging = false;

  Future<void> _browseFiles() async {
    final platformFiles = await FilePicker.pickFiles(allowMultiple: true);

    final files = platformFiles
        .where((f) => f.path != null)
        .map((f) => File(f.path!))
        .toList();

    if (files.isNotEmpty) {
      widget.onFilesDropped(files);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragEntered: (_) => setState(() => _isDragging = true),
      onDragExited: (_) => setState(() => _isDragging = false),
      onDragDone: (details) {
        setState(() => _isDragging = false);
        final files = details.files.map((f) => File(f.path)).toList();
        widget.onFilesDropped(files);
      },
      child: Container(
        width: double.infinity,
        height: 180,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isDragging ? Colors.indigoAccent : Colors.grey,
            width: 2,
          ),
          color: _isDragging
              ? Colors.indigoAccent.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _isDragging ? 'Drop it!' : 'Drag files here to upload',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Text('or', style: TextStyle(color: Colors.grey.shade500)),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _browseFiles,
                icon: const Icon(Icons.folder_open),
                label: const Text('Browse files'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
