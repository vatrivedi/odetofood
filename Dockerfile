FROM mcr.microsoft.com/dotnet/core/sdk:2.1 AS build
WORKDIR /jsr

# copy csproj and restore as distinct layers
# since we have OdeToFood AND its Data & Core folders, copy them accordingly...
COPY *.sln .
COPY OdeToFood/*.csproj ./OdeToFood/
COPY OdeToFood.Core/*.csproj ./OdeToFood.Core/
COPY OdeToFood.Data/*.csproj ./OdeToFood.Data/
RUN dotnet restore

# copy everything else and build app
WORKDIR /jsr
COPY . .

# Setup NodeJs
RUN apt-get update -y
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash --debug
Run apt-get install nodejs -yq
# End setup

RUN npm install
RUN dotnet publish -c Release -o out


##############################################
#COPY aspnetapp/. ./aspnetapp/
#WORKDIR /app/aspnetapp
#RUN dotnet publish -c Release -o out


FROM mcr.microsoft.com/dotnet/core/aspnet:2.1 AS runtime
WORKDIR /jsr
COPY --from=build /jsr/OdeToFood/out ./
ENTRYPOINT ["dotnet", "OdeToFood.dll"]