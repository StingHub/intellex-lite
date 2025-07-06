// 🌟 Intellex Lite — MAXED UI + SMOOTH UX + BATTLE POLISH

import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const IntellexApp());

class IntellexApp extends StatelessWidget {
  const IntellexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intellex: NEXTLEVEL',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF111122), // Deep soft background
        primaryColor: Colors.tealAccent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1C1C2D),
          elevation: 6,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Colors.tealAccent,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono',
            letterSpacing: 1.3,
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 18,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
            fontFamily: 'RobotoMono',
          ),
          headlineSmall: TextStyle(
            fontSize: 28,
            color: Colors.tealAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.tealAccent,
          brightness: Brightness.dark,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.tealAccent,
            foregroundColor: Colors.black,
            shadowColor: Colors.teal,
            elevation: 4,
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontFamily: 'RobotoMono',
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(14))),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.amberAccent, width: 2),
            foregroundColor: Colors.amberAccent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'RobotoMono',
            ),
          ),
        ),
      ),
      themeAnimationCurve: Curves.easeInOutCubicEmphasized,
      themeAnimationDuration: const Duration(milliseconds: 500),
      home: const HomeScreen(),
    );
  }
}



class GameData {
  int coins;
  int xp;
  int streak;
  int correctAnswers;
  int wrongAnswers;
  String selectedSkin;
  final List<String> unlockedSkins;

  GameData({
    this.coins = 0,
    this.xp = 0,
    this.streak = 0,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
    this.selectedSkin = '🙂 Default',
    List<String>? unlockedSkins,
  }) : unlockedSkins = unlockedSkins ?? ['🙂 Default'];

  /// Resets session-based stats, but retains coins and skins.
  void resetGame() {
    correctAnswers = 0;
    wrongAnswers = 0;
    streak = 0;
  }

  /// Checks if a skin is already unlocked.
  bool isUnlocked(String skin) => unlockedSkins.contains(skin);

  /// Attempts to unlock a skin. Returns true if successful.
  bool unlockSkin(String skin, int cost) {
    if (isUnlocked(skin) || coins < cost) return false;
    coins -= cost;
    unlockedSkins.add(skin);
    return true;
  }

  /// Safely changes the selected skin if it's unlocked.
  bool selectSkin(String skin) {
    if (isUnlocked(skin)) {
      selectedSkin = skin;
      return true;
    }
    return false;
  }

  /// Grants XP and coins for a correct answer.
  void rewardCorrect({int xpGain = 5, int coinGain = 1}) {
    correctAnswers++;
    xp += xpGain;
    coins += coinGain;
    streak++;
  }

  /// Handles logic for a wrong answer.
  void penalizeWrong() {
    wrongAnswers++;
    streak = 0;
  }

  /// Returns the player's current level (example: XP threshold per level = 20).
  int get level => (xp ~/ 20) + 1;

  /// Returns accuracy percentage.
  double get accuracy {
    final total = correctAnswers + wrongAnswers;
    return total == 0 ? 0 : (correctAnswers / total) * 100;
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
      appBar: AppBar(
        title: const Text('Intellex Lite'),
        centerTitle: true,
        backgroundColor: const Color(0xFF222831),
        elevation: 3,
      ),
      body: Container(
        color: const Color(0xFF1C1C1C),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Coins: ${gameData.coins}    XP: ${gameData.xp}    🔥 ${gameData.streak}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Select Grade',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButton<int>(
                    value: selectedGrade,
                    dropdownColor: const Color(0xFF2D2D2D),
                    iconEnabledColor: Colors.white,
                    style: const TextStyle(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                    items: List.generate(
                      12,
                      (i) => DropdownMenuItem(
                        value: i + 1,
                        child: Text('Grade ${i + 1}'),
                      ),
                    ),
                    onChanged: (value) => setState(() => selectedGrade = value!),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Skin: ${gameData.selectedSkin}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white60,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      gameData.resetGame();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => BattleScreen(grade: selectedGrade)),
                      );
                    },
                    child: const Text('Start Game'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey.shade700,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(220, 50),
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ShopScreen()));
                    },
                    child: const Text('Open Shop'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.grey),
                      minimumSize: const Size(220, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                ],
              ),
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

