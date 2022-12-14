FROM mcr.microsoft.com/dotnet/sdk:6.0 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["src/HappyX.Api/HappyX.Api.csproj", "src/HappyX.Api/"]
COPY ["src/HappyX.Infrastructure/HappyX.Infrastructure.csproj", "src/HappyX.Infrastructure/"]
COPY ["src/HappyX.Domain/HappyX.Domain.csproj", "src/HappyX.Domain/"]
RUN dotnet restore "src/HappyX.Api/HappyX.Api.csproj"
COPY . .
WORKDIR "/src/src/HappyX.Api"
RUN dotnet build "HappyX.Api.csproj" -c Release -o /app/build
FROM build AS publish
RUN dotnet publish "HappyX.Api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "HappyX.Api.dll"]