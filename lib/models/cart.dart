import 'package:flutter/foundation.dart';
import 'package:flutter_provider_example_app/models/catalog.dart';

class CartModel extends ChangeNotifier {
  late CatalogModel _catalog;

  /// 선택한 아이템의 id
  final List<int> _itemIds = [];

  CatalogModel get catalog => _catalog;

  /// CatalogModel 저장하는데 ChangeNotifierProxyProvider 처음에 변경 되고 바뀌지 않아서
  /// 굳이 이렇게 해야 되나? 이거 같은 경우는 그냥 상수로 써도 될듯. 진짜 안 바뀐다는 가정 하에!
  /// 근데 바뀔 가능성이 있으면 이렇게 쓰는게 맞을듯...
  set catalog(CatalogModel newCatalog) {
    _catalog = newCatalog;
    notifyListeners();
  }

  /// 선택한 아이템의 id 리스트로 아이템 리스트 가져오는 로직
  List<Item> get items => _itemIds.map((id) => _catalog.getById(id)).toList();

  /// 전체 금액 계산
  int get totalPrice =>
      items.fold(0, (total, current) => total + current.price);

  /// 장바구니에 아이템 담기
  void add(Item item) {
    _itemIds.add(item.id);
    /// notifyListeners 이거 넣어줘야 값이 바뀌면 구독하는 입장에서 바뀐거 알 수 있음!!
    notifyListeners();
  }

  void remove(Item item) {
    _itemIds.remove(item.id);
    notifyListeners();
  }
}
