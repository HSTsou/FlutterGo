import 'package:flutter/material.dart';

class AlbumCard extends StatelessWidget {
  final Color color;
  final String imageUrl;
  final String title;
  final int idx;
  final double currentPage;

  AlbumCard(
      {this.color, this.idx, this.imageUrl, this.title, this.currentPage});

  @override
  Widget build(BuildContext context) {
    double relativePosition = idx - currentPage;
    return Container(
      width: 250,
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.003) // add perspective
          ..scale((1 - relativePosition.abs()).clamp(0.2, 0.6) + 0.4)
          ..rotateY(relativePosition),
        alignment: relativePosition >= 0
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: Container(
          child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: DecoratedBox(
                decoration: const BoxDecoration(color: Colors.black45),
                child: Text(title,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "CircularStd",
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    )),
              )),
          margin: EdgeInsets.only(top: 16, bottom: 16, left: 4, right: 4),
          padding: EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: color,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(imageUrl),
            ),
          ),
        ),
      ),
    );
  }
}
