# DailyFocus

Aplicativo **Flutter** minimalista para **gestão de foco diário**.  
Permite registrar até **3 prioridades por dia** e consultar o **histórico dos últimos 7 dias**, com persistência local.  

---

## 🚀 Funcionalidades

- Registrar até **3 tarefas prioritárias** para o dia.  
- Marcar como concluídas ou redefinir.  
- Visualizar **histórico de 7 dias**.  
- Configurações de tema (light/dark mode).  
- Estrutura preparada para sincronização com API externa.  

---

## 🛠️ Arquitetura

O projeto segue princípios de **Clean Architecture / DDD** com separação em camadas:  

```
lib/
│── main.dart
│
│── core/                  # Núcleo do app
│   ├── router/            # Gerenciamento de rotas (GoRouter)
│   └── theme/             # Estilos e tema (Material 3)
│
│── features/daily_focus/  # Módulo principal
│   ├── domain/            # Entidades, Repositórios, Value Objects
│   ├── application/       # Controladores (casos de uso)
│   ├── infrastructure/    # Persistência (Hive), Models, Repos Impl
│   └── presentation/      # UI: Pages e Widgets
```

### Telas
- **Today:** até 3 tarefas diárias.  
- **History:** últimas 7 tarefas concluídas.  
- **Settings:** tema e sync mock.  

---

## 📦 Tecnologias Utilizadas

- **Flutter 3.x + Dart**  
- **Riverpod** (gerenciamento de estado)  
- **GoRouter** (navegação)  
- **Hive** (persistência local)  
- **Material 3** + modo escuro  
- **Dio** (opcional, preparado para chamadas HTTP)  

---

## ▶️ Como Rodar o Projeto

### 1. Preparação inicial (somente na primeira vez)
```bash
flutter create . --platforms=android,ios,web
flutter clean
```

### 2. Rodar localmente
```bash
flutter pub get
flutter run -d chrome   # ou substitua por dispositivo/emulador
```

---

## 🧪 Testes

Rodar todos os testes:
```bash
flutter test
```

Testes principais:
- `task_title_test.dart`: validações de **Value Object**.  
- `today_controller_test.dart`: fluxo de adicionar, alternar e resetar tarefas.  
- `today_page_widget_test.dart`: **smoke test** da UI da tela Today.  

---

## 📌 Próximos Passos

- Sincronização real com API externa.  
- Notificações push para lembrete das tarefas.  
- Exportar histórico completo.  
- Publicar app nas lojas (Google Play / App Store).  
