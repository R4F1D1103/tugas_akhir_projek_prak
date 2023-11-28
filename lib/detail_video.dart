import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DetailVideo extends StatefulWidget {
  final String videoUrl;

  DetailVideo({required this.videoUrl});

  @override
  State<DetailVideo> createState() => _DetailVideoState(videoUrl);
}

class _DetailVideoState extends State<DetailVideo> {
  final String videoUrl;
  _DetailVideoState(this.videoUrl);

  late VideoPlayerController playercontroller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playercontroller = VideoPlayerController.network(videoUrl)
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((value) => playercontroller
          .play()); //jika masuk ke beranda resep video, video akan langsung otomatis terputar
    @override
    void dispose() {
      super.dispose(); //keluar dari halaman mengahirkan proses
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu),
            SizedBox(width: 10),
            Text('Resep Video')
          ],
        ),
      ),
      body: Center(
        child: playercontroller.value.isInitialized
            ? Container(
                alignment: Alignment.topCenter,
                child: buildVideo(), //jika terinialisasi maka akan build video
              )
            : Container(
                height: 200,
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }

  Widget buildVideo() => Stack(
        children: <Widget>[
          buildVideoPlayer(), //dimulai dengan menjalankan video player
          Positioned.fill(
              child:
                  buildBasicOverlay()) // posisinya menggunakan basic ovelar yang sudah disiapkan dibawah
        ],
      );

  Widget buildVideoPlayer() => AspectRatio(
        aspectRatio: playercontroller.value.aspectRatio,
        child: VideoPlayer(playercontroller),
      );

  Widget buildBasicOverlay() => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => playercontroller.value.isPlaying
            ? playercontroller
                .pause() //jika playing/jalan ketika tombol di klik akan di pause
            : playercontroller.play(), //jika di klik akan play
        child: Stack(
          children: <Widget>[
            buildPlay(),
            Positioned(bottom: 0, left: 0, right: 0, child: buildIndicator())
          ],
        ),
      );
  Widget buildIndicator() =>
      VideoProgressIndicator(playercontroller, allowScrubbing: true);

  Widget buildPlay() => playercontroller.value.isPlaying
      ? Container()
      : Container(
          alignment: Alignment.center,
          color: Colors.black26,
          child: Icon(
            Icons.play_arrow,
            color: Colors.white,
            size: 80,
          ),
        );
}
