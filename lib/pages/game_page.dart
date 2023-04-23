import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris2048/components/grid.dart';
import 'package:tetris2048/components/game_button.dart';



class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  static List<List<int>> pieces = [
    [4, 5, 14, 15],
    [4, 14, 24, 25],
    [5, 15, 24, 25],
    [4, 14, 24, 34],
    [4, 14, 15, 25],
    [5, 15, 14, 24],
    [4, 5, 6, 15],
  ];

  List<Color> pieceColor = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
  ];

  List<int> chosenPiece = [];
  List<int> landedPiece = [];
  List<List<int>> landedPosColor = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];

  static int numberOfSquares = 180;
  static int number = 0;
  double count  = 0;

  void countLanded() {
    for (int i = 0; i < numberOfSquares; i++) {
      if (landedPiece.contains(i)) {
        count++;
      }
    }
    if (count == numberOfSquares) {
      print("Game Over");
    }
    count = 0;
  }


  void startGame() {
    resetPieces();
    choosePiece();
    const duration = Duration(milliseconds: 300);

    Timer.periodic(
      duration,
      (timer) {
        if (hitFloor()) {
          for (int i = 0; i < chosenPiece.length; i++) {
            landedPiece.add(chosenPiece[i]);
            print('landedPiece: $landedPiece');
            
            landedPosColor[number % pieces.length].add(chosenPiece[i]);
          }
          number++;
          startGame();
          timer.cancel();
        } else {
          moveDown();
        }
      }
    );
  }
  
  void resetPieces() {
    landedPiece = [];
    landedPosColor = [];
  }

  void choosePiece() {
    // Choose a random piece
    int randomIndex = Random().nextInt(pieces.length);
    chosenPiece = pieces[randomIndex];

    print('chosenPiece: $chosenPiece');

    // Assign a color to each square in the chosen piece
    Color color = pieceColor[randomIndex]; // Replace red with the desired color
    print('color: $color');

    print('landedPosColor: $landedPosColor');
  }

  bool hitFloor() {
    bool hitFloor = false;
    chosenPiece.sort();

    if (chosenPiece[chosenPiece.length - 1] + 10 >= numberOfSquares) {
      hitFloor = true;
      countLanded();
    }

    for (int i = 0; i < chosenPiece.length; i++) {
      if (landedPiece.contains(chosenPiece[i] + 10)) {
        hitFloor = true;
        countLanded();
      }
    }
    return hitFloor;
  }

  void moveDown() {
    setState(() {
      for (int i = 0; i < chosenPiece.length; i++) {
        chosenPiece[i] += 10;
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
      // appBar: AppBar(
      //   title: const Text("Tetris 2048"),
      // ),
      children: <Widget> [
        Expanded(
          child: GameGridView(
            newPiece: chosenPiece,
            landedPieces: landedPosColor,
            newColor: pieceColor[number % pieces.length],
          ),
        ),
        SizedBox(
          height: 100,
          child: Row(
            children: <Widget> [
              Expanded(
                child: GestureDetector(
                  onTap: startGame, 
                  child: const GameButton(
                    child: Text("Play", 
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: startGame, 
                  child: const GameButton(
                    child: Icon(
                      Icons.arrow_left,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: startGame, 
                  child: const GameButton(
                    child: Icon(
                      Icons.arrow_right,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: startGame, 
                  child: const GameButton(
                    child: Icon(
                      Icons.rotate_right,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    );
  }
}