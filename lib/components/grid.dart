import 'package:flutter/material.dart';

class GameGridView extends StatelessWidget {
  final List<int> newPiece;
  final List<dynamic> landedPieces;
  final Color newColor;
  
  
  const GameGridView({
    Key? key,
    required this.newPiece,
    required this.landedPieces,
    required this.newColor,
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
                if (newPiece.contains(index))
                  Container(
                    color: newColor,
                ),
                if (landedPieces.isNotEmpty)
                  for (int i = 0; i < landedPieces.length; i++)
                    if (landedPieces[i][0].contains(index))
                      Container(
                        color: landedPieces[i][1],
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}

