import 'package:flutter/foundation.dart';
import '../models/upload_item.dart';

class UploadQueue extends ChangeNotifier {
  final List<UploadItem> _items = [];

  List<UploadItem> get items => List.unmodifiable(_items);

  void addItem(UploadItem item) {
    _items.add(item);
    notifyListeners();
  }

  void updateProgress(String id, int uploadedBytes) {
    final item = _items.firstWhere((i) => i.id == id);
    item.uploadedBytes = uploadedBytes;
    item.status = UploadStatus.uploading;
    notifyListeners();
  }

  void markSuccess(String id) {
    final item = _items.firstWhere((i) => i.id == id);
    item.status = UploadStatus.success;
    notifyListeners();
  }

  void resetForRetry(String id) {
    final item = _items.firstWhere((i) => i.id == id);
    item.status = UploadStatus.queued;
    item.uploadedBytes = 0;
    item.errorMessage = null;
    notifyListeners();
  }

  void markFailed(String id, String error) {
    final item = _items.firstWhere((i) => i.id == id);
    item.status = UploadStatus.failed;
    item.errorMessage = error;
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((i) => i.id == id);
    notifyListeners();
  }

  void clearCompleted() {
    _items.removeWhere((i) => i.status == UploadStatus.success);
    notifyListeners();
  }
}
