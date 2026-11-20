import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza App - Lilis',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Praktikum 4: SharedPreferences
  int appCounter = 0;

  // Praktikum 5: path_provider
  String documentsPath = '';
  String tempPath = '';

  // Praktikum 6: dart:io
  late File myFile;
  String fileText = '';

  // Praktikum 7: flutter_secure_storage
  final storage = const FlutterSecureStorage();
  final String myKey = 'myPass';
  final TextEditingController pwdController = TextEditingController();
  String myPass = '';

  @override
  void initState() {
    super.initState();
    readAndWritePreference();
    getPaths().then((_) {
      myFile = File('$documentsPath/pizzas.txt');
      writeFile().then((_) {
        readFile();
      });
    });
  }

  @override
  void dispose() {
    pwdController.dispose();
    super.dispose();
  }

  // Praktikum 4: Membaca dan menambah nilai counter di SharedPreferences
  Future<void> readAndWritePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    appCounter = prefs.getInt('appCounter') ?? 0;
    appCounter++;
    await prefs.setInt('appCounter', appCounter);
    setState(() {});
  }

  // Praktikum 4: Menghapus / mereset data SharedPreferences
  Future<void> deletePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      appCounter = 0;
    });
  }

  // Praktikum 5: Mengambil path direktori documents dan temporary
  Future<void> getPaths() async {
    final docDir = await getApplicationDocumentsDirectory();
    final tempDir = await getTemporaryDirectory();
    setState(() {
      documentsPath = docDir.path;
      tempPath = tempDir.path;
    });
  }

  // Praktikum 6: Menulis data ke berkas pizzas.txt
  Future<bool> writeFile() async {
    try {
      await myFile.writeAsString('Margherita, Capricciosa, Napoli');
      return true;
    } catch (e) {
      return false;
    }
  }

  // Praktikum 6: Membaca isi berkas pizzas.txt
  Future<bool> readFile() async {
    try {
      String fileContent = await myFile.readAsString();
      setState(() {
        fileText = fileContent;
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // Praktikum 7: Menyimpan nilai rahasia ke FlutterSecureStorage
  Future<void> writeToSecureStorage() async {
    await storage.write(key: myKey, value: pwdController.text);
  }

  // Praktikum 7: Membaca nilai rahasia dari FlutterSecureStorage
  Future<String> readFromSecureStorage() async {
    String secret = await storage.read(key: myKey) ?? '';
    return secret;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pizza App - Lilis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Bagian SharedPreferences ---
            Text(
              'You have opened the app $appCounter times.',
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: deletePreference,
              child: const Text('Reset counter'),
            ),
            const Divider(height: 32),

            // --- Bagian path_provider ---
            const Text(
              'Documents Path:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(documentsPath),
            const SizedBox(height: 8),
            const Text(
              'Temporary Path:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(tempPath),
            const Divider(height: 32),

            // --- Bagian dart:io (File) ---
            const Text(
              'File Content (pizzas.txt):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(fileText),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                await writeFile();
                await readFile();
              },
              child: const Text('Write & Read File'),
            ),
            const Divider(height: 32),

            // --- Bagian flutter_secure_storage ---
            const Text(
              'Secure Storage:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: pwdController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Masukkan password / secret',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: writeToSecureStorage,
                    child: const Text('Save Value'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final secret = await readFromSecureStorage();
                      setState(() {
                        myPass = secret;
                      });
                    },
                    child: const Text('Read Value'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Saved Value: $myPass'),
          ],
        ),
      ),
    );
  }
}
