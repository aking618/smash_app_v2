import 'dart:math';

import 'package:flutter/material.dart';

class RandomCharacterGenerator extends StatefulWidget {
  const RandomCharacterGenerator({Key? key}) : super(key: key);

  @override
  _RandomCharacterGeneratorState createState() =>
      _RandomCharacterGeneratorState();
}

class _RandomCharacterGeneratorState extends State<RandomCharacterGenerator> {
  List<String> options = [];
  String selectedOption = "";

  @override
  void initState() {
    super.initState();
    getOptions();
  }

  Future<void> getOptions() async {
    // final result = await retreiveOptions();
    final result = List<String>.generate(50, (index) => "$index");
    setState(() => options = result);
  }

  Container buildBody() {
    return Container(
        child: Column(
      children: [
        buildResult(),
        buildRandomizeButton(),
      ],
    ));
  }

  buildResult() {
    return Text(selectedOption);
  }

  buildRandomizeButton() {
    return TextButton(
      onPressed: () {
        Random rand = new Random();
        setState(() => selectedOption = options[rand.nextInt(options.length)]);
      },
      child: Text(
        "Randomize Character",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody(),
    );
  }
}
