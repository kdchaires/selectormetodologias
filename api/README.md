# API REST Selector de Metodologías

Este proyecto es una aplicación REST programada en el lenguaje Go.

Si usted es un desarrollador, por favor adicionalmente consulte
[CONTRIBUTING.md](/CONTRIBUTING.md) para más información técnica sobre el
proyecto.

A continuación se detallan los pasos necesarios para instalar y ejecutar esta
aplicación en un ambiente de pre-producción.


## Preparación de la base de datos

El proyecto utiliza la base de datos [MongoDB](https://docs.mongodb.com/), puede
revisar la siguiente documentación para consultar instrucciones de instalación:

- [Install MongoDB Community Edition](https://docs.mongodb.com/manual/administration/install-community/)

Una vez instalado el manejador de base de datos es necesario crear la estructura
y llenarla con los datos iniciales que requiere el proyecto. Por ahora no se
tiene un sistema de migraciones por lo que será necesario restablecer la base de
datos a partir de un respaldo.

En la carpeta raíz del [repositorio
principal](https://github.com/kdchaires/selectormetodologias) se encuentra la
carpeta `data/` cuyo contenido es el respaldo de la base de datos tal cual se
generó con la herramienta `mongodump`. Para restablecer este respaldo utilice
la herramienta `mongorestore` de la siguiente manera:

```sh
# Remplace "<nombre bd>" con el nombre deseado para su base de datos
$ mongorestore -d <nombre bd> data/selector_metodologias
```

Nótese que el comando debe ejecutarse en la carpeta principal del proyecto, es
decir, dentro de aquella que contiene a la carpeta `data/`. Además el nombre de
la base de datos que haya elegido debe especificarlo en las configuraciones de
la aplicación (vea abajo la sección _"Configuración de la aplicación"_).

## Instalar y ejecutar la aplicación

### Configuración del `$GOPATH`

Antes de comenzar la instalación verifique que su sistema tiene establecido el
`$GOPATH` y `$GOROOT` correctamente, puede revisar la siguiente documentación
para aprender más al respecto:

- [How to write Go code](https://golang.org/doc/code.html#GOPATH)
- [GOPATH](https://github.com/golang/go/wiki/GOPATH)

**Nota**: Esto es necesario para poder compilar cualquier proyecto realizado en
Go.


### Instalación de dependencias con `dep`

Las dependencias se administran utilizando la herramienta `dep`, para instalar
el proyecto es necesario contar con esta herramienta instalada en su sistema,
por favor visite [golang/dep](https://github.com/golang/dep) para obtener
información de como instalar esta herramienta en su sistema.

Una vez instalada, abra una terminal y dentro de la carpeta del proyecto (la
carpeta donde esta este archivo) ejecute:

``` sh
$ dep ensure
```

La herramienta leerá los archivos `Gopkg.lock` y `Gopkg.toml` e instalará las
dependencias en la carpeta `vendor/`.


### Configuración de la aplicación

Para que la aplicación se pueda ejecutar correctamente necesita que se le
configuren diferentes parámetros mediante variables de entorno, para simplificar
la configuración debe crear un archivo llamado `.env` en la raíz del proyecto,
cuyo contenido tiene el formato `VARIABLE=valor`.

Para facilitar la configuración del sistema, se incluye el archivo `example.env`
que puede utilizar como plantilla para crear su configuración, siéntase libre de
renombrar el archivo y de utilizarlo como su configuración:

``` sh
$ mv example.env .env
```

Las variables que deben especificarse en el archivo de configuración son:

- `APP_BIND_ADDRESS`: Dirección IP utilizada por el servidor de aplicación.
- `APP_BIND_PORT`: Puerto TCP utilizado por el servidor de la aplicación.
- `APP_ENV`: Permite informar a la aplicación sobre el tipo de ambiente: `testing`, `local` o `production`.
- `MONGODB_HOST`: Dirección IP del manejador de base de datos MongoDB.
- `MONGODB_PORT`: Puerto TPC del manejador de base de datos MongoDB.
- `MONGODB_NAME`: Nombre de la base de datos de la aplicación en MongoDB.
- `MONGODB_USERNAME`: Nombre de usuario de la base de datos.
- `MONGODB_PASSWORD`: Contraseña del usuario de base de datos.
- `MONGODB_AUTH_ENABLED`: `true` si MongoDB tiene habilitada la autenticación,
  `false` caso contrario. Es necesario que esta variable sea `true` si se
  ejecuta la aplicación en ambiente de producción.
- `STRICT_EMAIL_VERIFICATION`: Si es `true` intentará ver que el email del usuario es real.


#### MongoDB y Autenticación de usuarios

Por default MongoDB no tiene activado el sistema de autenticación, sin embargo
para que la aplicación funcione correctamente en un ambiente de producción
(`APP_ENV=production`) entonces será necesario habilitar la autenticación en el
servidor de MongoDB.

Refiérase a los siguientes enlaces para consultar documentación de cómo habilitar
la autenticación en MongoDB:

- [Enable Auth - MongoDB Documentation](https://docs.mongodb.com/manual/tutorial/enable-authentication/)
- [How to setup user authentication in MongoDB](https://medium.com/@matteocontrini/how-to-setup-auth-in-mongodb-3-0-properly-86b60aeef7e8)

Una vez que la autenticación esté configurada debe especificar la variable
`MONGODB_AUTH_ENABLED=true` en el archivo de configuración (`.env`).

**Nota**: Si se utiliza el entorno `local` o `testing` entonces no se requiere
autenticación en el servidor de base de datos.

### Ejecución del proyecto

Ya que se hayan instalado las dependencias y si el `$GOPATH` del sistema está
correctamente configurado podrá construir y ejecutar el proyecto con el
siguiente comando.

``` sh
$ go run main.go
```


## Instalación y ejecución de la aplicación a nivel de sistema (experimental)

Si se desea instalar definitivamente el sistema (sin necesidad de estarlo
compilando y ejecutando desde la carpeta del proyecto) necesita construir el
proyecto y posteriormente instalarlo.

### Construcción del proyecto

Ya que se hayan instalado las dependencias y si el `$GOPATH` del sistema está
correctamente configurado podrá compilar el proyecto, para ello, simplemente
ejecute el siguiente comando en la misma carpeta donde esta éste archivo:

``` sh
$ go build
```

En éste punto se generará un binario con el nombre `metselector`, ahora puede
ejecutar la aplicación de la siguiente manera:

``` sh
$ ./metselector
```

### Instalación a nivel de sistema (opcional)

Si se desea instalar la aplicación a nivel de sistema para que sea posible
iniciarla desde cualquier ubicación, utilice el siguiente comando:

``` sh
$ go install
```

En éste punto el ejecutable se habrá generado en su `$GOPATH/bin` y de tener
configurado el `$GOPATH` en el `$PATH` del sistema podrá iniciar la aplicación
simplemente ejecutando:

``` sh
$ metselector
```
