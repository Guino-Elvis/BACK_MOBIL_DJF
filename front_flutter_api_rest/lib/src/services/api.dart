class ConfigApi {
  static const String appName = "Colegio";
  static const String apiURL = "192.168.0.105:9090";

  static String buildUrl(String endpoint) {
    return 'http://$apiURL$endpoint';
  }
  
 
}
