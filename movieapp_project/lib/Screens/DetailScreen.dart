
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({Key? key,required this.data}) : super(key: key);
  final data;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {

  var movieData;
  void getHttp() async {
    try {
      var response = await Dio().get('http://www.omdbapi.com/?apikey=c66c3adb&i=${widget.data['imdbID']}');
      movieData = response.data;
      print(movieData);
      setState(() {

      });
    } catch (e) {
      print(e);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHttp();
    print(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(top:20.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              widget.data['Poster']==null?Container():Container(width: MediaQuery.of(context).size.width,child: Image.network(widget.data['Poster'],fit: BoxFit.cover,)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(alignment:Alignment.topLeft,child: Card(
                  shape: CircleBorder(),
                  color: Colors.white,
                  child: IconButton(onPressed:(){
                    Navigator.pop(context);
                  } , icon: Icon(Icons.arrow_back_rounded)),
                )),
              ),
              movieData==null?Container():Align(alignment:Alignment.bottomCenter,child: Container(
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
                        child: Text(widget.data['Title'],style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Icon(Icons.star_border,color:Colors.white30),
                            Text(movieData['imdbRating'],style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),
                            SizedBox(width: 10.0,),
                            Icon(Icons.timer,color:Colors.white30),
                            Text(movieData['Runtime'],style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text('Genre',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),
                            Spacer(),
                            Chip(backgroundColor:Colors.black54,label:Text(movieData['Genre'].toString().split(",")[0],style: TextStyle(color: Colors.white,fontWeight: FontWeight.w800),),shape: StadiumBorder(),),
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
                        child: Text(movieData['Plot'],style: TextStyle(color: Colors.white54,fontWeight: FontWeight.w800),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Director: '+movieData['Director'],style: TextStyle(color: Colors.white54,fontWeight: FontWeight.w800),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Writers: '+movieData['Writer'],style: TextStyle(color: Colors.white54,fontWeight: FontWeight.w800),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Actors: '+movieData['Plot'],style: TextStyle(color: Colors.white54,fontWeight: FontWeight.w800),),
                      ),


                    ],
                  ),
                ),
              ).asGlass(clipBorderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0))))
            ],
          ),
        ),
      ),
    );

  }
}
