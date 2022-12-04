import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Joke> fetchJoke() async {
  print('response çalıştı');
  final response = await http.get(Uri.parse(
      'https://v2.jokeapi.dev/joke/Any?blacklistFlags=nsfw,religious,political,racist,explicit&idRange=0-30'));
  print('response attık');
  print(response.body);
  if (response.statusCode == 200) {
    return Joke.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Joke');
  }
}

class Joke {
  Joke({
    required this.error,
    required this.category,
    required this.type,
    required this.joke,
    required this.id,
    required this.safe,
    required this.lang,
  });

  bool error;
  String category;
  String type;
  String joke;
  int id;
  bool safe;
  String lang;

  factory Joke.fromJson(Map<String, dynamic> json) => Joke(
        error: json["error"],
        category: json["category"],
        type: json["type"],
        joke: json["joke"],
        id: json["id"],
        safe: json["safe"],
        lang: json["lang"],
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "category": category,
        "type": type,
        "joke": joke,
        "id": id,
        "safe": safe,
        "lang": lang,
      };
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Joke> futureJoke;

  @override
  void initState() {
    super.initState();
    futureJoke = fetchJoke();
    print(futureJoke);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JOKE',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Today's Joke"),
        ),
        body: Center(
          child: FutureBuilder<Joke>(
            future: futureJoke,
            builder: (context, snapshot) {
              print(snapshot.hasData);
              if (snapshot.hasData) {
                return Text(snapshot.data!.joke);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
