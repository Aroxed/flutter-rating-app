// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_rating_app/main.dart';
import 'package:image_rating_app/screens/image_list_screen.dart';
import 'package:image_rating_app/services/image_service.dart';
import 'package:image_rating_app/models/image_item.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  group('App Tests', () {
    testWidgets('App title is displayed correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.text('Image Rating App'), findsOneWidget);
    });

    testWidgets('Loading indicator is shown initially', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('Image List Screen Tests', () {
    testWidgets('Images are displayed correctly', (WidgetTester tester) async {
      // Mock HTTP client
      final mockClient = MockClient((request) async {
        if (request.url.toString() == 'http://localhost:3000/api/images') {
          return http.Response(
            json.encode([
              {
                'id': 1,
                'filename': 'test.jpg',
                'rating': 3,
                'created_at': '2024-03-20T12:00:00Z'
              }
            ]),
            200,
          );
        }
        return http.Response('', 404);
      });

      // Create a test app with mock client
      await tester.pumpWidget(
        MaterialApp(
          home: ImageListScreen(
            imageService: ImageService(client: mockClient),
          ),
        ),
      );

      // Wait for the loading indicator to disappear and images to load
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Verify that the image card is displayed
      expect(find.byType(Card), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      
      // Verify that the rating stars are displayed
      expect(find.byType(IconButton), findsNWidgets(5));
    });

    testWidgets('Rating stars are interactive', (WidgetTester tester) async {
      int currentRating = 0;
      
      // Mock HTTP client
      final mockClient = MockClient((request) async {
        if (request.url.toString() == 'http://localhost:3000/api/images') {
          return http.Response(
            json.encode([
              {
                'id': 1,
                'filename': 'test.jpg',
                'rating': currentRating,
                'created_at': '2024-03-20T12:00:00Z'
              }
            ]),
            200,
          );
        }
        if (request.url.toString() == 'http://localhost:3000/api/images/1/rate') {
          final body = json.decode(request.body);
          currentRating = body['rating'];
          return http.Response(
            json.encode({'message': 'Rating updated successfully'}),
            200,
          );
        }
        return http.Response('', 404);
      });

      // Create a test app with mock client
      await tester.pumpWidget(
        MaterialApp(
          home: ImageListScreen(
            imageService: ImageService(client: mockClient),
          ),
        ),
      );

      // Wait for the loading indicator to disappear and images to load
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.byIcon(Icons.star), findsNWidgets(0));
      expect(find.byIcon(Icons.star_border), findsNWidgets(5));

      // Tap the third star
      await tester.tap(find.byIcon(Icons.star_border).at(2));
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Verify that the rating was updated
      expect(find.byIcon(Icons.star), findsNWidgets(3));
      expect(find.byIcon(Icons.star_border), findsNWidgets(2));
    });

    testWidgets('Error handling shows snackbar', (WidgetTester tester) async {
      // Mock HTTP client that always fails
      final mockClient = MockClient((request) async {
        return http.Response('', 500);
      });

      // Create a test app with mock client
      await tester.pumpWidget(
        MaterialApp(
          home: ImageListScreen(
            imageService: ImageService(client: mockClient),
          ),
        ),
      );

      // Wait for the loading indicator to disappear and error to show
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // Verify that error snackbar is shown
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.textContaining('Error loading images'), findsOneWidget);
    });
  });
}
