import 'dart:async';
import 'package:meta/meta.dart' show required;
import '../src/connection.dart';

/// Query and modify DOM storage.
class DOMStorageApi {
  final Client _client;

  DOMStorageApi(this._client);

  Stream<DomStorageItemAddedEvent> get onDomStorageItemAdded => _client.onEvent
      .where((event) => event.name == 'DOMStorage.domStorageItemAdded')
      .map((event) => DomStorageItemAddedEvent.fromJson(event.parameters));

  Stream<DomStorageItemRemovedEvent> get onDomStorageItemRemoved => _client
      .onEvent
      .where((event) => event.name == 'DOMStorage.domStorageItemRemoved')
      .map((event) => DomStorageItemRemovedEvent.fromJson(event.parameters));

  Stream<DomStorageItemUpdatedEvent> get onDomStorageItemUpdated => _client
      .onEvent
      .where((event) => event.name == 'DOMStorage.domStorageItemUpdated')
      .map((event) => DomStorageItemUpdatedEvent.fromJson(event.parameters));

  Stream<StorageId> get onDomStorageItemsCleared => _client.onEvent
      .where((event) => event.name == 'DOMStorage.domStorageItemsCleared')
      .map((event) => StorageId.fromJson(event.parameters['storageId']));

  Future<void> clear(StorageId storageId) async {
    await _client.send('DOMStorage.clear', {
      'storageId': storageId.toJson(),
    });
  }

  /// Disables storage tracking, prevents storage events from being sent to the client.
  Future<void> disable() async {
    await _client.send('DOMStorage.disable');
  }

  /// Enables storage tracking, storage events will now be delivered to the client.
  Future<void> enable() async {
    await _client.send('DOMStorage.enable');
  }

  Future<List<Item>> getDOMStorageItems(StorageId storageId) async {
    var result = await _client.send('DOMStorage.getDOMStorageItems', {
      'storageId': storageId.toJson(),
    });
    return (result['entries'] as List).map((e) => Item.fromJson(e)).toList();
  }

  Future<void> removeDOMStorageItem(StorageId storageId, String key) async {
    await _client.send('DOMStorage.removeDOMStorageItem', {
      'storageId': storageId.toJson(),
      'key': key,
    });
  }

  Future<void> setDOMStorageItem(
      StorageId storageId, String key, String value) async {
    await _client.send('DOMStorage.setDOMStorageItem', {
      'storageId': storageId.toJson(),
      'key': key,
      'value': value,
    });
  }
}

class DomStorageItemAddedEvent {
  final StorageId storageId;

  final String key;

  final String newValue;

  DomStorageItemAddedEvent(
      {@required this.storageId, @required this.key, @required this.newValue});

  factory DomStorageItemAddedEvent.fromJson(Map<String, dynamic> json) {
    return DomStorageItemAddedEvent(
      storageId: StorageId.fromJson(json['storageId']),
      key: json['key'],
      newValue: json['newValue'],
    );
  }
}

class DomStorageItemRemovedEvent {
  final StorageId storageId;

  final String key;

  DomStorageItemRemovedEvent({@required this.storageId, @required this.key});

  factory DomStorageItemRemovedEvent.fromJson(Map<String, dynamic> json) {
    return DomStorageItemRemovedEvent(
      storageId: StorageId.fromJson(json['storageId']),
      key: json['key'],
    );
  }
}

class DomStorageItemUpdatedEvent {
  final StorageId storageId;

  final String key;

  final String oldValue;

  final String newValue;

  DomStorageItemUpdatedEvent(
      {@required this.storageId,
      @required this.key,
      @required this.oldValue,
      @required this.newValue});

  factory DomStorageItemUpdatedEvent.fromJson(Map<String, dynamic> json) {
    return DomStorageItemUpdatedEvent(
      storageId: StorageId.fromJson(json['storageId']),
      key: json['key'],
      oldValue: json['oldValue'],
      newValue: json['newValue'],
    );
  }
}

/// DOM Storage identifier.
class StorageId {
  /// Security origin for the storage.
  final String securityOrigin;

  /// Whether the storage is local storage (not session storage).
  final bool isLocalStorage;

  StorageId({@required this.securityOrigin, @required this.isLocalStorage});

  factory StorageId.fromJson(Map<String, dynamic> json) {
    return StorageId(
      securityOrigin: json['securityOrigin'],
      isLocalStorage: json['isLocalStorage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'securityOrigin': securityOrigin,
      'isLocalStorage': isLocalStorage,
    };
  }
}

/// DOM Storage item.
class Item {
  final List<String> value;

  Item(this.value);

  factory Item.fromJson(List<dynamic> value) => Item(List<String>.from(value));

  List<String> toJson() => value;

  @override
  bool operator ==(other) =>
      (other is Item && other.value == value) || value == other;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value.toString();
}
