import 'package:appwrite/appwrite.dart';
import 'package:file_picker/file_picker.dart';
import 'package:finance_90s_baby/constants.dart';

class StorageAPI {
  final Storage storage;

  StorageAPI(this.storage);

  /// Fetches the content of a lesson file from Appwrite Storage.
  Future<String?> getLessonContent(String fileId) async {
    try {
      final result = await storage.getFileView(
        bucketId: AppConstants.bucketIdLessonContent,
        fileId: fileId,
      );
      return String.fromCharCodes(result);
    } catch (e) {
      print("Error retrieving lesson content: $e");
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

  /// Uploads a selected file to Appwrite Storage.
  Future<String?> uploadFile(PlatformFile file) async {
    try {
      final result = await storage.createFile(
        bucketId: AppConstants.bucketIdLessonContent,
        fileId: ID.unique(),
        file: InputFile(path: file.path, filename: file.name),
      );
      return result.$id;
    } catch (e) {
      print("Error uploading file: $e");
      return null;
    }
  }
}