import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:eClassify/Ui/screens/Item/add_item_screen/Widgets/ImageAdapter.dart';
import 'package:eClassify/Ui/screens/Item/add_item_screen/select_category.dart';
import 'package:eClassify/Ui/screens/widgets/blurred_dialoge_box.dart';
import 'package:eClassify/Utils/AppIcon.dart';
import 'package:eClassify/Utils/Extensions/extensions.dart';
import 'package:eClassify/Utils/responsiveSize.dart';

import 'package:eClassify/data/model/item/item_model.dart';
import 'package:eClassify/data/model/subscription_pacakage_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../../Utils/cloudState/cloud_state.dart';
import '../../../../Utils/helper_utils.dart';
import '../../../../Utils/imagePicker.dart';
import '../../../../Utils/ui_utils.dart';
import '../../../../Utils/validator.dart';
import '../../../../data/cubits/CustomField/fetch_custom_fields_cubit.dart';
import '../../../../data/model/category_model.dart';
import '../../../../exports/main_export.dart';
import '../../Widgets/AnimatedRoutes/blur_page_route.dart';
import '../../Widgets/DynamicField/dynamic_field.dart';
import '../../Widgets/custom_text_form_field.dart';

class AddItemDetails extends StatefulWidget {
  final List<CategoryModel>? breadCrumbItems;
  final bool? isEdit;

  const AddItemDetails({
    super.key,
    this.breadCrumbItems,
    required this.isEdit,
  });

  static Route route(RouteSettings settings) {
    Map<String, dynamic>? arguments =
        settings.arguments as Map<String, dynamic>?;
    return BlurredRouter(
      builder: (context) {
        return BlocProvider(
          create: (context) => FetchCustomFieldsCubit(),
          child: AddItemDetails(
            breadCrumbItems: arguments?['breadCrumbItems'],
            isEdit: arguments?['isEdit'],
          ),
        );
      },
    );
  }

  @override
  CloudState<AddItemDetails> createState() => _AddItemDetailsState();
}

class _AddItemDetailsState extends CloudState<AddItemDetails> {
  final PickImage _pickTitleImage = PickImage();
  final PickImage itemImagePicker = PickImage();
  String titleImageURL = "";
  List<dynamic> mixedItemImageList = [];
  List<int> deleteItemImageList = [];
  final GlobalKey<FormState> _formKey = GlobalKey();

  //Text Controllers
  final TextEditingController adTitleController = TextEditingController();
  final TextEditingController adSlugController = TextEditingController();
  final TextEditingController adDescriptionController = TextEditingController();
  final TextEditingController adPriceController = TextEditingController();
  final TextEditingController adPhoneNumberController = TextEditingController();
  final TextEditingController adAdditionalDetailsController =
      TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  DateTime? _tempEndDate;
  late String dateToShow = "chooseDate".translate(context);

  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();

