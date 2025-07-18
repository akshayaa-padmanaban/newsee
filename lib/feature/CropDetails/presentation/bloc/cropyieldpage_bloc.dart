import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/core/db/db_config.dart';
import 'package:newsee/feature/CropDetails/data/repository/cropdetails_repository_impl.dart';
import 'package:newsee/feature/CropDetails/domain/modal/crop_get_response.dart';
import 'package:newsee/feature/CropDetails/domain/modal/cropdetailsmodal.dart';
import 'package:newsee/feature/CropDetails/domain/modal/cropmodel.dart';
import 'package:newsee/feature/CropDetails/domain/modal/croprequestmodel.dart';
import 'package:newsee/feature/CropDetails/domain/repository/cropdetails_repository.dart';
import 'package:newsee/feature/landholding/data/repository/land_Holding_respository_impl.dart';
import 'package:newsee/feature/landholding/domain/modal/LandData.dart';
import 'package:newsee/feature/landholding/domain/repository/landHolding_repository.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_bloc.dart';
import 'package:newsee/feature/loader/presentation/bloc/global_loading_event.dart';
import 'package:newsee/feature/masters/domain/modal/lov.dart';
import 'package:newsee/feature/masters/domain/repository/lov_crud_repo.dart';
import 'package:sqflite/sqflite.dart';

part 'cropyieldpage_event.dart';
part 'cropyieldpage_state.dart';

class CropyieldpageBloc extends Bloc<CropyieldpageEvent, CropyieldpageState> {
  CropyieldpageBloc(): super(CropyieldpageState.init()) {
    on<CropPageInitialEvent>(initCropYieldDetails);
    on<CropFormSaveEvent>(onSaveCropYieldPage);
    on<CropDetailsSetEvent>(onDataSet);
    on<CropDetailsResetEvent>(onResetForm);
    on<CropDetailsUpdateEvent>(onUpdateForm);
    on<CropDetailsSubmitEvent>(onSubmitCropDetails);
  }

  Future<void> onSubmitCropDetails(
    CropDetailsSubmitEvent event,
    Emitter emit
  ) async {
    try {
      final CropRequestModel cropReq = CropRequestModel(
        proposalNumber: event.proposalNumber,
        userid: event.userid,
        cropDetailModel: CropModal(
          taluk: "Saidapet",
          agriCultivated: "1",
          state: "38",
          firka: "Test",
          distanceFromBranch: "2",
          irrigated: event.irrigated,
          natureOfRight: "1",
          district: "0001",
          village: "sholinganallur",
          rainfed: event.rainfed,
          total: event.total,
          cropsCultivatedOrProposedCrops: "12",
          surveyNo: "34567",
          farmDistance: "Chennai"
        ),
        assessmentSOF: state.cropData,
        token: ApiConfig.AUTH_TOKEN
      );
      print("cropReq $cropReq");
      CropDetailsRepository cropRepository = CropDetailsRepositoryImpl();
      var responseHandler = await cropRepository.saveCrop(
        cropReq,
      );  
      print("get responseHandler value is => $responseHandler");
      if (responseHandler.isRight()) {
        // List<Map<String, dynamic>> listofAssessment = responseHandler.right.responseData?['AssessmentSOF'];
        // print("listofAssessment value is => $listofAssessment");
        // List<LandData> landData = listofAssessment.map((e) => LandData.fromMap(e)).toList();
        
        emit(
          state.copyWith(
            status: CropPageStatus.success,
            // landData: landData
          )
        );
      } else {
      print('cif failure response.left ');
      emit(
        state.copyWith(
          status: CropPageStatus.failure,
          errorMessage: responseHandler.left.message,
        ),
      );
    }
    } catch(error) {
      print("onSubmitCropDetails $error");
    }
  }

  Future<void> initCropYieldDetails(CropPageInitialEvent event, Emitter emit) async {
    try {
      Database _db = await DBConfig().database;
      List<Lov> listOfLov = await LovCrudRepo(_db).getAll();
      print('listOfLov => $listOfLov');
      
      GlobalLoadingBloc().add(ShowLoading(message: 'Fetching Crop Details'));

      //Get Crop Details
      CropDetailsRepository cropRepository = CropDetailsRepositoryImpl();
      AsyncResponseHandler<Failure, CropGetResponse> cropResponse = await cropRepository.getCrop(
        event.proposalNumber
      );

      //Get Land Details
      final LandHoldingRepository landHoldingRepository =
          LandHoldingRespositoryImpl();
      final landresponse = await landHoldingRepository.getLandholding(event.proposalNumber);
      print("get responseHandler value is => $cropResponse");

      //Emit init state
      if (cropResponse.isRight() && landresponse.isRight()) {
        List<LandData> landData = landresponse.right.agriLandHoldingsList.map((e) => LandData.fromMap(e)).toList();
        emit(
          state.copyWith(
            lovlist: listOfLov,
            status: CropPageStatus.init,
            cropData: cropResponse.right.agriCropDetails,
            landDetails: cropResponse.right.agriLandDetails,
            landData: landData
          )
        );
      } else if (landresponse.isRight()) {
        List<LandData> landData = landresponse.right.agriLandHoldingsList.map((e) => LandData.fromMap(e)).toList();
        emit(
          state.copyWith(
            lovlist: listOfLov,
            status: CropPageStatus.init,
            landData: landData
          )
        );
      } else {
        emit(
          state.copyWith(
            lovlist: listOfLov,
            status: CropPageStatus.init,
          )
        );
      }
      
    } catch(error) {
      print("onSaveCropYieldPage-error $error");
    }
  }

  Future<void> onSaveCropYieldPage(
      CropFormSaveEvent event,
      Emitter<CropyieldpageState> emit,
    ) async {
    final newList = [...?state.cropData, event.cropData];
    emit(
      state.copyWith(
        status: CropPageStatus.save,
        cropData: newList,
        selectedCropData: null,
      ),
    );
  }

   // Load data into form for editing
  void onDataSet(CropDetailsSetEvent event, Emitter<CropyieldpageState> emit) {
    emit(
      state.copyWith(
        selectedCropData: event.cropData,
        status: CropPageStatus.set
      )
    );
  }

  void onResetForm(CropDetailsResetEvent event, Emitter<CropyieldpageState> emit) {
    emit(
      state.copyWith(
        selectedCropData: null,
        status: CropPageStatus.reset
      )
    );
  }

  void onUpdateForm(CropDetailsUpdateEvent event, Emitter<CropyieldpageState> emit) {
    List<CropDetailsModal>? fullcropdata = state.cropData;
    fullcropdata?[event.index] = event.cropData;
    print("Updated crop data is there is $fullcropdata");
    emit(
      state.copyWith(
        cropData: fullcropdata,
        selectedCropData: null,
        status: CropPageStatus.save,
      )
    );
  }



}