import { defineRailway, project, service } from "railway/iac";

// Last resort for a per-service CaC repo. Prefer one .railway file for the
// project and drop this if you later combine services into that file.
export const partial = "plux";

export default defineRailway(() => {
  const plux = service("plux", {
    healthcheck: "/health",
    healthcheckTimeout: 60,
    // dockerfilePath from CaC: "Dockerfile"
    // builder from CaC: "DOCKERFILE"
  });
  return project("plux", {
    resources: [plux],
  });
});
