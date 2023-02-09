import 'package:amazon_clone/common/widget/widget.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../constants/global_variables.dart';
import '../../models/order.dart';
import '../../shard/admin_cubit/cubit.dart';
import '../../shard/admin_cubit/states.dart';
import '../../shard/cubit/cubit.dart';
import 'package:flutter/material.dart';

import '../auth/serveses/serveses.dart';
import '../search/search_screen.dart';

class OrderDetailsAdminScreen extends StatelessWidget {
  OrderDetailsAdminScreen({
    required this.orderData,
    required this.index,
  });
  int? index;
  final Order? orderData;
  var searchController = TextEditingController();
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AdminCubit.get(context);
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: AppBar(
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Image.asset(
                          "assets/images/amazon_in.png",
                          width: 120,
                          height: 45,
                          color: Colors.black,
                        ),
                      ),
                      const Text(
                        'Admin',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ]),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Veiw order detials",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Order Date :   ${DateFormat().format(
                            DateTime.fromMillisecondsSinceEpoch(
                              orderData!.orderdAt!.toInt(),
                            ),
                          )}"),
                          Text("Order Id :       ${orderData!.id!}"),
                          Text("Order Id :      \$${orderData!.totalPrice}"),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Purchase Detials",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for (int i = 0; i < orderData!.orders!.length; i++)
                            Row(
                              children: [
                                Image.network(
                                  orderData!.orders![i].product!.images![0],
                                  fit: BoxFit.contain,
                                  width: 120,
                                  height: 120,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 235,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: Text(
                                          (orderData!.orders![i].product!.name)
                                              .toString(),
                                          style: TextStyle(fontSize: 17),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        width: 235,
                                        padding: const EdgeInsets.only(
                                            top: 5, left: 10),
                                        child: Text(
                                            "Qty ${orderData!.orders![i].quantity}"),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Tracking",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                        ),
                        child: Stepper(
                          currentStep: orderData!.status != null
                              ?orderData!.status!>3? 3: orderData!.status!.toInt()
                              : 0,
                          controlsBuilder: (context, details) {
                             if(orderData!.status! <4) {
                               return ConditionalBuilder(
                              fallback: (context) => const Center(
                                  child: CircularProgressIndicator()),
                              condition: state is! ChangeOrdersStatusLoudingState ,
                                 
                              builder: (context) => defaultTextButton(
                                onPress: () {
                                 
                                  cubit.changeOrderStatus(
                                      index: index,
                                      id: orderData!
                                      .id,
                                      status: orderData!.status! + 1);
                               
                                },
                                text: 'Done',
                              ),
                            );
                             }else{
                              return SizedBox();
                             }
                          
                          },
                          steps: [
                            Step(
                              title: const Text('Pending'),
                              content: const Text(
                                  'Your order is yet to be delivered'),
                              isActive:  orderData!.status! > 0,
                              state: orderData!.status! > 0
                                  ? StepState.complete
                                  : StepState.indexed,
                            ),
                            Step(
                              title: const Text('Completed'),
                              content: const Text(
                                  'Your order has been delivered , you are yet to sign.'),
                              isActive: orderData!.status! > 1,
                              state: orderData!.status! > 1
                                  ? StepState.complete
                                  : StepState.indexed,
                            ),
                            Step(
                              title: const Text('Received'),
                              content: const Text(
                                  'Your order has been delivered and signed by you '),
                              isActive: orderData!.status! > 2,
                              state: orderData!.status! > 2
                                  ? StepState.complete
                                  : StepState.indexed,
                            ),
                            Step(
                              title: const Text('Delivered'),
                              content: const Text(
                                  'Your order has been delivered and signed by you !'),
                              isActive: orderData!.status! > 3,
                              state: orderData!.status! > 3
                                  ? StepState.complete
                                  : StepState.indexed,
                            ),
                          ],
                        )),
                  ]),
            )),
          );
        });
  }
}
