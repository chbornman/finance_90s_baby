import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:finance_90s_baby/screens/feedback_screen.dart';
import 'api_mocks.mocks.dart';

void main() {
  late MockDatabaseAPI mockDatabaseAPI;

  setUp(() {
    mockDatabaseAPI = MockDatabaseAPI();
  });

  testWidgets('displays feedback input field', (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: FeedbackScreen(mockDatabaseAPI, userId: 'user456'),
      ),
    );

    // Assert
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Your thoughts'), findsOneWidget);
  });

  testWidgets('submits feedback when Enter is pressed',
      (WidgetTester tester) async {
    // Arrange
    when(mockDatabaseAPI.addComment(any, any, any)).thenAnswer((_) async => {});

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: FeedbackScreen(mockDatabaseAPI, userId: 'user456'),
      ),
    );
    await tester.enterText(find.byType(TextField), 'Great app!');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    // Assert
    verify(mockDatabaseAPI.addComment('feedback', 'user456', 'Great app!'))
        .called(1);
  });
}
