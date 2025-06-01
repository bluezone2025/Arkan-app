// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
//
// class VideoPlayerScreen extends StatefulWidget {
//   final String url;
//   const VideoPlayerScreen({Key? key, required this.url}) : super(key: key);
//
//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   VideoPlayerController? videoPlayerController;
//   ChewieController? chewieController;
//   @override
//   void initState() {
//     super.initState();
//     videoPlayerController = VideoPlayerController.network(widget.url)
//       ..initialize();
//     chewieController = ChewieController(
//       videoPlayerController: videoPlayerController!,
//       autoPlay: true,
//       looping: true,
//     );
//   }
//
//   @override
//   void dispose() {
//     videoPlayerController!.dispose();
//     chewieController!.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double h = MediaQuery.of(context).size.height;
//     return Container(
//       width: double.infinity,
//       height: h * 0.2,
//       color: Colors.white,
//       child: Chewie(controller: chewieController!),
//     );
//   }
// }
