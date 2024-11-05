import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finance_90s_baby/widgets/lesson_list_item.dart';

void main() {
  testWidgets('displays lesson title', (WidgetTester tester) async {
    // Arrange
    final lesson = Document(
      $id: 'Sample Lesson ID',
      $collectionId: 'Sample Collection ID',
      $databaseId: 'Sample Database ID',
      $createdAt: '2023-01-01T00:00:00.000Z',
      $updatedAt: '2023-01-01T00:00:00.000Z',
      $permissions: [],
      data: {'title': 'Sample Lesson'},
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LessonListItem(lesson: lesson.data),
        ),
      ),
    );

    // Assert
    expect(find.text('Sample Lesson'), findsOneWidget);
  });

  testWidgets('navigates to lesson details on tap', (WidgetTester tester) async {
    // Arrange
    final lesson = Document(
      $id: 'Sample Lesson ID',
      $collectionId: 'Sample Collection ID',
      $databaseId: 'Sample Database ID',
      $createdAt: '2023-01-01T00:00:00.000Z',
      $updatedAt: '2023-01-01T00:00:00.000Z',
      $permissions: [],
      data: {'title': 'Sample Lesson'},
    );
    
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LessonListItem(lesson: lesson.data),
        ),
        routes: {
          '/lesson': (context) => const Scaffold(body: Text('Lesson Details Screen')),
        },
      ),
    );
    await tester.tap(find.text('Sample Lesson'));
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Lesson Details Screen'), findsOneWidget);
  });
}