# Primeiros passos

## Setup

### Requisitos

- Flutter **v2.10** *Null Safety*

- Dart **v2.16.1**

- Slidy **v3.2.2+2** *Null Safety*

- Mobx **v2.0.6+1** *Null Safety*

- Flutter Modular **v4.4.0** *Null Safety*

### Instalação


## Comandos

`git add .`: Adicionar todos os arquivos/diretórios ao commit que irá realizar;

`git commit -m "minha mensagem de commit"`: Comitar os arquivos adicionados informando uma mensagem;

`git push origin main`: Enviar arquivos/diretórios comitados para o repositório remoto `main`. Caso queira subir para outra branch, pasta apenas trocar a palavra main. Ex.: `git push origin feat/OSI-2`;

`git pull origin main`: Atualizar repositório local de acordo com o repositório remoto `main` (para atualizar outra branch, basta trocar a palavra main). Se estiver trabalhando em uma outra branch, você pode utilizar este comando também para atualizar o seu código com as novas features que foram mergeadas para a principal, basta apenas estar com checkout na sua branch;

`git checkout origin feat/OSI-2`: Navegar entre as branches, este em específico para a branch feat/OSI-2;

`git checkout -b feat/OSI-3`: Criar nova branch localmente;

`git fetch`: Buscar as alterações e sincroniza o que você possui no repositório local com o repositório remoto;

**Tipo de ramificação**

O fluxo de trabalho da ramificação de recursos pressupõe um repositório central (`main`), e a ramificação principal representa o histórico oficial do projeto. Em vez de fazer o commit direto na ramificação principal `main`, os desenvolvedores criam uma nova ramificação sempre que começam a trabalhar em um novo recurso. As ramificações dos recursos deve ter nome descritivo, seguindo este padrão:  `feat/OSI-numero_do_board`. As branches podem ser classificadas em:

`feat`: é usada para adicionar uma nova funcionalidade;

`fix`: é usada para corrigir algum bug;

`refactor`: se trata de alguma refatoração ou atualização de biblioteca.

 A ideia é dar um objetivo claro e bastante focado a cada ramificação.
