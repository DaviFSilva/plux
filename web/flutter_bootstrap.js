// Plux — custom Flutter bootstrap.
//
// Override the auto-generated flutter_bootstrap.js to:
// 1. Skip service worker registration (we don't need offline; the SW's
//    1-year immutable cache breaks the ?theme=<name> URL switcher by
//    serving stale bundles from previous visits).
// 2. Load main.dart.js as usual so the rest of the app starts normally.
//
// This file replaces the one Flutter would otherwise generate. Keep the
// engineRevision/builds payload in sync with Flutter releases; the
// values below were captured from Flutter 3.41.9.

(function () {
  if (!window._flutter) {
    window._flutter = {};
  }
  _flutter.buildConfig = {
    engineRevision: "42d3d75a56efe1a2e9902f52dc8006099c45d937",
    builds: [
      { compileTarget: "dart2js", renderer: "canvaskit", mainJsPath: "main.dart.js" },
      {},
    ],
  };

  // Load Flutter with NO service worker. The first param is the entry
  // point config; the second is the onEntrypointLoaded callback that
  // initializes the engine.
  _flutter.loader.load(
    {
          config: {},
          onEntrypointLoaded: async function (engineInitializer) {
            const appRunner = await engineInitializer.initializeEngine({
              renderer: "canvaskit",
            });
            await appRunner.runApp();
          },
        }
  );
})();