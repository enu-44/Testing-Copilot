# Generador de proyectos .NET

Este directorio contiene un script Bash para generar la estructura inicial de una solución .NET 8 con una Minimal API, un proyecto de pruebas y un archivo Dockerfile.

El nombre de los proyectos se recibe como primer parámetro del script. Si no se indica, se utiliza `MinimalApi`.

## Requisitos

- macOS, Linux o un entorno compatible con Bash.
- .NET SDK 8.
- Acceso a NuGet para descargar las dependencias.
- Docker, si se desea construir y ejecutar la imagen.

## Uso

Desde esta carpeta, ejecuta:

```bash
chmod +x generador.sh
./generador.sh NombreDelProyecto
```

Por ejemplo:

```bash
./generador.sh ProyectoCopilot
```

El comando crea o utiliza los siguientes elementos:

- `ProyectoCopilot/`: proyecto principal de Minimal API.
- `ProyectoCopilot.Tests/`: proyecto de pruebas xUnit.
- `ProyectoCopilot.sln`: solución que contiene ambos proyectos.
- `ProyectoCopilot/Dockerfile`: imagen de contenedor para la API.

Si no se proporciona un nombre, el valor predeterminado es `MinimalApi`:

```bash
./generador.sh
```

## Qué hace el script

1. Crea una Minimal API con `dotnet new webapi`.
2. Crea un proyecto de pruebas con `dotnet new xunit`.
3. Agrega una referencia desde el proyecto de pruebas al proyecto principal.
4. Crea una solución .NET y agrega ambos proyectos.
5. Agrega al proyecto de pruebas:
   - `Microsoft.AspNetCore.Mvc.Testing` versión `8.0.14`, compatible con `net8.0`.
   - `MiniValidation`.
6. Genera un `Dockerfile` basado en las imágenes oficiales de .NET 8.

La solución existente se reutiliza si ya existe un archivo `.sln` o `.slnx` con el nombre indicado. Sin embargo, los proyectos y paquetes deben generarse en una carpeta nueva para evitar conflictos o referencias duplicadas.

## Estructura

Después de ejecutar el script, la estructura principal es similar a esta:

```text
Proyecto/
├── generador.sh
├── README.md
├── NombreDelProyecto.sln
├── NombreDelProyecto/
│   ├── NombreDelProyecto.csproj
│   ├── Program.cs
│   └── Dockerfile
└── NombreDelProyecto.Tests/
    ├── NombreDelProyecto.Tests.csproj
    └── UnitTest1.cs
```

## API generada

La aplicación inicial incluye el endpoint:

```text
GET /weatherforecast
```

Este endpoint devuelve un arreglo de cinco pronósticos meteorológicos de ejemplo. En el entorno de desarrollo también se habilita Swagger/OpenAPI para consultar y probar la API desde el navegador.

## Ejecutar la API

Entra en la carpeta del proyecto generado y ejecuta:

```bash
dotnet run
```

La URL exacta se muestra en la terminal. En desarrollo, la interfaz de Swagger normalmente está disponible en:

```text
https://localhost:<puerto>/swagger
```

## Ejecutar las pruebas

Desde la carpeta `Proyecto`, ejecuta:

```bash
dotnet test NombreDelProyecto.Tests/NombreDelProyecto.Tests.csproj
```

El proyecto de pruebas está configurado para `net8.0` y utiliza xUnit.

## Construir y ejecutar con Docker

Desde la carpeta del proyecto principal:

```bash
cd NombreDelProyecto
docker build -t NombreDelProyecto .
docker run --rm -p 8080:80 NombreDelProyecto
```

La imagen utiliza una etapa de compilación con `mcr.microsoft.com/dotnet/sdk:8.0` y una etapa final con `mcr.microsoft.com/dotnet/aspnet:8.0`.