    adTitleController.dispose();
    adSlugController.dispose();
    adDescriptionController.dispose();
    adPriceController.dispose();
    adPhoneNumberController.dispose();
    adAdditionalDetailsController.dispose();
    endDateController.dispose();
    scrollController.dispose();
  }

  void _onBreadCrumbItemTap(int index) {
    int popTimes = (widget.breadCrumbItems!.length - 1) - index;
    int current = index;
    int length = widget.breadCrumbItems!.length;

    for (int i = length - 1; i >= current + 1; i--) {
      widget.breadCrumbItems!.removeAt(i);
    }

    for (int i = 0; i < popTimes; i++) {
      Navigator.pop(context);
    }
    setState(() {});
  }

  late List selectedCategoryList;
  ItemModel? item;

  Future<void> fetchPackages() async {
    await BlocProvider.of<FetchAdsListingSubscriptionPackagesCubit>(context)
        .fetchPackages();
  }

  @override
  void initState() {
    AbstractField.fieldsData.clear();
    AbstractField.files.clear();
    fetchPackages();
    if (widget.isEdit == true) {
      item = getCloudData('edit_request') as ItemModel;

      clearCloudData("item_details");
      clearCloudData("with_more_details");
      context.read<FetchCustomFieldsCubit>().fetchCustomFields(
            categoryIds: item!.allCategoryIds!,
          );
      adTitleController.text = item?.name ?? "";
      adSlugController.text = item?.slug ?? "";
      adDescriptionController.text = item?.description ?? "";
      adPriceController.text = item?.price.toString() ?? "";
      adPhoneNumberController.text = item?.contact ?? "";
      adAdditionalDetailsController.text = item?.videoLink ?? "";
      if (item?.endDate != null) {
        endDateController.text = item!.endDate!.toIso8601String();
        dateToShow = DateFormat.yMMMd().format(item!.endDate!);
      }
      titleImageURL = item?.image ?? "";

      List<String?>? list = item?.galleryImages?.map((e) => e.image).toList();
      mixedItemImageList.addAll([...list ?? []]);

      setState(() {});
    } else {
      List<int> ids = widget.breadCrumbItems!.map((item) => item.id!).toList();

      context
          .read<FetchCustomFieldsCubit>()
          .fetchCustomFields(categoryIds: ids.join(','));
      selectedCategoryList = ids;
      adPhoneNumberController.text = HiveUtils.getUserDetails().mobile ?? "";
    }

    _pickTitleImage.listener((p0) {
      titleImageURL = "";
      WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
        if (mounted) setState(() {});
      });
    });

    itemImagePicker.listener((images) {
      try {
        mixedItemImageList.addAll(List<dynamic>.from(images));
      } catch (e) {}

      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: UiUtils.getSystemUiOverlayStyle(
          context: context, statusBarColor: context.color.secondaryColor),
      child: PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          //Navigator.pop(context, true);
          return;
        },
        /*onWillPop: () async {
          Navigator.pop(context, true);
          return false;
        },*/
        child: SafeArea(
          child: Scaffold(
            appBar: UiUtils.buildAppBar(context,
                showBackButton: true, title: "AdDetails".translate(context)),
            bottomNavigationBar: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: UiUtils.buildButton(context, onPressed: () {
                  ///File to

                  if (_formKey.currentState?.validate() ?? false) {
                    List<File>? galleryImages = mixedItemImageList
                        .where((element) => element != null && element is File)
                        .map((element) => element as File)
                        .toList();

                    if (_pickTitleImage.pickedFile == null &&
                        titleImageURL == "") {
                      UiUtils.showBlurredDialoge(
                        context,
                        dialoge: BlurredDialogBox(
                          title: "imageRequired".translate(context),
                          content:
                              Text("selectImageYourItem".translate(context)),
                          onAccept: () async {
                            scrollController.animateTo(
                              100,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.bounceIn,
                            );
                          },
                        ),
                      );
                      return;
                    }

                    /* if (galleryImages.isEmpty && mixedItemImageList.isEmpty) {
                      UiUtils.showBlurredDialoge(context,
                          dialoge: BlurredDialogBox(
                            title: "atLeastOneImageRequired".translate(context),
                            content: Text(
                              "selectUpTOOneImage".translate(context),
                            ),
                          ));
                      return;
                    }*/

                    print("deleteItemImageList*****$deleteItemImageList");

                    addCloudData("item_details", {
                      "name": adTitleController.text,
                      "slug": adSlugController.text,
                      "description": adDescriptionController.text,
                      if (widget.isEdit != true)
                        "category_id": selectedCategoryList.last,
                      if (widget.isEdit == true) "id": item?.id,
                      "price": adPriceController.text,
                      "contact": adPhoneNumberController.text.trim().isEmpty
                          ? null
                          : adPhoneNumberController.text.trim(),
                      "video_link": adAdditionalDetailsController.text,
                      if (widget.isEdit == true)
                        "delete_item_image_id": deleteItemImageList.join(','),
                      "end_date": endDateController.text,
                      "all_category_ids": widget.isEdit == true
                          ? item!.allCategoryIds
                          : selectedCategoryList.join(',')
                      /*"image": _pickTitleImage.pickedFile,
                      "gallery_images": galleryImages,*/
                    });
                    screenStack++;
                    if (context.read<FetchCustomFieldsCubit>().isEmpty()!) {
                      addCloudData("with_more_details", {
                        "name": adTitleController.text,
                        "slug": adSlugController.text,
                        "description": adDescriptionController.text,
                        if (widget.isEdit != true)
                          "category_id": selectedCategoryList.last,
                        if (widget.isEdit == true) "id": item?.id,
                        "price": adPriceController.text,
                        "contact": adPhoneNumberController.text.trim().isEmpty
                            ? null
                            : adPhoneNumberController.text.trim(),
                        "video_link": adAdditionalDetailsController.text,
                        "all_category_ids": widget.isEdit == true
                            ? item!.allCategoryIds
                            : selectedCategoryList.join(','),
                        if (widget.isEdit == true)
                          "delete_item_image_id": deleteItemImageList.join(','),
                        "end_date": endDateController.text

                        //missing in API
                        /* "image": _pickTitleImage.pickedFile,
                        "gallery_images": galleryImages,*/
                      });
                      print(
                          "_pickTitleImage.pickedFile***${_pickTitleImage.pickedFile}");
                      print("otherImage***${galleryImages}");
                      Navigator.pushNamed(context, Routes.confirmLocationScreen,
                          arguments: {
                            "isEdit": widget.isEdit,
                            "mainImage": _pickTitleImage.pickedFile,
                            "otherImage": galleryImages
                          });
                    } else {
                      print(
                          "_pickTitleImage.pickedFile11***${_pickTitleImage.pickedFile}");
                      print("otherImage11***${galleryImages}");
                      Navigator.pushNamed(context, Routes.addMoreDetailsScreen,
                          arguments: {
                            "context": context,
                            "isEdit": widget.isEdit == true,
                            "mainImage": _pickTitleImage.pickedFile,
                            "otherImage": galleryImages
                          }).then((value) {
                        screenStack--;
                      });
                    }
                  }
                },
                    height: 48.rh(context),
                    fontSize: context.font.large,
                    buttonTitle: "next".translate(context)),
              ),
            ),
            body: Form(
              key: _formKey,
              child: RefreshIndicator(
                onRefresh: fetchPackages,
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("youAreAlmostThere".translate(context))
                            .size(context.font.large)
                            .bold(weight: FontWeight.w600)
                            .color(context.color.textColorDark),
                        SizedBox(
                          height: 16.rh(context),
                        ),
                        if (widget.breadCrumbItems != null)
                          _AlmostHereWidget(
                            breadCrumbItems: widget.breadCrumbItems,
                            onTapCat: _onBreadCrumbItemTap,
                          ),
                        SizedBox(height: 18.rh(context)),
                        Row(
                          children: [
                            Text("mainPicture".translate(context)),
                            const SizedBox(width: 3),
                            Text("maxSize".translate(context))
                                .italic()
                                .size(context.font.small),
                          ],
                        ),
                        SizedBox(height: 10.rh(context)),
                        Wrap(children: [titleImageListener()]),
                        SizedBox(height: 13.rh(context)),
                        Row(
                          children: [
                            Text("otherPictures".translate(context)),
                            const SizedBox(width: 3),
                            Text("max5Images".translate(context))
                                .italic()
                                .size(context.font.small),
                          ],
                        ),
                        SizedBox(height: 10.rh(context)),
                        itemImagesListener(),
                        SizedBox(height: 10.rh(context)),
                        Text("adTitle".translate(context)),
                        SizedBox(height: 10.rh(context)),
                        CustomTextFormField(
                          controller: adTitleController,
                          // controller: _itemNameController,
                          validator: CustomTextFieldValidator.adTitle,
                          action: TextInputAction.next,
                          capitalization: TextCapitalization.sentences,
                          hintText: "adTitleHere".translate(context),
                          hintTextStyle: TextStyle(
                              color: context.color.textDefaultColor
                                  .withOpacity(0.5),
                              fontSize: context.font.large),
                          onChange: (String val) {
                            String text = '';
                            val = val.trim();
                            for (int i = 0; i < val.length; i++) {
                              text += slugLetter[val[i].toLowerCase()] ?? '';
                            }
                            adSlugController.text = text;
                          },
                        ),
                        // SizedBox(height: 15.rh(context)),
                        // Text(
                        //     "${"adSlug".translate(context)}\t(${"englishOnlyLbl".translate(context)})"),
                        // SizedBox(
                        //   height: 10.rh(context),
                        // ),
                        // CustomTextFormField(
                        //   controller: adSlugController,
                        //   // controller: _itemNameController,
                        //   validator: CustomTextFieldValidator.slug,
                        //   enabled: false,
                        //   hintText: "adSlugHere".translate(context),
                        //   hintTextStyle: TextStyle(
                        //       color: context.color.textDefaultColor
                        //           .withOpacity(0.5),
                        //       fontSize: context.font.large),
                        // ),
                        SizedBox(height: 15.rh(context)),
                        Text("descriptionLbl".translate(context)),
                        SizedBox(height: 15.rh(context)),
                        CustomTextFormField(
                          controller: adDescriptionController,

                          action: TextInputAction.newline,
                          // controller: _descriptionController,
                          validator: CustomTextFieldValidator.nullCheck,
                          capitalization: TextCapitalization.sentences,
                          hintText: "writeSomething".translate(context),
                          maxLine: 100,
                          minLine: 6,

                          hintTextStyle: TextStyle(
                              color: context.color.textDefaultColor
                                  .withOpacity(0.5),
                              fontSize: context.font.large),
                        ),
                        SizedBox(height: 15.rh(context)),
                        Text("price".translate(context)),
                        SizedBox(
                          height: 10.rh(context),
                        ),
                        CustomTextFormField(
                          controller: adPriceController,
                          action: TextInputAction.next,
                          prefixWithBorder: Text(Constant.currencySymbol),
                          // controller: _priceController,
                          formaters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d*')),
                          ],
                          isReadOnly: false,
                          keyboard: TextInputType.number,
                          validator: CustomTextFieldValidator.nullCheck,
                          hintText: "00",
                          hintTextStyle: TextStyle(
                              color: context.color.textDefaultColor
                                  .withOpacity(0.5),
                              fontSize: context.font.large),
                        ),
                        SizedBox(height: 10.rh(context)),
                        Text("phoneNumber".translate(context)),
                        SizedBox(height: 10.rh(context)),
                        CustomTextFormField(
                          controller: adPhoneNumberController,
                          action: TextInputAction.next,
                          formaters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d*')),
                          ],
                          isReadOnly: false,
                          suffixWithBorder: Icon(Icons.call_outlined),
                          keyboard: TextInputType.phone,
                          validator: adPhoneNumberController.text.isEmpty
                              ? null
                              : CustomTextFieldValidator.phoneNumber,
                          hintText: "9876543210",
                          hintTextStyle: TextStyle(
                              color: context.color.textDefaultColor
                                  .withOpacity(0.5),
                              fontSize: context.font.large),
                        ),
                        SizedBox(height: 10.rh(context)),
                        Text("videoLink".translate(context)),
                        SizedBox(height: 10.rh(context)),
                        CustomTextFormField(
                          controller: adAdditionalDetailsController,
                          validator:
                              adAdditionalDetailsController.text.isNotEmpty
                                  ? CustomTextFieldValidator.url
                                  : null,
                          // prefix: Text("${Constant.currencySymbol} "),
                          // controller: _videoLinkController,
                          // isReadOnly: widget.properyDetails != null,
                          hintText: "http://example.com/video.mp4",
                          hintTextStyle: TextStyle(
                              color: context.color.textDefaultColor
                                  .withOpacity(0.5),
                              fontSize: context.font.large),
                        ),
                        SizedBox(height: 10.rh(context)),
                        Text("endDate".translate(context)),
                        SizedBox(
                          height: 10.rh(context),
                        ),
                        BlocConsumer<FetchAdsListingSubscriptionPackagesCubit,
                            FetchAdsListingSubscriptionPackagesState>(
                          listener: (context, state) {
                            if (state
                                is FetchAdsListingSubscriptionPackagesSuccess) {
                              DateTime? farthestEndDate = DateTime(2001);
                              for (SubscriptionPackageModel e
                                  in state.subscriptionPackages) {
                                if (e.endDate == null && e.isActive == true) {
                                  farthestEndDate = null;
                                  break;
                                }

                                if (e.endDate != null &&
                                    e.endDate!.isAfter(farthestEndDate!) &&
                                    e.isActive == true) {
                                  farthestEndDate = e.endDate!;
                                  _tempEndDate = e.endDate!;
                                }
                              }
                              if (item?.endDate != null) return;
                              if (farthestEndDate != null) {
                                dateToShow =
                                    DateFormat.yMMMd().format(farthestEndDate);
                                endDateController.text =
                                    farthestEndDate.toIso8601String();
                              }
                            }
                          },
                          builder: (context, state) {
                            return CustomValidator<String>(
                              initialValue: endDateController.text,
                              validator: (String? value) {
                                if (value?.isNotEmpty == true) {
                                  return null;
                                }

                                return "pleaseSelectDate".translate(context);
                              },
                              builder: (state) {
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        final initialDate = DateTime.tryParse(
                                            endDateController.text);
                                        showDatePicker(
                                          context: context,
                                          initialEntryMode:
                                              DatePickerEntryMode.calendarOnly,
                                          firstDate: !(DateTime.now().isAfter(
                                                  initialDate ??
                                                      DateTime.now()))
                                              ? DateTime.now()
                                              : initialDate!,
                                          lastDate:
                                              _tempEndDate ?? DateTime(2100),
                                          initialDate: initialDate,
                                        ).then((e) {
                                          if (e != null) {
                                            dateToShow =
                                                DateFormat.yMMMd().format(e);
                                            endDateController.text = e
                                                .copyWith(
                                                    hour: 23,
                                                    minute: 59,
                                                    second: 59)
                                                .toIso8601String();
                                            print(
                                                "ddd ${DateTime.parse(endDateController.text)}");
                                            state.didChange(
                                                endDateController.text);
                                          }
                                          HelperUtils.unfocus();
                                        });
                                      },
                                      child: Container(
                                        height: 48,
                                        width: double.infinity,
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 14.0),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: context.color.secondaryColor,
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            border: Border.all(
                                              width: 1,
                                              color: state.hasError
                                                  ? context.color.error
                                                  : context.color.borderColor
                                                      .darken(30),
                                            )),
                                        child: Text(
                                          dateToShow,
                                          style: TextStyle(
                                            color: state.hasError
                                                ? context.color.error
                                                : context.color.textColorDark
                                                    .withOpacity(0.7),
                                            fontSize: context.font.large,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: state.hasError,
                                      child: Container(
                                        width: double.infinity,
                                        padding:
                                            const EdgeInsetsDirectional.only(
                                                start: 14.0),
                                        child: Text(
                                          state.errorText ?? '',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: context.font.small,
                                            color: context.color.error,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(height: 15.rh(context)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showImageSourceDialog(
      BuildContext context, Function(ImageSource) onSelected) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('selectImageSource'.translate(context)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('camera'.translate(context)),
                  onTap: () {
                    Navigator.of(context).pop();
                    onSelected(ImageSource.camera);
                  },
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text('gallery'.translate(context)),
                  onTap: () {
                    Navigator.of(context).pop();
                    onSelected(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /*Widget titleImageListener() {
    return _pickTitleImage.listenChangesInUI((context, file) {
      Widget currentWidget = Container();
      if (titleImageURL != "") {
        currentWidget = GestureDetector(
          onTap: () {
            UiUtils.showFullScreenImage(context,
                provider: NetworkImage(titleImageURL));
          },
          child: Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.all(5),
              clipBehavior: Clip.antiAlias,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: UiUtils.getImage(
                titleImageURL,
                fit: BoxFit.cover,
              )),
        );
      }
      if (file is File) {
        currentWidget = GestureDetector(
          onTap: () {
            UiUtils.showFullScreenImage(context, provider: FileImage(file));
          },
          child: Column(
            children: [
              Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.all(5),
                  clipBehavior: Clip.antiAlias,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Image.file(
                    file,
                    fit: BoxFit.cover,
                  )),
            ],
          ),
        );
      }

      return Wrap(
        children: [
          if (file == null && titleImageURL == "")
            DottedBorder(
              color: context.color.textLightColor,
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              child: GestureDetector(
                onTap: () {
                  showImageSourceDialog(context, (source) {
                    _pickTitleImage.resumeSubscription();
                    _pickTitleImage.pick(
                        pickMultiple: false, context: context, source: source);
                    _pickTitleImage.pauseSubscription();
                    titleImageURL = "";
                    setState(() {});
                  });
                  */ /* _pickTitleImage.resumeSubscription();
                  _pickTitleImage.pick(
                      pickMultiple: false,
                      context: context,
                      source: ImageSource.gallery);
                  _pickTitleImage.pauseSubscription();
                  titleImageURL = "";
                  setState(() {});*/ /*
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  alignment: AlignmentDirectional.center,
                  height: 48.rh(context),
                  child: Text(
                    "addMainPicture".translate(context),
                    style: TextStyle(
                        color: context.color.textDefaultColor,
                        fontSize: context.font.large),
                  ),
                ),
              ),
            ),
          Stack(
            children: [
              currentWidget,
              closeButton(context, () {
                _pickTitleImage.clearImage();

                titleImageURL = "";
                setState(() {});
              })
            ],
          ),
          if (file != null || titleImageURL != "")
            uploadPhotoCard(context, onTap: () {
              showImageSourceDialog(context, (source) {
                _pickTitleImage.resumeSubscription();
                _pickTitleImage.pick(
                    pickMultiple: false, context: context, source: source);
                _pickTitleImage.pauseSubscription();
                titleImageURL = "";
                setState(() {});
              });
            })
        ],
      );
    });
  }*/

  Widget titleImageListener() {
    return _pickTitleImage.listenChangesInUI((context, List<File>? files) {
      Widget currentWidget = Container();
      File? file = files?.isNotEmpty == true ? files![0] : null;

      if (titleImageURL.isNotEmpty) {
        currentWidget = GestureDetector(
          onTap: () {
            UiUtils.showFullScreenImage(context,
                provider: NetworkImage(titleImageURL));
          },
          child: Container(
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(5),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: UiUtils.getImage(
              titleImageURL,
              fit: BoxFit.cover,
            ),
          ),
        );
      }

      if (file != null) {
        currentWidget = GestureDetector(
          onTap: () {
            UiUtils.showFullScreenImage(context, provider: FileImage(file));
          },
          child: Column(
            children: [
              Container(
                width: 100,
                height: 100,
                margin: const EdgeInsets.all(5),
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Image.file(
                  file,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        );
      }

      return Wrap(
        children: [
          if (file == null && titleImageURL.isEmpty)
            _AddImages(
              mainTitle: "addMainPicture".translate(context),
              dimensionsText: "mainImageDimensions".translate(context),
              onTapAdd: () {
                showImageSourceDialog(
                  context,
                  (source) {
                    _pickTitleImage.resumeSubscription();
                    _pickTitleImage.pick(
                      pickMultiple: false,
                      context: context,
                      source: source,
                    );
                    _pickTitleImage.pauseSubscription();
                    titleImageURL = "";
                    setState(() {});
                  },
                );
              },
            ),
          Stack(
            children: [
              currentWidget,
              closeButton(context, () {
                _pickTitleImage.clearImage();
                titleImageURL = "";
                setState(() {});
              })
            ],
          ),
          if (file != null || titleImageURL.isNotEmpty)
            uploadPhotoCard(context, onTap: () {
              showImageSourceDialog(context, (source) {
                _pickTitleImage.resumeSubscription();
                _pickTitleImage.pick(
                  pickMultiple: false,
                  context: context,
                  source: source,
                );
                _pickTitleImage.pauseSubscription();
                titleImageURL = "";
                setState(() {});
              });
            })
        ],
      );
    });
  }

  Widget itemImagesListener() {
    return itemImagePicker.listenChangesInUI((context, files) {
      Widget current = Container();

      current = Wrap(
        children: List.generate(mixedItemImageList.length, (index) {
          final image = mixedItemImageList[index];
          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  HelperUtils.unfocus();
                  if (image is String) {
                    UiUtils.showFullScreenImage(context,
                        provider: NetworkImage(image));
                  } else {
                    UiUtils.showFullScreenImage(context,
                        provider: FileImage(image));
                  }
                },
                child: Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.all(5),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ImageAdapter(image: image),
                ),
              ),
              closeButton(context, () {
                if (image is String) {
                  deleteItemImageList.add(item!.galleryImages![index].id!);
                }

                mixedItemImageList.removeAt(index);
                setState(() {});
              }),
            ],
          );
        }),
      );

      return Wrap(
        runAlignment: WrapAlignment.start,
        children: [
          if ((files == null || files.isEmpty) || mixedItemImageList.isEmpty)
            _AddImages(
              mainTitle: "addOtherPicture".translate(context),
              dimensionsText: "otherImagesDimensions".translate(context),
              onTapAdd: () {
                showImageSourceDialog(
                  context,
                  (source) {
                    itemImagePicker.pick(
                        pickMultiple: source == ImageSource.gallery,
                        context: context,
                        imageLimit: 5,
                        maxLength: mixedItemImageList.length,
                        source: source);
                  },
                );
              },
            ),
          current,
          if (mixedItemImageList.length < 5)
            if ((files != null && files.isNotEmpty) &&
                mixedItemImageList.isNotEmpty)
              uploadPhotoCard(context, onTap: () {
                showImageSourceDialog(context, (source) {
                  itemImagePicker.pick(
                      pickMultiple: source == ImageSource.gallery,
                      context: context,
                      imageLimit: 5,
                      maxLength: mixedItemImageList.length,
                      source: source);
                });
              })
        ],
      );
    });
  }

  /* Widget itemImagesListener() {
    return itemImagePicker.listenChangesInUI((context, file) {
      Widget current = Container();

      current = Wrap(
        children: List.generate(mixedItemImageList.length, (index) {
          final image = mixedItemImageList[index];
          return Stack(
            children: [
              GestureDetector(
                onTap: () {
                  HelperUtils.unfocus();
                  if (image is String) {
                    UiUtils.showFullScreenImage(context,
                        provider: NetworkImage(image));
                  } else {
                    UiUtils.showFullScreenImage(context,
                        provider: FileImage(image));
                  }
                },
                child: Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.all(5),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ImageAdapter(image: image),
                ),
              ),
              closeButton(context, () {
                print("image is string***${image is String}");
                if (image is String) {
                  deleteItemImageList.add(item!.galleryImages![index].id!);
                }

                mixedItemImageList.removeAt(index);
                setState(() {});
              }),
            ],
          );
        }),
      );

      return Wrap(
        runAlignment: WrapAlignment.start,
        children: [
          if (file == null && mixedItemImageList.isEmpty)
            DottedBorder(
              color: context.color.textLightColor,
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              child: GestureDetector(
                onTap: () {
                  //showImageSourceDialog(context, (source) {
                  itemImagePicker.pick(
                      pickMultiple: true,
                      context: context,
                      imageLimit: 5,
                      maxLength: mixedItemImageList.length,
                      source: ImageSource.gallery);
                  //});
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  alignment: AlignmentDirectional.center,
                  height: 48.rh(context),
                  child: Text("addOtherPicture".translate(context),
                      style: TextStyle(
                          color: context.color.textDefaultColor,
                          fontSize: context.font.large)),
                ),
              ),
            ),
          current,
          if (mixedItemImageList.length < 5)
            if (file != null || titleImageURL != "")
              uploadPhotoCard(context, onTap: () {
                //showImageSourceDialog(context, (source) {
                itemImagePicker.pick(
                    pickMultiple: true,
                    context: context,
                    imageLimit: 5,
                    maxLength: mixedItemImageList.length,
                    source: ImageSource.gallery);
                //});
              })
        ],
      );
    });
  }*/

  Widget closeButton(BuildContext context, Function onTap) {
    return PositionedDirectional(
      top: 6,
      end: 6,
      child: GestureDetector(
        onTap: () {
          onTap.call();
        },
        child: Container(
          decoration: BoxDecoration(
              color: context.color.primaryColor.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10)),
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(
              Icons.close,
              size: 24,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget uploadPhotoCard(BuildContext context, {required Function onTap}) {
    return GestureDetector(
      onTap: () {
        onTap.call();
      },
      child: Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.all(5),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: DottedBorder(
            color: context.color.textColorDark.withOpacity(0.5),
            borderType: BorderType.RRect,
            radius: const Radius.circular(10),
            child: Container(
              alignment: AlignmentDirectional.center,
              child: Text("uploadPhoto".translate(context)),
            )),
      ),
    );
  }
}

class _AddImages extends StatelessWidget {
  const _AddImages({
    required this.mainTitle,
    required this.dimensionsText,
    required this.onTapAdd,
  });
  final String mainTitle;
  final String dimensionsText;
  final void Function() onTapAdd;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: DottedBorder(
        color: context.color.borderColor.darken(60),
        padding: EdgeInsets.zero,
        borderType: BorderType.RRect,
        radius: const Radius.circular(5),
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: onTapAdd,
          child: Container(
            height: 181,
            width: double.maxFinite,
            constraints: const BoxConstraints(maxWidth: 390),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UiUtils.getSvg(AppIcons.addImagesIcon),
                GestureDetector(
                  onTap: onTapAdd,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: context.color.territoryColor),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      mainTitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: context.font.small),
                    ),
                  ),
                ),
                Flexible(
                  child: Text(
                    "${"maximumImageSizeExtensions".translate(context)}\n$dimensionsText",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: context.font.small),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AlmostHereWidget extends StatelessWidget {
  const _AlmostHereWidget({
    required this.breadCrumbItems,
    required this.onTapCat,
  });

  final List<CategoryModel>? breadCrumbItems;
  final void Function(int) onTapCat;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: context.screenWidth,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              bool isNotLast = (breadCrumbItems!.length - 1) != index;

              return Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (breadCrumbItems![index].url != null)
                    Container(
                      height: 50,
                      width: 50,
                      clipBehavior: Clip.antiAlias,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: context.color.borderColor,
                          width: 1,
                        ),
                        color: const Color(0x7FFDCCCC),
                      ),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: UiUtils.imageType(
                              breadCrumbItems![index].url!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: () => onTapCat(index),
                    child: Text(breadCrumbItems![index].name!)
                        .firstUpperCaseWidget()
                        .color(
                          isNotLast
                              ? context.color.textColorDark
                              : context.color.territoryColor,
                        ),
                  ),
                  if (index < breadCrumbItems!.length - 1)
                    const Text(" > ").color(context.color.territoryColor),

                  /*InkWell(
                                      onTap: () {
                                        _onBreadCrumbItemTap(index);
                                      },
                                      child: Text(widget
                                              .breadCrumbItems[index].name)
                                          .firstUpperCaseWidget()
                                          .color(
                                            isNotLast
                                                ? context.color.teritoryColor
                                                : context.color.textColorDark,
                                          ),
                                    ),
                
                                    ///if it is not last
                                    if (isNotLast)
                                      const Text(" > ")
                                          .color(context.color.teritoryColor)*/
                ],
              );
            },
            itemCount: breadCrumbItems!.length),
      ),
    );
  }
}

final Map<String, String> slugLetter = {
  'ٱ': 'a',
  'ا': 'a',
  'ب': 'b',
  'ت': 't',
  'ث': 'th',
  'ج': 'j',
  'ح': 'h',
  'خ': 'kh',
  'د': 'd',
  'ذ': 'dh',
  'ر': 'r',
  'ز': 'z',
  'س': 's',
  'ش': 'sh',
  'ص': 's',
  'ض': 'd',
  'ط': 't',
  'ظ': 'z',
  'ع': 'a',
  'غ': 'gh',
  'ف': 'f',
  'ق': 'q',
  'ك': 'k',
  'ل': 'l',
  'م': 'm',
  'ن': 'n',
  'ه': 'h',
  'و': 'w',
  'ي': 'y',
  'ة': 'h',
  'ى': 'a',
  'آ': 'aa',
  'إ': 'i',
  'أ': 'a',
  'ؤ': 'w',
  'ئ': 'y',
  'ء': "a",
  'ـ': '-',
  'َ': 'a',
  'ُ': 'u',
  'ِ': 'i',
  'ّ': '',
  'ً': 'an',
  'ٌ': 'un',
  'ٍ': 'in',
  'ٓ': 'a',
  '٠': '0',
  '١': '1',
  '٢': '2',
  '٣': '3',
  '٤': '4',
  '٥': '5',
  '٦': '6',
  '٧': '7',
  '٨': '8',
  '٩': '9',
  'a': 'a',
  'b': 'b',
  'c': 'c',
  'd': 'd',
  'e': 'e',
  'f': 'f',
  'g': 'g',
  'h': 'h',
  'i': 'i',
  'j': 'j',
  'k': 'k',
  'l': 'l',
  'm': 'm',
  'n': 'n',
  'o': 'o',
  'p': 'p',
  'q': 'q',
  'r': 'r',
  's': 's',
  't': 't',
  'u': 'u',
  'v': 'v',
  'w': 'w',
  'x': 'x',
  'y': 'y',
  'z': 'z',
  '0': '0',
  '1': '1',
  '2': '2',
  '3': '3',
  '4': '4',
  '5': '5',
  '6': '6',
  '7': '7',
  '8': '8',
  '9': '9',
  ' ': '-',
};
