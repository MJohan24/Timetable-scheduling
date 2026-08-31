abstract interface class AccessTokenProvider {
  Future<String?> getAccessToken({bool forceRefresh = false});
}
