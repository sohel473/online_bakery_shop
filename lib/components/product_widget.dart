import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pc_build_assistant/models/product.dart';
import 'package:pc_build_assistant/util/constants.dart';

typedef OnComponentSelected(Product component);

class ProductWidget extends StatelessWidget {
  final Product component;
  final OnComponentSelected onAdd;
  final OnComponentSelected onView;
  ProductWidget({Key key, @required this.component, this.onAdd, this.onView})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    CachedNetworkImageProvider img = CachedNetworkImageProvider(
      component.imgurl,
    );
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kProductBoxColor,
        boxShadow: [
          BoxShadow(
            color: Color(0x44000000),
            blurRadius: 6,
            spreadRadius: 3,
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: img,
            width: 150,
            height: 150,
          ),
          Text(
            component.name,
            style: TextStyle(
              fontFamily: "Rodin",
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1, color: Colors.green)),
            padding: EdgeInsets.all(5),
            child: Text(
              component.price.toString() + " Tk",
              style: TextStyle(color: Colors.green, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          //-------------------------row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kRadius),
                  color: Colors.greenAccent,
                ),
                child: RawMaterialButton(
                  child: Text(
                    "Add to cart",
                    style: kAnimatedTextStyle.copyWith(fontSize: 10),
                  ),
                  onPressed: () {
                    onAdd(component);
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kRadius),
                  color: Colors.blueAccent,
                ),
                child: RawMaterialButton(
                  child: Text(
                    "Details",
                    style: kAnimatedTextStyle.copyWith(fontSize: 10),
                  ),
                  onPressed: () {
                    onView(component);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
