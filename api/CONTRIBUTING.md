# Guía de contribución al proyecto Go (backend) para desarrolladores

## ¿Cómo puedo contribuir al proyecto?

En el código de la aplicación se pueden encontrar comentarios etiquetados con
la palabra `TODO` los cuales contienen pequeñas tareas las cuales si fuesen
evaluadas y resueltas resultarían en un mejor proyecto. Para ver la lista de
pendientes puede utilizar:

```sh
$ grep -nr 'TODO' --exclude-dir=vendor .
```

Aun que a manera de recomendación, es más conveniente utilizar herramientas como
`ack`, `ag` o `rg` las cuales tienen soporte para integrarse con editores de
código.

```sh
$ ag --go TODO --ignore-dir=vendor
```

Adicionalmente puedes añadir más pruebas al proyecto para mejorar el coverage.


## Tips para aprender Go

- [An introduction to programming in Go](https://www.golang-book.com/books/intro)
- [Bootcamp Golang](https://www.youtube.com/playlist?list=PLSak_q1UXfPrI6D67NF8ajfeJ6f7MH83S)


## Dependencias

### `globalsign/mgo`

Driver de conexión para el manejador de base de datos MongoDB.

- [Doumentación](https://godoc.org/github.com/globalsign/mgo)
- [Ejemplo `mgo`](https://gist.github.com/border/3489566)
- [Construir microservicios con Go y MongoDB](http://goinbigdata.com/how-to-build-microservice-with-mongodb-in-golang/)


### `gorilla/mux`

Utilería para manejar las rutas HTTP de la aplicación.

- [Documentación](http://www.gorillatoolkit.org/pkg/mux)


### `joho/godotenv`

Utilería que permite leer variables de configuración desde un archivo `.env`.

- [Documentación](https://github.com/joho/godotenv)
