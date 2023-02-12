import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pay/pay.dart';

import '../../../shard/common/widget/widget.dart';
import '../../shard/constants/global_variables.dart';
import '../../shard/cubit/cubit.dart';
import '../../shard/cubit/stats.dart';

class AddressScreen extends StatelessWidget {
  
 
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AmazonCubit, AmazonStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AmazonCubit.get(context);
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: AppBar(
                flexibleSpace: Container(
                  decoration: const BoxDecoration(
                    gradient: GlobalVariables.appBarGradient,
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (cubit.userModel!.data!.address!.isNotEmpty )
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${cubit.userModel!.data!.address}".toString(),
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(
                              color: Colors.black12,
                              width: 1.5,
                            )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'OR',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    Form(
                      key:cubit.addressFormKey,
                      child: Column(
                        children: [
                          costomFormField(
                            Controller:cubit.flatBuildingController,
                            type: TextInputType.emailAddress,
                            prefix: Icons.house_sharp,
                            hintText: "flat ,house no, building",
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'please enter your flat or house no ';
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          costomFormField(
                            Controller: cubit.areaController,
                            type: TextInputType.streetAddress,
                            prefix: Icons.area_chart_outlined,
                            hintText: "Area, Street",
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'please enter your Area ';
                              }
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          costomFormField(
                            Controller: cubit.pincodeController,
                            type: TextInputType.visiblePassword,
                            ispass: cubit.ispass,
                            prefix: Icons.pin,
                            hintText: "Pincod",
                            suffix: AmazonCubit.get(context).suffix,
                            suffixpressed: () {
                              AmazonCubit.get(context).changePasssVisibility();
                            },
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'please enter your Pincod';
                              } 
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          costomFormField(
                            Controller: cubit.cityController,
                            type: TextInputType.name,
                            prefix: Icons.texture_rounded ,
                            //  prefix: Icons.lock_outline,
                            hintText: "Town/City",
                          
                            validator: (String? value) {
                              if (value!.isEmpty) {
                                return 'please enter your Town/City';
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    ApplePayButton(
                      paymentConfigurationAsset: 'applepay.json',
                      onPaymentResult: cubit.onGooglePayResult,
                      paymentItems: cubit.paymentItems,
                      style: ApplePayButtonStyle.whiteOutline,
                    ),
                    GooglePayButton(
                      paymentConfigurationAsset: "gpay.json",
                      onPaymentResult: cubit.onGooglePayResult,
                      paymentItems: cubit.paymentItems,
                      height: 50,

                      onPressed: cubit.paypress,
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 15),
                      loadingIndicator: const Center(child: CircularProgressIndicator()),
                      type: GooglePayButtonType.buy,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
