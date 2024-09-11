import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/app/routes.dart';
import 'package:flutter/material.dart';

import '../../../data/model/item/item_model.dart';

class SellerNameContainer extends StatelessWidget {
  const SellerNameContainer({
    super.key,
    required this.itemModel,
    required this.turnFnOn,
  });

  final ItemModel itemModel;
  final bool turnFnOn;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: turnFnOn
          ? () {
              Navigator.pushNamed(
                context,
                Routes.sellerDetailsScreen,
                arguments: {
                  "model": itemModel,
                },
              );
            }
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: context.color.territoryColor,
          borderRadius: BorderRadius.circular(500),
        ),
        child: Text("${itemModel.user?.projectName ?? itemModel.user?.name}")
            .bold()
            .color(Colors.white)
            .size(context.font.small),
      ),
    );
  }
}
