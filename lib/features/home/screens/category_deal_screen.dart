import 'package:amazon_clone/features/auth/serveses/serveses.dart';
import 'package:amazon_clone/features/product_detials/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/global_variables.dart';
import '../../../models/product.dart';
import '../../../shard/cubit/cubit.dart';
import '../../../shard/cubit/stats.dart';
import '../../account/screens/account_screen.dart';

class CategoryDealeScreen extends StatelessWidget {
  CategoryDealeScreen({this.category});
  final String? category;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AmazonCubit, AmazonStates>(
      listener: (context, state) {},
      builder: (context, state) {
        //  AmazonCubit.get(context).fetchAllProduct(category:category,newProduct: true );
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: AppBar(
              title: Text(
                category.toString(),
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: GlobalVariables.appBarGradient,
                ),
              ),
            ),
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                alignment: Alignment.topLeft,
                child: Text(
                  'Keep shopping for ${category}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 170,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 15),
                  physics: BouncingScrollPhysics(),
                  itemCount:
                      AmazonCubit.get(context).categoryProducsList!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 1.4,
                      crossAxisSpacing: 10),
                  itemBuilder: (context, index) {
                    final Product productData =
                        AmazonCubit.get(context).categoryProducsList![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: GestureDetector(
                        onTap: (){
                          navigatTo(context, ProductDetailsScreen(productData: productData ,));
                        },
                        child: Column(
                          children: [
                            SizedBox(
                                height: 130,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black12,
                                        width: 1.5,
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image.network(
                                      productData.images![0],
                                    ),
                                  ),
                                )),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.only(
                                top: 5,
                                right: 15,
                                left: 0,
                              ),
                              child: Text(
                                productData.name.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
