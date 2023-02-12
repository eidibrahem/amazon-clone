import 'package:amazon_clone/features/auth/screens/auth_screen.dart';

import '../../../shard/constants/global_variables.dart';
import 'package:amazon_clone/features/auth/serveses/serveses.dart';
import 'package:amazon_clone/features/order_detials/order_detials_screen.dart';
import 'package:amazon_clone/shard/cubit/cubit.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shard/common/widget/widget.dart';
import '../../../shard/cubit/stats.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
@override
  Widget build(BuildContext context) {
    return BlocConsumer<AmazonCubit, AmazonStates>(
        listener: (context, state) {},
        builder: (context, state) {
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
                        Container(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(right: 15),
                                  child: Icon(Icons.notifications_outlined),
                                ),
                                const Icon(Icons.search),
                              ]),
                        )
                      ]),
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                      gradient: GlobalVariables.appBarGradient,
                    ),
                  ),
                )),
            body: Column(children: [
              appBarBlue(name: AmazonCubit.get(context).getName()),
              const SizedBox(
                height: 10,
              ),
              topBottons(context),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        child: const Text(
                          'Your Orders',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 15),
                        child: const Text(
                          'See all',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  ConditionalBuilder(
                    condition: state is! FetchMyOrdersLoudingState||AmazonCubit.get(context).ordersList==null,
                    builder: (context) => Container(
                      height: 170,
                      padding:
                          const EdgeInsets.only(left: 10, top: 20, right: 0),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: AmazonCubit.get(context).ordersList!.length ,
                          itemBuilder: ((context, index) {
                            return GestureDetector(
                              onTap: (){
                                navigatTo(context, OrderDetailsScreen(orderData: AmazonCubit.get(context).ordersList?[index]));
                              },
                              child: SingleProduct(
                                  AmazonCubit.get(context).ordersList![index].orders![0].product!.images![0]),
                            );
                          }),),
                    ),
                    fallback: (context) =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                ],
              )
            ]),
          );
        });
  }
}

Widget topBottons(context) => Column(
      children: [
        Row(
          children: [
            accountBotton(
              onPressed: () {},
              text: 'Your Order ',
            ),
            accountBotton(
              onPressed: () {},
              text: 'Turn Seller',
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            accountBotton(
              onPressed: () {
                navigatAndFinsh(context, AuthScreen());
              },
              text: 'Log Out',
            ),
            accountBotton(
              onPressed: () {},
              text: 'Your Wish List',
            ),
          ],
        )
      ],
    );

Widget accountBotton({required void Function()? onPressed(), String? text}) =>
    Expanded(
        child: Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      height: 40,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: 0.0,
        ),
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
      ),
      child: OutlinedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            primary: Colors.black12.withOpacity(0.03),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
          child: Text(
            text!,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          )),
    ));
Widget SingleProduct(String image) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black12,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Container(
          width: 180,
          padding: const EdgeInsets.all(10),
          child: Image.network(
            image,
            fit: BoxFit.fitHeight,
            width: 180,
          ),
        ),
      ),
    );
