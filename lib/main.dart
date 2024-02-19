import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData _theme = ThemeData.dark();

  void setTheme(bool isDarkMode) {
    setState(() {
      _theme = isDarkMode ? ThemeData.dark() : ThemeData.light();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BreatheClear v1',
      theme: _theme,
      home: HomeScreen(setTheme: setTheme),
      routes: {
        '/settings': (context) => SettingsScreen(setTheme: setTheme),
        '/saving': (context) => SavingScreen(),
        '/donation': (context) => DonationScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Function(bool) setTheme;

  HomeScreen({required this.setTheme});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  late DateTime _startTime;
  late Duration _elapsedTime;

  bool _isCounting = false;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _elapsedTime = Duration(seconds: 0);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        _elapsedTime = DateTime.now().difference(_startTime);
      });
      _checkAchievements();
    });
  }

  void _resetTimer() {
    setState(() {
      _isCounting = false;
      _elapsedTime = Duration(seconds: 0);
    });
    _timer.cancel();
  }

  void _startCountup() {
    if (!_isCounting) {
      setState(() {
        _isCounting = true;
        _startTime = DateTime.now();
      });
      _startTimer();
    }
  }

  void _checkAchievements() {
    for (Achievement achievement in AchievementScreen.achievements) {
      if (_elapsedTime >= achievement.timeRequired && !achievement.isCompleted) {
        setState(() {
          achievement.isCompleted = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BreatheClear v1.0'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfileGreeting(),
            SizedBox(height: 20),
            Text(
              _formatDuration(_elapsedTime),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_isCounting) {
                  _resetTimer();
                } else {
                  _startCountup();
                }
              },
              child: Text(_isCounting ? 'Refresh' : 'Start'),
            ),
            SizedBox(height: 80),
            Text(
              _getRandomQuote(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
          
        ),
        
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset('assets/home.png', width: 24, height: 24),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/saving.png', width: 24, height: 24),
            label: 'Saving',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/achievements.png', width: 24, height: 24),
            label: 'Achievements',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/settings.png', width: 24, height: 24),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/donation.png', width: 24, height: 24),
            label: 'Donation',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/info.png', width: 24, height: 24),
            label: 'Info',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/profile.png', width: 24, height: 24),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue,
        onTap: (index) {
          switch (index) {
            case 0:
            // Burada "Home" sayfasına geçiş yapabilirsiniz.
              break;
            case 1:
            // Burada "Saving" sayfasına geçiş yapabilirsiniz.
              Navigator.pushNamed(context, '/saving');
              break;
            case 2:
            // Burada "Achievements" sayfasına geçiş yapabilirsiniz.
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AchievementScreen()),
              );
              break;
            case 3:
            // Burada "Settings" sayfasına geçiş yapabilirsiniz.
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen(setTheme: widget.setTheme)),
              );
              break;
            case 4:
            // Burada "Donation" sayfasına geçiş yapabilirsiniz.
              Navigator.pushNamed(context, '/donation');
              break;
            case 5:
            // Burada "Info" sayfasına geçiş yapabilirsiniz.
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InfoScreen()),
              );
              break;
            case 6:
            // Burada "Profile" sayfasına geçiş yapabilirsiniz.
              Navigator.pushNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitDays = twoDigits(duration.inDays);

    return "$twoDigitDays days $twoDigitHours hours $twoDigitMinutes minutes $twoDigitSeconds seconds";
  }

  String _getRandomQuote() {
    final quotes = ["“If you accept the expectations of others, especially negative ones, then you never will change the outcome.”\n– Michael Jordan","“Recovery is about progression, not perfection.”\n– Unknown","“The only person you are destined to become is the person you decide to be.”\n– Ralph Waldo Emerson","“One of the hardest things was learning that I was worth recovery.”\n– Demi Lovato","“You have to break down before you can breakthrough.”\n– Marilyn Ferguson"];
    final random = Random();
    return quotes[random.nextInt(quotes.length)];
  }
}

