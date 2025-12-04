import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prototype1/UserManagementComponent/signin.dart';
import 'package:prototype1/UserManagementComponent/signup.dart';
import 'package:prototype1/homePage.dart';

void main() {
  testWidgets('Homepage shows welcome text and buttons', (
    WidgetTester tester,
  ) async {
    // بناء الصفحة
    await tester.pumpWidget(const MaterialApp(home: Homepage()));

    // تحقق من وجود النص الترحيبي
    expect(find.text('أهلاً بك في عيادتي'), findsOneWidget);

    // تحقق من وجود الزرين
    expect(find.text('Already Have An Account'), findsOneWidget);
    expect(find.text('Create New Account'), findsOneWidget);
  });

  testWidgets('Clicking buttons navigates to correct pages', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: Homepage()));

    // الضغط على زر "Already Have An Account"
    await tester.tap(find.text('Already Have An Account'));
    await tester.pumpAndSettle(); // لانتظار عملية التنقل
    expect(find.byType(Signin), findsOneWidget);

    // العودة إلى الصفحة الرئيسية
    await tester.pageBack();
    await tester.pumpAndSettle();

    // الضغط على زر "Create New Account"
    await tester.tap(find.text('Create New Account'));
    await tester.pumpAndSettle();
    expect(find.byType(Signup), findsOneWidget);
  });
}
