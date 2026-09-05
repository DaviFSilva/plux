{{flutter_js}}
{{flutter_build_config}}

// Plux-specific: skip service worker registration. The auto-generated
// bootstrap registers an SW that caches main.dart.js for 1 year; that
// breaks the ?theme=<name> URL switcher. We don't need offline support
// for a design-comparison screen.
//
// Also unregister any pre-existing service workers from prior visits.
if ('serviceWorker' in navigator) {
  navigator.serviceWorker.getRegistrations().then(function (regs) {
    regs.forEach(function (r) { r.unregister(); });
  });
}

_flutter.loader.load({
  config: {},
});