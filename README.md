# RottenPotatoes

Catálogo de filmes com CRUD, validações, ordenação e testes — desenvolvido com Ruby on Rails.

## Pré-requisitos

- Ruby 3.3.6 (gerenciado via rbenv)
- Rails 8.1.3.1
- SQLite3

## Instalando as dependências

```bash
bundle install
```

## Preparando o banco de dados

Cria as tabelas:

```bash
bin/rails db:migrate
```

Popula com filmes iniciais (idempotente — pode ser rodado várias vezes sem duplicar):

```bash
bin/rails db:seed
```

## Executando os testes

```bash
bin/rails test
```

Resultado esperado: todos os testes passando, sem falhas.

## Iniciando o servidor

```bash
bin/rails server
```

Acesse em: [http://localhost:3000/movies](http://localhost:3000/movies)

## Funcionalidades

- Listar, criar, editar e excluir filmes
- Validações: título obrigatório, classificação dentro de G / PG / PG-13 / R / NC-17, data de lançamento obrigatória
- Ordenação por título ou data de lançamento via parâmetro de URL (`?sort_by=title` ou `?sort_by=release_date`)
- Destaque visual da coluna ordenada
