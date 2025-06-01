abstract class AppCubitStates {}

class AppInitialstates extends AppCubitStates {}

class SelectionColorState extends AppCubitStates {}

class SelectionSizeState extends AppCubitStates {}

class ProfileImageState extends AppCubitStates {}

class SelectionAddressState extends AppCubitStates {}

class HomeitemsLoaedingState extends AppCubitStates {}

class HomeitemsSuccessState extends AppCubitStates {}

class HomeitemsErrorState extends AppCubitStates {
  final String error;
  HomeitemsErrorState(this.error);
}
class CountLoading extends AppCubitStates {}
class CountSuccess extends AppCubitStates {}
class CountError extends AppCubitStates {
  final String message;

  CountError(this.message);
}
class SettingDataLoadingState extends AppCubitStates {}

class SettingDataSuccessState extends AppCubitStates {}

class SettingDataErrorState extends AppCubitStates {
  final String error;

  SettingDataErrorState(this.error);
}

class CheckQuantityLoadingState extends AppCubitStates {}

class CheckQuantitySuccessState extends AppCubitStates {}

class CheckQuantityErrorState extends AppCubitStates {
  final String error;

  CheckQuantityErrorState(this.error);
}

class SingleProductLoaedingState extends AppCubitStates {}

class SingleProductSuccessState extends AppCubitStates {}

class SingleProductErrorState extends AppCubitStates {
  final String error;
  SingleProductErrorState(this.error);
}

class SingleProductColorLoaedingState extends AppCubitStates {}

class SingleProductColorSuccessState extends AppCubitStates {}

class SingleProductColorErrorState extends AppCubitStates {
  final String error;
  SingleProductColorErrorState(this.error);
}
class NotifyLoading extends AppCubitStates {}
class NotifySuccess extends AppCubitStates {}
class NotifyError extends AppCubitStates {
  final String message;

  NotifyError(this.message);
}
class AvailableTimesLoading extends AppCubitStates {}
class AvailableTimesSuccess extends AppCubitStates {}
class AvailableTimesError extends AppCubitStates {
  final String message;

  AvailableTimesError(this.message);
}
class TabbyStatusLoading extends AppCubitStates {}
class TabbyStatusSuccess extends AppCubitStates {}
class TabbyStatusError extends AppCubitStates {
  final String message;

  TabbyStatusError(this.message);
}
