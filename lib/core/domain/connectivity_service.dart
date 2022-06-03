import 'package:connectivity_plus/connectivity_plus.dart';

abstract class ConnectivityService {
  Future<bool> isOnline();
}

class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity connectivity;

  ConnectivityServiceImpl({required this.connectivity});

  @override
  Future<bool> isOnline() async {
    final result = await connectivity.checkConnectivity();

    final isOnline = (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile);

    return isOnline;
  }
}
