import '../../../shard/constants/global_variables.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shard/admin_cubit/cubit.dart';
import '../../../shard/admin_cubit/states.dart';

class AdminLayout extends StatelessWidget {
  const AdminLayout( {Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AdminCubit.get(context);
        var bottomBarWidth = 42;
        var bottomBarBorder = 5;
        return (Scaffold(
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
                    const Text('Admin',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,),)
                  ]),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: GlobalVariables.appBarGradient,
                ),
              ),
            ),
          ),
          body: AdminCubit.get(context)
              .screens[AdminCubit.get(context).currentIndex],
            
          bottomNavigationBar: BottomNavigationBar(
            onTap: ((index) {
              AdminCubit.get(context).changCurrentIndexe(index);
              if(index==1){
                 AdminCubit.get(context).getEarnings();
              }
              else if(index==2){
              AdminCubit.get(context).fetchAllOrders();
              }
            }),
            currentIndex: cubit.currentIndex,
            selectedItemColor: GlobalVariables.selectedNavBarColor,
            backgroundColor: GlobalVariables.backgroundColor,
            unselectedItemColor: GlobalVariables.unselectedNavBarColor,
            iconSize: 28,
            items: [
              //posts
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
                    child: Badge(
                      elevation: 0,
                      badgeContent: const Text('2'),
                      badgeColor: Colors.white,
                      child: const Icon(Icons.home_outlined)) ,
                  ),
                  label: ''),
                  //analytics
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
                    child:const Icon(Icons.analytics_outlined) ,
                  ), label: ''),
                  //Order
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
                    child: const Icon(Icons.all_inbox_outlined) ,
                  ),label: ''),
            ],
          ),
        ));
      },
    );
  }
}
