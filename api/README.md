# API REST para selector de metodologías

La carpeta `api/` (esta carpeta) contiene el proyecto que se ejecuta en el
servidor, se trata de una aplicación REST programada en el lenguaje Go.


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

## Ejecución del proyecto `go run`

La herramienta leerá los archivos `Gopkg.lock` y `Gopkg.toml` e instalará las
dependencias en la carpeta `vendor/`. Si el `$GOPATH` del sistema está
correctamente configurado podrá iniciar la aplicación con el comando:

``` sh
$ go run src/main.go
```
