class BundleCourses {
  BundleCourses({
    this.id,
    this.userId,
    this.courseId,
    this.title,
    this.detail,
    this.price,
    this.discountPrice,
    this.type,
    this.slug,
    this.status,
    this.featured,
    this.previewImage,
    this.createdAt,
    this.updatedAt,
  });

  int id;
  String userId;
  List<String> courseId;
  String title;
  String detail;
  dynamic price;
  dynamic discountPrice;
  String type;
  String slug;
  dynamic status;
  dynamic featured;
  String previewImage;
  String createdAt;
  String updatedAt;
}
