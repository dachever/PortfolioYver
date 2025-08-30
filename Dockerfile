# Stage 1: Build the app
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

# Copy the solution and project files
COPY *.sln ./
COPY *.csproj ./

# Restore dependencies
RUN dotnet restore

# Copy the rest of the project files
COPY . ./

# Build and publish
RUN dotnet publish -c Release -o out

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build /app/out ./

# Expose the port Render assigns
ENV ASPNETCORE_URLS=http://*:${PORT}
EXPOSE ${PORT}

# Run the app
ENTRYPOINT ["dotnet", "MyPortfolio.dll"]
