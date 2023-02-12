
import '/../shard/constants/global_variables.dart';
import 'package:amazon_clone/features/order_detials/order_detials_admin_screen.dart';
import 'package:badges/badges.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shard/admin_cubit/cubit.dart';
import '../../../../shard/admin_cubit/states.dart';
import '../../../../shard/cubit/cubit.dart';
import '../../../account/screens/account_screen.dart';
import '../../../auth/serveses/serveses.dart';
import '../../../order_detials/order_detials_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AdminCubit.get(context);
          var bottomBarWidth = 42;
          var bottomBarBorder = 5; 
          return ConditionalBuilder(
            fallback: (context) =>
                        const Center(child: CircularProgressIndicator()),
            condition: state is! FetchAllOrdersLoudingState||AdminCubit.get(context).ordersList==null,
                    builder: (context) => GridView.builder(
                      
               gridDelegate: 
               SliverGridDelegateWithFixedCrossAxisCount( crossAxisCount: 2, ),
                      itemCount: cubit.ordersList!.length,
            
              itemBuilder: (context, index){ 
                return GestureDetector(
                                onTap: (){
                                  navigatTo(context, OrderDetailsAdminScreen(orderData: AdminCubit.get(context).ordersList?[index],index:index));
                                },
                                child: SizedBox(
                                  height: 140 ,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: SingleProduct(
                                        AdminCubit.get(context).ordersList![index].orders![0].product!.images![0]),
                                  ),
                                ),
                              );}
          
              ,),
          );
        });
  }
}

///OrdersScreen.dart