class _BattleScreenState extends State<BattleScreen> with SingleTickerProviderStateMixin {
  late Map<String, dynamic> question;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    question = generateQuestion(widget.grade);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).chain(CurveTween(curve: Curves.easeInOut)).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

    _controller.forward();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(correct ? '✅ Correct!' : '❌ Wrong! Answer: ${question['answer']}'),
        backgroundColor: correct ? Colors.green : Colors.red,
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
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
      appBar: AppBar(
        title: const Text('⚔️ Battle Mode'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  children: [
                    Text('🎭 ${gameData.selectedSkin}', style: const TextStyle(fontSize: 20), textAlign: TextAlign.center),
                    const SizedBox(height: 6),
                    Text('💰 Coins: ${gameData.coins}', textAlign: TextAlign.center),
                    Text('✅ ${gameData.correctAnswers}   ❌ ${gameData.wrongAnswers}', textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    Text(
                      '❓ ${question['question']}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              ...question['choices'].map<Widget>((choice) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => handleAnswer(choice),
                    child: Text(choice, textAlign: TextAlign.center),
                  ),
                );
              }).toList(),
            ],
          ),
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

    // Reset game state after frame renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      gameData.resetGame();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('📉 Game Over'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
              const SizedBox(height: 20),
              Text(
                '🎯 Final Score\n$finalScore correct!',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '💰 Earned: $earnedCoins coins',
                style: const TextStyle(fontSize: 20, color: Colors.green),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: const Icon(Icons.refresh),
                label: const Text(
                  'Return Home',
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
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

// Dart: Full Math Question Generator for Grades 1–12


Map<String, dynamic> generateQuestion(int grade) {
  final rnd = Random();
  int a = rnd.nextInt(100) + 1;
  int b = rnd.nextInt(100) + 1;
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
        question = 'What is $a - $b?';
        answer = '${a - b}';
      } else {
        question = 'What comes after $a?';
        answer = '${a + 1}';
      }
      break;

    case 2:
      if (type == 0) {
        question = 'What is $a + $b?';
        answer = '${a + b}';
      } else if (type == 1) {
        question = 'What is $a - $b?';
        answer = '${a - b}';
      } else {
        question = 'What is 1/2 of ${2 * a}?';
        answer = '$a';
      }
      break;

    case 3:
      if (type == 0) {
        question = 'What is ${a % 10} × ${b % 10}?';
        answer = '${(a % 10) * (b % 10)}';
      } else if (type == 1) {
        question = 'What is ${a % 100} ÷ ${b % 9 + 1}?';
        answer = (a % 100 / (b % 9 + 1)).toStringAsFixed(1);
      } else {
        question = 'Area of rectangle with sides ${a % 10} and ${b % 10}?';
        answer = '${(a % 10) * (b % 10)}';
      }
      break;

    case 4:
      if (type == 0) {
        question = 'Multiply: ${a % 90} × ${b % 20}';
        answer = '${(a % 90) * (b % 20)}';
      } else if (type == 1) {
        question = 'Convert ${a % 5}/10 to decimal:';
        answer = '${((a % 5) / 10).toStringAsFixed(1)}';
      } else {
        question = 'Find the missing factor: ${a % 10} × ? = ${(a % 10) * (b % 10)}';
        answer = '${b % 10}';
      }
      break;

    case 5:
      if (type == 0) {
        question = 'What is ${a % 10}/10 + ${b % 10}/10?';
        answer = '${((a % 10 + b % 10) / 10).toStringAsFixed(1)}';
      } else if (type == 1) {
        question = 'Volume of cube with side ${a % 10}?';
        answer = '${pow((a % 10), 3).toInt()}';
      } else {
        question = 'On a line plot, what is the total of ${a % 5} + ${b % 5}?';
        answer = '${(a % 5) + (b % 5)}';
      }
      break;

    case 6:
      if (type == 0) {
        question = 'What percent is $a of ${a + b}?';
        answer = '${((a / (a + b)) * 100).toStringAsFixed(1)}%';
      } else if (type == 1) {
        question = 'Solve: ${a % 10}x = ${a % 10 * b % 10}';
        answer = '${b % 10}';
      } else {
        question = 'What is -$a + $b?';
        answer = '${-a + b}';
      }
      break;

    case 7:
      if (type == 0) {
        question = 'Solve: 2x + 5 = ${2 * a + 5}';
        answer = '$a';
      } else if (type == 1) {
        question = 'What is $a% of $b?';
        answer = '${((a / 100) * b).toStringAsFixed(1)}';
      } else {
        question = 'What is the mean of $a, $b, ${a + b}?';
        answer = '${((a + b + a + b) / 3).toStringAsFixed(1)}';
      }
      break;

    case 8:
      if (type == 0) {
        question = 'Slope of line from (0,0) to ($a,$b)?';
        answer = (b / a).toStringAsFixed(1);
      } else if (type == 1) {
        question = 'Apply exponent rule: $a^2 × $a^3';
        answer = '${a}^5';
      } else {
        question = 'What is √${a * a}?';
        answer = '$a';
      }
      break;

    case 9:
      if (type == 0) {
        question = 'Factor: x² + ${2 * a}x + ${a * a}';
        answer = '(x + $a)²';
      } else if (type == 1) {
        question = 'What is ($a + $b)²?';
        answer = '${(a + b) * (a + b)}';
      } else {
        question = 'Quadratic: x² - ${a + b}x + ${a * b} = 0 → roots?';
        answer = '$a and $b';
      }
      break;

    case 10:
      if (type == 0) {
        question = 'Name a property of triangles';
        answer = 'Sum of angles = 180°';
      } else if (type == 1) {
        question = 'Find area of circle with r=${a % 10}';
        answer = '${(3.14 * pow(a % 10, 2)).toStringAsFixed(1)}';
      } else {
        question = 'Right triangle: legs $a, $b. Hypotenuse?';
        answer = '${sqrt(a * a + b * b).toStringAsFixed(1)}';
      }
      break;

    case 11:
      if (type == 0) {
        question = 'What is log base 10 of ${10 * a}?';
        answer = '${(log(10 * a) / log(10)).toStringAsFixed(1)}';
      } else if (type == 1) {
        question = 'Solve: (x - $a)(x + $a) = 0';
        answer = '$a and -$a';
      } else {
        question = 'What is ($a + $b)! if both < 5?';
        int f = 1;
        for (int i = 1; i <= a + b; i++) f *= i;
        answer = '$f';
      }
      break;

    case 12:
    default:
      if (type == 0) {
        question = 'What is the limit as x→0 of sin(x)/x?';
        answer = '1';
      } else if (type == 1) {
        question = 'Evaluate: cos²($a) + sin²($a)';
        answer = '1';
      } else {
        question = 'Matrix: Add [[1,2],[3,4]] + [[${a},0],[0,${b}]]';
        answer = '[[${1 + a},2],[3,${4 + b}]]';
      }
      break;
  }

  choices.add(answer);
  while (choices.length < 4) {
    int delta = rnd.nextInt(10) - 5;
    String fake = (int.tryParse(answer.replaceAll(RegExp(r'[^0-9\-]'), '')) ?? 0 + delta).toString();
    if (!choices.contains(fake)) choices.add(fake);
  }
  choices.shuffle();
  return {'question': question, 'answer': answer, 'choices': choices};
}

