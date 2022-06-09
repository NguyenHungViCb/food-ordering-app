import 'dart:convert';

import 'package:app/models/api/base_response.dart';
import 'package:app/models/order/orders.dart';
import 'package:app/share/constants/app_config.dart';
import 'package:app/share/constants/storage.dart';
import 'package:app/utils/api_service.dart';
import 'package:socket_io_client/socket_io_client.dart';

class OrderService {
  final ResponseOrder _nullSafety = ResponseOrder("0", "0", "", "", "", "", "",
      "", "0", "", "", [OrderDetail('', '', '', 0, "0", '', '')]);
  get nullSafety {
    return _nullSafety;
  }

  fetchOnGoingOrder() async {
    try {
      var response = await ApiService().get('/api/orders/ongoing');
      if (response.statusCode == 200) {
        var decoded = responseFromJson(response.body).data;
        return ResponseOrder.fromJson(decoded);
      }
      return _nullSafety;
    } catch (e) {
      return _nullSafety;
    }
  }

  cancelOrder() async {
    try {
      var response = await ApiService()
          .put("/api/orders/status/update", {"status": "canceled"});
      if (response.statusCode == 200) {
        return true;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

class OrderSocket {
  Socket? _socket;
  static final OrderSocket _instance = OrderSocket._internal();

  factory OrderSocket() {
    return _instance;
  }

  OrderSocket._internal();

  _initialize() async {
    print("initialized");
    String? savedToken = await GlobalStorage.read(key: "tokens");
    if (savedToken != null) {
      var decoded = json.decode(savedToken);
      _instance._socket = io(
          baseURL,
          OptionBuilder()
              .setTransports(['websocket'])
              .disableAutoConnect()
              .setExtraHeaders({"authorization": "Bearer " + decoded['token']})
              .build());
    }
  }

  Future<OrderSocket> connect() async {
    if (_socket == null) {
      await _initialize();
      _socket!.connect();
    } else {
      if (_socket!.disconnected == true) {
        _socket!.connect();
      }
    }
    return _instance;
  }

  Future<OrderSocket> onConnect([Function? cb]) async {
    _instance._socket!.on("connect", (data) {
      print("connected");
      if (cb != null) {
        cb(data);
      }
    });
    return _instance;
  }

  Future<OrderSocket> onStatusUpdate(Function cb) async {
    _instance._socket!.on("ORDER_UPDATE_STATUS", (status) {
      cb(status);
    });
    return _instance;
  }

  Future<OrderSocket> cancel([Function? cb]) async {
    print("cancelled");
    _instance._socket!.close();
    _instance._socket!.destroy();
    if (cb != null) {
      cb();
    }
    return _instance;
  }
}

class OrderProgressService {
  Map<String, double?> status = {
    "pending": 0,
    "confirmed": 0,
    "processing": 0,
    "shipping": 0,
    "succeeded": 0,
    "cancelled": 0
  };

  Map<String, double?> getStatus(ResponseOrder order) {
    orderStatus.forEach((key, value) {
      if (orderStatus[order.status] != null) {
        if (value < (orderStatus[order.status] as int)) {
          status[key] = 100;
        } else if (value > (orderStatus[order.status] as int)) {
          status[key] = 0;
        } else {
          status[key] = null;
        }
      }
    });
    return status;
  }
}
