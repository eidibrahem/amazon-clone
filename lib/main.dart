import 'package:amazon_clone/features/admin/screens/admin_layout.dart';
import 'package:amazon_clone/shard/cubit/cubit.dart';
import 'package:amazon_clone/shard/cubit/stats.dart';
import 'package:amazon_clone/shard/network/local/cache_helper.dart';
import 'package:amazon_clone/shard/network/remot/dio_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/home/screens/home_layout.dart';
import 'shard/admin_cubit/cubit.dart';
import 'shard/constants/global_variables.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => AmazonCubit()..getUserData(inStart: true)..fetchDealOfDay()),
        BlocProvider(create: (BuildContext context) => AdminCubit()..fetchAllProduct()),
      ],
      child: BlocConsumer<AmazonCubit, AmazonStates>(
          listener: (context, state) {},
          builder: (context, state) {
            bool isToken = AmazonCubit.get(context).isToken();
            var token = CacheHelper.getData1(key: 'token');
            print("ttttt${isToken}${token}");

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                scaffoldBackgroundColor: GlobalVariables.backgroundColor,
                colorScheme: const ColorScheme.light(
                  primary: GlobalVariables.secondaryColor,
                ),
                appBarTheme: const AppBarTheme(
                  elevation: 0,
                  iconTheme: IconThemeData(color: Colors.black),
                ),
              ),
              home: AmazonCubit.get(context).isToken()
                  ? (AmazonCubit.get(context).userModel?.data?.type != 'user'
                      ? AdminLayout() //HomeLayout(AmazonCubit.get(context).getToken())
                      : HomeLayout(AmazonCubit.get(context).getToken())
                      )
                  : AuthScreen(),
            );
          }),
    );
  }
}
