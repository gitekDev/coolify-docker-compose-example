FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 9797

# Set environment variable for ASP.NET Core to use a specific URL
ENV ASPNETCORE_URLS=http://+:9797

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["xonet.api/xonet.api.csproj", "xonet.api/"]
RUN dotnet restore "xonet.api/xonet.api.csproj"
COPY . .
WORKDIR "/src/xonet.api"
RUN dotnet build "xonet.api.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "xonet.api.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "xonet.api.dll"]
