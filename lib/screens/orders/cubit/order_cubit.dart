// ignore_for_file: avoid_print, body_might_complete_normally_nullable
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../componnent/http_services.dart';
import '../model/all_orders.dart';
import '../model/single_order.dart';
part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());

  static OrderCubit get(context) => BlocProvider.of(context);

  AllOrdersModel? allOrdersModel;

  Future<AllOrdersModel?> getAllorders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    emit(AllOrdersLoadingState());
    try {
      var response = await http.post(Uri.parse(EndPoints.All_ORDERS),
          headers: {'auth-token': preferences.getString('token').toString()});
      var data = jsonDecode(response.body);
      print(preferences.getString('token').toString());
      if (data['status'] == 1) {
        allOrdersModel = AllOrdersModel.fromJson(data);
        emit(AllOrdersSuccessState());
        return allOrdersModel;
      } else if (data['status'] == 0) {
        allOrdersModel = AllOrdersModel.fromJson(data);
        emit(AllOrdersSuccessState());
        return allOrdersModel;
      }
    } catch (error) {
      emit(AllOrdersErrorState(error.toString()));
      print("order arror : " + error.toString());
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////

  SingleOrderModel? singleOrderModel;
  Future<SingleOrderModel?> getSingleOrder({required String orderId}) async {
    emit(SingleOrdersLoadingState());
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String token = preferences.getString('token').toString();
    try {
      Map<String, dynamic> body = {
        'id': orderId,
      };
      var response = await http.post(Uri.parse(EndPoints.SINGLE_ORDERS),
          body: body, headers: {'auth-token': token});
      var data = jsonDecode(response.body);
      print('getSingleOrder  $data');
      if (data['status'] == 1) {
        singleOrderModel = SingleOrderModel.fromJson(data);
        emit(SingleOrdersSuccessState());
        return singleOrderModel;
      }
    } catch (error) {
      emit(SingleOrdersErrorState(error.toString()));
      print("single order error : " + error.toString());
    }
  }

/////////////////////////////////////////////////////////////////////////////////////////////

  void cashOrder({required String orderId}) async {
    emit(CashOrdersLoadingState());
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String token = preferences.getString('token').toString();
    try {
      Map<String, dynamic> body = {
        'order_id': orderId,
        'fcm_token': await FirebaseMessaging.instance.getToken(),
      };
      print(1);
      print(orderId);
      var response = await http.post(Uri.parse(EndPoints.CASH_ORDER),
          body: body, headers: {'auth-token': token});
      print(2);
      print(response.body);
      var data = jsonDecode(response.body);
      print(3);
      print('cashOrder  $data');
      if (data['status'] == 1) {
        print(4);
        emit(CashOrdersSuccessState());
      }
    } catch (error) {
      emit(CashOrdersErrorState(error.toString()));
      print("CASH order error : $error");
    }
  }
}
