
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movieapp_project/Screens/DetailScreen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 var movieList;
 TextEditingController movieSearchController = TextEditingController();
 @override
 void initState() {
   // TODO: implement initState
   super.initState();
   getHttp('Marvel');
 }
 @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    movieSearchController.dispose();
  }




 void getHttp(String movie) async {
   try {
     var response = await Dio().get('http://www.omdbapi.com/?apikey=c66c3adb&s='+movie);
     movieList = response.data;
     setState(() {

     });
   } catch (e) {
     print(e);
   }
 }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Browse',style: TextStyle(fontWeight: FontWeight.w800,color: Colors.white,fontSize: 28.0),),
                          Text('Movies',style: TextStyle(fontWeight: FontWeight.w800,color: Colors.white54,fontSize: 24.0),),

                        ],
                      ),
                      IconButton(onPressed: (){}, icon: Icon(Icons.menu,color: Colors.white54,))
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  height: 50.0,
                  decoration: BoxDecoration(color: Colors.white54,borderRadius: BorderRadius.circular(5.0)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.search,color: Colors.white30,),
                      ),
                      Expanded(
                        child: TextField(
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.search,
                          style: TextStyle(color: Colors.white30,fontSize: 20.0,fontWeight: FontWeight.w800,),
                           onSubmitted:(value){
    getHttp(value);
    },
                          decoration: InputDecoration(
                            hintText: 'Search',

                            hintStyle: TextStyle(color: Colors.white30,fontSize: 20.0,fontWeight: FontWeight.w800,),
                            contentPadding: EdgeInsets.zero,

                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent)
                            ),
                            disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent)
                            ),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.transparent)
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50.0,
              ),
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left:30.0,right: 30.0),
                    child: GestureDetector(
                      onTap:(){
                        showModalBottomSheet(isScrollControlled:true,context: context, builder: (BuildContext context){
                          return DetailScreen(movieId: movieList['Search'][index]['imdbID'],posterUrl:movieList['Search'][index]['Poster'],);
                        });
                      },
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(

                                  borderRadius: BorderRadius.circular(10.0),
                                child: CachedNetworkImage(imageUrl: movieList['Search'][index]['Poster'],placeholder: (context,url)=>Icon(Icons.image),errorWidget:(context,url,error)=>Icon(Icons.error,color: Colors.white30,),),

                              ),
                            ),
                            Text(movieList['Search'][index]['Title'],overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white54,fontWeight: FontWeight.w800),),
                            Text(movieList['Search'][index]['Year'],overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white54,fontWeight: FontWeight.w800),),

                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: movieList==null?0:movieList["Search"].length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio:200/250,
                mainAxisSpacing: 25.0,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
