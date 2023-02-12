import 'package:amazon_clone/features/account/screens/account_screen.dart';
import 'package:amazon_clone/features/auth/serveses/serveses.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shard/admin_cubit/cubit.dart';
import '../../../shard/admin_cubit/states.dart';
import 'add_product_screen.dart';
class PostsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cubit = AdminCubit.get(context);
    return BlocConsumer<AdminCubit, AdminStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
            condition: cubit.productList != null,
            builder: (context) => Scaffold(
                  body: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: cubit.productList!.length,
                    itemBuilder: (context, index) {
                      final Product productData = cubit.productList![index];
                      return Column(
                        children: [
                          SizedBox(
                              height: 132,
                              child: SingleProduct(
                                productData.images![0],
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                productData.name.toString(),
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                              ),
                              IconButton(
                                onPressed: () {
                                  cubit.deletProduct(id: productData.id,index: index);
                                },
                                icon: const Icon(Icons.delete_outline,),
                              )
                            ],
                          )
                        ],
                      );
                    },
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: FloatingActionButton(
                    onPressed: () {
                      AdminCubit.get(context).fetchAllProduct();
                      navigatTo(context, AddProductScreen());
                    },
                    tooltip: 'add Product',
                    child: const Icon(Icons.add,),
                  ),
                ),
            fallback: (context) => const Center(child:  CircularProgressIndicator()));
      },
    );
  }
}
