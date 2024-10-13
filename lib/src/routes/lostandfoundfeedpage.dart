import 'package:InstiApp/src/api/model/lostandfoundPost.dart';
import 'package:InstiApp/src/bloc_provider.dart';
import 'package:InstiApp/src/blocs/lost_and_found_bloc.dart';
import 'package:InstiApp/src/drawer.dart';
import 'package:InstiApp/src/utils/common_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../utils/title_with_backbutton.dart';

class LostNFoundPage extends StatefulWidget {
  LostNFoundPage({Key? key}) : super(key: key);
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  State<LostNFoundPage> createState() => _LostNFoundPageState();
}

class _LostNFoundPageState extends State<LostNFoundPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LostPage(),
    );
  }
}

class LostPage extends StatefulWidget {
  const LostPage({Key? key}) : super(key: key);

  @override
  State<LostPage> createState() => _LostpageState();
}

class _LostpageState extends State<LostPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  lnFType lnftype = lnFType.All;
  bool firstBuild = true;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    LostAndFoundPostBloc lnFPostBloc =
        BlocProvider.of(context)!.bloc.lostAndFoundPostBloc;

    if (firstBuild) {
      lnFPostBloc.refresh();
    }

    double screen_wr = MediaQuery.of(context).size.width;
    double screen_hr = MediaQuery.of(context).size.height;
    double x, y;
    var bloc = BlocProvider.of(context)!.bloc;
    var theme = Theme.of(context);
    bool isLoggedIn = bloc.currSession != null;

    screen_hr >= screen_wr ? x = 0.35 : x = 0.80;
    if (1 >= screen_hr / screen_wr && screen_hr / screen_wr >= 0.5) {
      x = 0.35;
    }
    screen_hr >= screen_wr ? y = 0.9 : y = 0.5;
    double screen_w = screen_wr * y;
    double screen_h = screen_hr * x;

    double myfont = ((18 / 274.4) * screen_h);
    return Scaffold(
        key: _scaffoldKey,
        drawer: NavDrawer(),
        bottomNavigationBar: MyBottomAppBar(
          shape: RoundedNotchedRectangle(),
          notchMargin: 4.0,
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.menu_outlined,
                  semanticLabel: "Show navigation drawer",
                ),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.info),
          label: Text("Info"),
          onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                      title: Text('How to use Lost and Found'),
                      content: SingleChildScrollView(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'If you find a lost item:',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                              'Give the item to the nearest security office \n'),
                          Text(
                            'If you want to claim your lost item:',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                              'Use the contact details provided to claim your item\n'),
                          Text(
                              'Only the security offices can post items on Lost and Found, students can only claim items and report lost items to the security offices'),
                        ],
                      )),
                      actions: <Widget>[
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'OK',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.lightBlue),
                          ),
                        )
                      ])),
        ),
        body: SafeArea(
            child: !isLoggedIn
                ? Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(50),
                    child: Column(
                      children: [
                        Icon(
                          Icons.cloud,
                          size: 200,
                          color: Colors.grey[600],
                        ),
                        Text(
                          "Login To View Lost and Found Posts",
                          style: theme.textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TitleWithBackButton(
                        child: Text(
                          "Lost & Found (Beta)",
                          style: theme.textTheme.headlineMedium,
                        ),
                      ),
                      StreamBuilder<List<LostAndFoundPost>>(
                          stream: lnFPostBloc.lostAndFoundPosts,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<LostAndFoundPost>> snapshot) {
                            if (snapshot.data?.length != 0) {
                              return ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: snapshot.data?.length ?? 0,
                                itemBuilder: (_, index) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                        child:
                                            CircularProgressIndicatorExtended(
                                      label: Text("Loading..."),
                                    ));
                                  }

                                  return _buildContent(screen_h, screen_w,
                                      index, myfont, context, snapshot);
                                },
                              );
                            }
                            return Center(
                              child: Text(
                                'No posts \n have been added yet',
                                style: TextStyle(
                                    fontSize: 25.0,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w300),
                                textAlign: TextAlign.center,
                              ),
                            );
                          }),
                    ],
                  ))));
  }

  Widget _buildContent(double screen_h, double screen_w, int index,
      double myfont, BuildContext context, AsyncSnapshot snapshot) {
    List<LostAndFoundPost> posts = snapshot.data!;
    var theme = Theme.of(context);

    return Center(
      child: (SizedBox(
        height: screen_h * 0.7,
        width: screen_w * 1.2,
        child: Container(
          child: Stack(alignment: Alignment.center, children: [
            Card(
              color: theme.cardColor,
              margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                      "/lostandfound/info" + (posts[index].id ?? ""));
                },
                child: SizedBox(
                    child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                      child: Row(
                        children: [
                          Center(
                            child: Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                              height: screen_h,
                              width: screen_h * 0.20 / 0.43,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    topLeft: Radius.circular(10)),
                                child: CachedNetworkImage(
                                  imageUrl: posts[index].imageUrl?[0] ?? '',
                                  placeholder: (context, url) => Image.asset(
                                    'assets/buynsell/DevcomLogo.png',
                                    fit: BoxFit.fill,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      new Image.asset(
                                    'assets/buynsell/DevcomLogo.png',
                                    fit: BoxFit.fill,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      margin: EdgeInsets.fromLTRB(
                          screen_h * 0.20 / 0.43, 11, 0, 50),
                      child: Text(
                        posts[index].name ?? "",
                        style: theme.textTheme.titleLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          screen_h * 0.20 / 0.43, 105, 10, 0),
                      child: Text(
                        (posts[index].foundAt ?? "").length <= 10
                            ? posts[index].foundAt ?? ""
                            : (posts[index].foundAt ?? "").substring(0, 10) +
                                '...',
                        style: theme.textTheme.bodyMedium,
                        maxLines: 1,
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(
                            screen_w * 0.7, 110, screen_h * 0.04 / 1.5, 1),
                        child: Row(
                          children: [
                            Spacer(),
                            Text(
                              (posts[index].claimed == true
                                  ? "Claimed"
                                  : "Not\nclaimed"),
                              style: theme.textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            )
                          ],
                        )),
                    Container(
                      // child: MyPosts
                      //     ? Container()
                      child: Row(children: [
                        Icon(
                          Icons.access_time,
                          size: ((myfont / 18 * 12).toInt()).toDouble(),
                        ),
                        Text(' ' + (posts[index].timeBefore ?? ""),
                            style: theme.textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ))
                      ]),

                      margin: EdgeInsets.fromLTRB(
                          screen_h * 0.20 / 0.43, 135, 0, 0),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(
                            screen_h * 0.20 / 0.43, 35, 0, 0)),
                    Container(
                        padding: EdgeInsets.fromLTRB(0, 13, 10, 0),
                        child: Text(
                          (posts[index].description ?? ""),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium,
                        ),
                        margin: EdgeInsets.fromLTRB(
                            screen_h * 0.20 / 0.43, 43, 0, 0)),
                    Row(
                      children: [
                        Spacer(),
                        Container(),
                      ],
                    )
                  ],
                )),
              ),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.blue),
              ),
            ),
            if (posts[index].claimed == true)
              Container(
                width: screen_w * 0.15,
                height: screen_w * 0.15,
                decoration: new BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            if (posts[index].claimed == true)
              Container(
                  child: Icon(
                Icons.check,
                color: Colors.white,
                size: screen_w * 0.15,
              )),
          ]),
        ),
      )),
    );
  }
}
