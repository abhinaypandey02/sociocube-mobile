String getMeURL(String username, bool clean) {
  return '${clean ? '' : 'https://'}$username.sociocube.me';
}
