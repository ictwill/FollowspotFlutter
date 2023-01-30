/// A placeholder class that represents an entity or model.
class Cue {
  const Cue(
    this.id,
    this.action,
    this.target,
    this.time,
    this.size,
    this.intensity,
    this.frames,
    this.notes,
    this.number,
  );

  final int id;
  final String number;
  final String action;
  final String target;
  final String size;
  final int intensity;
  final List<String> frames;
  final int time;
  final String notes;
}
