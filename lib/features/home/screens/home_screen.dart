// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:amazon_clone/features/auth/serveses/serveses.dart';
import 'package:amazon_clone/features/product_detials/product_details_screen.dart';
import 'package:amazon_clone/features/search/search_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shard/constants/global_variables.dart';
import '../../../shard/cubit/cubit.dart';
import '../../../shard/cubit/stats.dart';
import 'category_deal_screen.dart';

class HomeScreen extends StatelessWidget {
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
                                  hintText: "Search Amazon.eg",
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
                  AdderssBox(name: "Eid", address: "${cubit.userModel!.data!.address}"),
                  const SizedBox(height: 10),
                  /* TopCategories(
                   
                      list: cubit.ImagesCategories), */
                  ////////////////////////////////////////////////////////////////
                  SizedBox(
                    height: 62, //CategoryDealeScreen
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cubit.ImagesCategories.length,
                      physics: BouncingScrollPhysics(),
                      itemExtent: 75,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            navigatTo(
                                context,
                                CategoryDealeScreen(
                                    category: cubit.ImagesCategories[index][
                                        'title']!)); //CategoryDealeScreen(category: list[index]['title']!
                            cubit.fetchAllProduct(
                                newProduct: true,
                                category: cubit.ImagesCategories[index]
                                    ['title']!);
                          },
                          child: Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(
                                    cubit.ImagesCategories[index]['image']!,
                                    fit: BoxFit.cover,
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ),
                              Text(
                                cubit.ImagesCategories[index]['title']!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  ///////////////////////////////////////////////////
                  const SizedBox(height: 10),
                  CarouselSlidert(
                      list: AmazonCubit.get(context).carouselImages),
                  cubit.productDay.images!.length== 0 
                      ? const Center(child: CircularProgressIndicator())
                      : cubit.productDay.name!.isEmpty
                          ? const SizedBox()
                          : GestureDetector(
                              onTap: () {
                                navigatTo(
                                    context,
                                    ProductDetailsScreen(
                                        productData: cubit.productDay));
                              },
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: const EdgeInsets.only(
                                        top: 15, left: 10),
                                    child: const Text(
                                      'Deal of the day',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  Image.network(
                                    cubit.productDay.images![
                                        0], //'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRdkBpK4GnL7VLTWJdlQ2kI4b6OFt2AdOewYg&usqp=CAU',
                                    fit: BoxFit.contain,
                                    height: 235,
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                    ),
                                    child: Text(
                                      '\$ ${cubit.productDay.price}',
                                      style: TextStyle(fontSize: 18),
                                      maxLines: 2,
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: const EdgeInsets.only(
                                      left: 10,
                                      top: 5,
                                      right: 40,
                                    ),
                                    child: Text(
                                      '${cubit.productDay.name}',
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 2,
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: cubit.productDay.images!
                                          .map(
                                            (e) => Image.network(
                                              e, //"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQb8hiP3fjnYQU7IolYQoGmDX37Hot2m6w3Kpmo2u8KvtMINWOyS_PzpSJQFXluqVJVYKM&usqp=CAU",
                                              height: 100,
                                              width: 100,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 15,
                                    ).copyWith(left: 15),
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      'See all deals',
                                      style: TextStyle(
                                        color: Colors.cyan[800],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                ],
              ),
            ),
          );
        });
  }
}

Widget AdderssBox({required String name, String? address}) => Container(
      height: 50,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 114, 226, 221),
          Color.fromARGB(255, 162, 236, 221),
        ], stops: [
          .5,
          1
        ]),
      ),
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 5,
              ),
              // ignore: prefer_const_constructors
              child: Text(
                'Dlivery to ${name} - ${address}',
                style: const TextStyle(
                  overflow: TextOverflow.clip,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 5, top: 5),
            child: Icon(
              Icons.arrow_drop_down_outlined,
              size: 18,
            ),
          )
        ],
      ),
    );
// ignore: non_constant_identifier_names
Widget TopCategories({
  List<Map<String, String>>? list,
}) =>
    SizedBox(
      height: 62, //CategoryDealeScreen
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list!.length,
        physics: BouncingScrollPhysics(),
        itemExtent: 75,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              navigatTo(
                  context,
                  CategoryDealeScreen(
                      category: list[index][
                          'title']!)); //CategoryDealeScreen(category: list[index]['title']!
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      list[index]['image']!,
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
                Text(
                  list[index]['title']!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

Widget CarouselSlidert({required List<String> list}) {
  return CarouselSlider(
    items: list.map((i) {
      return Builder(
        builder: (context) => Image.network(
          i,
          fit: BoxFit.cover,
          height: 200,
        ),
      );
    }).toList(),
    options: CarouselOptions(viewportFraction: 1, height: 200),
  );
}
