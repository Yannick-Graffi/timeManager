# Utiliser une image officielle Elixir
FROM elixir:1.15.6

# Installer hex et rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Installer postgresql-client pour le débogage
RUN apt-get update && apt-get install -y postgresql-client

RUN apt-get update && apt-get install -y inotify-tools


# Créer un répertoire pour votre application
WORKDIR /app

# Copier les dépendances de l'application Elixir
COPY mix.exs ./
RUN mix do deps.get, deps.compile

# Copier tout le reste de l'application
COPY . .

# Compiler l'application
RUN mix do compile

# Exposer le port utilisé par Phoenix
EXPOSE 4000

# Définir l'entrée par défaut pour démarrer l'application
CMD ["mix", "phx.server"]
