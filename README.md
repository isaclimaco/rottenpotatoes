
# 🍅 RottenPotatoes

Catálogo de filmes com CRUD, validações, ordenação e testes, desenvolvido com Ruby on Rails na disciplina de Engenharia de Software (UnB), seguindo o livro *Engineering Software as a Service* (ESaaS):

- **Homework 2 (Capítulo 4):** aplicação Rails com CRUD, validações e ordenação de colunas.
- **Tarefa de BDD:** cenários Cucumber + Capybara que descrevem e testam o comportamento da aplicação do ponto de vista do usuário.

## Funcionalidades

- Listar, criar, visualizar, editar e excluir filmes
- Validações: título obrigatório, classificação dentro de G / PG / PG-13 / R / NC-17 e data de lançamento obrigatória
- Ordenação por título ou por data de lançamento, clicando no cabeçalho da tabela (`?sort_by=title` ou `?sort_by=release_date`)
- Destaque visual da coluna que está ordenando a tabela
- Formulário de novo filme já preenchido com a data de hoje
- Busca no TMDb (The Movie Database), apenas o *sad path*: ao buscar um filme, a aplicação avisa que ele não foi encontrado (`'Título' was not found in TMDb.`)

## Como foi implementado

- **Model (`app/models/movie.rb`):** o `Movie` herda de `ApplicationRecord` e concentra as regras de negócio (validações e a lista `RATINGS`).
- **Rotas (`config/routes.rb`):** `resources :movies` cria as rotas REST do CRUD; uma rota de coleção `POST /movies/search_tmdb` atende a busca no TMDb.
- **Controller (`app/controllers/movies_controller.rb`):**
   - `index` lê o parâmetro de ordenação em `params`, aceita apenas os campos permitidos (`title` e `release_date`) e usa o método `order` do ActiveRecord.
   - `new` cria o filme já com a data de hoje; `create` volta para a lista de filmes após salvar.
   - `search_tmdb` lê o termo buscado em `params`, coloca a mensagem de "não encontrado" no `flash` e redireciona para a lista.
- **Views (`app/views/movies/`):** escritas em Haml. Os cabeçalhos de título (**Movie Title**) e de data de lançamento são links criados com `link_to`, com os ids `title_header` e `release_date_header`. A página inicial também tem o formulário **Search TMDb for a movie**.
- **CSS (`app/assets/stylesheets/application.css`):** estiliza o layout e aplica a classe de destaque na coluna ordenada.
- **Testes de unidade (`test/`):** Minitest para o model e o controller.
- **Testes BDD (`features/`):** Cucumber + Capybara (detalhes na seção *Testes BDD*).

## Tecnologias

- Ruby 3.3.6 (gerenciado com rbenv)
- Rails 8.1.4
- SQLite3
- Haml
- Minitest (testes de unidade)
- Cucumber, Capybara e RSpec Expectations (testes BDD)

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

Para rodar também os cenários BDD:

```bash
bundle exec cucumber
```

Resultado esperado: `3 scenarios (3 passed)`.

### 7. Iniciar o servidor

```bash
bin/rails server
```

Acesse [http://localhost:3000/movies](http://localhost:3000/movies). Para desligar o servidor, use `Ctrl + C`.

## O que testar

- Clicar em **Movie Title** e no cabeçalho de data de lançamento para ordenar a tabela; a coluna escolhida fica destacada.
- Digitar qualquer título em **Search Terms** e clicar em **Search TMDb**: aparece a mensagem de que o filme não foi encontrado.
- Criar, visualizar, editar e excluir um filme.
- Tentar criar um filme sem título e conferir a mensagem de erro.
- Acessar `/movies?sort_by=qualquer`: a página deve abrir normalmente, sem erro.

## Testes BDD

Os cenários ficam em `features/` e são escritos em Gherkin (*Given / When / Then*). O Cucumber lê cada frase, encontra o *step definition* correspondente e o Capybara executa a ação como um usuário faria.

| Arquivo | Cenário | Tipo |
|---|---|---|
| `features/add_movie_tmdb.feature` | *Try to add nonexistent movie*: busca no TMDb um filme que não existe e confere a mensagem de aviso | Sad path |
| `features/sort_movie_list.feature` | *View movie list after adding 2 movies*: adiciona dois filmes pelo formulário, ordena por título e confere a ordem | Imperativo |
| `features/sort_movie_list.feature` | *View movie list sorted by title*: a mesma história em 3 passos, descrevendo o **o quê** e não o **como** | Declarativo |

Arquivos de apoio:

- `features/step_definitions/web_steps.rb`: steps genéricos de navegação (visitar página, clicar, preencher, selecionar, conferir texto e ordem).
- `features/step_definitions/movie_steps.rb`: steps do cenário declarativo (criar filmes direto no banco e ordenar por título).
- `features/support/paths.rb`: traduz nomes de páginas (como *the RottenPotatoes home page*) em rotas do Rails.

```bash
bundle exec cucumber
```

## Problemas comuns

**`rails-8.1.x requires Ruby version >= 3.2.0`**
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

