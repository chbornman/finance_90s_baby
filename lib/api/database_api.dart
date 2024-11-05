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
      LogService.instance
          .error("Lesson with ID $lessonId deleted successfully.");
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

  /// Updates the 'completed' status of a specific lesson in the lessons collection.
  Future<void> updateLessonCompletion(String lessonId, bool? completed) async {
    try {
      await database.updateDocument(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.lessonsCollectionId,
        documentId: lessonId,
        data: {
          'completed': completed,
        },
      );
      LogService.instance.info(
          "Lesson with ID $lessonId completion status updated to $completed.");
    } catch (e) {
      LogService.instance.error("Error updating lesson completion status: $e");
    }
  }

  /// Marks a lesson as completed or uncompleted for a specific user.
  Future<void> markLessonCompleted(
      String userId, String lessonId, bool completed) async {
    try {
      // Query for existing progress document for this user and lesson
      final response = await database.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants
            .userProgressCollectionId, // Collection for user progress
        queries: [
          Query.equal('userId', userId),
          Query.equal('lessonId', lessonId),
        ],
      );

      if (response.documents.isNotEmpty) {
        // Update the existing document
        await database.updateDocument(
          databaseId: AppConstants.databaseId,
          collectionId: AppConstants.userProgressCollectionId,
          documentId: response.documents.first.$id,
          data: {'completed': completed},
        );
      } else {
        // Create a new progress document if none exists
        await database.createDocument(
          databaseId: AppConstants.databaseId,
          collectionId: AppConstants.userProgressCollectionId,
          documentId: ID.unique(),
          data: {
            'userId': userId,
            'lessonId': lessonId,
            'completed': completed,
          },
        );
      }

      LogService.instance.info(
          "User $userId marked lesson $lessonId as completed: $completed.");
    } catch (e) {
      LogService.instance
          .error("Error marking lesson as completed for user $userId: $e");
    }
  }

  /// Checks if a lesson is completed by a specific user.
  Future<bool> isLessonCompleted(String userId, String lessonId) async {
    try {
      // Query for the progress document for this user and lesson
      final response = await database.listDocuments(
        databaseId: AppConstants.databaseId,
        collectionId: AppConstants.userProgressCollectionId,
        queries: [
          Query.equal('userId', userId),
          Query.equal('lessonId', lessonId),
        ],
      );

      // Check if a document exists and return its 'completed' status
      if (response.documents.isNotEmpty) {
        return response.documents.first.data['completed'] ?? false;
      }

      return false; // Return false if no document exists
    } catch (e) {
      LogService.instance.error(
          "Error checking completion status for user $userId on lesson $lessonId: $e");
      return false;
    }
  }
}
