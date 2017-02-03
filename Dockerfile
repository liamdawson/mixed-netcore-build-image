FROM buildpack-deps:jessie-scm

# Install .NET CLI dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libc6 \
        libcurl3 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu52 \
        liblttng-ust0 \
        libssl1.0.0 \
        libstdc++6 \
        libunwind8 \
        libuuid1 \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Install .NET Core SDK 1.1
ENV DOTNET_SDK_VERSION 1.0.0-preview2-1-003177
ENV DOTNET_SDK_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/preview/Binaries/$DOTNET_SDK_VERSION/dotnet-dev-debian-x64.$DOTNET_SDK_VERSION.tar.gz

RUN curl -SL $DOTNET_SDK_DOWNLOAD_URL --output dotnet.tar.gz \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Install .NET Core runtime 1.0.3
ENV STABLE_RUNTIME_VERSION 1.0.3
ENV STABLE_RUNTIME_DOWNLOAD_URL https://go.microsoft.com/fwlink/?LinkID=836295

RUN curl -SL $STABLE_RUNTIME_DOWNLOAD_URL --output dotnet.tar.gz \
  && mkdir $STABLE_RUNTIME_VERSION \
  && tar -xzf dotnet.tar.gz -C $STABLE_RUNTIME_VERSION \
  && rm dotnet.tar.gz \
  && mv $STABLE_RUNTIME_VERSION/host /usr/share/dotnet/host \
  && mv $STABLE_RUNTIME_VERSION/shared /usr/share/dotnet/shared \
  && rm -rf $STABLE_RUNTIME_VERSION

# Trigger the population of the local package cache
ENV NUGET_XMLDOC_MODE skip
RUN mkdir warmup \
    && cd warmup \
    && dotnet new \
    && cd .. \
    && rm -rf warmup \
    && rm -rf /tmp/NuGetScratch

