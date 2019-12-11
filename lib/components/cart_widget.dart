import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pc_build_assistant/models/product.dart';
import 'package:pc_build_assistant/util/constants.dart';

typedef OnComponentRemove(Product component);

class CartProductWidget extends StatefulWidget {
  final Product component;
  final OnComponentRemove onRemove;
  CartProductWidget({Key key, @required this.component, this.onRemove})
      : super(key: key);

  @override
  _CartProductWidgetState createState() => _CartProductWidgetState();
}

class _CartProductWidgetState extends State<CartProductWidget>
    with TickerProviderStateMixin {
  bool _removed; //keeps track of whether the component has been removed or not
  @override
  void initState() {
    _removed = widget.component != null
        ? false
        : true; // sets the initial value of widget
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          Radius.circular(kRadius),
        ),
      ),
      child: Column(
        //Title and rest
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AnimatedSize(
            vsync: this,
            duration: Duration(milliseconds: 100),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: !_removed
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image(
                          image: CachedNetworkImageProvider(
                              widget.component.imgurl),
                          width: 150,
                          height: 150,
                        ),
                        Text(
                          widget.component.name,
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
                              border:
                                  Border.all(width: 1, color: Colors.green)),
                          padding: EdgeInsets.all(5),
                          child: Text(
                            widget.component.price.toString() + " Tk",
                            style: TextStyle(color: Colors.green, fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        //-------------------------row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(kRadius),
                                color: kRegisterButtonColor,
                              ),
                              child: RawMaterialButton(
                                child: Text(
                                  "Remove",
                                  style:
                                      kAnimatedTextStyle.copyWith(fontSize: 10),
                                ),
                                onPressed: () {
                                  if (widget.onRemove != null) {
                                    setState(() {
                                      _removed = true;
                                    });
                                    widget.onRemove(widget.component);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(
                      key: UniqueKey(),
                      //When there's no component of this type
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                Icons.help,
                                size: 40,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              "Not Added",
                              style: TextStyle(
                                  fontSize: 20, color: kRedButtonColor),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
