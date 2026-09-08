enum UploadStatus { queued, uploading, success, failed }

class UploadItem {
  final String id;          // unique id (e.g. timestamp + filename)
  final String filePath;    // full path on disk
  final String fileName;    // just the display name
  final String category;    // user-selected category/tag
  final int totalBytes;     // file size, for progress %
  int uploadedBytes;        // how much has been sent so far
  UploadStatus status;
  String? errorMessage;     // set only if status == failed

  UploadItem({
    required this.id,
    required this.filePath,
    required this.fileName,
    required this.category,
    required this.totalBytes,
    this.uploadedBytes = 0,
    this.status = UploadStatus.queued,
    this.errorMessage,
  });

  double get progress =>
      totalBytes == 0 ? 0.0 : uploadedBytes / totalBytes;
}
