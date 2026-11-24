import 'package:flutter_test/flutter_test.dart';

import 'package:cv_flutter_nadia/main.dart';

void main() {
  testWidgets('Affiche la page de connexion', (WidgetTester tester) async {
    await tester.pumpWidget(const NadiaCvApp());

    expect(find.text('Bienvenue !'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
  });
}
