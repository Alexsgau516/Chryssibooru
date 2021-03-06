import 'package:chryssibooru/DerpisRepo.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_downloader/image_downloader.dart';

String parseFileSize(int size) {
  if (size > 1024*1024*1024) {
    return (size/(1024*1024*1024)).toStringAsFixed(2) + " GB";
  } else if (size > 1024*1024) {
    return (size/(1024*1024)).toStringAsFixed(2) + " MB";
  } else if (size > 1024) {
    return (size/(1024)).toStringAsFixed(2) + " KB";
  } else {
    return size.toStringAsFixed(2) + " B";
  }
}


Future openInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


Future downloadImage(String url) async {
  try {
    // Saved with this method.
    var imageId = await ImageDownloader.downloadImage('https://'+url);
    if (imageId == null) {
      debugPrint("Image is null");
    }
  } catch (error) {
    debugPrint(error);
  }
}

enum Quality {
  Low,
  Medium,
  High,
  Source
}

String getImageOfQuality(Quality quality, DerpisRepo repo, int index) {
  switch (quality) {
    case Quality.Low:
      return repo.derpis[index].representations.small;
    case Quality.Medium:
      return repo.derpis[index].representations.medium;
    case Quality.High:
      return repo.derpis[index].representations.large;
    case Quality.Source:
      return repo.derpis[index].representations.full;
    // Default has to be there or the linter starts bitching ¯\_(ツ)_/¯
    default:
      return repo.derpis[index].representations.medium;
  }
}

class Semver {
  int major;
  int minor;
  int hotfix;

  Semver(this.major, this.minor, this.hotfix);

  Semver.fromString(String version) {
    var parts = version.split('.');
    List<int> iParts = List<int>();

    if (parts.length > 3) throw ArgumentError('Incorrect semver format');

    for (var p in parts) {
      int i = int.parse(p);
      if (i == null) throw ArgumentError('Incorrect semver format');
      else iParts.add(i);
    }

    this.major = iParts[0];
    this.minor = iParts[1];
    this.hotfix = iParts[2];
  }

  @override
  String toString() => '$major.$minor.$hotfix';

  bool operator < (Semver other) {
    if (this.major < other.major) return true;
    if (this.minor < other.minor) return true;
    if (this.hotfix < other.hotfix) return true;
    else return false;
  }

  bool operator > (Semver other) {
    if (this.major > other.major) return true;
    if (this.minor > other.minor) return true;
    if (this.hotfix > other.hotfix) return true;
    else return false;
  }

  bool operator <= (Semver other)  => (this < other) || (this == other);

  bool operator >= (Semver other) => (this > other) || (this == other);

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is Semver &&
              runtimeType == other.runtimeType &&
              major == other.major &&
              minor == other.minor &&
              hotfix == other.hotfix;

  @override
  int get hashCode =>
      major.hashCode ^
      minor.hashCode ^
      hotfix.hashCode;

}