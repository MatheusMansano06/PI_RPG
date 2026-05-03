# Google Maps Setup

Este app usa `google_maps_flutter`. Configure chaves separadas para Android, iOS e Web. Nao coloque chaves reais em arquivos versionados.

## APIs para habilitar

No Google Cloud Console, habilite:

- Maps SDK for Android
- Maps SDK for iOS
- Maps JavaScript API

Tambem deixe billing ativo no projeto Google Cloud. Sem billing e APIs habilitadas, o mapa nao carrega.

O projeto iOS usa `platform :ios, '14.0'` no `ios/Podfile`, conforme a configuracao atual recomendada para o pacote Flutter do Google Maps.

## Chave Android

1. Abra Google Cloud Console > APIs & Services > Credentials.
2. Crie uma API key chamada, por exemplo, `RPG Campus I Android`.
3. Em Application restrictions, selecione Android apps.
4. Adicione:
   - Package name: `com.example.projeto_integrador_jogo` enquanto o app estiver com esse `applicationId`.
   - SHA-1 certificate fingerprint do keystore usado para debug/release.
5. Em API restrictions, selecione Restrict key.
6. Permita somente Maps SDK for Android.
7. Salve.

Para obter o SHA-1 debug:

```bash
cd android
./gradlew signingReport
```

## Chave iOS

1. Abra Google Cloud Console > APIs & Services > Credentials.
2. Crie uma API key chamada, por exemplo, `RPG Campus I iOS`.
3. Em Application restrictions, selecione iOS apps.
4. Adicione o Bundle ID do app. Hoje ele vem de `PRODUCT_BUNDLE_IDENTIFIER` no Xcode.
5. Em API restrictions, selecione Restrict key.
6. Permita somente Maps SDK for iOS.
7. Salve.

## Chave Web

1. Abra Google Cloud Console > APIs & Services > Credentials.
2. Crie uma API key chamada, por exemplo, `RPG Campus I Web`.
3. Em Application restrictions, selecione Websites.
4. Em Website restrictions, adicione os HTTP referrers permitidos.
5. Para desenvolvimento local, adicione:

```text
http://localhost:*/*
```

6. Para producao, adicione somente os dominios reais do app.
7. Em API restrictions, selecione Restrict key.
8. Permita somente Maps JavaScript API.
9. Salve.

## Onde colocar as chaves localmente

Android:

1. Copie `android/local.properties.example` para `android/local.properties`, preservando o `flutter.sdk` real que o Flutter ja gerou.
2. Adicione:

```properties
MAPS_API_KEY=SUA_CHAVE_ANDROID
```

O Gradle injeta essa chave no `AndroidManifest.xml` usando o placeholder `${MAPS_API_KEY}`.

iOS:

1. Copie `ios/Flutter/GoogleMapsKeys.xcconfig.example` para `ios/Flutter/GoogleMapsKeys.xcconfig`.
2. Adicione:

```text
GOOGLE_MAPS_API_KEY=SUA_CHAVE_IOS
```

O `Info.plist` recebe `$(GOOGLE_MAPS_API_KEY)` e o `AppDelegate.swift` passa esse valor para `GMSServices.provideAPIKey`.

Web/Chrome:

1. Abra `web/index.html`.
2. Substitua somente no seu ambiente local o placeholder:

```html
<script src="https://maps.googleapis.com/maps/api/js?key=SUA_CHAVE_WEB_AQUI"></script>
```

por:

```html
<script src="https://maps.googleapis.com/maps/api/js?key=SUA_CHAVE_WEB"></script>
```

Use uma chave Web separada, restrita por HTTP referrer. O erro `TypeError: Cannot read properties of undefined (reading 'maps')` normalmente acontece quando `window.google.maps` nao foi carregado antes do mapa Flutter Web iniciar.

## Restricoes e seguranca

- Use chaves separadas para Android, iOS e Web.
- Sempre aplique uma restricao de aplicacao e uma restricao de API.
- A chave Android deve ficar restrita a package name + SHA-1 e Maps SDK for Android.
- A chave iOS deve ficar restrita ao Bundle ID e Maps SDK for iOS.
- A chave Web deve ficar restrita por HTTP referrer e Maps JavaScript API.
- Revise uso e billing no Google Cloud Console.
- Se uma chave vazar, rotacione ou revogue a chave e publique uma nova versao do app.

## Referencias oficiais

- Google Maps for Flutter setup: https://developers.google.com/maps/flutter-package/config
- `google_maps_flutter` package: https://pub.dev/packages/google_maps_flutter
- Google Maps Platform API security best practices: https://developers.google.com/maps/api-security-best-practices
