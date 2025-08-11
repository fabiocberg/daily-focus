# DailyFocus

App minimalista para gerenciar **3 prioridades do dia** e ver o histórico de 7 dias.

## Stack
- Flutter 3.x + Dart
- Riverpod, GoRouter
- Hive (persistência local), Dio (opcional para API)
- Material 3 + dark mode

## Rodando localmente
```bash
flutter pub get
flutter run -d chrome # ou dispositivo/emulador
```

## Testes
```bash
flutter test
```
- `task_title_test.dart`: validações do VO
- `today_controller_test.dart`: fluxo add/toggle/reset com repo fake
- `today_page_widget_test.dart`: smoke test da tela Today

## Estrutura (resumo)
```
lib/
  core/
    router/
    theme/
  features/daily_focus/
    presentation/
      pages/
      widgets/
    application/
    domain/
      entities/
      repos/
      value_objects/
    infrastructure/
      datasources/
      models/
      repos/
```

## Telas
- Today (até 3 tarefas)
- History (últimos 7 dias)
- Settings (tema e sync mock)

## Licença
MIT