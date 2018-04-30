# DockerNifiMaki

Este Docker hace referencia a los procesos de NiFi solo para LA INGESTA en el Event Server del Prediction Maki mediante peticiones POST, no inluye ningun proceso o servicio del Prediction Maki para eso hace referencia a otro Docker (DockerMakiPrediction).

# 1. Construir la imagen :
```docker build -t bigdatamx/nifi  . ```

# 2. Construir el Container :

```docker run --name nifi -v /{TU_PATH}/facturas:/opt/nifi/nifi-1.6.0/facturas -p 8080:8080 -p 8443:8443 -p 10000:10000 -p 5656:7070 -d  bigdatamx/nifi```

Ejemplo :

``` docker run --name nifi -v /home/javier/facturas:/opt/nifi/nifi-1.6.0/facturas -p 8080:8080 -p 8443:8443 -p 10000:10000 -p 5656:7070 -d bigdatamx/nifi```

En la etiqueta de -v ```{TU_PATH}``` colocar el path completo de donde se encuentran almacenados las facturas, los xml de tu host local.


# 3. En el navegador poner la siguiente URL : 
```http://localhost:8080/nifi/```  ó ```http://{IP-HOST}:8080/nifi/``` 


En {IP-HOST} = Colocar la ip del host en donde se esta ejecutando.


# 4. Cambiar el host del processor del POSTPredictionIOEventServer:

Colocar el host del server, ```NO PONER localhost```

```http://{TU_IP}:7070```

Ejemplo : 

```http://192.168.100.5:7070```


Para saber la ip, en la consola de la máquina tipear : ```ifconfig``` 


# 5. Cambiar el PredictionIO Event Server App Key del processor del POSTPredictionIOEventServer , para saber la key tipear en la consola donde se este ejecutando prediction maki:
```pio app list```



# 6. La ruta default en donde se encuentra las facturas es :
Esta ruta es creada dentro del container :
 ```/opt/nifi/nifi-1.6.0/facturas```

Se recomienda no cambiar esta ruta, que hace referencia al container.


# 7. Para acceder a la Consola del Container tipear :
```docker exec -it nifi bash```

# Nota :
Antes de ejecutar el dataflow de NiFi, comprobar que el servicio del Event Server del Prediction Maki este levantado en el host en donde se este ejecutando.
Para comprobar que se esten almacenando en el EventServer del PredictionMaki, colocar en el navegador :

```http://localhost:7070/events.json?accessKey={KEY}```  ó  ```http://{IP-HOST}:7070/events.json?accessKey={KEY}```

Cambiar ```{KEY}```, por el  PredictionIO Event Server App Key.

Cambiar ```{IP-HOST}```, por la ip del host en donde se este ejecutando.


# Funcionamiento del DataFlow del NiFi 

Son 4 processors pero 3 son los Processors principales: 

El primero GetFile, este processor lo que hace es que obtiene las facturas en formato XML, desde el path de su locacion, y los lee.


El segundo processor lo que hace es que de la informacion de las facturas es decir del contenido de los XML, lo transforma a un formato JSON.


El tercer processor lo que hace es que del formato json, lo recive y le da un formato de acuerdo a al formato requerido por el engine del prediction maki, y hace el post del json.


El cuarto processor es solo para los logs.

