class Images {
  /* String id; */
  String src;
  /* String? ratio, type; */
  /* String createdAt, updatedAt; */

  Images(
    /* this.id, */
    this.src,
    /* this.type,  */
    /* this.updatedAt, */
    /* this.createdAt, */
    /* this.ratio */
  );

  factory Images.fromJson(Map<dynamic, dynamic> json) => Images(
        /* json["id"], */
        json["src"],
        /* json["type"], */
        /* json["updated_at"], */
        /* json["created_at"], */
        /* json["ratio"] */
      );
}

