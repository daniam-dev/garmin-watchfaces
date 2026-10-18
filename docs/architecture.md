# Arquitectura y trabajo con Codex

## Límites del repositorio

Cada esfera es un proyecto Connect IQ autónomo bajo `watchfaces/<slug>/`.
Puede compilarse sin el código o los recursos de la otra. El manifiesto es la
autoridad de identidad y permisos; ambos proyectos admiten únicamente `fr170`.

`projects.json` asocia el slug de cada carpeta con el nombre del programa de
salida. Los scripts lo leen para evitar mantener listas de proyectos dentro
del compilador. `bin/` siempre pertenece a la esfera seleccionada.

Las herramientas comunes se limitan a desarrollo: compilación y comprobación
de estructura. No hay una biblioteca de ejecución compartida: Pixel Analog
aún no tiene funcionalidades que justifiquen extraerla.

## Modular One

| Archivo en `source/` | Responsabilidad |
| --- | --- |
| `garmin-watchfacesApp.mc` | Entrada de aplicación y creación de la vista |
| `garmin-watchfacesView.mc` | Ciclo de vida, refresco y suscripciones |
| `DataProviders.mc` | Modelo `FaceData` y lectura de APIs oficiales |
| `Formatters.mc` | Formato de valores, ausencia y límites de porcentajes |
| `FaceRenderer.mc` | Composición de la esfera desde `FaceData` |
| `Components.mc` | Primitivas de iconos, círculos y arcos |
| `Theme.mc` | Colores y medidas reutilizadas |

La vista refresca los datos al cambiar el minuto y atiende los cambios de la
complicación Body Battery. El renderizador no lee sensores ni gestiona
suscripciones. En reposo se limpia la pantalla a negro.

Conservar esta separación permite modificar el dibujo sin cambiar la lectura
de datos. No se han renombrado clases ni dividido archivos por anticipación.

## Pixel Analog

Contiene una aplicación y una vista vacía compilables. Su `PRODUCT.md` separa
las restricciones confirmadas de las decisiones pendientes. Tendrá su propio
modelo y renderizador cuando el diseño y las funciones lo requieran.

## Herramientas y validación

- `scripts/build.ps1`: compila una esfera o todas, en secuencia. Resuelve el
  SDK seleccionado y la clave existente; admite rutas alternativas explícitas.
- `scripts/verify.ps1`: sin SDK ni firma, comprueba registro, manifiestos,
  UUID únicos, exclusividad `fr170`, recursos XML, rutas locales de Jungle,
  contexto de cada esfera, workspace, configuración Impeccable y sintaxis de
  los scripts. No sustituye la compilación ni la revisión visual.
- `tests/tooling.tests.ps1`: usa una copia temporal sin claves ni binarios para
  comprobar que se rechazan IDs duplicados, dispositivos incompatibles,
  tareas ausentes y slugs con rutas fuera de la convención.

## Contexto para Codex

`AGENTS.md` contiene reglas comunes y comandos. Los archivos locales de cada
esfera añaden únicamente sus contratos; enlazan la raíz para las sesiones
abiertas desde una subcarpeta. README explica el uso y este documento los
límites arquitectónicos. No es necesario pegarlos en cada petición.

Las instrucciones se mantienen breves y específicas, siguiendo la
[guía de AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md)
y la recomendación de OpenAI de
[evitar contexto redundante](https://developers.openai.com/blog/rethinking-skills-and-prompts-for-gpt-6-astra).
Abre una sesión nueva para que Codex descubra las instrucciones recién creadas.
Si la carpeta no tiene raíz Git reconocida, inicia en la raíz del proyecto o
pide leer su `AGENTS.md`; los archivos de las esferas también lo enlazan.

No se añaden ajustes de modelos, permisos o confianza en `.codex/config.toml`:
estas tareas no necesitan alterar la configuración personal de Codex.

## Impeccable

Es obligatorio para trabajo visual. La skill se instala en el entorno del
desarrollador; el repositorio guarda sus reglas y contexto, no una copia de
su ejecutable. La configuración raíz declara `watchfaces/*` y cada esfera
conserva sus documentos y artefactos.

Al usar la skill, trabaja desde la esfera afectada y selecciona un objetivo
concreto. Garmin es una plataforma nativa Monkey C; no debe tratarse como una
web, iOS o Android. Aplica composición, tipografía y calidad de iconos con las
restricciones de Connect IQ, y valida en simulador o reloj. Un fallo de acceso
a las ventanas se documenta como límite de la comprobación visual.

## Añadir otra esfera

1. Crea `watchfaces/<slug>/` con manifiesto UUID único, `monkey.jungle`, código
   mínimo y recursos propios. Mantén únicamente `fr170`.
2. Registra `<slug>: <NombreDelPrograma>` en `projects.json`.
3. Añade `PRODUCT.md` y un `AGENTS.md` local que enlace el común. Documenta
   decisiones pendientes en lugar de inventar un diseño.
4. Añade carpeta y tarea de compilación al workspace. El script no requiere
   otra lista de proyectos.
5. Ejecuta verificación, pruebas de herramientas y compilación de todas.
