import 'v_image_cropper_stub.dart'
    if (dart.library.html) 'v_image_cropper_web.dart'
    if (dart.library.io) 'v_image_cropper_io.dart';

export 'v_image_cropper_stub.dart' show vSupportsImageCrop, vCropImage;
