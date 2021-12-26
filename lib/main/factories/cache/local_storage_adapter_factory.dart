import 'package:localstorage/localstorage.dart';

import '/data/cache/cache.dart';
import '/infra/cache/cache.dart';

CacheStorage makeLocalStorageAdapter() => LocalStorageAdapter(localStorage: LocalStorage('appname'));