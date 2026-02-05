import 'package:file_selector/file_selector.dart';
import 'package:flutter/widgets.dart';

/// Whether image cropping is supported on this platform.
const bool vSupportsImageCrop = false;

/// Opens the image cropper for the given file.
Future<XFile?> vCropImage({
  required XFile file,
  required BuildContext context,
  String? sourcePath,
}) async {
  return null;
}
