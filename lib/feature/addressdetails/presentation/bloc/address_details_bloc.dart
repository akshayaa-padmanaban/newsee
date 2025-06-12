/* 
@author   : karthick.d  10/06/2025
@desc     : bloc for saving updating address details page
@param    : 
 */
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/DBConstants/table_key_geographymaster.dart';
import 'package:newsee/Model/address_data.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_response_model.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/modal/statecitymaster.dart';
import 'package:newsee/feature/masters/domain/repository/geographymaster_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/lov_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/statecity_master_crud_repo.dart';
import 'package:sqflite/sqlite_api.dart';

part './address_details_event.dart';
part './address_details_state.dart';

final class AddressDetailsBloc
    extends Bloc<AddressDetailsEvent, AddressDetailsState> {
  AddressDetailsBloc() : super(AddressDetailsState.init()) {
    on<AddressDetailsInitEvent>(initAddressDetails);
    on<AddressDetailsSaveEvent>(saveAddressDetails);
  }

  Future<void> initAddressDetails(
    AddressDetailsInitEvent event,
    Emitter emit,
  ) async {
    Database _db = await DBConfig().database;
    List<Lov> listOfLov = await LovCrudRepo(_db).getAll();
    List<GeographyMaster> stateCityMaster = await GeographymasterCrudRepo(
      _db,
    ).getByColumnNames(
      columnNames: [
        TableKeysGeographyMaster.stateId,
        TableKeysGeographyMaster.cityId,
      ],
      columnValues: ['0', '0'],
    );
    emit(
      state.copyWith(
        lovList: listOfLov,
        stateCityMaster: stateCityMaster,
        status: SaveStatus.init,
      ),
    );
  }

  Future<void> saveAddressDetails(
    AddressDetailsSaveEvent event,
    Emitter emit,
  ) async {
    print('PersonalData => ${event.addressData}');
    emit(
      state.copyWith(
        addressData: event.addressData,
        status: SaveStatus.success,
      ),
    );
  }
}
