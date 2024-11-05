import 'package:appwrite/appwrite.dart';
import 'package:finance_90s_baby/constants.dart';
import 'package:finance_90s_baby/log_service.dart';

class DatabaseAPI {
  final Databases database;

  DatabaseAPI(this.database);

  /// Retrieves a list of lessons from the Appwrite database.
  Future<List<Map<String, dynamic>>> getLessons() async {
    try {
      final response = await database.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.lessonsCollectionId,
      );

      // Convert each Document to a Map<String, dynamic>
      return response.documents.map((doc) => doc.data).toList();
    } catch (e) {
      LogService.instance.error("Error fetching lessons: $e");
      return [];
    }
  }

  /// Adds a new lesson to the lessons collection in the Appwrite database, including fileId.
  Future<void> addLesson({
    required String title,
    required String fileUrl,
    required String fileId, // Added fileId as a parameter
  }) async {
    try {
      await database.createDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.lessonsCollectionId,
        documentId: ID.unique(),
        data: {
          'title': title,
          'fileUrl': fileUrl,
          'fileId': fileId, // Store fileId in the document
        },
      );
    } catch (e) {
      LogService.instance.error("Error adding lesson: $e");
    }
  }

  /// Adds a comment to a specific lesson in the feedback collection.
  Future<void> addComment(
      String lessonId, String userId, String commentText) async {
    try {
      await database.createDocument(
        databaseId: AppConstants.databaseId,
        collectionId: 'finance90sbaby-feedback',
        documentId: ID.unique(),
        data: {
          'lessonId': lessonId,
          'userId': userId,
          'comment': commentText,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      LogService.instance.error("Error adding comment: $e");
    }
  }

  /// Retrieves feedback for all lessons from the feedback collection.
  Future<List<Map<String, dynamic>>> getFeedback() async {
    try {
      final response = await database.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: 'finance90sbaby-feedback',
      );
      return response.documents.map((doc) => doc.data).toList();
    } catch (e) {
      LogService.instance.error("Error fetching feedback: $e");
      return [];
    }
  }

  /// Deletes a lesson from the lessons collection in the Appwrite database.
  Future<void> deleteLesson(String lessonId) async {
    try {
      await database.deleteDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.lessonsCollectionId,
        documentId: lessonId,
      );
      LogService.instance.error("Lesson with ID $lessonId deleted successfully.");
    } catch (e) {
      LogService.instance.error("Error deleting lesson: $e");
    }
  }

  /// Retrieves comments for a specific lesson from the feedback collection.
  Future<List<Map<String, dynamic>>> getCommentsForLesson(
      String lessonId) async {
    try {
      final response = await database.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: 'finance90sbaby-feedback',
        queries: [
          Query.equal('lessonId', lessonId),
        ],
      );
      return response.documents.map((doc) => doc.data).toList();
    } catch (e) {
      LogService.instance.error("Error fetching comments for lesson: $e");
      return [];
    }
  }
}
