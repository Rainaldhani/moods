class MoodList {
  String moodName;
  String moodImage;

  MoodList({
    required this.moodName,
    required this.moodImage,
  });
}

var moods = [
  MoodList(
    moodName: "hug",
    moodImage: "lib/assets/images/hug.png",
  ),
  MoodList(
    moodName: "kiss",
    moodImage: "lib/assets/images/kiss.png",
  ),
  MoodList(
    moodName: "happy",
    moodImage: "lib/assets/images/happy.png",
  ),
  MoodList(
    moodName: "sad",
    moodImage: "lib/assets/images/sad.png",
  ),
  MoodList(
    moodName: "horn(y)",
    moodImage: "lib/assets/images/horn.png",
  )
];
