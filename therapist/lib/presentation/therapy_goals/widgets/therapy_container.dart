import 'package:flutter/material.dart';
import 'package:therapist/model/model.dart';
import 'package:therapist/presentation/therapy_goals/widgets/therapy_dotted_empty_container.dart';

enum TherapyDetailsType {
  goals('Goals'),
  observation('Observation'),
  regression('Regression'),
  activities('Activities');

  final String value;
  const TherapyDetailsType(this.value);

}

class TherapyContainer extends StatelessWidget {
  const TherapyContainer({
    super.key,
    required this.therapyDetailsType,
    required this.therapyInfo,
  });

  final TherapyDetailsType therapyDetailsType;
  final List<TherapyModel> therapyInfo;

  @override
  Widget build(BuildContext context) {
    return therapyInfo.isEmpty ? 
      TherapyDottedEmptyContainer(therapyDetailsType: therapyDetailsType)
      : Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: const Color(0xffC7C8D2),),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            therapyDetailsType.value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xff121417)
            ),
          ),
          const SizedBox(height: 8,),
          const Divider(
            color: Color(0xffE1E2E7),
            height: 1,
          ),
          ...therapyInfo.map(
            (info) => Container(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                info.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(
                    0xff111847,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}