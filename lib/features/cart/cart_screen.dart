import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/widget/widget.dart';
import '../../constants/global_variables.dart';
import '../../shard/cubit/cubit.dart';
import '../../shard/cubit/stats.dart';
import '../address/address_screen.dart';
import '../auth/serveses/serveses.dart';
import '../home/screens/home_screen.dart';
import '../search/search_screen.dart';

class CartScreen extends StatelessWidget {
  var searchController = TextEditingController();
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
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          height: 42,
                          margin: const EdgeInsets.only(left: 15),
                          child: Material(
                            borderRadius: BorderRadius.circular(7),
                            elevation: 1,
                            child: TextFormField(
                              controller: searchController,
                              onFieldSubmitted: ((value) {
                                navigatTo(context,
                                    SearchScreen(searchController.text));
                                cubit.fetchSearchProduct(
                                    search: searchController.text);
                              }),
                              decoration: InputDecoration(
                                  prefixIcon: InkWell(
                                    onTap: () {},
                                    child: const Padding(
                                      padding: EdgeInsets.only(left: 6),
                                      child: Icon(Icons.search,
                                          color: Colors.black, size: 23),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding:
                                      const EdgeInsets.only(top: 10),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(7),
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(7),
                                    ),
                                    borderSide: BorderSide(
                                      color: Colors.black38,
                                      width: 1,
                                    ),
                                  ),
                                  hintText: "Search Amazon.in",
                                  hintStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17,
                                  )),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.transparent,
                        height: 42,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        child: const Icon(
                          Icons.mic,
                          color: Colors.black,
                          size: 25,
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
              child: Column(
                children: [
                  AdderssBox(name: "Eid", address: ""),
                  const SizedBox(height: 5),
                  Container(
                    margin: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        const Text(
                          "Subtotal ",
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "\$${cubit.sum} ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: defaultTextButton(
                      onPress: () {
                        navigatTo(context, AddressScreen());
                      },
                      text:
                          'Proceed Buy (${cubit.userModel?.data!.cart!.cart!.length} items )',
                      color: Colors.yellow[600],
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    color: Colors.black12.withOpacity(.08),
                    height: 1,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cubit.userModel?.data!.cart!.cart!.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          //productData.images![0],
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            height: 140,
                            child: Row(children: [
                              Image.network(
                                (cubit.userModel?.data!.cart!.cart![index]
                                        .product!.images![0])
                                    .toString(),
                                fit: BoxFit.contain,
                                width: 135,
                                height: 135,
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
                                        (cubit.userModel?.data!.cart!.cart![index]
                                                .product!.name)
                                            .toString(),
                                        style: TextStyle(fontSize: 16),
                                        maxLines: 2,
                                      ),
                                    ),
                                    Container(
                                      width: 235,
                                      padding:
                                          const EdgeInsets.only(top: 5, left: 10),
                                      child: Stars(
                                          rating: (cubit
                                                  .userModel
                                                  ?.data!
                                                  .cart!
                                                  .cart![index]
                                                  .product!
                                                  .rating
                                                  .avargeRate)!
                                              .toDouble()),
                                    ),
                                    Container(
                                      width: 235,
                                      padding:
                                          const EdgeInsets.only(top: 5, left: 10),
                                      child: Text(
                                        "\$${cubit.userModel?.data!.cart!.cart![index].product!.price}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                      ),
                                    ),
                                    Container(
                                      width: 235,
                                      padding:
                                          const EdgeInsets.only(top: 5, left: 10),
                                      child: const Text(
                                          "Eligible for Free Shipping "),
                                    ),
                                    Container(
                                      width: 235,
                                      padding:
                                          const EdgeInsets.only(top: 5, left: 10),
                                      child: Text(
                                        "In Stock",
                                        style: TextStyle(color: Colors.teal),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ]),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black12, width: 1.5),
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.black12,
                                  ),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          cubit.removeFromCart(
                                              product: cubit.userModel?.data!
                                                  .cart!.cart![index].product);
                                     
                                        },
                                        child: Container(
                                          height: 32,
                                          width: 35,
                                          child: Icon(
                                            Icons.remove,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.black12,
                                                width: 1.5),
                                            color: Colors.white),
                                        child: Container(
                                            height: 32,
                                            width: 35,
                                            child: Center(
                                              child: Text(
                                                  "${cubit.userModel?.data!.cart!.cart![index].quantity}"),
                                            )),
                                      ),
                                      InkWell(
                                        onTap: () {
                                         
                                          cubit.addToCart(
                                              product: cubit.userModel?.data!
                                                  .cart!.cart![index].product);
                                        },
                                        child: Container(
                                          height: 32,
                                          width: 35,
                                          child: const Icon(
                                            Icons.add,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 5)
                ],
              ),
            ),
          );
        });
  }
}

Widget CarSubtotal() {
  return Container(
    margin: const EdgeInsets.all(10.0),
    child: Row(
      children: [
        const Text(
          "Subtotal ",
          style: TextStyle(fontSize: 20),
        ),
      ],
    ),
  );
}
