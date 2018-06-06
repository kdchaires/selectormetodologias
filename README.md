# Selector de Metodologías

[![Build Status](https://travis-ci.org/kdchaires/selectormetodologias.svg?branch=master)](https://travis-ci.org/kdchaires/selectormetodologias)

Selector de Metodologías es una aplicación que ayuda a todos aquellos desarrolladores, experimentados o no, a evaluar sus proyectos y recomendarles diferentes metodologías de desarrollo que se adecuen a sus necesidades y posibilidades.

# Tabla de contenido
 - Instalación
	- Estructura de carpetas
	- Requerimientos del servidor
	- Instalación con Vagrant


# Instalación
El proyecto esta compuesto de dos partes principales, una **Aplicación web** desarrollada en [Elm](https://github.com/elm-lang) y un API REST desarrollado en [Go](https://github.com/golang/go). La ejecución paralela de ambas partes son necesarias para el correcto funcionamiento de la aplicación.

## Estructura de carpetas
selectormetodologias/
├── api/ (API REST Go)
├── app/ (Web app Elm)
└── data/ (Datos iniciales MongoDB)

## Requerimientos del servidor

La instalación de este proyecto requiere algunos requerimientos de sistema. Para probar de manera rápida y fácil puedes utilizar nuestra [Caja de Vagrant](http://handlebarsjs.com/) la cual ya cumple con todos los requerimientos de sistema necesarios.

Si decides utilizar un servidor propio debes estar seguro de cumplir con los siguientes requerimientos.
- Elm v0.18.0
- create-elm-app v1.10.4
- Go v1.10.1
- MongoDB v3.6

# Instalación con Vagrant
Para utilizar nuestra **Caja de Vagrant** es necesario tener instaladas las siguientes aplicaciones:
- Vagrant v2.x.x
- VirtualBox v5.2.x

Sigue las [instrucciones de instalación de Vagrant](https://www.vagrantup.com/intro/getting-started/install.html) y las [instrucciones de instalación de VirtualBox](https://www.virtualbox.org/wiki/Downloads) oficiales para su correcta instalación.

Para descargar y ejecutar la caja solo es necesario entrar a la raíz del proyecto y ejecutar el siguiente comando:
```sh
$ vagrant up
```
Una vez que se encuentre corriendo la caja se puede acceder a través de SSH:
```sh
$ vagrant ssh
```
Solo basta ejecutar el API REST y la Web app:
> Tip: Puedes ejecutar dos conexiones ssh en diferentes consolas para ejecutar las dos partes por separado
```sh
$ go run go/src/cimat/metodologias/selector/src/*.go
```
```sh
$ cd /vagrant/app
$ elm-app start
```
Por ultimo, desde cualquier navegador ingresa a http://localhost:3000/ para abrir la aplicación.
