import 'dart:io' show Platform;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid || Platform.isIOS) {
    final config = RequestConfiguration(
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
    );
    MobileAds.instance.updateRequestConfiguration(config);
    await MobileAds.instance.initialize();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Renk Avı',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeMenuPage(),
    );
  }
}

class HomeMenuPage extends StatelessWidget {
  const HomeMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mini Oyunlar')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ColorHuntPage()),
                );
              },
              child: const Text('Renk Avı'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const BridgeBuilderPage()),
                );
              },
              child: const Text('Küçük Mühendis: Köprü Kur'),
            ),
          ],
        ),
      ),
    );
  }
}

class ColorHuntPage extends StatefulWidget {
  const ColorHuntPage({super.key});

  @override
  State<ColorHuntPage> createState() => _ColorHuntPageState();
}

class _ColorHuntPageState extends State<ColorHuntPage> {
  List<String> currentPalette = ['red', 'green', 'blue'];
  String targetColor = 'blue';
  Key gridKey = UniqueKey();
  late BannerAd _bannerAd;
  bool _bannerLoaded = false;
  InterstitialAd? _interstitialAd;
  int _correctCount = 0;

  String get baseUrl {
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    return 'http://localhost:3000';
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid || Platform.isIOS) {
      _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-3940256099942544/6300978111',
        listener: BannerAdListener(
          onAdLoaded: (_) => setState(() => _bannerLoaded = true),
          onAdFailedToLoad: (_, __) => setState(() => _bannerLoaded = false),
        ),
        request: const AdRequest(),
      )..load();
      InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) => _interstitialAd = ad,
          onAdFailedToLoad: (_) => _interstitialAd = null,
        ),
      );
    }
    _fetchLevels();
  }

  Future<void> _fetchLevels() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/api/color-hunt/levels'))
          .timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List;
        if (list.isNotEmpty) {
          final level = Map<String, dynamic>.from(list.first);
          final palette = List<String>.from(jsonDecode(level['paletteJson']));
          currentPalette = List<String>.from(palette)..shuffle();
          targetColor = (List<String>.from(palette)..shuffle()).first;
          setState(() {});
        }
      }
    } catch (_) {
      // sessiz geç
    }
  }

  void _onTapName(String name, int index) {
    final correct = name == targetColor;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(correct ? 'Doğru!' : 'Tekrar dene'),
        duration: const Duration(milliseconds: 800),
      ),
    );
    _postEvent(correct);
    if (!correct) return;
    currentPalette = [...currentPalette.sublist(1), currentPalette.first];
    gridKey = UniqueKey();
    _correctCount++;
    if (_interstitialAd != null && _correctCount % 3 == 0) {
      _interstitialAd!.show();
      _interstitialAd = null;
      InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) => _interstitialAd = ad,
          onAdFailedToLoad: (_) => _interstitialAd = null,
        ),
      );
    }
    setState(() {});
  }

  Future<void> _postEvent(bool correct) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/api/color-hunt/events'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'sessionId': 'local',
          'anonymousId': 'anon',
          'eventType': 'tap',
          'payload': {'correct': correct},
        }),
      );
    } catch (_) {}
  }

  Color _parseColor(String name) {
    switch (name) {
      case 'red':
        return Colors.red;
      case 'green':
        return Colors.green;
      case 'blue':
        return Colors.blue;
      case 'yellow':
        return Colors.yellow;
      case 'purple':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  String _instructionText() {
    switch (targetColor) {
      case 'red':
        return 'KIRMIZIYI BUL!';
      case 'green':
        return 'YEŞİLİ BUL!';
      case 'blue':
        return 'MAVİYİ BUL!';
      case 'yellow':
        return 'SARIYI BUL!';
      case 'purple':
        return 'MORU BUL!';
      default:
        return 'Rengi Bul!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_instructionText())),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Row(
                key: gridKey,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(currentPalette.length, (i) {
                  final name = currentPalette[i];
                  final color = _parseColor(name);
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => _onTapName(name, i),
                    child: Container(
                      margin: const EdgeInsets.all(12),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(blurRadius: 6, color: Colors.black26),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          if (_bannerLoaded && (Platform.isAndroid || Platform.isIOS))
            SizedBox(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd),
            ),
        ],
      ),
    );
  }
}

class BridgeBuilderPage extends StatefulWidget {
  const BridgeBuilderPage({super.key});

  @override
  State<BridgeBuilderPage> createState() => _BridgeBuilderPageState();
}

class _BridgeBuilderPageState extends State<BridgeBuilderPage>
    with SingleTickerProviderStateMixin {
  // Görsel ölçüler
  final double totalWidth = 360;
  final double pillarWidth = 80;
  final double roadHeight = 14;

  // Seviye parametreleri
  late double gap; // piksel cinsinden boşluk
  int rodsLeft = 3;
  final List<double> options = [60, 80, 100];
  double builtLength = 0;

  // Araç animasyonu
  late AnimationController controller;
  late Animation<double> carX;
  bool running = false;
  bool success = false;

  @override
  void initState() {
    super.initState();
    _resetLevel();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    carX = Tween<double>(begin: 0, end: totalWidth).animate(controller)
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) {
          setState(() {
            running = false;
          });
        }
      });
  }

  void _resetLevel() {
    gap = 150 + (DateTime.now().millisecond % 70);
    rodsLeft = 3;
    builtLength = 0;
    success = false;
    running = false;
  }

  void _addRod(double len) {
    if (running || rodsLeft <= 0) return;
    setState(() {
      builtLength += len;
      rodsLeft -= 1;
    });
  }

  void _start() {
    if (running) return;
    // Başarı ölçütü: yerleştirilen toplam uzunluk, boşluğu kapatmalı
    success = builtLength >= gap;
    setState(() {
      running = true;
    });
    _postBridgeEvent();
    controller.reset();
    controller.forward();
    final msg = success ? 'Başarılı! Araç geçti' : 'Köprü çöktü!';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(milliseconds: 900)),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leftPillarColor = success ? Colors.green : Colors.grey.shade700;
    final rightPillarColor = success ? Colors.green : Colors.grey.shade700;
    return Scaffold(
      appBar: AppBar(title: const Text('Küçük Mühendis: Köprü Kur')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Görsel sahne
            SizedBox(
              width: totalWidth,
              height: 180,
              child: Stack(
                children: [
                  // Sol ayak
                  Positioned(
                    left: 0,
                    bottom: 24,
                    child: Container(
                        width: pillarWidth, height: 80, color: leftPillarColor),
                  ),
                  // Sağ ayak
                  Positioned(
                    left: pillarWidth + gap,
                    bottom: 24,
                    child: Container(
                        width: pillarWidth,
                        height: 80,
                        color: rightPillarColor),
                  ),
                  // Yol (yerleştirilen uzunluk görseli)
                  Positioned(
                    left: pillarWidth,
                    bottom: 80,
                    child: Container(
                        width: (builtLength.clamp(0.0, gap)) as double,
                        height: roadHeight,
                        color: Colors.brown),
                  ),
                  // Araç
                  AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) {
                      final double x = (carX.value).clamp(
                              0.0, pillarWidth + gap + pillarWidth - 24.0)
                          as double;
                      return Positioned(
                        left: x,
                        bottom: 96,
                        child: Container(
                            width: 24, height: 14, color: Colors.blueAccent),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
                'Boşluk: ${gap.toStringAsFixed(0)} px  |  Yerleştirilen: ${builtLength.toStringAsFixed(0)} px  |  Çubuk: $rodsLeft'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: options
                  .map((e) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6.0),
                        child: ElevatedButton(
                          onPressed: () => _addRod(e),
                          child: Text('${e.toStringAsFixed(0)} px'),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: _start, child: const Text('Başlat')),
                const SizedBox(width: 12),
                OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _resetLevel();
                      });
                    },
                    child: const Text('Sıfırla')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String get _baseUrl {
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    return 'http://localhost:3000';
  }

  Future<void> _postBridgeEvent() async {
    try {
      final rodsUsed = 3 - rodsLeft;
      await http.post(
        Uri.parse('$_baseUrl/api/color-hunt/events'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'sessionId': 'local',
          'anonymousId': 'anon',
          'gameId': 'bridge_builder',
          'eventType': 'bridge_run',
          'payload': {
            'success': success,
            'gap': gap,
            'builtLength': builtLength,
            'rodsUsed': rodsUsed,
          }
        }),
      );
    } catch (_) {}
  }
}
