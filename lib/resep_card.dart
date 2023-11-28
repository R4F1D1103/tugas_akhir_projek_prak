import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projectakhir_kelompok_resep/detail_video.dart';

class ResepCard extends StatefulWidget {
  final String title;
  final String rating;
  final String cookTime;
  final String thumbnailUrl;
  final String videoUrl;
  final bool isBookmarked;

  ResepCard({
    required this.title,
    required this.cookTime,
    required this.rating,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.isBookmarked,
  });

  @override
  State<ResepCard> createState() => _ResepCardState();
}

class _ResepCardState extends State<ResepCard> {
  bool _isBookmarked = false;
  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.isBookmarked;
    _checkBookmarkStatus();
  }
  void _checkBookmarkStatus() async {
    var box = await Hive.openBox('favoriteBox');
    setState(() {
      _isBookmarked = box.containsKey(widget.title);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      width: MediaQuery.of(context).size.width,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            offset: Offset(
              0.0,
              10.0,
            ),
            blurRadius: 10.0,
            spreadRadius: -6.0,
          ),
        ],
        image: DecorationImage(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.35),
            BlendMode.multiply,
          ),
          image: NetworkImage(widget.thumbnailUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Align(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 19,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ),
            alignment: Alignment.center,
          ),
          Align(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: widget.videoUrl != 'noVideo' ? true : false,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DetailVideo(
                                      videoUrl: widget.videoUrl,
                                    )))
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.yellow,
                            size: 18,
                          ),
                          SizedBox(width: 7),
                          Text('Play Video'),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: Colors.yellow,
                        size: 18,
                      ),
                      SizedBox(width: 7),
                      Text(widget.cookTime),
                    ],
                  ),
                )
              ],
            ),
            alignment: Alignment.bottomLeft,
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: _isBookmarked ? Colors.yellow : Colors.white),
              onPressed: () async {
                 _toggleBookmark(
                  widget.title,
                  widget.cookTime,
                  widget.rating,
                  widget.thumbnailUrl,
                  widget.videoUrl,
                );
                setState(() {
                  _isBookmarked = !_isBookmarked;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _isBookmarked ? 'Bookmark ditambahkan!' : 'Bookmark dihapus!',
                    ),
                    duration: Duration(seconds: 1),
                  ),
                );

              },
            ),
          ),
        ],
      ),
    );
  }
}

void _toggleBookmark(
  String title,
  String cookTime,
  String rating,
  String thumbnailUrl,
  String videoUrl,

) async {
  var box = await Hive.openBox('favoriteBox');
  bool isAlreadyBookmarked = box.containsKey(title);

  if (isAlreadyBookmarked) {
    // Remove from favorites if already bookmarked
    box.delete(title);
  } else {
    print('Favorit berhasil disimpan ke dalam Hive box.');

    // Add to favorites if not bookmarked
    box.put(title, {
      'title': title,
      'cookTime': cookTime,
      'rating': rating,
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl,

    });
  }
}
