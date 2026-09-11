# ❄️ NixOS & Quickshell Configs

Uma configuração **NixOS** modular, minimalista e focada em desempenho, gerenciada inteiramente por **Nix Flakes** e **sem o uso do Home Manager**.

O principal destaque do projeto é uma **shell própria desenvolvida em QML com Quickshell**, projetada para oferecer uma experiência de desktop completa, visualmente consistente, de baixo consumo de recursos computacionais e personalizável.

> [!WARNING]
> O suporte a **múltiplos monitores ainda não foi testado**.

---

## ✨ Destaques

* **NixOS + Flakes** — configuração declarativa e reprodutível do sistema.
* **Sem Home Manager** — o gerenciamento do ambiente do usuário é feito por um módulo próprio.
* **Arquitetura modular** — sistemas, usuários, ambientes e bundles são separados em módulos independentes.
* **Configuração por flags** — ambientes e componentes podem ser ativados ou desativados por opções booleanas.
* **Dotfiles gerenciados declarativamente** — arquivos de configuração são vinculados a partir de um modulo criador de symlinks, sem depender do Home Manager.
* **Shell própria em Quickshell** — shell desenvolvida em QML, integrada ao restante do ambiente.
* **Múltiplos ambientes** — suporte a diferentes compositores e ambientes, permitindo alternar a configuração conforme a necessidade.
* **Foco em desempenho** — componentes escolhidos e organizados para manter um ambiente enxuto e responsivo.

---

## 🧭 Filosofia do Projeto

O projeto foi pensado para oferecer um ambiente de trabalho **Limpo, personalizável e de baixo consumo de recursos**, sem abrir mão de funcionalidades normalmente encontradas em desktop environments completos.

A arquitetura busca manter uma separação clara entre:

* **Configuração do sistema**
* **Configuração de usuários**
* **Bundles de aplicativos**
* **Ambientes gráficos**
* **Dotfiles**
* **Shell e componentes visuais**

A ideia é que adicionar um novo usuário, criar um novo ambiente ou alternar entre diferentes conjuntos de aplicativos exija apenas alterações declarativas nas respectivas opções.
Em vez de centralizar toda a configuração em um único arquivo, cada componente possui sua própria responsabilidade e pode ser habilitado conforme a necessidade.

---

## 🖥️ Quickshell

A shell é o principal componente visual do projeto e foi desenvolvida inteiramente em **QML utilizando Quickshell**.

Entre os recursos implementados estão:

### 🎨 Interface e aparência

* Tela de boas-vindas durante a inicialização.
* Transições suaves entre wallpapers utilizando **double buffering**.
* Sistema de temas e wallpapers.
* Bordas e elementos visuais sincronizados em toda a interface.
* Cores dinâmicas baseadas no estado dos componentes.

### 🔒 Segurança e sessão

* **Lockscreen integrada ao PAM**.
* Controle da sessão diretamente pela shell.

* **Opção de SoftLock (rfkill) nos módulos de bluetooth e network**.
* Desativação de transmissores de ondas de rádio.

### 🔔 Notificações

* Sistema de notificações em formato **Stack**.
* Cores das bordas definidas dinamicamente de acordo com a **prioridade da notificação**.
* Integração visual das notificações com o restante da shell.

### 🔊 Hardware e controle do sistema

* Controle de **mídia**.
* Controle de **idle**.
* Controle de **volume**.
* Controle de **brilho**.
* Integração com **Gammastep**.
* Configuração personalizada da **temperatura de cor da tela**.

### 🧰 Menus e utilitários

* Menu de aplicativos.
* Menu de sessão.
* Indicador de workspaces (Niri).
* Menu de **Tray**.
* Clipboard.
* Bluetooth.
* Network.
* Relógio e Calendário.
* Controles e alternadores para personalização do ambiente.

---

## 🧩 Arquitetura

A configuração é organizada em camadas, permitindo que cada parte do sistema evolua de forma independente.

```text
System
├── Configurações do sistema
│   └── configurations/
│
└── Usuários
    └── users/
        └── <usuário>/
            ├── <usuário>.nix
            ├── bundles/
            └── home/

```

Essa estrutura permite combinar diferentes componentes sem duplicar configurações.
Por exemplo, um usuário pode utilizar um compositor específico, uma shell minimalista ou a shell baseada em Quickshell simplesmente ativando ou desativando os respectivos bundles.

### `flake.nix`

Ponto de entrada do projeto.
Define os **inputs** utilizados pelo sistema e os **outputs** responsáveis por construir as configurações NixOS.

### `configurations/`

Contém as configurações globais do sistema, incluindo:

* configuração principal do NixOS;
* configuração de hardware;
* módulos e opções compartilhadas entre os usuários.

### `users/`

Agrupa todas as configurações específicas dos usuários do sistema.
Cada usuário possui seu próprio diretório, permitindo manter configurações independentes e reutilizáveis.

### `users/<usuário>/<usuário>.nix`

Define as configurações do usuário e determina quais **bundles** estarão ativos.
A seleção de ambientes e componentes é feita de maneira declarativa, principalmente através de opções booleanas.

### `bundles/`

Responsável por agrupar funcionalidades relacionadas.

Os bundles podem representar:

* ambientes gráficos;
* compositores;
* shells;
* ferramentas;
* conjuntos específicos de aplicativos.

Isso permite, por exemplo, habilitar **Niri**, **Sway**, **GNOME**, **KDE**, uma shell minimalista ou a shell baseada em **Quickshell** sem espalhar essa lógica pelo restante da configuração.

### `home/`

Representa a estrutura do `$HOME` gerenciada pelo projeto.
Os arquivos presentes nessa árvore são utilizados como origem para os **dotfiles** do usuário.

---

## 🏠 Gerenciamento de Dotfiles

O projeto **não utiliza Home Manager**.
Em vez disso, foi desenvolvido um módulo próprio para gerenciar os arquivos do `$HOME` de maneira declarativa.
A estrutura em:

```text
users/<usuário>/home/
```

funciona como uma representação dos arquivos que devem existir no ambiente do usuário.
A instalação dos dotfiles é controlada pelo próprio sistema NixOS, permitindo que a configuração acompanhe a mesma abordagem declarativa utilizada no restante do sistema.
Isso mantém os arquivos de configuração versionados junto ao restante da infraestrutura.

---

## 🚀 Fluxo de Configuração

A lógica geral do projeto segue uma abordagem simples:

```text
flake.nix
    │
    ▼
Configuração NixOS
    │
    ▼
Usuário
    │
    ├── Bundles
    │   ├── Ambiente
    │   ├── Shell
    │   └── Ferramentas
    │
    └── Home / Dotfiles
            │
            ▼
       Ambiente final
```

A ativação ou desativação de componentes é determinada pelas opções declaradas na configuração do usuário.
Dessa forma, o mesmo usuário pode ter diferentes combinações de ambientes sem precisar manter cópias distintas da configuração.

## 📌 Observações

Esta configuração foi desenvolvida principalmente para uso pessoal, portanto algumas decisões arquiteturais refletem as minhas necessidades e preferências.
Ainda assim, a estrutura modular foi pensada para facilitar a adaptação do projeto para outros usuários, ambientes e combinações de software.
