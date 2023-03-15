import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/cue.dart';
import 'edit_cue/cue_edit_form.dart';

Future<dynamic> navigateNewCue(BuildContext context, int spot) =>
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return CueEditForm(cue: Cue(id: const Uuid().v4(), spot: spot));
      },
    );
