

import 'package:amazon_clone/constants/global_variables.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shard/cubit/cubit.dart';
import '../../../shard/cubit/stats.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout(this.token, {Key? key}) : super(key: key);
  final String? token;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AmazonCubit, AmazonStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AmazonCubit.get(context);
        var bottomBarWidth = 42;
        var bottomBarBorder = 5;
        return (Scaffold(
          body: AmazonCubit.get(context)
              .screens[AmazonCubit.get(context).currentIndex],
            
          bottomNavigationBar: BottomNavigationBar(
            onTap: ((index) {
              AmazonCubit.get(context).changCurrentIndexe(index);
              if(index==2){
                AmazonCubit.get(context).getUserData();
              }else if(index==1){
              AmazonCubit.get(context).fetchMyOrders();
              }

            }),
            currentIndex: cubit.currentIndex,
            selectedItemColor: GlobalVariables.selectedNavBarColor,
            backgroundColor: GlobalVariables.backgroundColor,
            unselectedItemColor: GlobalVariables.unselectedNavBarColor,
            iconSize: 28,
            items: [
              //home 
              BottomNavigationBarItem(
                  icon: Container(
                    width: bottomBarWidth.toDouble(),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: cubit.currentIndex == 0
                              ? GlobalVariables.selectedNavBarColor
                              : GlobalVariables.backgroundColor,
                          width: bottomBarBorder.toDouble(),
                        ),
                      ),
                    ),
                    child: const Icon(Icons.home_outlined) ,
                  ),
                  label: ''),
                  //Acount
              BottomNavigationBarItem(icon:  Container(
                    width: bottomBarWidth.toDouble(),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: cubit.currentIndex == 1
                              ? GlobalVariables.selectedNavBarColor
                              : GlobalVariables.backgroundColor,
                          width: bottomBarBorder.toDouble(),
                        ),
                      ),
                    ),
                    child:const Icon(Icons.person_outline_outlined) ,
                  ), label: ''),
              BottomNavigationBarItem(icon:  Container(
                    width: bottomBarWidth.toDouble(),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: cubit.currentIndex == 2
                              ? GlobalVariables.selectedNavBarColor
                              : GlobalVariables.backgroundColor,
                          width: bottomBarBorder.toDouble(),
                        ),
                      ),
                    ),
                    child: Badge(
                      elevation: 0,
                      badgeContent:Text("${cubit.userModel?.data?.cart!.cart!.length}") ,
                      badgeColor: Colors.white,
                      child: const Icon(Icons.shopping_cart_outlined)) ,
                  ),
                  label: ''),
            ],
          ),
        ));
      },
    );
  }
}
