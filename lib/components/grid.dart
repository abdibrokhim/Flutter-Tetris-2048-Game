import 'package:flutter/material.dart';

class GameGridView extends StatelessWidget {
  final List<dynamic> landedPieces;
  final List<dynamic> currentPiece;
  
  
  const GameGridView({
    Key? key,
    required this.landedPieces,
    required this.currentPiece,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 180,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 10,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 0.5,
              ),
            ),
            child: Stack(
              children: <Widget>[
                if (currentPiece.isNotEmpty)
                  for (int i = 0; i < currentPiece[0].length; i++)
                    if (currentPiece[0][i][1] == index)
                      Container(
                        color: currentPiece[1],
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            currentPiece[0][i][0].toString(),
                              style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                if (landedPieces.isNotEmpty)
                  for (int i = 0; i < landedPieces.length; i++)
                    for (int j = 0; j < landedPieces[i][0].length; j++)
                      if (landedPieces[i][0][j][1] == index)
                        Container(
                          color: landedPieces[i][1],
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              landedPieces[i][0][j][0].toString(),
                                style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
              ],
            ),
          );
        },
      ),
    );
  }
}

