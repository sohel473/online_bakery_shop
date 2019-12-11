import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pc_build_assistant/components/rounded_button_widget.dart';
import 'package:pc_build_assistant/logic/products_manager.dart';
import 'package:pc_build_assistant/models/product.dart';
import 'package:pc_build_assistant/util/constants.dart';

class ViewScreen extends StatefulWidget {
  static String id = "/viewScreenId";

  @override
  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme.copyWith(color: Colors.black),
        title: Text(
          "Description",
          style: TextStyle(fontFamily: "Rodin"),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 100,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Center(
                    child: RoundedButton(
                      onPressed: () {
                        ProductManager.products.add(product);
                      },
                      title: "Add to cart",
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              Image(
                image: CachedNetworkImageProvider(product.imgurl),
                width: 250,
                height: 250,
              ),
              Text(
                product.name,
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
                  product.price.toString() + " Tk",
                  style: TextStyle(color: Colors.green, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Text(
                    product.description,
                    style: kAnimatedTextStyle.copyWith(
                        fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              )
              //-------------------------row
            ],
          ),
        ),
      ),
    );
  }
}
