// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class CameraPopup extends StatefulWidget {
//   final List<CameraDescription> cameras;
//   final void Function()? onCancel;
//   final void Function(XFile image)? onNext;
//   const CameraPopup(
//       {super.key, required this.cameras, this.onCancel, this.onNext});

//   @override
//   State<CameraPopup> createState() => _CameraPopupState();
// }

// class _CameraPopupState extends State<CameraPopup> {
//   late CameraController _controller;
//   bool _isCameraInitialized = false;
//   XFile? _capturedImage;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   Future<void> _initializeCamera() async {
//     _controller = CameraController(
//       widget.cameras[0],
//       ResolutionPreset.medium,
//     );
//     await _controller.initialize();
//     if (mounted) {
//       setState(() {
//         _isCameraInitialized = true;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     _controller.dispose();
//     super.dispose();
//   }

//   void _takePicture() async {
//     final image = await _controller.takePicture();
//     setState(() {
//       _capturedImage = image;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       child: AspectRatio(
//         aspectRatio: 3 / 4,
//         child: _isCameraInitialized
//             ? Stack(
//                 children: [
//                   Positioned(
//                     top: 8,
//                     right: 8,
//                     child: IconButton(
//                       icon: const Icon(Icons.close, color: Colors.white),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                   ),
//                   Positioned.fill(
//                     child: _capturedImage == null
//                         ? CameraPreview(_controller)
//                         : Image.file(File(_capturedImage!.path),
//                             fit: BoxFit.cover),
//                   ),
//                   Positioned(
//                     bottom: 20,
//                     left: 0,
//                     right: 0,
//                     child: Center(
//                       child: _capturedImage == null
//                           ? ElevatedButton(
//                               onPressed: _takePicture,
//                               child: const Text('Capture'),
//                             )
//                           : Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       _capturedImage = null;
//                                     });
//                                     if (widget.onCancel != null)
//                                       widget.onCancel!();
//                                   },
//                                   child: const Text('Cancel'),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: () {
//                                     Navigator.pop(context); // close dialog
//                                     if (widget.onNext != null) {
//                                       widget.onNext!(_capturedImage!);
//                                     }
//                                   },
//                                   child: const Text('Next'),
//                                 ),
//                               ],
//                             ),
//                     ),
//                   ),
//                 ],
//               )
//             : const Center(child: CircularProgressIndicator()),
//       ),
//     );
//   }
// }
