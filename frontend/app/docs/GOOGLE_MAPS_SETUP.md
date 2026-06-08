# Configuracao do Google Maps

Este app usa `google_maps_flutter`. Configure chaves separadas para Android e iOS. Não coloque chaves reais em arquivos versionados.

## APIs para habilitar

No Google Cloud Console, habilite:

- Maps SDK for Android
- Maps SDK for iOS

Também deixe billing ativo no projeto Google Cloud. Sem billing e APIs habilitadas, o mapa não carrega.

O projeto iOS usa `platform :ios, '14.0'` no `ios/Podfile`, conforme a configuração atual recomendada para o pacote Flutter do Google Maps.

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

## Onde colocar as chaves localmente

Android:

1. Copie `android/local.properties.example` para `android/local.properties`, preservando o `flutter.sdk` real que o Flutter já gerou.
2. Adicione:

```properties
MAPS_API_KEY=SUA_CHAVE_ANDROID
```

O Gradle injeta essa chave no `AndroidManifest.xml` usando o marcador `${MAPS_API_KEY}`.

iOS:

1. Copie `ios/Flutter/GoogleMapsKeys.xcconfig.example` para `ios/Flutter/GoogleMapsKeys.xcconfig`.
2. Adicione:

```text
GOOGLE_MAPS_API_KEY=SUA_CHAVE_IOS
```

O `Info.plist` recebe `$(GOOGLE_MAPS_API_KEY)` e o `AppDelegate.swift` passa esse valor para `GMSServices.provideAPIKey`.

## Restrições e segurança

- Use chaves separadas para Android e iOS.
- Sempre aplique uma restrição de aplicação e uma restrição de API.
- A chave Android deve ficar restrita a package name + SHA-1 e Maps SDK for Android.
- A chave iOS deve ficar restrita ao Bundle ID e Maps SDK for iOS.
- Revise uso e billing no Google Cloud Console.
- Se uma chave vazar, rotacione ou revogue a chave e publique uma nova versão do app.

## Referências oficiais

- Google Maps for Flutter setup: https://developers.google.com/maps/flutter-package/config
- `google_maps_flutter` package: https://pub.dev/packages/google_maps_flutter
- Google Maps Platform API security best practices: https://developers.google.com/maps/api-security-best-practices
