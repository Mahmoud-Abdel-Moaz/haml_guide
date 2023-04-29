class SocialMediaModel {
  String? faceBookUrl,
      telegramUrl,
      instgramUrl,
      youtubeUrl,
      websiteUrl,
      whatsupUrl;

  SocialMediaModel({
    this.faceBookUrl,
    this.instgramUrl,
    this.telegramUrl,
    this.websiteUrl,
    this.whatsupUrl,
    this.youtubeUrl,
  });

  SocialMediaModel.fromjson(Map<String, dynamic> jsonData) {
    faceBookUrl = jsonData['facebook_url'];
    instgramUrl = jsonData['instagram_url'];
    telegramUrl = jsonData['telegram_url'];
    websiteUrl = jsonData['website_url'];
    whatsupUrl = jsonData['whatsapp_url'];
    youtubeUrl = jsonData['youtube_url'];
  }
}
