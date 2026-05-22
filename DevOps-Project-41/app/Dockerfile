# syntax=docker/dockerfile:1

# ─── Build stage ─────────────────────────────────────────────────────────────
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
WORKDIR /src

COPY AiPlatform.sln ./
COPY src/AiProvider/AiProvider.csproj ./src/AiProvider/
COPY src/AiApi/AiApi.csproj           ./src/AiApi/
COPY src/AiWorker/AiWorker.csproj     ./src/AiWorker/
COPY tests/AiApi.Tests/AiApi.Tests.csproj       ./tests/AiApi.Tests/
COPY tests/AiWorker.Tests/AiWorker.Tests.csproj ./tests/AiWorker.Tests/

RUN dotnet restore

COPY . .

RUN dotnet build -c Release --no-restore
RUN dotnet test  -c Release --no-build --no-restore

# ─── Publish API ─────────────────────────────────────────────────────────────
FROM build AS publish-api
RUN dotnet publish src/AiApi/AiApi.csproj -c Release --no-build -o /app/api

# ─── Publish Worker ──────────────────────────────────────────────────────────
FROM build AS publish-worker
RUN dotnet publish src/AiWorker/AiWorker.csproj -c Release --no-build -o /app/worker

# ─── API runtime image ────────────────────────────────────────────────────────
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS api
WORKDIR /app

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

COPY --from=publish-api --chown=appuser:appgroup /app/api .

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

HEALTHCHECK --interval=15s --timeout=5s --start-period=20s --retries=3 \
  CMD wget -qO- http://localhost:8080/health || exit 1

ENTRYPOINT ["dotnet", "AiApi.dll"]

# ─── Worker runtime image ─────────────────────────────────────────────────────
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS worker
WORKDIR /app

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

COPY --from=publish-worker --chown=appuser:appgroup /app/worker .

EXPOSE 9090

ENTRYPOINT ["dotnet", "AiWorker.dll"]
