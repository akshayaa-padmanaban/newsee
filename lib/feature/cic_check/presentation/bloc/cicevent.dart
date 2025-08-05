part of 'cicbloc.dart';

abstract class CICEvent {
  const CICEvent();
}

class CICInitEvent extends CICEvent {
  final Map<String, dynamic> proposalData;
  const CICInitEvent({required this.proposalData});
}
