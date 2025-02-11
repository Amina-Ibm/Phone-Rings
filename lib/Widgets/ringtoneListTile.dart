import 'package:flutter/material.dart';
import 'package:phone_rings/Models/ringtoneModel.dart';
import 'package:phone_rings/Widgets/ringtonePlayer.dart';

class RingtoneListTile extends StatefulWidget {
  RingtoneListTile({ required this.ringtone});
  final Ringtone ringtone;
  @override
  State<RingtoneListTile> createState() => _RingtoneListTileState();
}

class _RingtoneListTileState extends State<RingtoneListTile> {
  bool playing = false;
  Widget build(BuildContext context) {
    //String formattedDuration = formatDuration(widget.ringtone.duration as int);
    return Row(
      children: [
        Expanded(
          child: ListTile(
            leading: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.blue.shade500,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.music_note)
            ),
            title: Text(
              widget.ringtone.name,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
            subtitle: Text(widget.ringtone.username,
              style: Theme.of(context).textTheme.bodySmall ,),
            onTap: () {
              showModalBottomSheet(context: context,
                  builder: (context) =>
                      RingtonePlayer(ringtone: widget.ringtone)
              );
            },
            trailing: Text(widget.ringtone.duration.toInt().toString(),
                style: Theme.of(context).textTheme.bodySmall),
          ),
        ),
      ],
    );
  }
  String formatDuration(int durationMs) {
    int totalSeconds = durationMs ~/ 1000;
    int seconds = totalSeconds % 60;
    return '${seconds}s';
  }
}