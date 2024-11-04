import 'package:appwrite/appwrite.dart';
import 'package:finance_90s_baby/constants.dart';

class StorageAPI {
  final Storage storage;

  StorageAPI(this.storage);

  Future<String> getLessonContent(String fileId) async {
    final result = await storage.getFileView(
      bucketId: AppConstants.bucketIdLessonContent,
      fileId: fileId,
    );
    return String.fromCharCodes(result);
  }
}