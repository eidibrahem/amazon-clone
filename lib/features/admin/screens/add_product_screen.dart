import '../../../shard/constants/global_variables.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../shard/common/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shard/admin_cubit/cubit.dart';
import '../../../shard/admin_cubit/states.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var addProductFormKey = GlobalKey<FormState>();
    var ProductNameController = TextEditingController();
    var discriptionController = TextEditingController();
    var PriceController = TextEditingController();
    var quantityController = TextEditingController();

    return BlocConsumer<AdminCubit, AdminStates>(
      listener: (context, state) {
        if (state is AddProductSeccessState) {
          if (state.res!.status == true) {
            // print(state.userMoDel?.data!.token);|| state is FetchAllProducsSeccessState
            ShowToast(
                text: state.res!.msg.toString(), state: ToastStates.SUCCESS);
          } else {
            ShowToast(
                text: state.res!.msg.toString(), state: ToastStates.ERROR);
          }
        }
        if (state is FetchAllProducsSeccessState) {
          if (state.res!.status == true) {
            // print(state.userMoDel?.data!.token);||
            ShowToast(
                text: state.res!.msg.toString(), state: ToastStates.SUCCESS);
          } else {
            ShowToast(
                text: state.res!.msg.toString(), state: ToastStates.ERROR);
          }
        }
      },
      builder: (context, state) {
        var cubit = AdminCubit.get(context);
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              title: const Text(
                'Add Product',
                style: TextStyle(color: Colors.black),
              ),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: GlobalVariables.appBarGradient,
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: addProductFormKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    cubit.Images.isNotEmpty
                        ? CarouselSlider(
                            items: cubit.Images.map((i) {
                              return Builder(
                                builder: (context) => Image.file(
                                  i,
                                  fit: BoxFit.cover,
                                  height: 200,
                                ),
                              );
                            }).toList(),
                            options: CarouselOptions(
                                viewportFraction: 1, height: 200),
                          )
                        : InkWell(
                            onTap: cubit.slectImages,
                            child: DottedBorder(
                              radius: Radius.circular(10),
                              borderType: BorderType.RRect,
                              dashPattern: [10, 4],
                              strokeCap: StrokeCap.round,
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.folder_outlined,
                                      size: 40,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Sellect Product Images',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(
                      height: 30,
                    ),
                    costomFormField(
                        Controller: ProductNameController,
                        type: TextInputType.name,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'please enter your name ';
                          }
                        },
                        hintText: 'Product Name'),
                    const SizedBox(
                      height: 10,
                    ),
                    costomFormField(
                        Controller: discriptionController,
                        type: TextInputType.name,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'please enter your Discription ';
                          }
                        },
                        maxLines: 7,
                        hintText: 'Discription'),
                    const SizedBox(
                      height: 10,
                    ),
                    costomFormField(
                        Controller: PriceController,
                        type: TextInputType.number,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'please enter your Price ';
                          }
                        },
                        hintText: 'Price'),
                    const SizedBox(
                      height: 10,
                    ),
                    costomFormField(
                        Controller: quantityController,
                        type: TextInputType.number ,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'please enter your Quantity ';
                          }
                        },
                        hintText: 'Quantity'),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: DropdownButton(
                        value: cubit.categoriesValue,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                        ),
                        items: cubit.productsCategories.map((String item) {
                          return DropdownMenuItem(
                            child: Text(item),
                            value: item,
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          cubit.changCatValue(value);
                        },
                      ),
                    ),
                    ConditionalBuilder(
                      condition: state is! AddProducLoudingState,
                      fallback: (context) =>
                          const Center(child: CircularProgressIndicator()),
                      builder: (context) => defaultTextButton(
                          text: 'sell',
                          onPress: () {
                            if (addProductFormKey.currentState!.validate() &&
                                cubit.Images.isNotEmpty) {
                              AdminCubit.get(context).sellProduct(
                                  context: context,
                                  name: ProductNameController.text,
                                  description: discriptionController.text,
                                  price: double.parse(PriceController.text),
                                  quantity:
                                      double.parse(quantityController.text),
                                  category: cubit.categoriesValue);
                            }
                          }),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
