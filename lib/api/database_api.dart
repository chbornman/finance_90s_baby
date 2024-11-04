import 'package:appwrite/appwrite.dart';
import 'package:finance_90s_baby/constants.dart';

class DatabaseAPI {
  final Databases databases;

  DatabaseAPI(this.databases);

  /// Retrieves a list of lessons from the Appwrite database.
  Future<List> getLessons() async {
    try {
      final response = await databases.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.lessonsCollectionId,
      );
      return response.documents;
    } catch (e) {
      print("Error fetching lessons: $e");
      return [];
    }
  }

  /// Adds a new lesson document to the database.
  Future<void> addLesson(Map<String, dynamic> lessonData) async {
    try {
      await databases.createDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.lessonsCollectionId,
        documentId: ID.unique(),
        data: lessonData,
      );
    } catch (e) {
      print("Error adding lesson: $e");
    }
  }

  /// Adds a comment to a specific lesson in the feedback collection.
  Future<void> addComment(String lessonId, String comment) async {
    try {
      await databases.createDocument(
        databaseId: AppConstants.databaseId,
        collectionId: 'finance90sbaby-feedback',
        documentId: ID.unique(),
        data: {
          'lessonId': lessonId,
          'comment': comment,
        },
      );
    } catch (e) {
      print("Error adding comment: $e");
    }
  }
}