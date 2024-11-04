import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:finance_90s_baby/screens/home_screen.dart';
import 'api_mocks.mocks.dart';

void main() {
  late MockDatabaseAPI mockDatabaseAPI;

  setUp(() {
    mockDatabaseAPI = MockDatabaseAPI();
  });

  testWidgets('displays loading indicator while fetching lessons', (WidgetTester tester) async {
    // Arrange
    when(mockDatabaseAPI.getLessons()).thenAnswer((_) async => Future.delayed(Duration(seconds: 1), () => []));

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(mockDatabaseAPI),
      ),
    );

    // Assert: Verify loading indicator is displayed initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Simulate a 1-second delay to allow the Future to complete
    await tester.pump(Duration(seconds: 1));

    // Ensure the widget tree updates after the delay
    await tester.pumpAndSettle();

    // Assert: Verify loading indicator is gone after loading completes
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}