// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import 'appState.dart';

class DataBaseCubit extends Cubit<DatabaseStates> {
  DataBaseCubit() : super(DatabaseInitialState());

  static DataBaseCubit get(context) => BlocProvider.of(context);

  late Database database;
  List<Map> cart = [];
  int quantity = 0;
  Map<int, int> counter = {};
  Map<int, bool> isexist = {};
  void createDb() {
    openDatabase('cart.db', version: 1, onCreate: (database, version) {
      database
          .execute(
              'CREATE TABLE cart (id INTEGER PRIMARY KEY , productId INTEGER, productNameEn TEXT , productNameAr TEXT , productDescEn TEXT , productDescAr TEXT , productPrice INTEGER , productQty INTEGER , productImg TEXT , sizeId INTEGER , colorId INTEGER , colorOption INTEGER , sizeOption INTEGER)')
          .then((value) {})
          .catchError((error) {});
    }, onOpen: (database) {
      getfromDataBase(database);
    }).then((value) {
      database = value;
      print("database created successfully -------------------------------");
      emit(CreatedatabaseState());
    });
  }
/////////////////////////////////////////////////////////////////////////

  getfromDataBase(database) {
    emit(LoadingDatafromDatabase());
    database.rawQuery('SELECT * FROM cart').then(
      (value) {
        cart = value;

        for (var element in value) {
          counter[element['productId']] = element['productQty'];
          isexist[element['productId']] = true;
        }
        for (var element in value) {
          quantity = quantity + (int.parse(element['productQty'].toString()));
        }
        emit(GetdatabaseState());
      },
    );
  }

////////////////////////////////////////////////////////////////////////////////////////////
  updateDatabase({required int productId, required int productQty}) {
    database.rawUpdate('UPDATE cart SET productQty = ? WHERE productId = ?',
        ['$productQty', '$productId']).then((value) {
      emit(UpdateDatafromDatabase());
      getfromDataBase(database);
      emit(GetdatabaseState());
      print("item updated successfulllllllllly");
    }).catchError((error) {
      print("error updating dataaaaaaaaaaaaaaaaaaaa" + error.toString());
    });
  }

///////////////////////////////////////////////////////////////////////////////////////////

  deletaFromDB({required int id}) {
    database.rawDelete('DELETE FROM cart WHERE productId = ?', ['$id']).then(
        (value) {
      getfromDataBase(database);
      isexist[id] = false;
      emit(DeletedatabaseState());
      print("item daleted successfulllllllllly");
    }).catchError((error) {
      print("error deleteing dataaaaaaaaaaaaaaaaaaaa" + error.toString());
    });
  }

////////////////////////////////////////////////////////////////////////////////////////////

  void inserttoDatabase({
    required int productId,
    required String productNameEn,
    required String productNameAr,
    required String productDescEn,
    required String productDescAr,
    required int productQty,
    required var productPrice,
    required String productImg,
    required int sizeId,
    required int colorId,
    required int colorOption,
    required int sizeOption,
  }) async {
    database.transaction((txn) async {
      txn
          .rawInsert(
              'INSERT INTO cart( productId ,  productNameEn , productNameAr , productDescEn , productDescAr , productPrice , productQty , productImg, sizeId , colorId, colorOption , sizeOption) VALUES("$productId", "$productNameEn", "$productNameAr" ,"$productDescEn", "$productDescAr","$productPrice", "$productQty", "$productImg", "$sizeId", "$colorId","$colorOption", "$sizeOption")')
          .then((value) {
        emit(InsertdatabaseState());

        for (var element in cart) {
          quantity = quantity + (int.parse(element['productQty'].toString()));
          counter[element['productId']] = quantity;
          isexist[element['productId']] = true;
          emit(TotalQuantityState());
        }
        getfromDataBase(database);
        print("item addedd successfulllllllllly");
        emit(GetdatabaseState());
      }).catchError((error) {
        print("error inserting dataaaaaaaaaaaaaaaaaaaa" + error.toString());
      });
      return null;
    });
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////

  deleteTableContent() {
    database.delete("cart").then((value) {
      cart = [];
      quantity = 0;
      counter = {};
      isexist = {};
      emit(DeleteTablecontentDatabase());
      print("table content deleted successfulllllllllly");
    }).catchError((error) {
      print("error deletind table content" + error.toString());
    });
  }
}
