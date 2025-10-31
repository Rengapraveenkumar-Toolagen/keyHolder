import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'loading.dart';

// Show Images from network
Widget widgetShowImages(String? imageUrl) {
  return imageUrl != null && imageUrl.isNotEmpty
      ? CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                //colorFilter:ColorFilter.mode(Colors.red, BlendMode.colorBurn)
              ),
            ),
          ),
          placeholder: (context, url) => const Center(child: Loading()),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        )
      : const SizedBox();
}
