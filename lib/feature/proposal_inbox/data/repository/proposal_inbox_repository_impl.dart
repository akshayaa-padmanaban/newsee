import 'package:dio/dio.dart';
import 'package:newsee/core/api/AsyncResponseHandler.dart';
import 'package:newsee/core/api/api_client.dart';
import 'package:newsee/core/api/api_config.dart';
import 'package:newsee/core/api/auth_failure.dart';
import 'package:newsee/core/api/failure.dart';
import 'package:newsee/core/api/http_connection_failure.dart';
import 'package:newsee/core/api/http_exception_parser.dart';
import 'package:newsee/feature/leadInbox/domain/modal/lead_request.dart';
import 'package:newsee/feature/proposal_inbox/data/datasource/proposal_inbox_remote_datasource.dart';
import 'package:newsee/feature/proposal_inbox/domain/modal/proposal_inbox_responce_model.dart';
import 'package:newsee/feature/proposal_inbox/domain/repository/proposal_inbox_repository.dart';

class ProposalInboxRepositoryImpl implements ProposalInboxRepository {
  @override
  Future<AsyncResponseHandler<Failure, List<ProposalInboxResponseModel>>>
  searchProposalInbox(LeadInboxRequest req) async {
    try {
      final response = await ProposalInboxRemoteDatasource(
        dio: ApiClient().getDio(),
      ).searchProposalInbox(req.toMap());

      final responseData = response.data;
      final isSuccess =
          responseData[ApiConfig.API_RESPONSE_SUCCESS_KEY] == true;

      if (isSuccess) {
        final data = responseData[ApiConfig.API_RESPONSE_RESPONSE_KEY];

        if (data is List) {
          final proposalInboxResponse =
              data
                  .map(
                    (e) => ProposalInboxResponseModel.fromMap(
                      e as Map<String, dynamic>,
                    ),
                  )
                  .toList();
          return AsyncResponseHandler.right(proposalInboxResponse);
        } else if (data is Map<String, dynamic>) {
          final proposalInboxResponse = ProposalInboxResponseModel.fromMap(
            data,
          );
          return AsyncResponseHandler.right([proposalInboxResponse]);
        } else {
          return AsyncResponseHandler.left(
            HttpConnectionFailure(
              message: "Unexpected data format: ${data.runtimeType}",
            ),
          );
        }
      } else {
        final errorMessage = responseData['ErrorMessage'] ?? "Unknown error";
        return AsyncResponseHandler.left(AuthFailure(message: errorMessage));
      }
    } on DioException catch (e) {
      final failure = DioHttpExceptionParser(exception: e).parse();
      return AsyncResponseHandler.left(failure);
    } catch (error, st) {
      print(" ProposalInboxResponseHandler Exception: $error\n$st");
      return AsyncResponseHandler.left(
        HttpConnectionFailure(
          message: "Unexpected Failure during Proposal Inbox Search",
        ),
      );
    }
  }
}
