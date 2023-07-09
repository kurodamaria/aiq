import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yaml/yaml.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _text = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              TextButton(
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    File file = File(result.files.single.path!);
                    final fileContent = await file.readAsString();
                    setState(() {
                      _text = fileContent;
                    });
                  } else {
                    // User canceled the picker
                  }
                },
                child: Text('Select File'),
              ),
              Card(
                child: SelectableText(_text),
              ),
              Card(
                child: SelectableText(
                  _text.isEmpty
                      ? ''
                      : sha256
                          .convert(
                            utf8.encode(
                              loadYaml(_text)['single_choice'][0]['question'],
                            ),
                          )
                          .toString(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
