enum AuthProviderType {
  restApi,
  firebaseGoogle,
}

class AuthUser {
  final AuthProviderType provider;
  final String displayName;
  final String email;
  final String? token;
  final String? photoUrl;

  const AuthUser({
    required this.provider,
    required this.displayName,
    required this.email,
    this.token,
    this.photoUrl,
  });
}

