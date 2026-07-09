class NextActivity {
  final int? id;
  final String? title;
  final String? description;
  final String? type;
  final String? status;
  final String? dueLabel;
  final int? lotId;
  final String? lotName;
  final bool? overdue;

  const NextActivity({
    this.id,
    this.title,
    this.description,
    this.type,
    this.status,
    this.dueLabel,
    this.lotId,
    this.lotName,
    this.overdue,
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        'type': type,
        'status': status,
        'dueLabel': dueLabel,
        if (lotId != null) 'lotId': lotId,
        if (lotName != null) 'lotName': lotName,
        if (overdue != null) 'overdue': overdue,
      };
}