class ProfileGreeting extends StatefulWidget {
  @override
  _ProfileGreetingState createState() => _ProfileGreetingState();
}

class _ProfileGreetingState extends State<ProfileGreeting> {
  late Future<void> _profileDataFuture;
  String _name = '';
  String _surname = '';

  @override
  void initState() {
    super.initState();
    _profileDataFuture = _getProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _profileDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Welcome back!');
        } else {
          if (_name.isNotEmpty && _surname.isNotEmpty) {
            return Text('Welcome back $_name $_surname!');
          } else {
            return Text('Welcome back!');
          }
        }
      },
    );
  }

  Future<void> _getProfileData() async {
    // Simüle edilmiş profil verileri alınır.
    await Future.delayed(Duration(seconds: 2));
    _name = 'John'; // Kullanıcı adı alınır.
    _surname = 'Doe'; // Kullanıcı soyadı alınır.
  }
}

class AchievementScreen extends StatelessWidget {
  static final List<Achievement> achievements = [
    Achievement(name: '- 20 minutes later: your heart rate and blood pressure drop.', timeRequired: Duration(minutes: 20)),
    Achievement(name: '- 12 hours later: the carbon monoxide level in your blood returns to normal.', timeRequired: Duration(hours: 12)),
    Achievement(name: '- 1 month later: your blood circulation improves and your lung function improves.', timeRequired: Duration(days: 30)),
    Achievement(name: '- 4 months later: your cough and shortness of breath decrease.', timeRequired: Duration(days: 120)),
    Achievement(name: '- 1 year later: your risk of coronary heart disease is half that of a smoker.', timeRequired: Duration(days: 365)),
    Achievement(name: '- 5 years later: your risk of stroke is reduced to that of someone who has not smoked for 5-15 years.', timeRequired: Duration(days: 1825)),
    Achievement(name: '- 10 years later: your risk of dying from lung cancer is about half that of a smoker.', timeRequired: Duration(days: 3650)),
    Achievement(name: '- 15 years later: your risk of coronary heart disease is reduced to that of a non-smoker.', timeRequired: Duration(days: 5475)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Achievement'),
        leading: IconButton(
          icon: Image.asset('assets/back_arrow.png'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(achievements[index].name),
                trailing: Checkbox(
                  value: achievements[index].isCompleted,
                  onChanged: null,
                ),
              ),
              SizedBox(height: 8), // 8 piksel boşluk
            ],
          );
        },
      ),
    );
  }





  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitDays = twoDigits(duration.inDays);

    return "$twoDigitDays days $twoDigitHours hours $twoDigitMinutes minutes $twoDigitSeconds seconds";
  }
}



class Achievement {
  final String name;
  final Duration timeRequired;
  bool isCompleted;

  Achievement({required this.name, required this.timeRequired, this.isCompleted = false});
}

class SettingsScreen extends StatelessWidget {
  final Function(bool) setTheme;

  SettingsScreen({required this.setTheme});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        leading: IconButton(
          icon: Image.asset('assets/back_arrow.png'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                setTheme(value);
              },
            ),
            Text('Dark Mode'),
          ],
        ),
      ),
    );
  }
}

class SavingScreen extends StatefulWidget {
  @override
  _SavingScreenState createState() => _SavingScreenState();
}

