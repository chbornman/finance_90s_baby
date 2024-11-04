import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:finance_90s_baby/main.dart';
import 'package:mockito/mockito.dart';
import 'appwrite_client_test.mocks.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final mockClient = MockClient();

    // Configure mock behavior
    when(mockClient.setEndpoint(any)).thenReturn(mockClient);
    when(mockClient.setProject(any)).thenReturn(mockClient);

    // Pass the mock client to MyApp
    await tester.pumpWidget(MyApp(client: mockClient));

    // Proceed with your widget tests...
  });
}
