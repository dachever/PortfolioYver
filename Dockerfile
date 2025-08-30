# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy only the csproj first (better for caching restores)
COPY MyPortfolio.csproj ./
RUN dotnet restore MyPortfolio.csproj

# Copy everything else and publish
COPY . ./
RUN dotnet publish MyPortfolio.csproj -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080
ENTRYPOINT ["dotnet", "MyPortfolio.dll"]
