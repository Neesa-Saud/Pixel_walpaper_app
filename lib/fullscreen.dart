import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class FullScreen extends StatefulWidget {
  final String imageurl;
  const FullScreen({super.key, required this.imageurl});
  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  Future<void> setwallpaper() async {
    int location = WallpaperManagerFlutter.homeScreen;
    var file = await DefaultCacheManager().getSingleFile(widget.imageurl);
    await WallpaperManagerFlutter().setWallpaper(file.path, location);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(child: Container(child: Image.network(widget.imageurl))),
            Material(
              color: Colors.black,
              child: InkWell(
                onTap: () {},
                splashColor: Colors.grey,
                child: Container(
                  height: 60,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      'Set Walpaper',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
