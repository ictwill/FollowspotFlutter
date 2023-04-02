import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../../data/gel_colors.dart';
import '../../data/show_model.dart';

class SpotColorEditView extends StatelessWidget {
  static const String routeName = '/settings/spotcolor';
  final Key formKey = GlobalKey();

  SpotColorEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Consumer<ShowModel>(
        builder: (context, showModel, child) => LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: showModel.show.spotList.map((spot) {
                  return Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Spot ${spot.number}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        for (var i = 0; i < spot.frames.length; i++)
                          FormBuilderTextField(
                            name: '${spot.id}-$i',
                            initialValue: spot.frames[i],
                            decoration: InputDecoration(
                                prefixText: '${i + 1} : ',
                                prefixIcon: const Icon(Icons.square_rounded),
                                prefixIconColor: getGelHex(spot.frames[i])),
                            onChanged: (value) {
                              if (value != null) {
                                showModel.updateFrame(spot.id, i, value);
                              }
                            },
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                showModel.addFrame(spot.id);
                              },
                              child:
                                  Text('Add Frame ${spot.frames.length + 1}')),
                        ),
                        const Divider()
                      ],
                    ),
                  ));
                }).toList(),
              );
            } else {
              return ListView(
                children: showModel.show.spotList.map((spot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Spot ${spot.number}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        for (var i = 0; i < spot.frames.length; i++)
                          FormBuilderTextField(
                            name: '${spot.id}-$i',
                            initialValue: spot.frames[i],
                            decoration: InputDecoration(
                                prefixText: '${i + 1} : ',
                                prefixIcon: const Icon(Icons.square_rounded),
                                prefixIconColor: getGelHex(spot.frames[i])),
                            onChanged: (value) {
                              if (value != null) {
                                showModel.updateFrame(spot.id, i, value);
                              }
                            },
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                                showModel.addFrame(spot.id);
                              },
                              child:
                                  Text('Add Frame ${spot.frames.length + 1}')),
                        ),
                        const Divider()
                      ],
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
