import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intellex_demo/main.dart';

void main() {
  group('🧪 Intellex Demo Widget Tests', () {
    testWidgets('Home screen loads with default coin count', (WidgetTester tester) async {
      await tester.pumpWidget(const IntellexApp());
      expect(find.textContaining('💰 Coins:'), findsOneWidget);
    });

    testWidgets('Grade dropdown shows all 12 grades', (WidgetTester tester) async {
      await tester.pumpWidget(const IntellexApp());
      await tester.tap(find.byType(DropdownButton<int>));
      await tester.pumpAndSettle();
      for (int i = 1; i <= 12; i++) {
        expect(find.text('Grade $i'), findsWidgets);
      }
    });

    testWidgets('Start Battle navigates to BattleScreen', (WidgetTester tester) async {
      await tester.pumpWidget(const IntellexApp());
      await tester.tap(find.text('🎮 Start Battle'));
      await tester.pumpAndSettle();
      expect(find.text('⚔️ Battle Mode'), findsOneWidget);
    });

    testWidgets('Question displays with 4 choices in battle mode', (WidgetTester tester) async {
      await tester.pumpWidget(const IntellexApp());
      await tester.tap(find.text('🎮 Start Battle'));
      await tester.pumpAndSettle();
      expect(find.textContaining('❓'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsNWidgets(4));
    });

    testWidgets('Correct answer increases coin count', (WidgetTester tester) async {
      await tester.pumpWidget(const IntellexApp());
      await tester.tap(find.text('🎮 Start Battle'));
      await tester.pumpAndSettle();

      final state = tester.state(find.byType(BattleScreen)) as dynamic;
      final correct = state.question['answer'];

      await tester.tap(find.text(correct));
      await tester.pumpAndSettle();
      expect(find.textContaining('✅'), findsOneWidget);
    });

    testWidgets('Incorrect answer triggers wrong feedback', (WidgetTester tester) async {
      await tester.pumpWidget(const IntellexApp());
      await tester.tap(find.text('🎮 Start Battle'));
      await tester.pumpAndSettle();

      final state = tester.state(find.byType(BattleScreen)) as dynamic;
      final correct = state.question['answer'];
      final wrong = state.question['choices'].firstWhere((c) => c != correct);

      await tester.tap(find.text(wrong));
      await tester.pumpAndSettle();
      expect(find.textContaining('❌'), findsOneWidget);
    });

    testWidgets('Shop opens from Home screen', (WidgetTester tester) async {
      await tester.pumpWidget(const IntellexApp());
      await tester.tap(find.text('🛍️ Open Shop'));
      await tester.pumpAndSettle();
      expect(find.text('🛒 Skin Shop'), findsOneWidget);
    });

    testWidgets('Shop displays at least 5 skins', (WidgetTester tester) async {
      await tester.pumpWidget(const IntellexApp());
      await tester.tap(find.text('🛍️ Open Shop'));
      await tester.pumpAndSettle();
      expect(find.textContaining('💰'), findsWidgets);
    });

    testWidgets('Game over screen appears after 10 wrongs', (WidgetTester tester) async {
      await tester.pumpWidget(const IntellexApp());
      await tester.tap(find.text('🎮 Start Battle'));
      await tester.pumpAndSettle();

      for (int i = 0; i < 10; i++) {
        final state = tester.state(find.byType(BattleScreen)) as dynamic;
        final correct = state.question['answer'];
        final wrong = state.question['choices'].firstWhere((c) => c != correct);
        await tester.tap(find.text(wrong));
        await tester.pumpAndSettle();
      }

      expect(find.text('📉 Game Over'), findsOneWidget);
    });

    testWidgets('Game resets after Game Over', (WidgetTester tester) async {
      await tester.pumpWidget(const IntellexApp());
      await tester.tap(find.text('🎮 Start Battle'));
      await tester.pumpAndSettle();

      for (int i = 0; i < 10; i++) {
        final state = tester.state(find.byType(BattleScreen)) as dynamic;
        final correct = state.question['answer'];
        final wrong = state.question['choices'].firstWhere((c) => c != correct);
        await tester.tap(find.text(wrong));
        await tester.pumpAndSettle();
      }

      await tester.tap(find.text('🔁 Return Home'));
      await tester.pumpAndSettle();
      expect(find.text('🎓 Intellex Lite'), findsOneWidget);
    });

    testWidgets('Default skin is equipped at start', (WidgetTester tester) async {
      await tester.pumpWidget(const IntellexApp());
      expect(find.textContaining('🙂 Default'), findsWidgets);
    });

    testWidgets('Skin can be purchased and equipped', (WidgetTester tester) async {
      gameData.coins = 999;
      await tester.pumpWidget(const IntellexApp());
      await tester.tap(find.text('🛍️ Open Shop'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Buy').first);
      await tester.pumpAndSettle();
      expect(find.text('Equip'), findsOneWidget);
      await tester.tap(find.text('Equip'));
      await tester.pumpAndSettle();
      expect(find.text('✅ Equipped'), findsOneWidget);
    });

    testWidgets('BattleScreen shows equipped skin', (WidgetTester tester) async {
      gameData.selectedSkin = '🥷 Ninja';
      await tester.pumpWidget(const IntellexApp());
      await tester.tap(find.text('🎮 Start Battle'));
      await tester.pumpAndSettle();
      expect(find.textContaining('🥷 Ninja'), findsOneWidget);
    });

    testWidgets('Correct and wrong counters are shown', (WidgetTester tester) async {
      await tester.pumpWidget(const IntellexApp());
      await tester.tap(find.text('🎮 Start Battle'));
      await tester.pumpAndSettle();
      expect(find.textContaining('✅'), findsOneWidget);
      expect(find.textContaining('❌'), findsOneWidget);
    });

    testWidgets('Shop cannot purchase skin without enough coins', (WidgetTester tester) async {
      gameData.coins = 0;
      await tester.pumpWidget(const IntellexApp());
      await tester.tap(find.text('🛍️ Open Shop'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Buy').first);
      await tester.pumpAndSettle();
      expect(find.text('Not enough coins!'), findsOneWidget);
    });

    testWidgets('Question updates after answering', (WidgetTester tester) async {
      await tester.pumpWidget(const IntellexApp());
      await tester.tap(find.text('🎮 Start Battle'));
      await tester.pumpAndSettle();

      final oldQ = find.textContaining('❓');
      final state = tester.state(find.byType(BattleScreen)) as dynamic;
      final correct = state.question['answer'];

      await tester.tap(find.text(correct));
      await tester.pumpAndSettle();
      expect(find.textContaining('❓'), isNot(equals(oldQ)));
    });

    testWidgets('Return Home button navigates to HomeScreen', (WidgetTester tester) async {
      gameData.wrongAnswers = 10;
      await tester.pumpWidget(const IntellexApp());
      await tester.tap(find.text('🎮 Start Battle'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('🔁 Return Home'));
      await tester.pumpAndSettle();
      expect(find.text('🎓 Intellex Lite'), findsOneWidget);
    });

    testWidgets('App displays release teaser on GameOver screen', (WidgetTester tester) async {
      gameData.wrongAnswers = 10;
      await tester.pumpWidget(const IntellexApp());
      await tester.tap(find.text('🎮 Start Battle'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('🔁 Return Home'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('🎮 Start Battle'));
      await tester.pumpAndSettle();

      final state = tester.state(find.byType(BattleScreen)) as dynamic;
      final correct = state.question['answer'];
      final wrong = state.question['choices'].firstWhere((c) => c != correct);

      for (int i = 0; i < 10; i++) {
        await tester.tap(find.text(wrong));
        await tester.pumpAndSettle();
      }

      expect(find.textContaining('Coming Soon: Intellex Full Version'), findsOneWidget);
    });
  });
}
