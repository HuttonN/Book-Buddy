import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:book_buddy/screens/home_page2.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Mock classes for Firebase dependencies
class MockUser extends Mock implements User {
  @override
  String get uid => 'test_uid';
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  User? get currentUser => MockUser();
}

void main() {
  late bool isDarkMode;
  late Function(bool) toggleDarkMode;
  late MockFirebaseAuth mockAuth;

  setUp(() {
    isDarkMode = false;
    toggleDarkMode = (value) => isDarkMode = value;
    mockAuth = MockFirebaseAuth();
  });

  group('NavBar Widget Tests', () {
    testWidgets('NavBar renders correctly with 5 items', (WidgetTester tester) async {
      int currentIndex = 0;
      void onTap(int index) => currentIndex = index;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(),
            bottomNavigationBar: NavBar(  
              currentIndex: currentIndex,
              onTap: onTap,
            ),
          ),
        ),
      );

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.byIcon(Icons.menu_book), findsOneWidget);
      expect(find.byIcon(Icons.bookmark), findsOneWidget);
      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('NavBar calls onTap with correct index', (WidgetTester tester) async {
      int currentIndex = 0;
      int tappedIndex = -1;
      void onTap(int index) => tappedIndex = index;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Container(),
            bottomNavigationBar: NavBar(  
              currentIndex: currentIndex,
              onTap: onTap,
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.menu_book));
      expect(tappedIndex, equals(0));

      await tester.tap(find.byIcon(Icons.bookmark));
      expect(tappedIndex, equals(1));

      await tester.tap(find.byIcon(Icons.camera_alt));
      expect(tappedIndex, equals(2));
    });
  });
}