class AppWriteConstant {
  static const String databaseId = "65da0ab867f084540bdf";
  static const String projectId = "65d99e6d007ebc30c6cc";
  static const String endPoint = "http://192.168.8.117:8080/v1";
  // static const String endPoint = "http://localhost:8080/v1";
  static const String userCollectionId = "65dc3e18817b97f94999";
  static const String tweetCollectionId = "65ef2f71c4c55d1d8a71";
  static const String imagesBucket = "65ef4e91e0b4814e32fe";

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
