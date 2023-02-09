import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../constants/global_variables.dart';
import '../../models/product.dart';
import '../../shard/cubit/cubit.dart';
import '../../shard/cubit/stats.dart';
import '../account/screens/account_screen.dart';
import '../auth/serveses/serveses.dart';
import '../home/screens/home_screen.dart';
import '../product_detials/product_details_screen.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen(
    this.text,
  );
  String text;
  var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var cubit = AmazonCubit.get(context);
    return BlocConsumer<AmazonCubit, AmazonStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ConditionalBuilder(
              condition: state is! FetchSearchProducLoudingState,
              builder: (context) => Scaffold(
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
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
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
                  body: Column(
                    children: [
                      AdderssBox(name: "Eid", address: ""),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: cubit.searchProducsList!.length,
                          itemBuilder: (context, index) {
                            final Product productData =
                                cubit.searchProducsList![index];
                            return GestureDetector(
                              onTap: (){
                              
                          navigatTo(context, ProductDetailsScreen(productData: productData,));
                        
                              },
                              child: Column(
                                children: [
                                  //productData.images![0],
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    height: 140,
                                    child: Row(children: [
                                      Image.network(
                                        productData.images![0],
                                        fit: BoxFit.contain,
                                        width: 135,
                                        height: 135,
                                      ),
                                      Column(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 235,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0),
                                            child: Text(
                                              productData.name.toString(),
                                              style: TextStyle(fontSize: 16),
                                              maxLines: 2,
                                            ),
                                          ),
                                          Container(
                                            width: 235,
                                            padding: const EdgeInsets.only(
                                                top: 5, left: 10),
                                            child: Stars(rating: productData.rating.avargeRate ),
                                          ),
                                          Container(
                                            width: 235,
                                            padding: const EdgeInsets.only(
                                                top: 5, left: 10),
                                            child: Text(
                                              "\$${productData.price}",
                                              style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold ),
                                              maxLines: 2,
                                            ),
                                          ),
                                          Container(
                                            width: 235,
                                            padding: const EdgeInsets.only(
                                                top: 5, left: 10),
                                            child:const Text(
                                              "Eligible for Free Shipping "
                                            ),
                                          ),
                                          Container(
                                            width: 235,
                                            padding: const EdgeInsets.only(
                                                top: 5, left: 10),
                                            child: Text(
                                              "In Stock",
                                              style: TextStyle(color: Colors.teal),
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      )
                                    ]),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )),
              fallback: (context) => const Scaffold(
                  body: Center(child: CircularProgressIndicator())));
        });
  }
}

Widget Stars({required double rating}) {
  return RatingBarIndicator(
    direction: Axis.horizontal,
    itemCount: 5,
    rating: rating,
    itemSize: 15,
    itemBuilder: (context, index) => Icon(
      Icons.star,
      color: GlobalVariables.secondaryColor,
    ),
  );
}
