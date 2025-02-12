class Ringtone {
  final int id;
  final String url;
  final String name;
  final List<String> tags;
  final String type;
  final double duration;
  final String username;
  final String downloadUrl;
  final Map<String, String> previews;
  final String analysisFrames;
   bool isDownloaded = false;
  Ringtone({
    required this.id,
    required this.url,
    required this.name,
    required this.tags,
    required this.type,
    required this.duration,
    required this.username,
    required this.downloadUrl,
    required this.previews,
    //required this.images,
    required this.analysisFrames,
  });
  factory Ringtone.fromJson(Map<String, dynamic> json) {
    return Ringtone(
      id: json['id'],
      url: json['url'],
      name: json['name'],
      tags: List<String>.from(json['tags'] ?? []),
      type: json['type'],
      duration: json['duration'],
      username: json['username'],
      downloadUrl: json['download'],
      previews: Map<String, String>.from(json['previews'] ?? {}),
      //images: Map<String, String>.from(json['images'] ?? {}),
      analysisFrames: json['analysis_frames'] ?? '',
    );
  }
}
