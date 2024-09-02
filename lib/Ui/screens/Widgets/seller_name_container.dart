import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/hive_utils.dart';
import 'package:eClassify/app/routes.dart';
import 'package:flutter/material.dart';

import '../../../data/model/item/item_model.dart';

class SellerNameContainer extends StatelessWidget {
  const SellerNameContainer({super.key, required this.itemModel});

  final ItemModel itemModel;

  @override
  Widget build(BuildContext context) {
    final bool byMe = (itemModel.user?.id != null
            ? itemModel.user?.id.toString()
            : itemModel.userId) ==
        HiveUtils.getUserId();
    return GestureDetector(
      onTap: byMe
          ? null
          : () {
              Navigator.pushNamed(
                context,
                Routes.sellerDetailsScreen,
                arguments: {
                  "model": itemModel,
                },
              );
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: context.color.territoryColor,
          borderRadius: BorderRadius.circular(500),
        ),
        child: Text("${itemModel.user?.name}")
            .bold()
            .color(Colors.white)
            .size(context.font.small),
      ),
    );
  }
}
