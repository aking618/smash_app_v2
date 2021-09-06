import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RandomStageGenerator extends StatefulWidget {
  final db;
  const RandomStageGenerator({Key? key, this.db}) : super(key: key);

  @override
  _RandomStageGeneratorState createState() => _RandomStageGeneratorState();
}

class _RandomStageGeneratorState extends State<RandomStageGenerator> {
  final _random = Random();
  List<String> stageNames = [];
  List<dynamic> stageImgPaths = [];

  @override
  void initState() {
    super.initState();
    _getStageNames();
    _getStageImgPaths();
  }

  _getStageNames() async {
    // do http request

    setState(() {
      stageNames = List.generate(103, (index) => "Hello $index");
    });
  }

  _getStageImgPaths() async {
    setState(() {
      stageImgPaths =
          List.generate(103, (index) => "assets/images/stage_img$index.jpg");
    });
  }

  // build body

  // copy RandomCharacterGenerator layout

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
