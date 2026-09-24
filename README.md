##🍅 Como rodar o RottenPotatoes no seu computador
1. Pré-requisitos
Windows: use o WSL (Ubuntu). Abra o PowerShell, digite wsl ~ e rode tudo lá dentro.
Linux ou Mac: use o terminal normal.
Versões usadas no projeto: Ruby 3.3.6 e Rails 8.1.3.1. O Rails é instalado automaticamente no passo 4.

⚠️ No WSL, deixe o projeto dentro de ~ (a pasta do Linux), e não em /mnt/c/.... Pelas pastas do Windows, o Rails fica muito lento.

2. Instalar dependências do sistema (Ubuntu/WSL)
bash
sudo apt update
bash
sudo apt install -y build-essential libssl-dev libyaml-dev zlib1g-dev libffi-dev libreadline-dev sqlite3 libsqlite3-dev git curl

No Mac, o equivalente é: brew install sqlite3 libyaml openssl readline.

3. Instalar o Ruby 3.3.6 com rbenv

Pule este passo se o comando ruby --version já mostrar 3.3.6.

bash
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
bash
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

Se o seu terminal usa bash:

bash
echo 'eval "$(~/.rbenv/bin/rbenv init - bash)"' >> ~/.bashrc && exec bash

Se o seu terminal usa zsh:

bash
echo 'eval "$(~/.rbenv/bin/rbenv init - zsh)"' >> ~/.zshrc && exec zsh

Instale o Ruby. Isso demora de 5 a 15 minutos, porque ele é compilado:

bash
rbenv install 3.3.6
bash
rbenv global 3.3.6
bash
ruby --version

O último comando tem que mostrar ruby 3.3.6.

4. Baixar o projeto e instalar as gems
bash
cd ~
bash
git clone https://github.com/isaclimaco/rottenpotatoes.git
bash
cd rottenpotatoes
bash
bundle install

O bundle install instala o Rails e todas as outras gems nas versões exatas do projeto, porque ele lê o arquivo Gemfile.lock.

5. Preparar o banco de dados
bash
bin/rails db:migrate
bash
bin/rails db:seed

O primeiro comando cria as tabelas. O segundo coloca 3 filmes de exemplo no banco.

6. Rodar os testes
bash
bin/rails test

No final, tem que aparecer 0 failures, 0 errors.

7. Iniciar o servidor
bash
bin/rails server

Abra no navegador: http://localhost:3000/movies

Para desligar o servidor, aperte Ctrl + C no terminal.

8. O que testar
Clicar em Título e em Lançamento para ordenar a tabela. A coluna escolhida fica destacada.
Criar, ver, editar e excluir um filme.
Tentar criar um filme sem título: tem que aparecer uma mensagem de erro.
Acessar /movies?sort=qualquer: a página tem que abrir normalmente, sem erro.
🛠️ Se der problema

rails-8.1.3.1 requires Ruby version >= 3.2.0
O terminal está usando um Ruby antigo. Rode exec zsh (ou exec bash) e depois ruby --version. Se ainda não aparecer 3.3.6, refaça o passo 3.

Network is unreachable no bundle install (comum no WSL)
O WSL está tentando se conectar por IPv6. Force o IPv4:

bash
echo 'precedence ::ffff:0:0/96  100' | sudo tee -a /etc/gai.conf

Depois rode o bundle install de novo.

O WSL não tem internet nenhuma (Destination Host Unreachable)
No PowerShell, abra o arquivo de configuração do WSL:

powershell
notepad $env:USERPROFILE\.wslconfig

Cole o conteúdo abaixo e salve:

[wsl2]
networkingMode=mirrored

Depois, ainda no PowerShell:

powershell
wsl --shutdown

Entre de novo com wsl ~.

command not found: rbenv
Rode exec zsh ou exec bash. Se não resolver, confira o passo 3.

A porta 3000 já está em uso
Suba o servidor em outra porta:

bash
bin/rails server -p 3001

e acesse localhost:3001/movies.
