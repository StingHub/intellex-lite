// 🌟 Intellex Lite — NEXTLEVEL UI Edition with XP, Streaks, and Upgraded Skin Shop

import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const IntellexApp());

class IntellexApp extends StatelessWidget {
  const IntellexApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intellex Lite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const HomeScreen(),
    );
  }
}

class GameData {
  int coins = 0;
  int xp = 0;
  int streak = 0;
  int correctAnswers = 0;
  int wrongAnswers = 0;
  String selectedSkin = '🙂 Default';
  List<String> unlockedSkins = ['🙂 Default'];

  void resetGame() {
    wrongAnswers = 0;
    correctAnswers = 0;
    streak = 0;
  }

  bool isUnlocked(String skin) => unlockedSkins.contains(skin);

  bool unlockSkin(String skin, int cost) {
    if (!isUnlocked(skin) && coins >= cost) {
      coins -= cost;
      unlockedSkins.add(skin);
      return true;
    }
    return false;
  }
}

final GameData gameData = GameData();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedGrade = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎓 Intellex Lite')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('💰 Coins: ${gameData.coins}', style: const TextStyle(fontSize: 22)),
              Text('📈 XP: ${gameData.xp}   🔥 Streak: ${gameData.streak}', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              const Text('Select Grade:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              DropdownButton<int>(
                value: selectedGrade,
                items: List.generate(12, (i) => DropdownMenuItem(value: i + 1, child: Text('Grade ${i + 1}'))),
                onChanged: (value) => setState(() => selectedGrade = value!),
              ),
              const SizedBox(height: 20),
              Text('🎭 Skin: ${gameData.selectedSkin}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  gameData.resetGame();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => BattleScreen(grade: selectedGrade)),
                  );
                },
                child: const Text('🎮 Start Battle', style: TextStyle(fontSize: 22)),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopScreen()));
                },
                child: const Text('🛍️ Open Shop', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BattleScreen extends StatefulWidget {
  final int grade;
  const BattleScreen({super.key, required this.grade});
  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  late Map<String, dynamic> question;

  @override
  void initState() {
    super.initState();
    question = generateQuestion(widget.grade);
  }

  void handleAnswer(String choice) {
    final correct = choice == question['answer'];
    if (correct) {
      gameData.correctAnswers++;
      gameData.coins++;
      gameData.xp += 5;
      gameData.streak++;
    } else {
      gameData.wrongAnswers++;
      gameData.streak = 0;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(correct ? '✅ Correct!' : '❌ Wrong! Answer: ${question['answer']}'),
        backgroundColor: correct ? Colors.green : Colors.red,
        duration: const Duration(milliseconds: 800),
      ),
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      if (gameData.wrongAnswers >= 10) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const GameOverScreen()),
          (route) => false,
        );
      } else {
        setState(() => question = generateQuestion(widget.grade));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⚔️ Battle Mode')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('🎭 ${gameData.selectedSkin}', style: const TextStyle(fontSize: 20)),
            Text('💰 Coins: ${gameData.coins}'),
            Text('✅ ${gameData.correctAnswers}   ❌ ${gameData.wrongAnswers}'),
            const SizedBox(height: 20),
            Text('❓ ${question['question']}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...question['choices'].map<Widget>((choice) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ElevatedButton(
                onPressed: () => handleAnswer(choice),
                child: Text(choice, style: const TextStyle(fontSize: 20)),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int finalScore = gameData.correctAnswers;
    final int earnedCoins = finalScore;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      gameData.resetGame();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('📉 Game Over')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Final Score: $finalScore correct!', style: const TextStyle(fontSize: 22)),
            Text('💰 Earned: $earnedCoins coins', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text('🔁 Return Home', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});
  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final Map<String, int> skins = {
    '🙂 Default': 0,
    '🥷 Ninja': 30,
    '🤖 Robot': 50,
    '👨‍💻 Hacker': 75,
    '🐱🧙 Cat Wizard': 100,
    '👻 Ghosty': 60,
    '👽 Alien': 80,
    '🎮 Gamer': 90,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🛒 Skin Shop')),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: skins.entries.map((entry) {
          final skin = entry.key;
          final cost = entry.value;
          final isUnlocked = gameData.isUnlocked(skin);
          final isSelected = gameData.selectedSkin == skin;

          return Container(
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.indigo, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(skin, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 8),
                Text('$cost 💰', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 12),
                isUnlocked
                    ? (isSelected
                        ? const Text('✅ Equipped')
                        : ElevatedButton(
                            onPressed: () => setState(() => gameData.selectedSkin = skin),
                            child: const Text('Equip'),
                          ))
                    : ElevatedButton(
                        onPressed: () {
                          final success = gameData.unlockSkin(skin, cost);
                          if (!success) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Not enough coins!'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } else {
                            setState(() {});
                          }
                        },
                        child: const Text('Buy'),
                      ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

Map<String, dynamic> generateQuestion(int grade) {
  final rnd = Random();
  int a = rnd.nextInt(10 * grade) + 1;
  int b = rnd.nextInt(10 * grade) + 1;
  if (b == 0) b = 1;

  String question = '';
  String answer = '';
  List<String> choices = [];
  int type = rnd.nextInt(3);

  switch (grade) {
    case 1:
      if (type == 0) {
        question = 'What is $a + $b?';
        answer = '${a + b}';
      } else if (type == 1) {
        question = 'Count: 🟢 ' * a;
        answer = '$a';
      } else {
        question = 'What comes after $a?';
        answer = '${a + 1}';
      }
      break;

    case 2:
      if (type == 0) {
        question = '$a - $b = ?';
        answer = '${a - b}';
      } else if (type == 1) {
        question = 'Double of $a is?';
        answer = '${2 * a}';
      } else {
        question = '10 more than $a?';
        answer = '${a + 10}';
      }
      break;

    case 3:
      if (type == 0) {
        question = 'What is $a × $b?';
        answer = '${a * b}';
      } else if (type == 1) {
        question = 'How many sides does a triangle have?';
        answer = '3';
      } else {
        question = '$a ÷ $b = ? (rounded)';
        answer = (a / b).toStringAsFixed(1);
      }
      break;

    case 4:
      if (type == 0) {
        question = 'Perimeter of square (side = $a)?';
        answer = '${4 * a}';
      } else if (type == 1) {
        question = 'Area of rectangle ($a × $b)?';
        answer = '${a * b}';
      } else {
        question = 'Half of $a?';
        answer = '${(a / 2).toStringAsFixed(1)}';
      }
      break;

    case 5:
      if (type == 0) {
        question = 'Simplify: $a + $b + $b = ?';
        answer = '${a + 2 * b}';
      } else if (type == 1) {
        question = 'What is 25% of ${4 * a}?';
        answer = '${(4 * a * 0.25).toStringAsFixed(1)}';
      } else {
        question = 'Volume of cube (side=$a)?';
        answer = '${a * a * a}';
      }
      break;

    case 6:
      if (type == 0) {
        question = 'Mean of [$a, $b, ${a + b}]?';
        answer = '${((a + b + (a + b)) / 3).toStringAsFixed(1)}';
      } else if (type == 1) {
        question = 'Solve: x + $a = ${a + b}';
        answer = '$b';
      } else {
        question = 'GCF of $a and $b?';
        int gcf(int x, int y) => y == 0 ? x : gcf(y, x % y);
        answer = '${gcf(a, b)}';
      }
      break;

    case 7:
      if (type == 0) {
        question = 'Solve: 2x + 3 = ${2 * a + 3}';
        answer = '$a';
      } else if (type == 1) {
        question = 'Area of triangle (b=$a, h=$b)?';
        answer = '${(a * b / 2).toStringAsFixed(1)}';
      } else {
        question = 'Is $a a prime number?';
        bool isPrime(int n) {
          if (n < 2) return false;
          for (int i = 2; i <= sqrt(n).toInt(); i++) {
            if (n % i == 0) return false;
          }
          return true;
        }
        answer = isPrime(a) ? 'Yes' : 'No';
      }
      break;

    case 8:
      if (type == 0) {
        question = 'What is $a² + 2×$a + 1?';
        answer = '${a * a + 2 * a + 1}';
      } else if (type == 1) {
        question = 'Slope between (0,0) and ($a,$b)?';
        answer = (b / a).toStringAsFixed(1);
      } else {
        question = 'Evaluate: ($a + $b)²';
        answer = '${(a + b) * (a + b)}';
      }
      break;

    case 9:
      if (type == 0) {
        question = 'Simplify: (${a}x + ${b}x)';
        answer = '${a + b}x';
      } else if (type == 1) {
        question = 'Factor: x² + ${2 * a}x + ${a * a}';
        answer = '(x + $a)²';
      } else {
        question = 'Evaluate |$a - $b|';
        answer = '${(a - b).abs()}';
      }
      break;

    case 10:
      if (type == 0) {
        question = 'Derivative of ${a}x²?';
        answer = '${2 * a}x';
      } else if (type == 1) {
        question = 'What is log₁₀(${10 * a})?';
        answer = '${(log(10 * a) / log(10)).toStringAsFixed(1)}';
      } else {
        question = 'Distance formula: (0,0) to ($a,$b)?';
        answer = sqrt(a * a + b * b).toStringAsFixed(2);
      }
      break;

    case 11:
      if (type == 0) {
        question = 'Limit x→0 of sin(x)/x?';
        answer = '1';
      } else if (type == 1) {
        question = 'Derivative of sin($a x)?';
        answer = '${a}cos($a x)';
      } else {
        question = 'Integral of 1/x dx?';
        answer = 'ln|x| + C';
      }
      break;

    case 12:
    default:
      if (type == 0) {
        question = 'What is ∫ x dx?';
        answer = '½x² + C';
      } else if (type == 1) {
        question = 'Evaluate: (x + $a)²';
        answer = 'x² + ${2 * a}x + ${a * a}';
      } else {
        question = 'What is the determinant of a 2×2: |$a $b| |$b $a|?';
        answer = '${a * a - b * b}';
      }
  }

  // MCQ: add answer + 3 distractors
  choices.add(answer);
  while (choices.length < 4) {
    String fake;
    if (answer.contains('x') || answer.contains('C') || answer.contains('|x|')) {
      fake = answer.replaceAll(a.toString(), '${a + rnd.nextInt(4) - 2}');
    } else if (answer.contains('.')) {
      double base = double.tryParse(answer) ?? 0;
      fake = (base + rnd.nextDouble() * 4 - 2).toStringAsFixed(1);
    } else {
      int base = int.tryParse(answer.replaceAll(RegExp(r'\D'), '')) ?? a;
      fake = '${base + rnd.nextInt(10) - 5}';
    }
    if (!choices.contains(fake)) choices.add(fake);
  }

  choices.shuffle();
  return {'question': question, 'answer': answer, 'choices': choices};
}
