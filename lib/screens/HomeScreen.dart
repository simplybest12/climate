import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:climate/model/models.dart';
import 'package:climate/services/apservices.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<WeatherModel> _getData(bool isCurrent, String cityName) async {
    return await APIservice().getWeatherDetails(isCurrent, cityName);
  }

  TextEditingController searchtext = TextEditingController(text: "");

  Future<WeatherModel>? _mydata;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _mydata = _getData(true, "");
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _mydata,
          builder: (context, AsyncSnapshot Snapshot) {
            if (Snapshot.connectionState == ConnectionState.done) {
              //if data has error
              if (Snapshot.hasError) {
                return Center(
                  child: Text(Snapshot.error.toString(),
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(fontSize: 18),
                      )),
                );
              } else if (Snapshot.hasData) {
                final data = Snapshot.data as WeatherModel;
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                        Color(0xff0c0b5c),
                        Color(0xff1e2273),
                        Color(0xff2e398b),
                        Color(0xff3e50a2),
                        Color(0xff4f68b9),
                        Color(0xff6081b1),
                        Color(0xff739ae8),
                        Color(0xff87b4ff),
                      ])),
                  child: Center(
                    child: Column(children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: AnimSearchBar(
                            rtl: true,
                            style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                              fontSize: 16,
                            )),
                            color: Colors.orange,
                            textFieldColor: Colors.blue[400],
                            textFieldIconColor: Colors.black,
                            searchIconColor: Colors.green[800],
                            textController: searchtext,
                            onSuffixTap: () async {
                              searchtext.text == ""
                                  ? print("No text had been entered")
                                  : setState(() {
                                      _mydata =
                                          _getData(false, searchtext.text);
                                    });
                              FocusScope.of(context).unfocus();
                              print(searchtext);
                            },
                            helpText: "Search for City",
                            width: 340,
                            animationDurationInMilli: 800,
                            onSubmitted: (String) async {
                              searchtext.text == ""
                                  ? print("No text had been entered")
                                  : setState(() {
                                      _mydata =
                                          (_getData(false, searchtext.text));
                                    });

                              print(searchtext);
                              FocusScope.of(context).unfocus();
                              searchtext.clear();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 150,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.location_pin),
                              const SizedBox(
                                width: 2,
                              ),
                              Text(
                                "${data.location.name},${data.location.country}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(data.current.condition.text),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${data.current.tempC}°C",
                            style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      )
                    ]),
                  ),
                );
              }
            } else if (Snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Center(child: Text(Snapshot.connectionState.toString()));
            }
            return const Center(child: Text("Server time out!"));
          }),
    );
  }
}
