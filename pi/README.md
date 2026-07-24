# 🎯 Pi — Dotfiles de Configuração

Configurações personalizadas para o [pi coding agent](https://pi.dev).

## Estrutura

```
~/.dotfiles/pi/
├── install.sh            # Script de instalação
├── README.md             # Este arquivo
├── settings.json         # Configurações globais do pi
├── themes/
│   ├── tokyo-night.json  # Tema Tokyo Night
│   └── nord.json         # Tema Nord
└── extensions/
    ├── effort.ts         # Comando /effort (níveis de pensamento)
    └── statusline.ts     # Statusline melhorada com tokens
```

## Instalação em outra máquina

```bash
# 1. Clonar dotfiles (ajuste o caminho conforme seu setup)
git clone <seu-repo-dotfiles> ~/.dotfiles

# 2. Instalar as configs do pi
~/.dotfiles/pi/install.sh

# 3. Iniciar o pi (ou usar /reload se já estiver rodando)
pi
```

### Opções do install.sh

| Flag | Descrição |
|------|-----------|
| (sem flags) | Instala arquivos que **não existem** ainda |
| `--force` ou `-f` | Sobrescreve arquivos existentes |
| `--dry-run` | Mostra o que seria copiado sem copiar |

## ⚠️ Segurança

**NENHUMA chave de API, token ou credencial está incluída nestes arquivos.**
- `auth.json` (credenciais OAuth) → ❌ **NÃO versionado**
- `models-store.json` (cache de modelos) → ❌ **NÃO versionado**
- `sessions/` (histórico de sessões) → ❌ **NÃO versionado**

Em uma máquina nova, você precisará autenticar via `/login` ou configurar
suas chaves de API via variáveis de ambiente (`ANTHROPIC_API_KEY`, etc.).

## Arquivos manualmente excluídos dos dotfiles

Estes arquivos ficam em `~/.pi/agent/` mas **não** devem ser versionados:

| Arquivo | Motivo |
|---------|--------|
| `auth.json` | Tokens de autenticação OAuth |
| `models-store.json` | Cache local de catálogo de modelos |
| `trust.json` | Decisões de confiança de projetos (caminhos locais) |
| `keybindings.json` | Atalhos de teclado personalizados (se existir) |
| `sessions/` | Histórico de sessões |

## Personalização

- **Alternar tema**: use `/settings` dentro do pi ou edite `settings.json`
- **Hot reload**: edite um arquivo de tema enquanto o pi roda — as cores se aplicam na hora
- **Extensões**: use `/reload` para recarregar extensões modificadas