class _SavingScreenState extends State<SavingScreen> {
  final TextEditingController _cigarettesController = TextEditingController();
  final TextEditingController _packPriceController = TextEditingController();
  int _dailyCigarettes = 0;
  double _packPrice = 0;
  double _dailyCost = 0;
  double _weeklyCost = 0;
  double _monthlyCost = 0;
  double _annualCost = 0;
  double _fiveYearCost = 0;
  double _tenYearCost = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saving'),
        leading: IconButton(
          icon: Image.asset('assets/back_arrow.png'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cigarettesController,
              decoration: InputDecoration(labelText: 'Daily Cigarettes'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _dailyCigarettes = int.tryParse(value) ?? 0;
                  _updateCost();
                });
              },
            ),
            TextField(
              controller: _packPriceController,
              decoration: InputDecoration(labelText: 'Pack Price (\$)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  _packPrice = double.tryParse(value) ?? 0;
                  _updateCost();
                });
              },
            ),
            SizedBox(height: 20),
            Text('Daily Cost: \$${_dailyCost.toStringAsFixed(2)}'),
            Text('Weekly Cost: \$${_weeklyCost.toStringAsFixed(2)}'),
            Text('Monthly Cost: \$${_monthlyCost.toStringAsFixed(2)}'),
            Text('Annual Cost: \$${_annualCost.toStringAsFixed(2)}'),
            Text('5-Year Cost: \$${_fiveYearCost.toStringAsFixed(2)}'),
            Text('10-Year Cost: \$${_tenYearCost.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }

  void _updateCost() {
    _dailyCost = _dailyCigarettes * _packPrice;
    _weeklyCost = _dailyCost * 7;
    _monthlyCost = _dailyCost * 30;
    _annualCost = _dailyCost * 365;
    _fiveYearCost = _dailyCost * 365 * 5;
    _tenYearCost = _dailyCost * 365 * 10;
  }
}

class DonationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donation'),
        leading: IconButton(
          icon: Image.asset('assets/back_arrow.png'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Support the Cause',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Open smoking donation link in browser
                // You can use packages like url_launcher for this purpose
              },
              child: Column(
                children: [
                  Text('Join Charities fight against Smoking'),
                  Text('https://truthinitiative.org/donate'),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Open alcohol donation link in browser
                // You can use packages like url_launcher for this purpose
              },
              child: Column(
                children: [
                  Text('Join Charities fight against Alcohol'),
                  Text('https://alcoholchange.org.uk/get-involved/donate/donate-now'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _name = '';
  String _surname = '';
  int _age = 0;

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Profil verilerini yükle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        leading: IconButton(
          icon: Image.asset('assets/back_arrow.png'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              onChanged: (value) => _name = value,
            ),
            TextField(
              controller: _surnameController,
              decoration: InputDecoration(labelText: 'Surname'),
              onChanged: (value) => _surname = value,
            ),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
              onChanged: (value) => _age = int.tryParse(value) ?? 0,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfileData, // Profil verilerini kaydet
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  // Profil verilerini geçici değişkenlere yükle
  void _loadProfileData() {
    setState(() {
      _nameController.text = _name;
      _surnameController.text = _surname;
      _ageController.text = _age.toString();
    });
  }

  // Profil verilerini geçici değişkenlere kaydet
  void _saveProfileData() {
    setState(() {
      _name = _nameController.text;
      _surname = _surnameController.text;
      _age = int.tryParse(_ageController.text) ?? 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile saved')));
  }
}

class InfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saving'),
        leading: IconButton(
          icon: Image.asset('assets/back_arrow.png'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: InfoContent(),
    );
  }
}

class InfoContent extends StatefulWidget {
  @override
  _InfoContentState createState() => _InfoContentState();
}

class _InfoContentState extends State<InfoContent> {
  bool _expanded = false;

  @override
Widget build(BuildContext context) {
  return ExpansionTile(
    title: Text('What are the Health Problems Caused by Tobacco Addiction?'),
    trailing: Image.asset('assets/down.png', width: 24, height: 24),
    onExpansionChanged: (value) {
      setState(() {
        _expanded = value;
      });
    },
    children: [
      if (_expanded)
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1-Types of cancer (lung, stomach, skin, cervix, etc.):\n'
              '2-Heart and vascular diseases\n'
              '3-Diabetes\n'
              '4-Respiratory diseases\n'
              '5-Gastric diseases such as gastritis, ulcer\n'
              '6-Tooth and gum diseases\n'
              '7-Premature birth, miscarriage, developmental disorders in the child, cessation of milk',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10), // Boşluk ekleyebilirsiniz
            Center(
            child: Image.asset('assets/sigara.png', width: 300, height: 300),
            )
          ],
        ),
    ],
    initiallyExpanded: _expanded,
  );
}

}