# 🚀 CI/CD - Deploy Web com Firebase Hosting

## Visão Geral

Este projeto utiliza **GitHub Actions** para automatizar o build e deploy da aplicação web no **Firebase Hosting**.

### Fluxo da Pipeline

```
┌─────────────────────────────────────────────────────────────────┐
│                         PUSH / PR                               │
└─────────────────────────┬───────────────────────────────────────┘
                          │
                          ▼
              ┌───────────────────────┐
              │   Build & Test Job    │
              │  • flutter pub get    │
              │  • build_runner       │
              │  • flutter analyze    │
              │  • flutter test       │
              │  • flutter build web  │
              └───────────┬───────────┘
                          │
            ┌─────────────┼─────────────┐
            ▼             ▼             ▼
        ┌────────┐   ┌──────────┐  ┌──────────┐
        │  PR    │   │  Main    │  │ Dispatch │
        │Preview │   │  Deploy  │  │ Manual   │
        └────────┘   └──────────┘  └──────────┘
```

## 📋 Pré-requisitos

### 1. Gerar a Service Account do Firebase

Você precisa criar uma **Firebase Service Account** para autenticação:

1. Acesse o [Firebase Console](https://console.firebase.google.com/)
2. Selecione o projeto: **adaptative-user-interface**
3. Vá em **⚙️ Settings** → **Service accounts**
4. Clique em **Generate new private key**
5. Baixe o arquivo JSON gerado

### 2. Adicionar Secret no GitHub

1. Acesse: `https://github.com/{seu-usuario}/{seu-repo}/settings/secrets/actions`
2. Clique em **New repository secret**
3. Adicione:
   - **Name:** `FIREBASE_SERVICE_ACCOUNT`
   - **Value:** Cole **todo o conteúdo** do arquivo JSON da service account

## 🔀 Triggers da Pipeline

| Evento | Comportamento |
|--------|---------------|
| `push` para `main` | Build + Testes + Deploy para produção (canal `live`) |
| `pull_request` para `main` | Build + Testes + Preview channel + Comentário no PR com URL |
| `workflow_dispatch` | Deploy manual (escolha preview ou production) |

## 📁 Estrutura de Arquivos

```
.github/
└── workflows/
    └── deploy-web.yml       # Pipeline principal

firebase.json                # Configuração do Firebase Hosting
.firebaserc                  # Mapeamento do projeto Firebase
```

## ⚙️ Configuração do Firebase Hosting

O `firebase.json` está configurado com:

- **Source:** `.` (raiz do projeto, o Flutter build gera os arquivos em `build/web/`)
- **Rewrites:** Toda rota direciona para `/index.html` (SPA)
- **Cache headers:**
  - `.js` e `.css`: 1 ano
  - Imagens: 24 horas
- **Security headers:** X-Content-Type-Options, X-Frame-Options, X-XSS-Protection

## 🛠️ Comandos Úteis

### Testar localmente antes do deploy

```bash
# Build web
flutter build web --release --wasm

# Testar localmente com Firebase
firebase emulators:start --only hosting

# Deploy manual (se tiver Firebase CLI instalado)
firebase deploy --only hosting
```

### Verificar status do workflow

```bash
# No navegador:
https://github.com/{seu-usuario}/{seu-repo}/actions

# Filtrar pelo workflow "Deploy Web - Firebase Hosting"
```

## 🐛 Troubleshooting

### Erro: "Firebase service account not found"
- Verifique se o secret `FIREBASE_SERVICE_ACCOUNT` está configurado corretamente
- O valor deve ser o JSON completo da service account

### Erro: "Build failed"
- Verifique os logs do job `build-and-test`
- Execute `flutter analyze` e `flutter build web` localmente para reproduzir

### Preview channel não aparece no PR
- Verifique se o job `preview-pr` rodou com sucesso
- O preview só é criado em PRs direcionados à `main`

## 📊 Versão do App

A versão atual é controlada no `pubspec.yaml`:
```yaml
version: 1.0.5
```

Para atualizar:
```bash
flutter pub version --patch   # 1.0.5 -> 1.0.6
flutter pub version --minor   # 1.0.5 -> 1.1.0
flutter pub version --major   # 1.0.5 -> 2.0.0
```
