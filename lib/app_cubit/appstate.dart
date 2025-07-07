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
class GetBrandsLoading extends AppCubitStates {}
class GetBrandsSuccess extends AppCubitStates {}
class GetBrandsError extends AppCubitStates {
  final String message;

  GetBrandsError(this.message);
}
class GetBrandProductsLoading extends AppCubitStates {}
class GetBrandProductsSuccess extends AppCubitStates {}
class GetBrandProductsError extends AppCubitStates {
  final String message;

  GetBrandProductsError(this.message);
}
class GetDiscountBrandProductsLoading extends AppCubitStates {}
class GetDiscountBrandProductsSuccess extends AppCubitStates {}
class GetDiscountBrandProductsError extends AppCubitStates {
  final String message;

  GetDiscountBrandProductsError(this.message);
}
class GetAdsLoading extends AppCubitStates {}
class GetAdsSuccess extends AppCubitStates {}
class GetAdsError extends AppCubitStates {
  final String message;

  GetAdsError(this.message);
}
