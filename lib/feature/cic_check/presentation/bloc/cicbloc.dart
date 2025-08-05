import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsee/AppData/app_api_constants.dart';
import 'package:newsee/AppData/app_constants.dart';
import 'package:newsee/feature/leadInbox/data/repository/lead_respository_impl.dart';
import 'package:newsee/feature/leadInbox/domain/modal/get_lead_response.dart';
import 'package:newsee/feature/leadInbox/domain/repository/lead_repository.dart';

part './cicevent.dart';
part './cicstate.dart';

final class CICBloc extends Bloc<CICEvent, CICInboxState> {
  CICBloc() : super(CICInboxState.init()) {
    on<CICInitEvent>(onCICInitFetch);
  }

  Future<void> onCICInitFetch(
    CICInitEvent event,
    Emitter<CICInboxState> emit,
  ) async {
    try {
      emit(state.copyWith(leadStatus: SaveStatus.loading));
      final request = {
        'LeadId': event.proposalData['leadNo'],
        'token': ApiConstants.api_qa_token,
      };

      final LeadRepository leadRepository = LeadRepositoryImpl();
      final response = await leadRepository.getLeadData(request);
      if (response.isRight()) {
        final List<Map<String, dynamic>> user =
            await getUserList(response.right);
        emit(
          state.copyWith(
            leadDetails: response.right,
            leadStatus: SaveStatus.success,
            coappandGauList: user,
            proposalData: event.proposalData,
          ),
        );
      } else {
        emit(
          state.copyWith(
            errorMessage: response.left.message,
            coappandGauList: [],
            leadStatus: SaveStatus.failure,
          ),
        );
      }
    } catch (_) {
      emit(state.copyWith(leadStatus: SaveStatus.failure, coappandGauList: []));
    }
  }

  Future<List<Map<String, dynamic>>> getUserList(
    applicationData,
  ) async {
    try {
      final List<Map<String, dynamic>> user = [];

      if (applicationData.LeadDetails!['lleadfrstname'] != null &&
          applicationData.LeadDetails!.isNotEmpty) {
        user.add({
          'name':
              applicationData.LeadDetails!['lleadfrstname'] +
              applicationData.LeadDetails!['lleadlastname'],
          'roleKey': 'applicant',
        });
      }

      if (applicationData.LeadDetails!['lldCoappfrstname'] != null &&
          applicationData.LeadDetails!.isNotEmpty) {
        user.add({
          'name':
              applicationData.LeadDetails!['lldCoappfrstname'] +
              applicationData.LeadDetails!['lldLastnameCoapplican'],
          'roleKey': 'coapplicant',
        });
      }

      if (applicationData.LeadDetails!['lldguafrstname'] != null &&
          applicationData.LeadDetails!.isNotEmpty) {
        user.add({
          'name':
              applicationData.LeadDetails!['lldguafrstname'] +
              applicationData.LeadDetails!['lldgualastname'],
          'roleKey': 'guarantor',
        });
      }

      return user;
    } catch (error) {
      final List<Map<String, dynamic>> user = [];
      return user;
    }
  }
}
