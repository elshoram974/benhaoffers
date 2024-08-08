import 'package:eClassify/utils/Extensions/extensions.dart';
import 'package:flutter/material.dart';

import '../../../../../Utils/ui_utils.dart';

class CategoryHomeCard extends StatelessWidget {
  final String title;
  final String url;
  final VoidCallback onTap;
  const CategoryHomeCard({
    super.key,
    required this.title,
    required this.url,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String extension = url.split(".").last.toLowerCase();
    bool isFullImage = false;

    if (extension == "png" || extension == "svg") {
      isFullImage = false;
    } else {
      isFullImage = true;
    }
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          child: Column(
            children: [
              if (isFullImage) ...[
                Expanded(
                  flex: 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      width: double.infinity,
                      color: context.color.secondaryColor,
                      child: UiUtils.imageType(url, fit: BoxFit.cover),
                    ),
                  ),
                ),
              ] else ...[
                Expanded(
                  flex: 4,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: context.color.borderColor.darken(60),
                        width: 1,
                      ),
                      color: context.color.secondaryColor,
                    ),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: UiUtils.imageType(url, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              Expanded(
                child: Text(title)
                    .centerAlign()
                    .setMaxLines(lines: 2)
                    .size(context.font.smaller)
                    .color(
                      context.color.textDefaultColor,
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
