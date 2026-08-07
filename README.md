## ❄️ NixOS & Quickshell Configs

Uma configuração **NixOS** modular, minimalista e focada em performance, gerenciada via **Flakes** e que **não faz o uso do Home-Manager**. O grande destaque é uma shell própria, com diversos recursos e totalmente customizada utilizando o toolkit **Quickshell**.

> ⚠️ **AVISO:** O suporte a múltiplos monitores ainda não foi testado.

---

## 🚀 Filosofia do Projeto

Pensado para um fluxo de trabalho dinâmico, visualmente limpo e de baixo consumo de recursos, este repositório entrega um sistema pronto para uso produtivo. A arquitetura foi desenhada para que a adição ou remoção de novos usuários e troca de ambientes de trabalho seja feita apenas alternando chaves booleanas.

### ✨ Conteúdo

* **Arquitetura Modular:** Crie e adicione novos perfis de usuários na pasta `users`, ative-os no arquivo de configurações globais, construa ambientes de trabalho ou bundles de aplicativos e ative-os no arquivo principal do usuário.

* **Shell Própria (Quickshell):** Totalmente escrita em QML, a shell conta com uma tela de Splash na inicialização e carregamento customizado de wallpaper, Lockscreen integrada via PAM, notificações Stack com cores de bordas dinâmicas em toda shell, controle de volume/brilho, integração com o gammastep com a possibilidade de seleção de diferentes valores de temperatura da cor da tela, suporte a menu de Tray e de aplicativos, sessão, clipboard, bluetooth, network e de customização com alternadores de temas e wallpapers.

---

## 📁 Estrutura do Repositório

A árvore do projeto separa a base do sistema e as configurações específicas de usuário:

```text
├── flake.nix                       # Entrada do ecossistema (Inputs/Outputs de pacotes)
├── configurations/                 # Configurações globais e de hardware para o sistema NixOS
└── users/                          # Pasta de usuários do sistema
    └── mateus/                     # Configurações do usuário, bundles de apps e dotfiles
        └── mateus.nix              # Configurações do usuário e gerenciamento de bundles ativos
        └── bundles/                # Pacotes de aplicativos e configurações de apps
        └── home/                   # Arquivos da pasta home do user
            └── .config/            # Configurações pessoais de apps (Alacritty, Neovim, etc.)
                └── .quickshell/    # Arquivos da shell customizada
```
