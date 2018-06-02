# Guía de contribución al proyecto Elm (frontend) para desarrolladores

## ¿Cómo puedo contribuir al proyecto?

En el código de la aplicación se pueden encontrar comentarios etiquetados con
la palabra `TODO` los cuales contienen pequeñas tareas las cuales si fuesen
evaluadas y resueltas resultarían en un mejor proyecto. Para ver la lista de
pendientes puede utilizar:

```sh
$ grep -nr 'TODO' --exclude-dir=elm-stuff .
```

Aun que a manera de recomendación, es más conveniente utilizar herramientas como
`ack`, `ag` o `rg` las cuales tienen soporte para integrarse con editores de
código.

```sh
$ ag --elm TODO --ignore-dir=elm-stuff
```

Adicionalmente puedes añadir más pruebas al proyecto para mejorar el coverage.


## Tips para aprender Elm

- [An introduction to Elm](https://guide.elm-lang.org/)
- [Elm in Action by Richard Feldman](https://www.manning.com/books/elm-in-action)


## Dependencias

### `NoRedInk/elm-decode-pipeline`

Decoders para convertir cadenas de JSON a registros de Elm.

- [Doumentación](http://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/latest)


### `debois/elm-mdl`

Material design en Elm

- [Documentación](http://package.elm-lang.org/packages/debois/elm-mdl/latest)
- [Elm](https://debois.github.io/elm-mdl/)
