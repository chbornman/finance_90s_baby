import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:finance_90s_baby/widgets/comment_section.dart';
import 'api_mocks.mocks.dart';

void main() {
  late MockDatabaseAPI mockDatabaseAPI;

  setUp(() {
    mockDatabaseAPI = MockDatabaseAPI();
  });

  testWidgets('displays comment input field', (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CommentSection(
            lessonId: 'lesson123',
            userId: 'user456',
            databaseAPI: mockDatabaseAPI,
          ),
        ),
      ),
    );

    // Assert
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Add a comment'), findsOneWidget);
  });

  testWidgets('submits comment when Enter is pressed', (WidgetTester tester) async {
    // Arrange
    when(mockDatabaseAPI.addComment(any, any, any)).thenAnswer((_) async => {});

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CommentSection(
            lessonId: 'lesson123',
            userId: 'user456',
            databaseAPI: mockDatabaseAPI,
          ),
        ),
      ),
    );
    await tester.enterText(find.byType(TextField), 'Nice lesson!');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    // Assert
    verify(mockDatabaseAPI.addComment('lesson123', 'userid485854738', 'Nice lesson!')).called(1);
  });
}