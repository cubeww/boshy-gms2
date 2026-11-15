<p align="center">
  <a>
    <picture>
      <source media="(prefers-color-scheme: dark)" srcset="docs/brand/artcraft-logo-white.svg">
      <img alt="" src="./logo.png" width="200">
    </picture>
  </a>
</p>

<h1 align="center">Boshy GMS2 Port</h1>

<p align="center">
  The GameMaker LTS 2026 port of “I Wanna Be The Boshy”.
</p>

> [!IMPORTANT]
> This project is still under development and may contain many bugs or behavior that differs from the original game. If you encounter any issues, please report them via the [issues page](https://github.com/cubeww/boshy-gms2/issues).

## Supported Platforms
All platforms supported by GameMaker LTS 2026.

## Progress
All game content except for the online features has been ported.

## About the Port
This is **NOT** a remake; the focus is on faithfully recreating the original game’s physics and visual effects. Certain features that significantly enhance the gameplay experience can be enabled in the options, such as Auto Fire and Low Input Latency.

## About the Engine
This project was originally developed in GameMaker 8.2, but because Boshy contains a large number of sprite images, it eventually exceeded the memory limit (2GB+), causing buffer addressing errors. Although there are ways to work around this issue—such as adding a hack to the address or dynamically loading resources by world—we opted for a more modern version that offers better performance and cross-platform capabilities.

## License
MIT License
