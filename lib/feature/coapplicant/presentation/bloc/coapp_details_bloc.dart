/* 
@autor      : karthick.d  20/06/2025
@desc       : bloc for saving co appdetails 
              more than one co-app can be add to co app list 
              co-applicant is optional and will be sent as part of lead details

 */

import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/DBConstants/table_key_geographymaster.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/Utils/utils.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/aadharvalidation/domain/modal/aadharvalidate_response.dart';
import 'package:newsee/feature/addressdetails/data/repository/citylist_repo_impl.dart';
import 'package:newsee/feature/addressdetails/domain/model/citydistrictrequest.dart';
import 'package:newsee/feature/addressdetails/domain/repository/cityrepository.dart';
import 'package:newsee/feature/cif/data/repository/cif_respository_impl.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_request.dart';
import 'package:newsee/feature/cif/domain/model/user/cif_response.dart';
import 'package:newsee/feature/cif/domain/repository/cif_repository.dart';
import 'package:newsee/feature/coapplicant/applicants_utility_service.dart';
import 'package:newsee/feature/coapplicant/domain/modal/coapplicant_data.dart';
import 'package:newsee/feature/masters/domain/modal/geography_master.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/repository/geographymaster_crud_repo.dart';
import 'package:newsee/feature/masters/domain/repository/lov_crud_repo.dart';
import 'package:sqflite/sqlite_api.dart';

part 'coapp_details_event.dart';
part 'coapp_details_state.dart';

