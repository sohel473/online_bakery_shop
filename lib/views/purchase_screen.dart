import 'package:flutter/material.dart';
import 'package:pc_build_assistant/arguments/confirmation_screen_argument.dart';
import 'package:pc_build_assistant/components/rounded_button_widget.dart';
import 'package:pc_build_assistant/logic/products_manager.dart';
import 'package:pc_build_assistant/models/product.dart';
import 'package:pc_build_assistant/util/constants.dart';
import 'package:pc_build_assistant/views/confirmation_screen.dart';

class PurchaseScreen extends StatefulWidget {
  static final String id = "/purchaseScreenId";

  @override
  _PurchaseScreenState createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  int sum = 0;

  String _name = "";
  String _email = "";
  String _address = "";

  calculateTotal() {
    int total = 0;
    for (Product item in ProductManager.products) {
      total += item.price;
    }
    setState(() {
      sum = total;
    });
  }

  @override
  void initState() {
    calculateTotal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration:
                      kLoginTextFieldDecoration.copyWith(hintText: "Name"),
                  onChanged: (name) {
                    _name = name;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                child: TextField(
                  decoration:
                      kLoginTextFieldDecoration.copyWith(hintText: "Address"),
                  onChanged: (address) {
                    _address = address;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
                child: TextField(
                  decoration:
                      kLoginTextFieldDecoration.copyWith(hintText: "Email"),
                  onChanged: (email) {
                    _email = email;
                  },
                ),
              ),
              Text(
                "Total price",
                style: TextStyle(
                  fontFamily: "Rodin",
                  fontSize: 24,
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
                  sum.toString() + " Tk",
                  style: TextStyle(color: Colors.green, fontSize: 20),
                ),
              ),

              SizedBox(
                height: 10,
              ),
              Text(
                "Shipping",
                style: TextStyle(
                  fontFamily: "Rodin",
                  fontSize: 24,
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
                  "50" + " Tk",
                  style: TextStyle(color: Colors.green, fontSize: 20),
                ),
              ),

              SizedBox(
                height: 10,
              ),
              Text(
                "Your total is",
                style: TextStyle(
                  fontFamily: "Rodin",
                  fontSize: 24,
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
                  (sum + 50).toString() + " Tk",
                  style: TextStyle(color: Colors.green, fontSize: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),

              SizedBox(
                height: 100,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Center(
                    child: RoundedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, ConfirmationScreen.id,
                            arguments: ConfirmationScreenArguments(
                                name: _name,
                                email: _email,
                                address: _address,
                                bill: sum + 50));
                      },
                      title: "Purchase",
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ),
              //-------------------------row
            ],
          ),
        ),
      ),
    );
  }
}
