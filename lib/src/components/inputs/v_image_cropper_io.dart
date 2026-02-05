import 'package:file_selector/file_selector.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';

/// Whether image cropping is supported on this platform.
const bool vSupportsImageCrop = true;

/// Opens the image cropper for the given file.
Future<XFile?> vCropImage({
  required XFile file,
  required BuildContext context,
  String? sourcePath,
}) async {
  final cropped = await ImageCropper().cropImage(sourcePath: file.path);
  if (cropped == null) return null;
  return XFile(cropped.path);
}
