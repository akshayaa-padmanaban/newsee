/* 
@author   : karthick.d  10/06/2025
@desc     : bloc events for saving updating address details page
@param    : 
 */

part of 'address_details_bloc.dart';

abstract class AddressDetailsEvent {}

class AddressDetailsInitEvent extends AddressDetailsEvent {
  final CifResponseModel? cifResponseModel;
  AddressDetailsInitEvent({required this.cifResponseModel});
}

class AddressDetailsSaveEvent extends AddressDetailsEvent {
  final AddressData? addressData;
  AddressDetailsSaveEvent({required this.addressData});
}
