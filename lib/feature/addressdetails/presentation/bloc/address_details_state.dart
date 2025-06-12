// ignore_for_file: public_member_api_docs, sort_constructors_first
part of './address_details_bloc.dart';

enum SaveStatus { init, success, failure }

class AddressDetailsState extends Equatable {
  final List<Lov>? lovList;
  final List<GeographyMaster>? stateCityMaster;
  final AddressData? addressData;
  final SaveStatus? status;

  AddressDetailsState({
    required this.addressData,
    required this.lovList,
    required this.stateCityMaster,
    required this.status,
  });

  factory AddressDetailsState.init() => AddressDetailsState(
    addressData: null,
    status: SaveStatus.init,
    lovList: [],
    stateCityMaster: [],
  );

  @override
  List<Object?> get props => [lovList, addressData, status, stateCityMaster];

  AddressDetailsState copyWith({
    List<Lov>? lovList,
    AddressData? addressData,
    SaveStatus? status,
    List<GeographyMaster>? stateCityMaster,
  }) {
    return AddressDetailsState(
      lovList: lovList ?? this.lovList,
      addressData: addressData ?? this.addressData,
      status: status ?? this.status,
      stateCityMaster: stateCityMaster ?? this.stateCityMaster,
    );
  }
}
