import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pc_build_assistant/components/cart_widget.dart';
import 'package:pc_build_assistant/components/product_widget.dart';
import 'package:pc_build_assistant/components/rounded_button_widget.dart';
import 'package:pc_build_assistant/components/tab_button_widget.dart';
import 'package:pc_build_assistant/components/tab_slider_widget.dart';
import 'package:pc_build_assistant/logic/products_manager.dart';
import 'package:pc_build_assistant/models/product.dart';
import 'package:pc_build_assistant/storage/database_helper.dart';
import 'package:pc_build_assistant/util/constants.dart';
import 'package:pc_build_assistant/util/decoration.dart';
import 'package:pc_build_assistant/views/login_screen.dart';
import 'package:pc_build_assistant/views/purchase_screen.dart';
import 'package:pc_build_assistant/views/view_screen.dart';
import 'package:simple_gravatar/simple_gravatar.dart';

class HomeScreen extends StatefulWidget {
  static String id = "/homeScreenId";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _currentUser;
  int _index = 0;

  GlobalKey _componentsKey = GlobalKey();
  GlobalKey _buildKey = GlobalKey();

  RenderBox _componentBox;
  double _tabWidth = 0;
  double _tabHeight = 0;

  static List<Product> _products = List<Product>();

  PageController _pageController = PageController();
  @override
  void initState() {
    getCurrentUser();
    getData();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => initialSize());
  }

  initialSize() {
    _componentBox = _componentsKey.currentContext.findRenderObject();
    upDateSize();
  }

  upDateSize() {
    Size tabSize = _componentBox.size;
    setState(() {
      _tabWidth = tabSize.width;
      _tabHeight = tabSize.height;
    });
  }

  getCurrentUser() async {
    FirebaseUser user;
    try {
      user = await _auth.currentUser();
      setState(() {
        _currentUser = user;
      });
    } catch (excp) {
      print("error occured $excp");
    }
  }

  getData() async {
    print("called getdata");
    List<Product> tempComponents = await DatabaseHelper.getData();
    setState(() {
      _products.clear();
      _products.addAll(tempComponents);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //---------------------------------------------APP BAR---------------------------------------------------
      appBar: AppBar(
        title: Text(
          "Sweet Delights",
          style: TextStyle(fontFamily: "Rodin"),
        ),
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                if (_currentUser == null) {
                  await Navigator.pushNamed(context, LoginScreen.id);
                }
                getCurrentUser();
              },
              child: Hero(
                tag: "avatar",
                child: _currentUser != null
                    ? CircleAvatar(
                        child: ClipOval(
                          child: Image.network(
                            Gravatar(_currentUser.email).imageUrl(
                              defaultImage: GravatarImage.retro,
                              size: 300,
                              fileExtension: true,
                            ),
                          ),
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Color(0xFFFFFFFF),
                        child: Icon(
                          FontAwesomeIcons.user,
                          size: 20,
                        ),
                      ),
              ),
            ),
          ),
        ],
        iconTheme: ThemeData.dark().iconTheme.copyWith(color: Colors.black),
      ),

      //---------------------------------------BODY OF APP----------------------------------------------
      body: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Theme(
            data: Theme.of(context).copyWith(accentColor: kLoginButtonColor),
            child: PageView(
              onPageChanged: (index) {
                setState(() {
                  _index = index;
                });
              },
              controller: _pageController,
              pageSnapping: true,
              children: <Widget>[
                _products.length > 0
                    ? ComponentPage(
                        onRefresh: () {
                          getData();
                        },
                        components: _products,
                      )
                    : Center(
                        child: TyperAnimatedTextKit(
                          text: ["Loading"],
                          duration: Duration(milliseconds: 600),
                          textStyle: loadingAnimationStyle,
                        ),
                      ),
                BuildPageAnimated(
                  onRefresh: () {
                    getData();
                  },
                ),
              ],
            ),
          ),

          //---------------------------------------------BOTTOM NAVBAR---------------------------------------------
          Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 30,
                  spreadRadius: 20,
                  color: kNavShadowColor,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            height: kNavBarHeight,
            child: AnimatedContainer(
              duration: kAnimationDuration,
              decoration: BoxDecoration(
                border: Border.all(
                    width: 2,
                    color: _index == 0
                        ? kContinueButtonColor
                        : kRegisterButtonColor),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(kRadius),
                  topRight: Radius.circular(kRadius),
                ),
              ),
              child: Stack(
                children: <Widget>[
                  //----------------------------------TAB BUTTON------------------------------------------------------
                  AnimatedAlign(
                    curve: Curves.decelerate,
                    duration: kAnimationDuration,
                    alignment: _index == 0
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: TabSlider(
                      left: _index == 0 ? true : false,
                      duration: kAnimationDuration,
                      width: _tabWidth,
                      height: _tabHeight,
                      colorLeft: kContinueButtonColor,
                      colorRight: kRegisterButtonColor,
                    ),
                  ),

                  //-------------------------------------TOP ICONS------------------------------------------
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: TabButton(
                            componentsKey: _componentsKey,
                            selected: _index == 0 ? true : false,
                            icon: FontAwesomeIcons.breadSlice,
                          ),
                          onTap: () {
                            setState(
                              () {
                                _index = 0;
                                _pageController.animateToPage(0,
                                    duration: kAnimationDuration,
                                    curve: Curves.decelerate);
                              },
                            );
                          },
                        ),
                      ),
                      Container(
                        width: 10,
                      ),
                      Expanded(
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          child: TabButton(
                            componentsKey: _buildKey,
                            selected: _index == 1 ? true : false,
                            icon: FontAwesomeIcons.shoppingCart,
                          ),
                          onTap: () {
                            setState(
                              () {
                                _index = 1;
                                _pageController.animateToPage(1,
                                    duration: kAnimationDuration,
                                    curve: Curves.decelerate);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//---------------------------------------------------------------PAGES--------------------------------------------------------------
typedef Refresh();

//----------------------------------------------------------COMPONENTS PAGE---------------------------------------------------------
class ComponentPage extends StatefulWidget {
  final Refresh onRefresh;
  final List<Product> components;

  ComponentPage({this.onRefresh, this.components});

  @override
  _ComponentPageState createState() => _ComponentPageState();
}

class _ComponentPageState extends State<ComponentPage> {
  @override
  Widget build(BuildContext context) {
    var products = widget.components;
    return RefreshIndicator(
      color: kLoginButtonColor,
      onRefresh: () async {
        widget.onRefresh();
      },
      child: ListView.builder(
        itemCount: products.length + 2,
        itemBuilder: (context, index) {
          double top = 5;
          double bottom = 5;
          if (index == 0) {
            return Container(
              height: 30,
            );
          } else if (index == products.length + 1) {
            return Container(
              height: kNavBarHeight,
            );
          } else {
            return Container(
              margin: EdgeInsets.only(
                  left: 10, right: 10, top: top, bottom: bottom),
              child: ProductWidget(
                component: products[index - 1],
                onAdd: (currentComponent) {
                  ProductManager.products.add(currentComponent);
                },
                onView: (currentProduct) {
                  Navigator.pushNamed(context, ViewScreen.id,
                      arguments: currentProduct);
                },
              ),
            );
          }
        },
      ),
    );
  }
}

//------------------------------------------------------BUILD PAGE NEW---------------------------------------------------

//class BuildPage extends StatefulWidget {
//  final Refresh onRefresh;
//  BuildPage({this.onRefresh});
//
//  @override
//  _BuildPageState createState() => _BuildPageState();
//}
//
//class _BuildPageState extends State<BuildPage> with TickerProviderStateMixin {
//  List<Widget> errorTexts = [];
//  bool errorExpanded = false;
//  @override
//  void initState() {
//    errorListBuilder(BuildManager.testBuild());
//    super.initState();
//  }
//
//  errorListBuilder(List<String> errors) {
//    List<Widget> newErrorTexts = [];
//    for (String error in errors) {
//      newErrorTexts.add(Container(
//        margin: EdgeInsets.all(5),
//        child: Text(
//          error,
//          style: TextStyle(color: kRedButtonColor),
//        ),
//      ));
//    }
//    setState(() {
//      errorTexts = newErrorTexts;
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return RefreshIndicator(
//      color: kLoginButtonColor,
//      onRefresh: () async {
//        widget.onRefresh();
//      },
//      child: Theme(
//        data: Theme.of(context).copyWith(accentColor: kLoginButtonColor),
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
//          children: <Widget>[
//            Column(
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                AnimatedSize(
//                  duration: kErrorAnimationDuration,
//                  vsync: this,
//                  child: errorExpanded
//                      ? Row(
//                          crossAxisAlignment: CrossAxisAlignment.center,
//                          mainAxisAlignment: MainAxisAlignment.start,
//                          mainAxisSize: MainAxisSize.max,
//                          children: <Widget>[
//                            Container(
//                              margin: EdgeInsets.all(30),
//                              child: errorTexts.length == 0
//                                  ? Icon(
//                                      Icons.check,
//                                      size: 50,
//                                      color: kLoginButtonColor,
//                                    )
//                                  : Icon(
//                                      Icons.error,
//                                      size: 50,
//                                      color: kRedButtonColor,
//                                    ),
//                            ),
//                            Container(
//                              width: 200,
//                              margin: EdgeInsets.all(10),
//                              child: Column(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                children: errorTexts.length > 0
//                                    ? errorTexts
//                                    : [
//                                        Text(
//                                          "Your Build is Okay",
//                                          style: TextStyle(
//                                              color: kLoginButtonColor),
//                                        )
//                                      ],
//                              ),
//                            ),
//                          ],
//                        )
//                      : Container(
//                          child: errorTexts.length == 0
//                              ? Text(
//                                  "Build is Okay",
//                                  style: TextStyle(color: kLoginButtonColor),
//                                )
//                              : Text(
//                                  "Build is not Okay",
//                                  style: TextStyle(color: kRedButtonColor),
//                                ),
//                        ),
//                ),
//                Center(
//                  child: IconButton(
//                    icon: Icon(
//                      errorExpanded
//                          ? Icons.arrow_drop_up
//                          : Icons.arrow_drop_down,
//                    ),
//                    onPressed: () {
//                      setState(() {
//                        errorExpanded = !errorExpanded;
//                      });
//                    },
//                  ),
//                )
//              ],
//            ),
//            Expanded(
//              child: ListView(
//                children: <Widget>[
//                  Container(
//                    height: 30,
//                  ),
//                  // Start of Component widgets
//                  Container(
//                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                    child: BuildComponentWidgetSingular(
//                      title: "Chassis",
//                      component: BuildManager.build.chassis,
//                      onRemove: (PCComponent removeComponent) {
//                        BuildManager.removeComponent(removeComponent);
//                        errorListBuilder(BuildManager.testBuild());
//                      },
//                    ),
//                  ),
//                  Container(
//                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                    child: BuildComponentWidgetSingular(
//                      title: "Motherboard",
//                      component: BuildManager.build.motherboard,
//                      onRemove: (PCComponent removeComponent) {
//                        BuildManager.removeComponent(removeComponent);
//                        errorListBuilder(BuildManager.testBuild());
//                      },
//                    ),
//                  ),
//                  Container(
//                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                    child: BuildComponentWidgetSingular(
//                      title: "Processor",
//                      component: BuildManager.build.processor,
//                      onRemove: (PCComponent removeComponent) {
//                        BuildManager.removeComponent(removeComponent);
//                        errorListBuilder(BuildManager.testBuild());
//                      },
//                    ),
//                  ),
//                  Container(
//                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                    child: BuildComponentWidgetSingular(
//                      title: "Graphics Card",
//                      component: BuildManager.build.gpu,
//                      onRemove: (PCComponent removeComponent) {
//                        BuildManager.removeComponent(removeComponent);
//                        errorListBuilder(BuildManager.testBuild());
//                      },
//                    ),
//                  ),
//                  Container(
//                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                    child: BuildComponentWidgetSingular(
//                      title: "Power Supply",
//                      component: BuildManager.build.psu,
//                      onRemove: (PCComponent removeComponent) {
//                        BuildManager.removeComponent(removeComponent);
//                        errorListBuilder(BuildManager.testBuild());
//                      },
//                    ),
//                  ),
//                  Container(
//                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                    child: BuildComponentWidgetsMultiple(
//                      title: "Rams",
//                      components: BuildManager.build.rams,
//                      onRemoveEntry: (PCComponent removeComponent, int index) {
//                        BuildManager.removeComponentEntry(
//                            removeComponent, index);
//                        errorListBuilder(BuildManager.testBuild());
//                      },
//                    ),
//                  ),
//                  Container(
//                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//                    child: BuildComponentWidgetsMultiple(
//                      title: "Sata Storages",
//                      components: BuildManager.build.satas,
//                      onRemoveEntry: (PCComponent removeComponent, int index) {
//                        BuildManager.removeComponentEntry(
//                            removeComponent, index);
//                        errorListBuilder(BuildManager.testBuild());
//                      },
//                    ),
//                  ),
//                  Container(
//                    height: kBottomNavigationBarHeight,
//                  ),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}

//-----------------------------------------------------------BUILD PAGE ANIMATED-------------------------------------------------------------
class BuildPageAnimated extends StatefulWidget {
  final Refresh onRefresh;
  BuildPageAnimated({this.onRefresh});

  @override
  _BuildPageAnimatedState createState() => _BuildPageAnimatedState();
}

class _BuildPageAnimatedState extends State<BuildPageAnimated>
    with TickerProviderStateMixin {
  List<Widget> errorTexts = [];

  @override
  void initState() {
    super.initState();
  }

  errorListBuilder(List<String> errors) {
    List<Widget> newErrorTexts = [];

    setState(() {
      errorTexts = newErrorTexts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: kLoginButtonColor,
      onRefresh: () async {
        widget.onRefresh();
      },
      child: Theme(
        data: Theme.of(context).copyWith(accentColor: kLoginButtonColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 24),
              child: Hero(
                tag: 'registerButton',
                child: RoundedButton(
                  title: 'Buy now',
                  onPressed: () {
                    Navigator.pushNamed(context, PurchaseScreen.id);
                  },
                  color: kLoginButtonColor,
                ),
              ),
            ),
            Expanded(
              child: AnimatedList(
                initialItemCount: ProductManager.products.length + 2,
                itemBuilder: (context, itemNumber, animation) {
                  if (itemNumber == 0) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                    );
                  } else if (itemNumber == ProductManager.products.length + 1) {
                    return Container(
                      height: kNavBarHeight,
                    );
                  } else {
                    Product component = ProductManager.products[itemNumber - 1];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: CartProductWidget(
                        component: component,
                        onRemove: (Product removeComponent) {
                          ProductManager.products.removeAt(itemNumber - 1);
                          //BuildManager.removeComponent(removeComponent);
                          AnimatedList.of(context).removeItem(
                            itemNumber,
                            (context, animation) {
                              //BuildManager.removeComponent(removeComponent);
                              return SizeTransition(
                                sizeFactor: animation,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  child: CartProductWidget(
                                    component: removeComponent,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//------------------------------------------------------------------BUILD PAGE------------------------------------------------------------------
//class BuildPage extends StatefulWidget {
//  final Refresh onRefresh;
//  BuildPage({this.onRefresh});
//
//  @override
//  _BuildPageState createState() => _BuildPageState();
//}
//
//class _BuildPageState extends State<BuildPage> {
//  @override
//  Widget build(BuildContext context) {
//    return RefreshIndicator(
//      color: kLoginButtonColor,
//      onRefresh: () async {
//        widget.onRefresh();
//      },
//      child: Theme(
//        data: Theme.of(context).copyWith(accentColor: kLoginButtonColor),
//        child: ListView(
//          children: <Widget>[
//            BuildManager.build.chassis != null
//                ? Container(
//              margin: EdgeInsets.symmetric(horizontal: 10),
//              child: BuildComponentWidget(
//                title: "Chassis",
//                component: BuildManager.build.chassis,
//                onRemove: (removeComponent) {
//                  setState(() {
//                    BuildManager.build.chassis = null;
//                  });
//                },
//              ),
//            )
//                : Container(),
//            BuildManager.build.motherboard != null
//                ? Container(
//              margin: EdgeInsets.symmetric(horizontal: 10),
//              child: BuildComponentWidget(
//                title: "Motherboard",
//                component: BuildManager.build.motherboard,
//                onRemove: (removeComponent) {
//                  setState(() {
//                    BuildManager.build.motherboard = null;
//                  });
//                },
//              ),
//            )
//                : Container(),
//            BuildManager.build.processor != null
//                ? Container(
//              margin: EdgeInsets.symmetric(horizontal: 10),
//              child: BuildComponentWidget(
//                title: "Processor",
//                component: BuildManager.build.processor,
//                onRemove: (removeComponent) {
//                  setState(() {
//                    BuildManager.build.processor = null;
//                  });
//                },
//              ),
//            )
//                : Container(),
//            BuildManager.build.gpu != null
//                ? Container(
//              margin: EdgeInsets.symmetric(horizontal: 10),
//              child: BuildComponentWidget(
//                title: "Graphics  Card",
//                component: BuildManager.build.gpu,
//                onRemove: (removeComponent) {
//                  setState(() {
//                    BuildManager.build.gpu = null;
//                  });
//                },
//              ),
//            )
//                : Container(),
//            BuildManager.build.psu != null
//                ? Container(
//              margin: EdgeInsets.symmetric(horizontal: 10),
//              child: BuildComponentWidget(
//                title: "Power Supply",
//                component: BuildManager.build.psu,
//                onRemove: (removeComponent) {
//                  setState(() {
//                    BuildManager.build.psu = null;
//                  });
//                },
//              ),
//            )
//                : Container(),
//            Container(
//              height: 50,
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
