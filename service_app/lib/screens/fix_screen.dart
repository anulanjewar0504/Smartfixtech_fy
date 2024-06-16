import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';



class VideoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.cyan),
      home: VideoPage(),
    );
  }
}

class VideoInfo {
  final String videoUrl;
  final String videoTitle;
  final String videoId;
  final String description;

  VideoInfo({
    required this.videoUrl,
    required this.videoTitle,
    required this.videoId,
    required this.description,
  });
}

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final supabase = Supabase.instance.client;
  List<VideoInfo> videoInfoList = [];
  List<VideoInfo> filteredVideoList = [];

  @override
  void initState() {
    super.initState();
    fetchVideoInfo();
  }

  Future<void> fetchVideoInfo() async {
    final response = await supabase.from('fixmyself').select();

    setState(() {
      videoInfoList = response.map((data) {
        return VideoInfo(
          videoUrl: data['videoUrl'] as String,
          videoTitle: data['videoTitle'] as String,
          videoId: data['videoId'] as String,
          description: data['description'] as String,
        );
      }).toList();
      filteredVideoList = List.from(videoInfoList);
    });
  }

  void filterVideos(String query) {
    setState(() {
      filteredVideoList = videoInfoList.where((video) {
        final titleLower = video.videoTitle.toLowerCase();
        final queryLower = query.toLowerCase();
        return titleLower.contains(queryLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if(filteredVideoList.isEmpty & videoInfoList.isEmpty ){
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(
          color: Colors.brown,
        )),
      );
    }
    else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Fix Yourself'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: filterVideos,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredVideoList.length,
                itemBuilder: (context, index) {
                  final videoInfo = filteredVideoList[index];
                  return VideoListItem(videoInfo: videoInfo);
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
class VideoListItem extends StatelessWidget {
  final VideoInfo videoInfo;

  const VideoListItem({
    Key? key,
    required this.videoInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          _launchURL(videoInfo.videoUrl);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                videoInfo.videoTitle,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                videoInfo.description,
                style: TextStyle(fontSize: 14),
              ),
            ),
            SizedBox(height: 8),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: GestureDetector(
                onTap: (){
                  _launchURL(videoInfo.videoUrl);
                },
                child: Image.asset(
                  'assets/img.png',
                  width: MediaQuery.of(context).size.width * 0.9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}