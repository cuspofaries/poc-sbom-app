# =============================================================================
# Project-Specific SBOM Policies (poc-sbom-build)
# =============================================================================
# These rules are evaluated IN ADDITION to the baseline policies from poc-sbom.
# They allow this project to enforce stricter or project-specific requirements.
#
# Rules use the same package (sbom) so OPA merges deny/warn sets automatically.
# Do NOT redefine baseline variables (approved_licenses, blocked_packages).
# Instead, create new rules with project-specific variables.
# =============================================================================
package sbom

import rego.v1

# ----- Project-specific configuration -----

# Packages not allowed in this project
project_blocked_packages := {
	"moment",     # Deprecated, use date-fns or dayjs
	"request",    # Deprecated, use node-fetch or axios
}

# ----- Project DENY rules (blocking) -----

# Deny project-specific blocked packages
deny contains msg if {
	some component in input.components
	component.name in project_blocked_packages
	msg := sprintf("[project] Package '%s' is not allowed in this project", [component.name])
}

# ----- Project WARN rules (advisory) -----

# Warn if GPL-3.0 licensed components are found
warn contains msg if {
	some component in input.components
	some license_entry in component.licenses
	license_id := license_entry.license.id
	license_id == "GPL-3.0-only"
	msg := sprintf("[project] GPL-3.0 license found in '%s@%s' — review required", [component.name, component.version])
}
