// ignore_for_file: file_names

abstract class DatabaseStates {}

class DatabaseInitialState extends DatabaseStates {}

class CreatedatabaseState extends DatabaseStates {}

class InsertdatabaseState extends DatabaseStates {}

class DeletedatabaseState extends DatabaseStates {}

class GetdatabaseState extends DatabaseStates {}

class LoadingDatafromDatabase extends DatabaseStates {}

class UpdateDatafromDatabase extends DatabaseStates {}

class DeleteTablecontentDatabase extends DatabaseStates {}

class TotalPriceIncreaseState extends DatabaseStates {}

class TotalPriceDecreaseState extends DatabaseStates {}

class TotalQuantityState extends DatabaseStates {}
