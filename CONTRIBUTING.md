# Guía de contribución al proyecto para desarrolladores

## ¿Cómo puedo contribuir al proyecto?

En el código de la aplicación se pueden encontrar comentarios etiquetados con
la palabra `TODO` los cuales contienen pequeñas tareas las cuales si fuesen
evaluadas y resueltas resultarían en un mejor proyecto. Para ver la lista de
pendientes utiliza el script `todos`:

```sh
$ ./todos
```

Se obtendrá un resultado como el siguiente:

```
[ GO API TODO LIST ]
api/controllers/base.go:9:	// TODO Move this to a shared package?
api/controllers/base.go:10:	// TODO Add a reference to the logger?
api/controllers/handlers.go:8:// TODO Use a helper to create a Json response type improving DRYness
api/models/database.go:28:// TODO Move to a more general file/package?
api/models/database.go:30:	// TODO Take into consideration user, password
api/models/questions.go:40:	// TODO When used multiple-times move it to a utils/shared package
api/test/handlers_test.go:38:	// TODO Extract marshaling to a helper
[ ELM APP TODO LIST ]
app/src/Questions.elm:13:-- TODO Use this sample questions to populate the JSONs in tests/SampleResponses
app/tests/Tests.elm:3:-- TODO Later organize tests in different modules
```

Como puede observar nos especifica el archivo y el número de linea de donde se
encuentra el `TODO`, al abrir el archivo podrá ver el código en contexto para
resolver el `TODO`.

Adicionalmente puede añadir más pruebas a los proyectos para mejorar el coverage.
