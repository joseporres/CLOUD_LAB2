# Integrantes

- Jorge Luis Vásquez Del Aguila
- Jose Adrian Porres Brugue



## Comando para crear la imagen

```
docker build -t wordcountlab2 .
```

## Comando para ejecutar el wordCount y crear el volumen
```
docker run -v "$(pwd)/data:/data"  wordcountlab2
```