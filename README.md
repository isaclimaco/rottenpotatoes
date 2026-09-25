# 🍅 RottenPotatoes

Catálogo de filmes com CRUD, validações, ordenação e testes, desenvolvido com Ruby on Rails como parte do Homework 2 da disciplina de Engenharia de Software (UnB), seguindo o Capítulo 4 do livro *Engineering Software as a Service*.

## Funcionalidades

- Listar, criar, visualizar, editar e excluir filmes
- Validações: título obrigatório, classificação dentro de G / PG / PG-13 / R / NC-17 e data de lançamento obrigatória
- Ordenação por título ou por data de lançamento, clicando no cabeçalho da tabela (`?sort_by=title` ou `?sort_by=release_date`)
- Destaque visual da coluna que está ordenando a tabela

## Como foi implementado

- **Model (`app/models/movie.rb`):** o `Movie` herda de `ApplicationRecord` e concentra as regras de negócio (validações e a lista `RATINGS`).
- **Controller (`app/controllers/movies_controller.rb`):** a action `index` lê o parâmetro de ordenação em `params`, aceita apenas os campos permitidos (`title` e `release_date`) e usa o método `order` do ActiveRecord para ordenar a consulta.
- **Views (`app/views/movies/`):** escritas em Haml. Os cabeçalhos Título e Data de Lançamento são links criados com `link_to`, com os ids `title_header` e `release_date_header`.
- **CSS (`app/assets/stylesheets/application.css`):** estiliza o layout e aplica a classe de destaque na coluna ordenada.
- **Testes (`test/`):** testes em Minitest para as validações do model.

## Tecnologias

- Ruby 3.3.6 (gerenciado com rbenv)
- Rails 8.1.3.1
- SQLite3
- Haml
- Minitest

## Como instalar e executar

### 1. Pré-requisitos

- **Windows:** use o **WSL (Ubuntu)**. Abra o PowerShell, digite `wsl ~` e rode tudo lá dentro.
- **Linux ou Mac:** use o terminal normal.

> ⚠️ No WSL, deixe o projeto dentro de `~` (a pasta do Linux), e não em `/mnt/c/...`. Pelas pastas do Windows, o Rails fica muito lento.

### 2. Dependências do sistema (Ubuntu/WSL)

```bash
sudo apt update
sudo apt install -y build-essential libssl-dev libyaml-dev zlib1g-dev libffi-dev libreadline-dev sqlite3 libsqlite3-dev git curl
```

No Mac, o equivalente é `brew install sqlite3 libyaml openssl readline`.

### 3. Ruby 3.3.6 com rbenv

Pule este passo se `ruby --version` já mostrar `3.3.6`.

```bash
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
```

Se o seu terminal usa **bash**:

```bash
echo 'eval "$(~/.rbenv/bin/rbenv init - bash)"' >> ~/.bashrc && exec bash
```

Se o seu terminal usa **zsh**:

```bash
echo 'eval "$(~/.rbenv/bin/rbenv init - zsh)"' >> ~/.zshrc && exec zsh
```

Instale o Ruby (a compilação leva de 5 a 15 minutos):

```bash
rbenv install 3.3.6
rbenv global 3.3.6
ruby --version
```

O último comando deve mostrar `ruby 3.3.6`.

### 4. Baixar o projeto e instalar as gems

```bash
cd ~
git clone https://github.com/isaclimaco/rottenpotatoes.git
cd rottenpotatoes
bundle install
```

O `bundle install` instala o Rails e as demais gems nas versões exatas do projeto, lidas do `Gemfile.lock`.

### 5. Preparar o banco de dados

```bash
bin/rails db:migrate
bin/rails db:seed
```

O primeiro comando cria as tabelas. O segundo insere filmes de exemplo e pode ser executado várias vezes sem duplicar os registros.

### 6. Executar os testes

```bash
bin/rails test
```

Resultado esperado: `0 failures, 0 errors`.

### 7. Iniciar o servidor

```bash
bin/rails server
```

Acesse [http://localhost:3000/movies](http://localhost:3000/movies). Para desligar o servidor, use `Ctrl + C`.

## O que testar

- Clicar em **Título** e em **Data de Lançamento** para ordenar a tabela; a coluna escolhida fica destacada.
- Criar, visualizar, editar e excluir um filme.
- Tentar criar um filme sem título e conferir a mensagem de erro.
- Acessar `/movies?sort_by=qualquer`: a página deve abrir normalmente, sem erro.

## Problemas comuns

**`rails-8.1.3.1 requires Ruby version >= 3.2.0`**
O terminal está usando um Ruby antigo. Rode `exec zsh` (ou `exec bash`) e confira `ruby --version`. Se não aparecer 3.3.6, refaça o passo 3.

**`Network is unreachable` no `bundle install` (comum no WSL)**
Force o uso de IPv4 e rode o `bundle install` de novo:

```bash
echo 'precedence ::ffff:0:0/96  100' | sudo tee -a /etc/gai.conf
```

**WSL sem internet (`Destination Host Unreachable`)**
No PowerShell, crie ou edite o arquivo de configuração do WSL:

```powershell
notepad $env:USERPROFILE\.wslconfig
```

Cole o conteúdo abaixo e salve:

```ini
[wsl2]
networkingMode=mirrored
```

Depois reinicie o WSL e entre novamente com `wsl ~`:

```powershell
wsl --shutdown
```

**`command not found: rbenv`**
Rode `exec zsh` ou `exec bash`. Se não resolver, confira o passo 3.

**Porta 3000 em uso**

```bash
bin/rails server -p 3001
```

E acesse `localhost:3001/movies`.

## Autora

Isabela de Souza Clímaco — matrícula 190088931
