// 🌟 Intellex Lite — MAXED UI + SMOOTH UX + BATTLE POLISH

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
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent, brightness: Brightness.dark),
        textTheme: const TextTheme(bodyMedium: TextStyle(fontSize: 18)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigoAccent,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
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
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('💰 Coins: ${gameData.coins}', style: const TextStyle(fontSize: 22)),
                Text('📈 XP: ${gameData.xp}   🔥 Streak: ${gameData.streak}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                const Text('Select Grade:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                DropdownButton<int>(
                  value: selectedGrade,
                  isExpanded: true,
                  dropdownColor: Colors.grey.shade900,
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
                  child: const Text('🎮 Start Battle'),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopScreen()));
                  },
                  child: const Text('🛍️ Open Shop'),
                ),
              ],
            ),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
              child: const Text('🔁 Return Home'),
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

  String skinRarity(String skin) {
    final cost = skins[skin]!;
    if (cost == 0) return 'Common';
    if (cost <= 50) return 'Rare';
    if (cost <= 80) return 'Epic';
    return 'Legendary';
  }

  Color rarityColor(String rarity) {
    switch (rarity) {
      case 'Common':
        return Colors.grey;
      case 'Rare':
        return Colors.blueAccent;
      case 'Epic':
        return Colors.purpleAccent;
      case 'Legendary':
        return Colors.amber;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🛍️ Skin Shop')),
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
          final rarity = skinRarity(skin);
          final color = rarityColor(rarity);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? color : Colors.indigo.shade300,
                width: isSelected ? 3 : 2,
              ),
              boxShadow: isSelected
                  ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10)]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(skin, style: TextStyle(fontSize: 24)),
                const SizedBox(height: 6),
                Text('$cost 💰', style: const TextStyle(fontSize: 16)),
                Text(rarity, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                isUnlocked
                    ? (isSelected
                        ? const Text('✅ Equipped', style: TextStyle(fontWeight: FontWeight.bold))
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
                        child: Text('Buy for $cost'),
                      ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}


// 🌟 Enhanced generateQuestion() — unique questions for EACH GRADE (1–12)

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
        question = '$a + $b = ?';
        answer = '${a + b}';
      } else if (type == 1) {
        question = '$a - $b = ?';
        answer = '${a - b}';
      } else {
        question = 'What comes after $a?';
        answer = '${a + 1}';
      }
      break;

    case 2:
      if (type == 0) {
        question = '$a + $b + ${a - b} = ?';
        answer = '${a + b + (a - b)}';
      } else if (type == 1) {
        question = 'Double $a = ?';
        answer = '${2 * a}';
      } else {
        question = 'Half of ${2 * a} = ?';
        answer = '${a}';
      }
      break;

    case 3:
      if (type == 0) {
        question = '$a × $b = ?';
        answer = '${a * b}';
      } else if (type == 1) {
        question = '$a ÷ $b = ? (1 decimal)';
        answer = (a / b).toStringAsFixed(1);
      } else {
        question = 'Area of square with side $a?';
        answer = '${a * a}';
      }
      break;

    case 4:
      if (type == 0) {
        question = 'Perimeter of rectangle: $a, $b';
        answer = '${2 * (a + b)}';
      } else if (type == 1) {
        question = 'Volume of cube (side=$a)?';
        answer = '${a * a * a}';
      } else {
        question = 'Simplify: $a + $b + $b';
        answer = '${a + 2 * b}';
      }
      break;

    case 5:
      if (type == 0) {
        question = '25% of ${4 * a}?';
        answer = '${(4 * a * 0.25).toStringAsFixed(1)}';
      } else if (type == 1) {
        question = 'GCF of $a and $b?';
        int gcf(int x, int y) => y == 0 ? x : gcf(y, x % y);
        answer = '${gcf(a, b)}';
      } else {
        question = 'Solve: x + $a = ${a + b}';
        answer = '$b';
      }
      break;

    case 6:
      if (type == 0) {
        question = 'Mean of [$a, $b, ${a + b}]?';
        answer = '${((a + b + (a + b)) / 3).toStringAsFixed(1)}';
      } else if (type == 1) {
        question = 'Area of triangle: b=$a, h=$b';
        answer = '${(a * b / 2).toStringAsFixed(1)}';
      } else {
        question = 'Solve: 2x + 3 = ${2 * a + 3}';
        answer = '$a';
      }
      break;

    case 7:
      if (type == 0) {
        question = 'Simplify: ${a}x + ${b}x';
        answer = '${a + b}x';
      } else if (type == 1) {
        question = 'Factor: x² + ${2 * a}x + ${a * a}';
        answer = '(x + $a)²';
      } else {
        question = 'Evaluate |$a - $b|';
        answer = '${(a - b).abs()}';
      }
      break;

    case 8:
      if (type == 0) {
        question = 'What is $a² + 2×$a + 1?';
        answer = '${a * a + 2 * a + 1}';
      } else if (type == 1) {
        question = 'Slope from (0,0) to ($a,$b)?';
        answer = (b / a).toStringAsFixed(1);
      } else {
        question = 'Solve: ($a + $b)²';
        answer = '${(a + b) * (a + b)}';
      }
      break;

    case 9:
      if (type == 0) {
        question = 'Derivative of ${a}x²?';
        answer = '${2 * a}x';
      } else if (type == 1) {
        question = 'Distance: (0,0) to ($a,$b)?';
        answer = (sqrt(a * a + b * b)).toStringAsFixed(2);
      } else {
        question = 'What is log₁₀(${10 * a})?';
        answer = '${(log(10 * a) / log(10)).toStringAsFixed(1)}';
      }
      break;

    case 10:
      if (type == 0) {
        question = 'Integral of x dx?';
        answer = '½x² + C';
      } else if (type == 1) {
        question = 'Evaluate: (x + $a)²';
        answer = 'x² + ${2 * a}x + ${a * a}';
      } else {
        question = 'Determinant: |$a $b| |$b $a|';
        answer = '${a * a - b * b}';
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
      break;
  }

  choices.add(answer);
  while (choices.length < 4) {
    String fake;
    if (answer.contains('x') || answer.contains('C') || answer.contains('|x|')) {
      fake = answer.replaceAll('$a', '${a + rnd.nextInt(4) - 2}');
    } else if (answer.contains('.')) {
      double base = double.tryParse(answer) ?? 0;
      fake = (base + rnd.nextDouble() * 3 - 1.5).toStringAsFixed(1);
    } else {
      int base = int.tryParse(answer.replaceAll(RegExp(r'[^0-9]'), '')) ?? a;
      fake = '${base + rnd.nextInt(8) - 4}';
    }
    if (!choices.contains(fake)) choices.add(fake);
  }

  choices.shuffle();
  return {'question': question, 'answer': answer, 'choices': choices};
}
