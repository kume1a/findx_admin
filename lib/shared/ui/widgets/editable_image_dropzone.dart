import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../logger.dart';

typedef OnChangePickedImages = void Function(List<Uint8List> files);

typedef ImagesValueNotifier = ValueNotifier<List<Uint8List>>;

const List<String> _mimetypeImages = ['image/png', 'image/jpg', 'image/jpeg'];

class EditableImageDropzone extends HookWidget {
  const EditableImageDropzone({
    super.key,
    required this.onChangePickedImages,
  });

  final OnChangePickedImages onChangePickedImages;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final controller = useState<DropzoneViewController?>(null);
    final images = useState<List<Uint8List>>([]);

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Expanded(
            child: _ImageDropzone(
              onCreateController: (value) => controller.value = value,
              onDropMultiple: (files) => _onPickMultiple(files, images, controller),
              child: images.value.isEmpty
                  ? const Text('Drop images here')
                  : _ImageList(
                      images: images.value,
                      onRemoveImage: (image) => _onRemoveImage(images, image),
                    ),
            ),
          ),
          if (images.value.isEmpty)
            ElevatedButton(
              onPressed: () => _pickMultiple(images, controller),
              child: const Text('Pick file'),
            ),
        ],
      ),
    );
  }

  Future<void> _pickMultiple(
    ImagesValueNotifier images,
    ValueNotifier<DropzoneViewController?> controller,
  ) async {
    final files = await controller.value?.pickFiles(
      multiple: true,
      mime: _mimetypeImages,
    );

    await _onPickMultiple(files, images, controller);
  }

  Future<void> _onPickMultiple(
    List<dynamic>? files,
    ImagesValueNotifier images,
    ValueNotifier<DropzoneViewController?> controller,
  ) async {
    if (controller.value == null || files == null || files.isEmpty) {
      return;
    }

    final imagesData = await Future.wait(files.map((e) => controller.value!.getFileData(e)));

    final imagesCopy = List.of(images.value);
    imagesCopy.addAll(imagesData);
    images.value = imagesCopy;

    onChangePickedImages.call(imagesData);
  }

  Future<void> _onRemoveImage(
    ImagesValueNotifier images,
    Uint8List image,
  ) async {
    final imagesCopy = List.of(images.value);
    imagesCopy.remove(image);
    images.value = imagesCopy;

    onChangePickedImages(imagesCopy);
  }
}

class _ImageDropzone extends HookWidget {
  const _ImageDropzone({
    required this.onCreateController,
    required this.onDropMultiple,
    required this.child,
  });

  final DropzoneViewCreatedCallback onCreateController;
  final ValueChanged<List<dynamic>?> onDropMultiple;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final highlighted = useState(false);
    final theme = Theme.of(context);

    return Container(
      color: highlighted.value ? theme.colorScheme.primaryContainer : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          DropzoneView(
            mime: _mimetypeImages,
            operation: DragOperation.copy,
            cursor: CursorType.grab,
            onCreated: onCreateController,
            onError: (e) => logger.e('Error picking file: $e'),
            onDropInvalid: (e) => logger.e('Error picking file, invalid MIME: $e'),
            onHover: () => highlighted.value = true,
            onLeave: () => highlighted.value = false,
            onDropMultiple: (files) {
              highlighted.value = false;

              onDropMultiple(files);
            },
          ),
          child,
        ],
      ),
    );
  }
}

class _ImageList extends StatelessWidget {
  const _ImageList({
    required this.images,
    required this.onRemoveImage,
  });

  final List<Uint8List> images;
  final void Function(Uint8List) onRemoveImage;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: images.length,
      itemBuilder: (_, index) {
        final imageData = images[index];

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.memory(
                    imageData,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: IconButton(
                      onPressed: () => onRemoveImage(imageData),
                      color: Colors.white,
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
