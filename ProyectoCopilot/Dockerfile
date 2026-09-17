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
ENTRYPOINT ["dotnet", "ProyectoCopilot.dll"]
