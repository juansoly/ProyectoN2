import 'package:flutter/material.dart';
import 'package:places/review.dart';
class ReviewList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    //review list
    final reviewList = Column(
      children: <Widget>[
        Review("assets/image/persona1.jpeg","Goku d","1 reviews - 3 photos",2,"Muy buen lugar para visitar"),
        Review("assets/image/persona2.jpeg","Alfredo Guzman","4 reviews - 3 photos",4,"Los momentos son los lugares interesantes"),
        Review("assets/image/persona3.jpg","Marial Veizaga","3 reviews - 2 photos",5,"Muy buen para sacar fotos"),
        Review("assets/image/persona4.jpg","Luisa Estrada","2 reviews - 3 photos",4,"La vida es hermosa"),
        Review("assets/image/persona5.jpg","Alberto Soria","5 reviews - 5 photos",2,"Muy buen lugar para Viajar")

      ],
    );
   return reviewList;
  }
}