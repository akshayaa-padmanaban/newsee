import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/Model/personal_data.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/aadharvalidation/domain/modal/aadharvalidate_response.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_response_model.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/repository/lov_crud_repo.dart';
import 'package:sqflite/sqlite_api.dart';

part './personal_details_event.dart';
part './personal_details_state.dart';

/* 

@author   : karthick.d  10/06/2025
@desc     : bloc for Personaldetials forward workflow and reverse workflow

 */
final class PersonalDetailsBloc
    extends Bloc<PersonalDetailsEvent, PersonalDetailsState> {
  PersonalDetailsBloc() : super(PersonalDetailsState.init()) {
    on<PersonalDetailsInitEvent>(initPersonalDetails);
    on<PersonalDetailsSaveEvent>(savePersonalDetails);
  }

  /*
  PersonalDetailsState.lovmaster state will be supplied with LovMasters from db
   */
  Future<void> initPersonalDetails(
    PersonalDetailsInitEvent event,
    Emitter emit,
  ) async {
    Database _db = await DBConfig().database;
    List<Lov> listOfLov = await LovCrudRepo(_db).getAll();
    print('listOfLov => $listOfLov');
    emit(
      PersonalDetailsState(
        lovList: listOfLov,
        personalData: null,
        status: SaveStatus.init,
      ),
    );
  }

  /* 
    saving personaldetails entered and storing in personalData
   */
  Future<void> savePersonalDetails(
    PersonalDetailsSaveEvent event,
    Emitter emit,
  ) async {
    print('PersonalData => ${event.personalData}');
    emit(
      state.copyWith(
        personalData: event.personalData,
        status: SaveStatus.success,
      ),
    );
  }
}
