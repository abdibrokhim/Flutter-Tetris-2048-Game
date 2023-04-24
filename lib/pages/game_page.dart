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
  List<dynamic> landedPiece = [];
  List<dynamic> landedPosColor = [];
  Color chosenColor = Colors.red;

  static int numberOfSquares = 180;
  static int number = 0;
  double count  = 0;
  bool isGameOver = false;

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
    const duration = Duration(milliseconds: 500);

    Timer.periodic(
      duration,
      (timer) {
        if (hitFloor()) {
          landedPiece.add(chosenPiece);
          // print('landedPiece: $landedPiece');

          landedPosColor.add([chosenPiece, chosenColor]);
          print('landedPosColor: $landedPosColor');

          number++;
          startGame();
          timer.cancel();
        } else {
          if (!isGameOver) {
            moveDown();
          } else if (isGameOver) {
            timer.cancel();
            return;
          }
        }
      }
    );
  }
  
  void resetPieces() {
    // landedPiece = [];
    // chosenPiece = [];
    // landedPosColor = [];
  }

  void choosePiece() {
    // Choose a random piece
    int randomIndex = Random().nextInt(pieces.length);
    
    chosenPiece = pieces[randomIndex];
    print('chosenPiece: $chosenPiece');

    chosenColor = pieceColor[randomIndex];
    print('color: $chosenColor');
  }

  bool hitFloor() {
    bool hitFloor = false;
    chosenPiece.sort();

    print('chosenPiece.sort(): $chosenPiece');

    if (chosenPiece[chosenPiece.length - 1] + 10 >= numberOfSquares) {
      hitFloor = true;
      countLanded();
    }

    if (landedPiece.isNotEmpty) {
      if (!isGameOver) {
        for (int i = 0; i < landedPiece.length; i++) {
          print('landedPiece[i]: $landedPiece');

          print('chosenPiece[chosenPiece.length - 1]:');
          print(chosenPiece[chosenPiece.length - 1]);

          for (int j = 0; j < chosenPiece.length; j++) {
            if (landedPiece[i].contains(chosenPiece[j] + 10)) {
              hitFloor = true;
              countLanded();
              break;
            }
          }
        }
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

  void moveLeft() {
    setState(() {
      for (int i = 0; i < chosenPiece.length; i++) {
        chosenPiece[i] -= 1;
      }
      landedPiece[landedPiece.length-1] = chosenPiece; // update landedPiece
    });
  }

  void moveRight() {
    setState(() {
      for (int i = 0; i < chosenPiece.length; i++) {
        chosenPiece[i] += 1;
      }
      landedPiece[landedPiece.length-1] = chosenPiece; // update landedPiece
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
            newColor: chosenColor,
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
                  onTap: moveLeft, 
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
                  onTap: moveRight, 
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