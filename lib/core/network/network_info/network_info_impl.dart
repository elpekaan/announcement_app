import 'package:ciu_announcement/core/network/network_info/base/base_network_info.dart';

class NetworkInfoImpl implements BaseNetworkInfo{
  @override
  Future<bool> get isConnected async {
    return true;
  }
}