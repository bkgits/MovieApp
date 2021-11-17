
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
import 'package:scientisst_db/scientisst_db.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key,required this.movieId,required this.posterUrl}) : super(key: key);
  final String movieId;
  final String posterUrl;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  var movieData;
  DocumentSnapshot? snap;
  void getHttp() async {
    try {
      var response = await Dio().get('http://www.omdbapi.com/?apikey=c66c3adb&i=${widget.movieId}');
      movieData = response.data;
      DocumentReference ref = await ScientISSTdb.instance.collection('MoviesDb').add({
        "MovieId":widget.movieId,
        "Title":response.data['Title'],
        "Poster":widget.posterUrl,
        "Rating":response.data['imdbRating'],
        "Runtime":response.data['Runtime'],
        "Genre":response.data['Genre'],
        "Plot":response.data['Plot'],
        "Director":response.data['Director'],
        "Writer":response.data['Writer'],
        "Actor":response.data['Actors'],
      });
      snap = await ref.get();
      setState(() {

      });
    } catch (e) {
      print(e);
    }
  }
  checkLocalDb()async{
    var values = await ScientISSTdb.instance.collection('MoviesDb').where('MovieId',isEqualTo:widget.movieId).getDocuments();
    if(values.isEmpty){
      getHttp();
    }
    else{
      snap = values[0];
      setState(() {
      });
    }

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLocalDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: snap==null?Center(child: CircularProgressIndicator(),): Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            snap!.data['Poster']==null?Container():Container(width: MediaQuery.of(context).size.width,child: CachedNetworkImage(imageUrl: snap!.data['Poster'],placeholder: (context,url)=>Icon(Icons.image),errorWidget:(context,url,error)=>Icon(Icons.error,color: Colors.white30,),fit: BoxFit.cover,),
    ),
            Padding(
              padding: const EdgeInsets.only(top:25.0,left: 10.0,right: 10.0,bottom: 10.0),
              child: Align(alignment:Alignment.topLeft,child: Card(
                shape: CircleBorder(),
                color: Colors.white,
                child: IconButton(onPressed:(){
                  Navigator.pop(context);
                } , icon: Icon(Icons.arrow_back_rounded)),
              )),
            ),
            snap==null?Container():Align(alignment:Alignment.bottomCenter,child: Container(
              width:MediaQuery.of(context).size.width/100*95,
              height:MediaQuery.of(context).size.height/100*50,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(snap!.data['Title'],style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.star_border,color:Colors.white30),
                          Text(snap!.data['Rating'],style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),
                          SizedBox(width: 10.0,),
                          Icon(Icons.timer,color:Colors.white30),
                          Text(snap!.data['Runtime'],style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text('Genre',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),
                          Spacer(),
                          Chip(backgroundColor:Colors.black54,label:Text(snap!.data['Genre'].toString().split(",")[0],style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),shape: StadiumBorder(),),
                        ],
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(
                        color:Colors.white30,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(snap!.data['Plot'],style: TextStyle(color: Colors.white54,fontWeight: FontWeight.w800),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Director: '+snap!.data['Director'],style: TextStyle(color: Colors.white54,fontWeight: FontWeight.w800),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Writers: '+snap!.data['Writer'],style: TextStyle(color: Colors.white54,fontWeight: FontWeight.w800),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Actors: '+snap!.data['Actor'],style: TextStyle(color: Colors.white54,fontWeight: FontWeight.w800),),
                    ),


                  ],
                ),
              ),
            ).asGlass(clipBorderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0))))
          ],
        ),
      ),
    );

  }
}
