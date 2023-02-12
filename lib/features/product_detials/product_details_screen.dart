import 'package:amazon_clone/models/product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../shard/common/widget/widget.dart';
import '../../../shard/constants/global_variables.dart';
import '../../shard/cubit/cubit.dart';
import '../../shard/cubit/stats.dart';
import '../auth/serveses/serveses.dart';
import '../search/search_screen.dart';

class ProductDetailsScreen extends StatelessWidget {
  ProductDetailsScreen({
    this.productData,
  });
  final Product? productData;

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
                              navigatTo(
                                  context, SearchScreen(searchController.text));
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
                                contentPadding: const EdgeInsets.only(top: 10),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        productData!.toString(),
                      ),
                      Stars(
                          rating: productData!.rating.avargeRate == null
                              ? 2
                              : productData!.rating.avargeRate.toDouble()),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  child: Text(
                    productData!.name.toString(),
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
                CarouselSlider(
                  items: productData!.images!.map((i) {
                    return Builder(
                      builder: (context) => Image.network(
                        i,
                        fit: BoxFit.contain,
                        height: 200,
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(viewportFraction: 1, height: 300),
                ),
                Container(
                  height: 5,
                  color: Colors.black12,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                        text: "Deal Price: ",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: "\$${productData!.price} ",
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "${productData!.description.toString()}  product quantity :  ${productData!.quantity}"),
                ),
                Container(
                  height: 5,
                  color: Colors.black12,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: defaultTextButton(onPress: () {}, text: 'Buy Now'),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: defaultTextButton(
                      color: const Color.fromRGBO(254, 216, 19, 1),
                      onPress: () {
                        cubit.addToCart(product: productData);
                      },
                      text: 'Add to Cart'),
                ),
                Container(
                  height: 5,
                  color: Colors.black12,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Rate The Product",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                RatingBar.builder(
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: GlobalVariables.secondaryColor,
                  ),
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  initialRating: cubit.findRating(product: productData),
                  minRating: 1,
                  onRatingUpdate: (rate) {
                    cubit.rateProduct(
                      context: context,
                      product: productData,
                      rating: rate,
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
