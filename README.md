# math_trainer_app

Тренажёр математики. Android, iOS и web подключаются к Firebase-проекту `math-traineer`. Ключи в git не хранятся. Без `lib/core/firebase/firebase_keys.dart` проект не компилируется: его импортируют `firebase_options.dart` и `main.dart`.

## Ключи Firebase

Нужны четыре файла. Все они перечислены в `.gitignore`.

| Файл | Откуда |
| --- | --- |
| `lib/core/firebase/firebase_keys.dart` | скопировать пример и заполнить константы |
| `android/app/google-services.json` | скачать в настройках Android-приложения |
| `ios/Runner/GoogleService-Info.plist` | скачать в настройках iOS-приложения |
| `ios/Flutter/FirebaseKeys.xcconfig` | собрать из iOS-клиента Google |

Консоль проекта: https://console.firebase.google.com/project/math-traineer/settings/general

Приложения уже заведены. Новые создавать не нужно. Android package и iOS bundle id — `com.agidel2012.math`.

### 1. Dart

```bash
cp lib/core/firebase/firebase_keys.example.dart lib/core/firebase/firebase_keys.dart
```

Заполните `firebase_keys.dart`. Пустые строки из примера оставлены специально: файл коммитить нельзя.

Значения берутся из скачанных конфигов и карточки Web app в тех же настройках проекта.

| Константа | Источник |
| --- | --- |
| `projectId` | `project_info.project_id` в `google-services.json` или `PROJECT_ID` в plist |
| `messagingSenderId` | `project_info.project_number` или `GCM_SENDER_ID` |
| `storageBucket` | `project_info.storage_bucket` или `STORAGE_BUCKET` |
| `authDomain` | Web app, обычно `<projectId>.firebaseapp.com` |
| `iosBundleId` | `BUNDLE_ID` в plist |
| `androidApiKey` | `api_key.current_key` в `google-services.json` |
| `iosApiKey` | `API_KEY` в plist |
| `webApiKey` | `apiKey` в конфиге Web app |
| `androidAppId` | `client_info.mobilesdk_app_id` |
| `iosAppId` | `GOOGLE_APP_ID` |
| `webAppId` | `appId` в конфиге Web app |
| `androidClientId` | OAuth-клиент `client_type` 1 в `google-services.json` или `ANDROID_CLIENT_ID` |
| `iosClientId` | `CLIENT_ID` в plist |
| `serverClientId` | OAuth-клиент `client_type` 3 (Web client) |
| `iosReversedClientId` | `REVERSED_CLIENT_ID` в plist |

`firebase_options.dart` и вход через Google читают только этот файл.

### 2. Android

В настройках проекта откройте Android-приложение `com.agidel2012.math` и скачайте `google-services.json` в `android/app/`. Плагин Google Services читает его при сборке. SHA-1 debug-ключа уже привязан к этому приложению; для локальной debug-сборки новый отпечаток добавлять не нужно.

### 3. iOS

Скачайте `GoogleService-Info.plist` того же iOS-приложения и положите его в `ios/Runner/`.

Рядом с этим создайте `ios/Flutter/FirebaseKeys.xcconfig`. `Info.plist` подставляет эти переменные в URL scheme и `GIDClientID`; сами идентификаторы в plist не пишите.

```
GID_CLIENT_ID = <CLIENT_ID из GoogleService-Info.plist>
REVERSED_CLIENT_ID = <REVERSED_CLIENT_ID из GoogleService-Info.plist>
```

`Debug.xcconfig` и `Release.xcconfig` уже подключают этот файл. После замены ключей пересоберите iOS-проект.

### Проверка

Файл с ключами не должен появляться в `git status`. Если он виден, его путь не совпадает с правилом в `.gitignore`.
