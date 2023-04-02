import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';

import '../../data/show_model.dart';
import '../../models/show.dart';

class ShowInfoEditView extends StatelessWidget {
  static const String routeName = '/settings/showinfo';
  final Key formKey = GlobalKey();

  ShowInfoEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Consumer<ShowModel>(
        builder: (context, showModel, child) {
          return ListView(
            children: [
              FormBuilderTextField(
                name: 'title',
                initialValue: showModel.show.info.title,
                decoration: const InputDecoration(label: Text('Show Title')),
                onChanged: (value) {
                  if (value != null) {
                    showModel.updateShow(Info.title, value);
                  }
                },
              ),
              FormBuilderTextField(
                name: 'location',
                initialValue: showModel.show.info.location,
                decoration: const InputDecoration(label: Text('Location')),
                onChanged: (value) {
                  if (value != null) {
                    showModel.updateShow(Info.location, value);
                  }
                },
              ),
              FormBuilderTextField(
                name: 'ld',
                initialValue: showModel.show.info.ld,
                decoration:
                    const InputDecoration(label: Text('Lighting Designer')),
                onChanged: (value) {
                  if (value != null) {
                    showModel.updateShow(Info.ld, value);
                  }
                },
              ),
              FormBuilderTextField(
                name: 'ald',
                initialValue: showModel.show.info.ald,
                decoration: const InputDecoration(label: Text('A.L.D.')),
                onChanged: (value) {
                  if (value != null) {
                    showModel.updateShow(Info.ald, value);
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
