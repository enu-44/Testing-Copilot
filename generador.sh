#!/usr/bin/env bash

set -e

PROJECT_NAME="${1:-MinimalApi}"
TEST_PROJECT_NAME="${PROJECT_NAME}.Tests"

echo "Nombre del proyecto: ${PROJECT_NAME}"

# Crea un proyecto de minimal api en .NET
echo "CREANDO PROYECTO MINIMAL API EN .NET"
dotnet new webapi -n "$PROJECT_NAME"

# Crea un proyecto de pruebas para el proyecto de minimal api en .NET
echo "CREANDO PROYECTO DE PRUEBAS PARA EL PROYECTO DE MINIMAL API EN .NET"
dotnet new xunit -n "$TEST_PROJECT_NAME"

# Asocia los dos proyectos 
echo "ASOCIANDO LOS PROYECTOS"
dotnet add "$TEST_PROJECT_NAME/$TEST_PROJECT_NAME.csproj" reference "$PROJECT_NAME/$PROJECT_NAME.csproj"

# Crea un archivo de solución de .NET
echo "CREANDO ARCHIVO DE SOLUCIÓN DE .NET"
if [[ ! -f "$PROJECT_NAME.sln" && ! -f "$PROJECT_NAME.slnx" ]]; then
	dotnet new sln -n "$PROJECT_NAME"
else
	echo "La solución $PROJECT_NAME ya existe; se reutilizará"
fi

# Agrega ambos proyectos a la solución de .NET
echo "AGREGANDO PROYECTOS A LA SOLUCIÓN DE .NET"
dotnet sln "$PROJECT_NAME.sln" add "$PROJECT_NAME/$PROJECT_NAME.csproj"
dotnet sln "$PROJECT_NAME.sln" add "$TEST_PROJECT_NAME/$TEST_PROJECT_NAME.csproj"

# Agrega los paquetes necesarios para el proyecto de tests de minimal api en .NET
echo "AGREGANDO PAQUETES NECESARIOS PARA EL PROYECTO DE PRUEBAS DE MINIMAL API EN .NET"
dotnet add "$TEST_PROJECT_NAME/$TEST_PROJECT_NAME.csproj" package Microsoft.AspNetCore.Mvc.Testing --version 8.0.14
dotnet add "$TEST_PROJECT_NAME/$TEST_PROJECT_NAME.csproj" package MiniValidation

# Agrega un archivo Dockerfile para el proyecto de minimal api en .NET
echo "CREANDO ARCHIVO DOCKERFILE PARA EL PROYECTO DE MINIMAL API EN .NET"
cd "$PROJECT_NAME"
cat <<EOL > Dockerfile
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app
EXPOSE 80

# Copy the project files and restore dependencies
COPY *.csproj ./
RUN dotnet restore 

# Copy the rest of the application code
COPY . ./
RUN dotnet publish -c Release -o out


#Use the official ASP.NET runtime image for the final stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
COPY --from=build /app/out .

#Expose port 80 for the application
EXPOSE 80

#Run the application
ENTRYPOINT ["dotnet", "${PROJECT_NAME}.dll"]
EOL

echo "ARCHIVO DOCKERFILE CREADO PARA EL PROYECTO DE MINIMAL API EN .NET"
cd ..

echo "PROCESO COMPLETADO PARA EL PROYECTO ${PROJECT_NAME}"