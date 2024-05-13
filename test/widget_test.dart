import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_color_picker/color_scheme_view.dart';
import 'package:image_color_picker/main.dart';

void main() {
  testWidgets('Test dynamic color example', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DynamicColorExample());

    // Verify that the initial state shows CircularProgressIndicator.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the first frame to load.
    await tester.pump();

    // Verify that the CircularProgressIndicator is replaced by image selection.
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(GestureDetector),
        findsNWidgets(6)); // 6 images to select from

    // Tap on the first image to select.
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pump();

    // Verify that after selecting an image, color scheme information is displayed.
    expect(find.byType(ColorSchemeView), findsOneWidget);
  });
  // Tap
}
