import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class FullScreen extends StatefulWidget {
  final String imageurl;
  const FullScreen({super.key, required this.imageurl});

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  Future<bool> _requestPermission() async {
    var status = await Permission.storage.status;
    print('Permission status: $status'); // Debug print
    if (!status.isGranted) {
      status = await Permission.storage.request();
      print('Permission request result: $status'); // Debug print
    }
    return status.isGranted;
  }

  Future<void> setwallpaper() async {
    bool permissionGranted = await _requestPermission();
    if (!permissionGranted) {
      print('Cannot set wallpaper: Storage permission not granted');
      return;
    }

    int location = WallpaperManagerFlutter.homeScreen;
    var file = await DefaultCacheManager().getSingleFile(widget.imageurl);
    print('Image downloaded: ${file.path}');
    await WallpaperManagerFlutter().setWallpaper(file, location);
    print('Wallpaper set successfully');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Image.network(widget.imageurl, fit: BoxFit.cover),
              ),
            ),
            Material(
              color: Colors.black,
              child: InkWell(
                onTap: setwallpaper,
                splashColor: Colors.grey,
                child: Container(
                  height: 60,
                  width: double.infinity,
                  child: const Center(
                    child: Text(
                      'Set Wallpaper',
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
