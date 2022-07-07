import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'package:http/http.dart'as http;
import 'dart:convert';

void main() {
  runApp(
      MaterialApp(
        theme: style.theme,
       home:MyApp()
      )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0 ; //초기값
  var data = []; //게시물 데이터는 자주 바뀌니 state에 저장

  getData() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    var result2 = jsonDecode(result.body);
    setState((){
      data = result2;
    });
  }


  @override
  void initState() {
    super.initState();
    getData();
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
    appBar: AppBar(
      title: Text('Instagram',),centerTitle: false,
      actions: [
        IconButton(
            icon: Icon(Icons.add_box_outlined),
        onPressed:(){}
    )
    ]
    ),
      body:[Home(),Text('샵페이지')][tab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i){setState(() {
          tab = i;
        });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),label:'홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined),label:'샵'),
        ],
    ),
    );
  }
}

class Home extends StatelessWidget {
  const Home ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder( //스크롤 생기게하려고 + 반복
      itemCount: 3, //      반복횟수
        itemBuilder: (c, i){
          return Column(
            children: [
              Image.network('https://codingapple1.github.io/kona.jpg'),
              Container(
                constraints: BoxConstraints(maxWidth: 600),
                padding: EdgeInsets.all(20),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('좋아요 100'),
                    Text('글쓴이'),
                    Text('글내용'),
                  ],
                ),
              )
            ],
          );
        });
  }
}
