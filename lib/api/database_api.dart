import 'package:appwrite/appwrite.dart';
import 'package:finance_90s_baby/constants.dart';

class DatabaseAPI {
  final Databases databases;

  DatabaseAPI(this.databases);

  Future<List> getLessons() async {
    final response = await databases.listDocuments(
      databaseId: AppConstants.databaseId,
      collectionId: AppConstants.lessonsCollectionId,
    );
    return response.documents;
  }

  Future<void> addComment(String lessonId, String comment) async {
    await databases.createDocument(
      databaseId: AppConstants.databaseId,
      collectionId: 'comments_collection_id',
      documentId: 'unique()',
      data: {
        'lessonId': lessonId,
        'comment': comment,
      },
    );
  }
}
