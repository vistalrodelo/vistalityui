import 'package:file_selector/file_selector.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';

const bool vSupportsImageCrop = true;

Future<XFile?> vCropImage({
  required XFile file,
  required BuildContext context,
  String? sourcePath,
}) async {
  final path = sourcePath ?? file.path;
  if (path.isEmpty) return null;
  final cropped = await ImageCropper().cropImage(
    sourcePath: path,
    uiSettings: [
      WebUiSettings(context: context),
    ],
  );
  if (cropped == null) return null;
  return XFile(cropped.path);
}
