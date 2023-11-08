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

# Copier les dépendances de l'application Elixir
COPY mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

# Copier tout le reste de l'application
COPY . .

# Compiler l'application
RUN mix do compile

# Si la compilation échoue pour les dépendances, réinstaller toutes les dépendances
RUN mix do deps.clean --all && mix do deps.get, deps.compile

# Exposer le port utilisé par Phoenix
EXPOSE 4000