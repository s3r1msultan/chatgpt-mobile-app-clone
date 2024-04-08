// import 'package:chatgpt_mobile_app/constants/cosntants.dart';
// import 'package:chatgpt_mobile_app/models/models_model.dart';
// import 'package:chatgpt_mobile_app/providers/models_provider.dart';
// import 'package:chatgpt_mobile_app/widgets/text_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class DropDownWidget extends StatefulWidget {
//   const DropDownWidget({super.key});

//   @override
//   State<DropDownWidget> createState() => _DropDownWidgetState();
// }

// class _DropDownWidgetState extends State<DropDownWidget> {
//   String? currentModel;
//   @override
//   Widget build(BuildContext context) {
//     final modelsProvider = Provider.of<ModelsProvider>(context, listen: false);
//     currentModel = modelsProvider.currentModel;
//     return FutureBuilder<List<ModelsModel>>(
//         future: modelsProvider.getAllModels(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(
//               child: TextWidget(label: snapshot.error.toString()),
//             );
//           }
//           return snapshot.data == null || snapshot.data!.isEmpty
//               ? const SizedBox.shrink()
//               : FittedBox(
//                   child: DropdownButton(
//                     dropdownColor: scaffoldBackgroundColor,
//                     iconEnabledColor: Colors.white,
//                     items: List<DropdownMenuItem<String>>.generate(
//                         snapshot.data!.length,
//                         (index) => DropdownMenuItem(
//                             value: snapshot.data![index].id,
//                             child: TextWidget(
//                               label: snapshot.data![index].id,
//                               fontSize: 15,
//                             ))),
//                     value: currentModel,
//                     onChanged: (value) {
//                       setState(() {
//                         currentModel = value.toString();
//                       });
//                       modelsProvider.setCurrentModel(value.toString());
//                     },
//                   ),
//                 );
//         });
//   }
// }
