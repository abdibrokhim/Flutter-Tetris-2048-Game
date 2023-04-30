import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tetris2048/components/grid.dart';
import 'package:tetris2048/components/game_button.dart';
import 'package:tetris2048/components/constants.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  List<dynamic> tempPieces = [];

  List<dynamic> currentPiece = [];
  // example list
  // List<dynamic> currentPiece = [
  //            [[2, 4, pieceColor[0]], [2, 5, pieceColor[0]], [2, 14, pieceColor[0]], [2, 15, pieceColor[0]]],
  // ];
  
  List<dynamic> landedPieces = [];
  // example list
  // List<dynamic> currentPiece = [
  //        [[2, 4, pieceColor[0]], [2, 5, pieceColor[0]], [2, 14, pieceColor[0]], [2, 15, pieceColor[0]]],
  //        [[2, 4, pieceColor[0]], [2, 5, pieceColor[0]], [2, 14, pieceColor[0]], [2, 15, pieceColor[0]]]
  // ];

  static const duration = Duration(milliseconds: 500);

  static int numberOfSquares = 180;
  double count  = 0;
  bool isGameOver = false;
  

  void startGame() {
    resetPieces();

    choosePiece();


    Timer.periodic(
      duration,
      (timer) {
        if (hitFloor()) {
          landedPieces.add(currentPiece);
          
          print('landedPieces:');
          for (int i = 0; i < landedPieces.length; i++) {
            print(landedPieces[i]);
          }

          startGame();
          timer.cancel();

        } else {
          if (!isGameOver) {
            moveDown(currentPiece);
          } else if (isGameOver) {
            timer.cancel();
            
            print('Game Over');
            return;
          }
        }
      }
    );
  }
  
  void resetPieces() {
    currentPiece = [];
  }

  void choosePiece() {
    int randomIndex = Random().nextInt(pieces.length);
    
    currentPiece.add(pieces[randomIndex]);

    print('currentPiece: $currentPiece');

  }


  bool hitFloor() {
    bool hitFloor = false;

    // currentPiece[1].sort();
    for (int i = 0; i < currentPiece[0].length; i++) {
      if (currentPiece[0][i][1] + 10 >= numberOfSquares) {
        hitFloor = true;
      }
    }

    if (landedPieces.isNotEmpty) {
      // isGameOver = gameOver();
    
      if (!isGameOver) {
        if (hitPiece()) {

          print('hitPiece() = true:');

          setState(() {
            for (int j = landedPieces.length - 1; j >= 0; j--) {
              print('j: $j');
              
              for (int k = 0; k < landedPieces[j][0].length; k++) {
                print('k: $k');

                for (int i = 0; i < currentPiece[0].length; i++) {
                  print('i: $i');

                  print(landedPieces[j][0][k][1] == currentPiece[0][i][1] + 10);
                  print(landedPieces[j][0][k][0] == currentPiece[0][i][0]);

                  if (landedPieces[j][0][k][1] == currentPiece[0][i][1] + 10 && landedPieces[j][0][k][0] == currentPiece[0][i][0]) {

                    landedPieces[j][0][k][0] *= 2;
                    print("landedPieces[j][0][k][0]:");
                    print(landedPieces[j][0][k][0]);
                    
                    if (landedPieces[j][0][k][0] == 4) {
                      landedPieces[j][0][k][2] = pieceColor[1];
                    } else if (landedPieces[j][0][k][0] == 8) {
                      landedPieces[j][0][k][2] = pieceColor[2];
                    } else if (landedPieces[j][0][k][0] == 16) {
                      landedPieces[j][0][k][2] = pieceColor[3];
                    }

                    List<dynamic> temp = currentPiece[0][i];
                    print('temp: $temp');
                    
                    currentPiece[0].removeAt(i);

                    moveDown(currentPiece);
                    // break;
                  }
                }
              }
            }
          });

          hitFloor = true;
        }
      }
    }

    return hitFloor;
  }

  bool hitPiece() {
    bool hitPiece = false;

    if (landedPieces.isNotEmpty) {
      for (int i = 0; i < landedPieces.length; i++) {
        for (int k = 0; k < landedPieces[i][0].length; k++) {
          for (int j = 0; j < currentPiece[0].length; j++) {
            if (landedPieces[i][0][k][1] == currentPiece[0][j][1] + 10) {
              hitPiece = true;
            }
          }
        }
      }
    }

    return hitPiece;
  }

  bool gameOver() {
    if (landedPieces.isNotEmpty) {
      for (int i = 0; i < currentPiece[0].length; i++) {
        if (landedPieces[landedPieces.length - 1][0][i][1] == currentPiece[0][i][1] + 10) {
          return true;
        }
      }
    }

    return false;
  }


  void moveDown(List<dynamic> piece) {
    setState(() {
      for (int i = 0; i < piece[0].length; i++) {
        piece[0][i][1] += 10;
      }
    });
  }

  // TODO: implement turnLeft
  void moveLeft() {
    setState(() {
      for (int i = 0; i < currentPiece.length; i++) {
        currentPiece[i] -= 1;
      }
      landedPieces[landedPieces.length-1] = currentPiece; // update landedPieces
    });
  }


  // TODO: implement turnRight
  void moveRight() {
    setState(() {
      for (int i = 0; i < currentPiece.length; i++) {
        currentPiece[i] += 1;
      }
      landedPieces[landedPieces.length-1] = currentPiece; // update landedPieces
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
            landedPieces: landedPieces,
            currentPiece: currentPiece,
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