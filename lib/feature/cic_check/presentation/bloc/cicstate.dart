part of 'cicbloc.dart';

class CICInboxState extends Equatable {
  final GetLeadResponse? leadDetails;
  final SaveStatus? leadStatus;
  final Map<String, dynamic>? proposalData;
  final List<Map<String, dynamic>>? coappandGauList;
  final String? errorMessage;

  const CICInboxState({
    this.leadDetails,
    this.leadStatus = SaveStatus.init,
    this.proposalData,
    this.coappandGauList,
    this.errorMessage,
  });

  factory CICInboxState.init() => const CICInboxState();

  CICInboxState copyWith({
    GetLeadResponse? leadDetails,
    SaveStatus? leadStatus,
    Map<String, dynamic>? proposalData,
    List<Map<String, dynamic>>? coappandGauList,
    String? errorMessage,
  }) {
    return CICInboxState(
      leadDetails: leadDetails ?? this.leadDetails,
      leadStatus: leadStatus ?? this.leadStatus,
      proposalData: proposalData ?? this.proposalData,
      coappandGauList: coappandGauList ?? this.coappandGauList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props {
    return [
      leadDetails,
      leadStatus,
      proposalData,
      coappandGauList,
      errorMessage,
    ];
  }
}
