# API REST para selector de metodologías

La carpeta `api/` (esta carpeta) contiene el proyecto que se ejecuta en el
servidor, se trata de una aplicación REST programada en el lenguaje Go.


## Preparación de la base de datos

El proyecto utiliza la base de datos [MongoDB](https://docs.mongodb.com/), puede
revisar la siguiente documentación para consultar instrucciones de instalación:

- [Install MongoDB Community Edition](https://docs.mongodb.com/manual/administration/install-community/)

Una vez instalado el manejador de base de datos es necesario crear la estructura
y poblarla con los datos iniciales que requiere el proyecto. Por ahora no se
tiene un sistema de migraciones por lo que será necesario restablecer la base de
datos a partir de un respaldo.

En la carpeta principal del repositorio se encuentra la carpeta `data/` cuyo
contenido es el respaldo de la base de datos tal cual se realizó con la
herramienta `mongodump`. Para restablecer este respaldo utilice la herramienta
`mongorestore` de la siguiente manera:

```sh
$ mongorestore -d selector_metodologias data/selector_metodologias
```

Nótese que el comando debe ejecutarse en la carpeta principal del proyecto, es
decir, dentro de aquella que contiene a la carpeta `data/`.


## Configuración del `$GOPATH`

Antes de comenzar la instalación verifique que su sistema tiene establecido el
`$GOPATH` y `$GOROOT` correctamente, puede revisar la siguiente documentación
para aprender más al respecto:

- [How to write Go code](https://golang.org/doc/code.html#GOPATH)
- [GOPATH](https://github.com/golang/go/wiki/GOPATH)


## Instalación de dependencias con `dep`

Las dependencias se administran utilizando la herramienta `dep`, para instalar
el proyecto es necesario contar con esta herramienta instalada, por favor visite
[golang/dep](https://github.com/golang/dep) para obtener información de como
instalar esta herramienta en su sistema.

Una vez instalada, abra una terminal y dentro de la carpeta del proyecto (la
carpeta donde esta este archivo) ejecute:

``` sh
$ dep ensure
```

La herramienta leerá los archivos `Gopkg.lock` y `Gopkg.toml` e instalará las
dependencias en la carpeta `vendor/`.


## Ejecución del proyecto `go run`

 Si el `$GOPATH` del sistema está
correctamente configurado podrá iniciar la aplicación con el comando:

``` sh
$ go run src/*.go
```
