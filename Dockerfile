﻿FROM mcr.microsoft.com/dotnet/runtime:6.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["redistester.csproj", "redistester/"]
RUN dotnet restore "redistester/redistester.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "redistester.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "redistester.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "redistester.dll"]
