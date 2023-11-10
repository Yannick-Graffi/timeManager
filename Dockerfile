# Utiliser une image officielle Elixir basée sur Alpine
FROM elixir:1.15.7-alpine

# Installer les dépendances et outils de développement nécessaires
RUN apk update && \
    apk add --no-cache \
    postgresql-client \
    inotify-tools \
    build-base \
    erlang-dev

# Créer un répertoire pour votre application
WORKDIR /app

# Copier les fichiers mix.exs et mix.lock pour installer les dépendances
COPY mix.exs mix.lock ./

# Copier tout le reste de l'application
COPY . .

# Installer et compiler les dépendances, puis compiler l'application
RUN mix do deps.get, deps.compile, compile

# Exposer le port utilisé par Phoenix
EXPOSE 4001
