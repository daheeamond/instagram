import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  var userImage;

  // addData(a){
  //   setState((){
  //     data.add(a);
  //   });
  // }


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
        onPressed:()async{
              var picker = ImagePicker();
              var image = await picker.pickImage(source: ImageSource.gallery);
              userImage = File(image.path);


              if(image != null){
                setState((){
                 userImage = File(image.path);
                });
              }

              Navigator.push(context,
                MaterialPageRoute(builder: (c) => Upload(userImage : userImage))
              );
        },
          iconSize: 30,
    )
    ]
    ),
      body:[Home(data : data ),Text('샵페이지')][tab],
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

class Home extends StatefulWidget {

  const Home ({Key? key, this.data }) : super(key: key);
 final data;


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var scroll = ScrollController();

  // getMore() async {
  //   var result = await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
  //   var result2 = jsonDecode(result.body);
  //   widget.addData(result2);
  // }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
     if(scroll.position.pixels == scroll.position.maxScrollExtent) {//스크롤한 거리 = 최대 스크롤거리 (맨밑까지 스크롤 된 경우)
       //스크롤 끝까지 내리면 실행될 코드
     }
     }
    );
        }
  //      setState((){
  //        getMore();}
  //      );}
  //   });
  // }

  @override
  Widget build(BuildContext context) {
   if(widget.data.isNotEmpty){ //왼쪽에 있는 리스트가 비어있는지 물어보는 코드
     return ListView.builder( //스크롤 생기게하려고 + 반복
         itemCount: 3, //      반복횟수
         controller: scroll,
         itemBuilder: (c, i){
           return Column(
             children: [
               Container(
                 constraints: BoxConstraints(maxWidth: 600),
                 padding: EdgeInsets.all(20),
                 width: double.infinity,
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Image.network(widget.data[i]['image']),
                     Text('좋아요 ${widget.data[i]['likes']}'),
                     Text('글쓴이 ${widget.data[i]['user']}'),
                     Text(widget.data[i]['content']),
                   ]
                 )
               )
             ],
           );
         });
   } else {
     return Text('로딩중임');
   }
  }
}

class Upload extends StatelessWidget {
  const Upload({Key? key, this.userImage}) : super(key: key);
  final userImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(userImage),
          Text('이미지업로드화면'),
          Textfield(),
          IconButton(
            onPressed:(){
              Navigator.pop(context);
            } , icon: Icon(Icons.close)),

        ],
      )
    );
  }
}
