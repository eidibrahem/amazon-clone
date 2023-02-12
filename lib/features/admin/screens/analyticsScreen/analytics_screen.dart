import 'package:amazon_clone/models/sales.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shard/admin_cubit/cubit.dart';
import '../../../../shard/admin_cubit/states.dart';
import 'package:charts_flutter/flutter.dart' as charts;
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminCubit, AdminStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AdminCubit.get(context);
          return ConditionalBuilder(
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
              condition:
                  state is! GetEarningsLoudingState || cubit.sales == null && false,
              builder: (context) => Column(
                    children: [
                      Text('\$${ cubit.totalEarning}',style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      SizedBox(
                        height: 250,
                        child: categoryCharts(seriesList: [
                          charts.Series(id: 'Sales', data: cubit.sales! , domainFn:(Sales sales,_)=>sales.label!.substring(0,4), measureFn: (Sales sales,_)=>sales.earning,  )
                        ]),
                      ),
                    ],
                  ));
        });
  }
}

Widget categoryCharts( 
  {required List<charts.Series<Sales,String>>seriesList }
)=>charts.BarChart(
  seriesList,
  animate: true,

);