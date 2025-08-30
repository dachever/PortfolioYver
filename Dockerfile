# Stage 1: Build the app
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

# Copy solution and project files
COPY *.sln .
COPY MyPortfolio/*.csproj ./MyPortfolio/

# Restore dependencies
RUN dotnet restore

# Copy the rest of the project and publish
COPY MyPortfolio/. ./MyPortfolio/
WORKDIR /app/MyPortfolio
RUN dotnet publish -c Release -o out

# Stage 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build /app/MyPortfolio/out .

# Expose the port Render assigns
ENV ASPNETCORE_URLS=http://*:${PORT}
EXPOSE ${PORT}

# Run the app
ENTRYPOINT ["dotnet", "MyPortfolio.dll"]
