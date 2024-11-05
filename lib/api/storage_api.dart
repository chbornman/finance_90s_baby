import 'package:appwrite/appwrite.dart';
import 'package:file_picker/file_picker.dart';
import 'package:finance_90s_baby/constants.dart';
import 'package:finance_90s_baby/log_service.dart';

class StorageAPI {
  final Storage storage;

  StorageAPI(this.storage);

  /// Fetches the content of a lesson file from Appwrite Storage using the fileId.
  Future<String?> getLessonContent(String fileId) async {
    try {
      final result = await storage.getFileView(
        bucketId: AppConstants.bucketIdLessonContent,
        fileId: fileId,
      );
      return String.fromCharCodes(result);
    } catch (e) {
      LogService.instance.error(fileId);
      LogService.instance.error("Error retrieving lesson content: $e");
      return null;
    }
  }

  /// Allows user to select a file from the device.
  Future<PlatformFile?> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      return result.files.first;
    }
    return null;
  }

  /// Uploads a selected file to Appwrite Storage and returns the fileId.
  Future<String?> uploadFile(PlatformFile file) async {
    try {
      final result = await storage.createFile(
        bucketId: AppConstants.bucketIdLessonContent,
        fileId: ID.unique(),
        file: InputFile(path: file.path, filename: file.name),
      );
      return result.$id; // Return the fileId after upload
    } catch (e) {
      LogService.instance.error("Error uploading file: $e");
      return null;
    }
  }

  /// Deletes a file from Appwrite Storage using the fileId.
  Future<void> deleteFile(String fileId) async {
    try {
      await storage.deleteFile(
        bucketId: AppConstants.bucketIdLessonContent,
        fileId: fileId,
      );
      LogService.instance.error("File with ID $fileId deleted successfully.");
    } catch (e) {
      LogService.instance.error("Error deleting file: $e");
    }
  }
}
