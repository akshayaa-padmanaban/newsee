// ignore_for_file: public_member_api_docs, sort_constructors_first
/* 
@author   : karthick.d  10/06/2025
@desc     : state for PersonalDetails and lov masters
 */
part of 'personal_details_bloc.dart';

/* 

 */
enum SaveStatus { init, success, failure }

class PersonalDetailsState extends Equatable {
  final List<Lov>? lovList;
  final PersonalData? personalData;
  final SaveStatus? status;
  PersonalDetailsState({
    required this.lovList,
    required this.personalData,
    required this.status,
  });

  factory PersonalDetailsState.init() => PersonalDetailsState(
    lovList: [],
    personalData: null,
    status: SaveStatus.init,
  );

  @override
  List<Object?> get props => [lovList, personalData, status];

  PersonalDetailsState copyWith({
    List<Lov>? lovList,
    PersonalData? personalData,
    SaveStatus? status,
  }) {
    return PersonalDetailsState(
      lovList: lovList ?? this.lovList,
      personalData: personalData ?? this.personalData,
      status: status ?? this.status,
    );
  }
}
