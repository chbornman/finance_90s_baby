import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:finance_90s_baby/screens/lesson_screen.dart';
import 'package:finance_90s_baby/widgets/comment_section.dart';

import 'api_mocks.mocks.dart';

void main() {
  // Define mock instances
  late MockStorageAPI mockStorageAPI;
  late MockDatabaseAPI mockDatabaseAPI;

  // Sample lesson data
  final sampleLesson = {
    'title': 'Test Lesson',
    'fileId': 'fileId123',
    '\$id': 'lessonId123',
  };

  setUp(() {
    // Initialize mocks before each test
    mockStorageAPI = MockStorageAPI();
    mockDatabaseAPI = MockDatabaseAPI();
  });

  testWidgets('displays loading indicator while fetching content',
      (WidgetTester tester) async {
    // Arrange: Set up mock to simulate loading state
    when(mockStorageAPI.getLessonContent(any))
        .thenAnswer((_) async => Future.delayed(const Duration(seconds: 2)));

    // Act: Build the LessonScreen widget
    await tester.pumpWidget(
      MaterialApp(
        home: LessonScreen(
          storageAPI: mockStorageAPI,
          databaseAPI: mockDatabaseAPI,
          lesson: sampleLesson,
        ),
      ),
    );

    // Assert: Verify loading indicator is displayed
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('displays lesson content once loaded', (WidgetTester tester) async {
    // Arrange: Mock lesson content
    when(mockStorageAPI.getLessonContent(any)).thenAnswer((_) async => 'Lesson content here.');

    // Act: Build the LessonScreen widget and trigger frame
    await tester.pumpWidget(
      MaterialApp(
        home: LessonScreen(
          storageAPI: mockStorageAPI,
          databaseAPI: mockDatabaseAPI,
          lesson: sampleLesson,
        ),
      ),
    );

    // Wait for FutureBuilder to complete
    await tester.pumpAndSettle();

    // Assert: Verify the content is displayed
    expect(find.text('Lesson content here.'), findsOneWidget);
    expect(find.byType(CommentSection), findsOneWidget);
  });

  testWidgets('displays comment section with correct lessonId', (WidgetTester tester) async {
    // Arrange: Mock lesson content
    when(mockStorageAPI.getLessonContent(any)).thenAnswer((_) async => 'Lesson content here.');

    // Act: Build the LessonScreen widget and trigger frame
    await tester.pumpWidget(
      MaterialApp(
        home: LessonScreen(
          storageAPI: mockStorageAPI,
          databaseAPI: mockDatabaseAPI,
          lesson: sampleLesson,
        ),
      ),
    );

    // Wait for FutureBuilder to complete
    await tester.pumpAndSettle();

    // Assert: Verify CommentSection is present with lesson ID
    final commentSectionFinder = find.byType(CommentSection);
    expect(commentSectionFinder, findsOneWidget);

    // Additional check: Confirm that CommentSection was given the correct lessonId
    CommentSection commentSectionWidget =
        tester.widget(commentSectionFinder) as CommentSection;
    expect(commentSectionWidget.lessonId, 'lessonId123');
  });
}