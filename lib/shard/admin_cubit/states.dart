import 'package:amazon_clone/models/add_product_res.dart';

abstract class AdminStates {}

class   AdminIntialState extends AdminStates {}

class NavState extends AdminStates {}
class ChangCatValue extends AdminStates {}
//changCatValue
class SlectImagesSeccessState extends AdminStates {}
class SlectImagesErrorState extends AdminStates {}
class AddProducLoudingState extends AdminStates {}
class AddProductSeccessState extends AdminStates {
  final AddProductRes? res;
  AddProductSeccessState(this.res);
}

class AddProductErrorState extends AdminStates {}
class FetchAllProducsLoudingState extends AdminStates {}
class FetchAllProducsSeccessState extends AdminStates {
  final AddProductRes? res;
  FetchAllProducsSeccessState(this.res);
}

class FetchAllProducstErrorState extends AdminStates {}

class DeletProductSeccessState extends AdminStates {}

class DeletProductErrorState extends AdminStates {}
class FetchAllOrdersLoudingState extends AdminStates {}
class FetchAllOrdersSeccessState extends AdminStates {
  final AddProductRes? res;
  FetchAllOrdersSeccessState(this.res);
}

class FetchAllOrderstErrorState extends AdminStates {}

class ChangeOrdersStatusLoudingState extends AdminStates {}
class ChangeOrdersStatusSeccessState extends AdminStates {
  final AddProductRes? res;
  ChangeOrdersStatusSeccessState(this.res);
}

class ChangeOrdersStatustErrorState extends AdminStates {}
class GetEarningsLoudingState extends AdminStates {}
class GetEarningsSeccessState extends AdminStates {
  final AddProductRes? res;
  GetEarningsSeccessState(this.res);
}

class GetEarningsErrorState extends AdminStates {}
