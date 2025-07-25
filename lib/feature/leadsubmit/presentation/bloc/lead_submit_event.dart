// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'lead_submit_bloc.dart';

/* 
@author   : karthick.d  13/06/2025
@desc     : events dispatched 
            LeadSubmitPageInitEvent - dispatched when bloc / page loads first
            LeadSubmitPushEvent     - on click push to lendperfect button

 */
abstract class LeadSubmitEvent {}

class LeadSubmitPageInitEvent extends LeadSubmitEvent {
  // this event will need personaldata and Cif state
  final PersonalData? personalData;

  LeadSubmitPageInitEvent({required this.personalData});
}

class LeadSubmitPushEvent extends LeadSubmitEvent {
  final LoanType loanType;
  final LoanProduct loanProduct;
  final Dedupe dedupe;
  final PersonalData? personalData;
  final AddressData? addressData;
  final List<CoapplicantData>?
  coAppAndGurantorData; // added coapplicant or gurantor applicants List
  final String isAddCoappGurantor; // added applicants option like Y or N
  LeadSubmitPushEvent({
    required this.loanType,
    required this.loanProduct,
    required this.dedupe,
    required this.personalData,
    required this.addressData,
    required this.coAppAndGurantorData,
    required this.isAddCoappGurantor,
  });
}

class CreateProposalEvent extends LeadSubmitEvent {
  final ProposalCreationRequest proposalCreationRequest;
  CreateProposalEvent({required this.proposalCreationRequest});
}
