import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/fullscreen.dart';

class Walpaper extends StatefulWidget {
  const Walpaper({super.key});
  @override
  State<Walpaper> createState() => _WalpaperState();
}

class _WalpaperState extends State<Walpaper> {
  List image = [];
  int page = 1;
  @override
  void initState() {
    super.initState();
    fetchapi();
  }

  fetchapi() async {
    await http
        .get(
          Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
          headers: {
            'Authorization':
                'FgnhUqF9O09FxKgFJBBGrl12lbZ9wehqgcuYnFhIsCIpVjQT58tj5nVf',
          },
        )
        .then((value) {
          Map result = jsonDecode(value.body);
          setState(() {
            image = result['photos'];
          });
          print(image[0]);
        });
  }

  loadmore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        // ignore: prefer_interpolation_to_compose_strings
        'https://api.pexels.com/v1/curated?per_page=80&page=' + page.toString();
    await http
        .get(
          Uri.parse('https://api.pexels.com/v1/curated?per_page=80'),
          headers: {
            'Authorization':
                'FgnhUqF9O09FxKgFJBBGrl12lbZ9wehqgcuYnFhIsCIpVjQT58tj5nVf',
          },
        )
        .then((value) {
          Map result = jsonDecode(value.body);
          setState(() {
            image.addAll(result['photos']);
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              child: GridView.builder(
                itemCount: image.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 2,
                  childAspectRatio: 2 / 3,
                  mainAxisSpacing: 2,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => FullScreen(
                                imageurl: image[index]['src']['large2x'],
                              ),
                        ),
                      );
                    },
                    child: Image.network(
                      image[index]['src']['tiny'],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ),
          Material(
            color: Colors.black,
            child: InkWell(
              onTap: () {
                loadmore();
              },
              splashColor: Colors.grey,
              child: Container(
                height: 60,
                width: double.infinity,
                child: Center(
                  child: Text(
                    'More Walpapers',
                    style: TextStyle(fontSize: 20, color: Colors.white),
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
