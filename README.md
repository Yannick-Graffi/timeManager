# TimeManager

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4001`](https://localhost:4001) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
  


## Partie DEVOPS et Sécurité


Pour le bon fonctionnement de notre application « Time Manager », on s’est orienté sur l’utilisation d’outils DEVOPS. Tout d’abord, nous avons utilisé DOCKER pour conteneuriser notre application en 3 conteneurs distincts : une pour la base de données, une pour l’api, et une pour le frontend. Pour séparer en plus le travail réalisé par les développeurs entre le frontend et le backend, l’application se trouve formé en 2 projets (frontend – api + base de données). Ainsi les deux projets sont à installer pour utiliser correctement l’application.

Techniquement, un fichier Dockerfile a été créé pour chaque projet pour donner les étapes d’installation et d’exécution de l’application. Un fichier Docker-compose.yml est également crée pour chaque projet afin de paramétrer l’environnement de l’application (volumes, ports, variables d’environnements etc…).
Le choix de cette approche DEVOPS a également été de faire des choix pour optimiser l’application. Les résultats ont été : une application plus légère, une application plus sécurisée et une application plus persistante (persistance des données).

La dernière étape de cette partie DEVOPS, concerne l’intégration continu de l’application. En utilisant des pipelines grâce à Github Actions. 
En revenant sur l’objectif de l’intégration continu, nous souhaitions ajouter sur Docker Hub notre application, et qu’une fois modifié, elle se mette à jour sur le Docker Hub. En deuxième étape, Le serveur destiné à héberger l’application devait automatiquement récupérer la nouvelle version à jour de l’application. Un pipeline pour exécuter ces processus a été créé pour chacune des deux étapes.

Un axe qui pourrait être apporté par la suite est l’utilisation de Kubernetes pour la gestion de plusieurs conteneurs, ou également l’utilisation de tests unitaire : avant d’ajouter une nouvelle version sur le serveur, intégrer ces tests au code pour vérifier que le code ajouté ne crée pas de problèmes à des niveaux que l’on n’aurait prévus.


Comme énoncé précédemment, une partie sécurité était attendue. Pour le bien de notre application, des modifications de configurations et des tests de sécurité ont été effectué. Et ainsi nous gardons une application qui porte le moins de vulnérabilité et qui respecte la confidentialité des données de l’application.