final class CoappDetailsBloc
    extends Bloc<CoappDetailsEvent, CoappDetailsState> {
  CoappDetailsBloc() : super(CoappDetailsState.initial()) {
    on<CoAppDetailsInitEvent>(initCoAppDetailsPage);
    on<CoAppDetailsSaveEvent>(saveCoAppDetailsPage);
    on<OnStateCityChangeEvent>(getCityListBasedOnState);
    on<CoAppGurantorSearchCifEvent>(onSearchCif);
    on<IsCoAppOrGurantorAdd>(addCoappOrGurantor);
    on<DeleteCoApplicantEvent>(_deleteApplicant);
    on<CoAppDetailsDedupeEvent>(_onDedupeResponse);
    on<CifEditManuallyEvent>((event, emit) {
      emit(state.copyWith(isCifValid: event.cifButton));
    });
  }

  _deleteApplicant(DeleteCoApplicantEvent event, Emitter emit) {
    try {
      final updatedList =
          state.coAppList
              .where(
                (e) =>
                    !(e.primaryMobileNumber ==
                            event.coapplicantData.primaryMobileNumber &&
                        e.applicantType == event.coapplicantData.applicantType),
              )
              .toList();

      emit(state.copyWith(coAppList: updatedList, status: SaveStatus.success));
    } catch (e) {
      print(e);
    }
  }

  addCoappOrGurantor(IsCoAppOrGurantorAdd event, Emitter emit) {
    emit(state.copyWith(isApplicantsAdded: event.addapplicants));
  }

  Future<void> initCoAppDetailsPage(
    CoAppDetailsInitEvent event,
    Emitter emit,
  ) async {
    // fetch lov
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

    print('listOfLov => $listOfLov');

    emit(state.copyWith(lovList: listOfLov, stateCityMaster: stateCityMaster));
  }

  Future<void> saveCoAppDetailsPage(
    CoAppDetailsSaveEvent event,
    Emitter emit,
  ) async {
    try {
      final updatedList = List<CoapplicantData>.from(state.coAppList);

      if (event.index != null && event.index! < updatedList.length) {
        updatedList[event.index!] = event.coapplicantData;
      } else {
        updatedList.add(event.coapplicantData);
      }

      emit(
        state.copyWith(
          coAppList: updatedList,
          status: SaveStatus.success,
          isApplicantsAdded: "Y",
          isCifValid: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: SaveStatus.failure, isCifValid: false));
    }
  }

  Future<void> getCityListBasedOnState(
    OnStateCityChangeEvent event,
    Emitter emit,
  ) async {
    /** 
     * @modified    : karthick.d 22/06/2025
     * 
     * @reson       : geograhy master parsing logic should be kept as function 
     *                so it the logic can be reused across various bLoC
     * 
     * @desc        : so geograpgy master fetching logic is reusable 
                      encapsulate geography master datafetching in citylist_repo_impl 
                      the desired statement definition as simple as calling the funtion 
                      and set the state
                      emit(state.copyWith(status:SaveStatus.loading));
                      await cityrepository.fetchCityList(
                              citydistrictrequest,
                          );
    */

    emit(state.copyWith(status: SaveStatus.loading));
    final CityDistrictRequest citydistrictrequest = CityDistrictRequest(
      stateCode: event.stateCode,
      cityCode: event.cityCode,
    );
    Cityrepository cityrepository = CitylistRepoImpl();
    AsyncResponseHandler response = await cityrepository.fetchCityList(
      citydistrictrequest,
    );
    CoappDetailsState coappDetailsState =
        mapGeographyMasterResponseForCoAppPage(state, response);
    emit(coappDetailsState);
  }

  /* 
fetching dedupe for co applicant reusing dedupe page cif search logic here

 */

  Future onSearchCif(CoAppGurantorSearchCifEvent event, Emitter emit) async {
    emit(state.copyWith(status: SaveStatus.loading));
    CifRepository dedupeRepository = CifRepositoryImpl();
    final response = await dedupeRepository.searchCif(event.request);
    if (response.isRight()) {
      CifResponse cifResponse = response.right;
      // map cifresponse to CoapplicantData so we can set data to form()
      CoapplicantData coapplicantDataFromCif = mapCoapplicantDataFromCif(
        cifResponse,
      );
      emit(
        state.copyWith(
          status: SaveStatus.dedupesuccess,
          selectedCoApp: coapplicantDataFromCif,
          isCifValid: true,
        ),
      );
    } else {
      print('cif failure response.left ');
      emit(state.copyWith(status: SaveStatus.dedupefailure, isCifValid: false));
    }
  }

  Future<void> _onDedupeResponse(
    CoAppDetailsDedupeEvent event,
    Emitter emit,
  ) async {
    try {
      final coapplicantDataFromDedupe = mapCoappAndGurantorDataFromDedupe(
        event.coapplicantData,
      );

      emit(
        state.copyWith(
          status: SaveStatus.dedupesuccess,
          selectedCoApp: coapplicantDataFromDedupe,
          isCifValid: true,
        ),
      );
    } catch (e) {
      print(e);
      emit(state.copyWith(status: SaveStatus.dedupefailure, isCifValid: false));
    }
  }

  // populate dedupe response to coapplicant form
  CoapplicantData mapCoappAndGurantorDataFromDedupe(dynamic response) {
    print('dedupe response: $response');

    return CoapplicantData(
      firstName: response.name ?? '',
      email: response.email ?? '',
      primaryMobileNumber: response.mobile ?? '',
      address1:
          (response.careOf?.isNotEmpty ??
                  false || response.street?.isNotEmpty ??
                  false)
              ? '${response.careOf ?? ''} ${response.street ?? ''}'.trim()
              : '',
      address2: response.landmark ?? '',
      pincode: response.pincode ?? '',
      aadharRefNo: response.maskAadhaarNumber ?? '',
      dob: getCorrectDateFormat(response.dateOfBirth),
      state: getStateCode(response.state, state.stateCityMaster),
      cityDistrict: getStateCode(response.district, state.districtMaster),
      // state: '',
      // cityDistrict: '',
    );
  }

  // Search for the matching GeographyMaster based on stateName
  String getStateCode(String stateName, List<GeographyMaster>? list) {
    if (list == null || list.isEmpty) {
      return '';
    }

    GeographyMaster? geographyMaster = list.firstWhere(
      (val) => val.value.toLowerCase() == stateName.toLowerCase(),
      orElse:
          () => GeographyMaster(
            stateParentId: '',
            cityParentId: '',
            code: '',
            value: '',
          ),
    );

    if (geographyMaster.code.isEmpty) {
      return '';
    } else {
      print('getStateCode $geographyMaster');
      return geographyMaster.code;
    }
  }
}
