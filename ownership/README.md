## Ownership

This terraform module takes 'service_key' variable as input (e.g. roll-call), and looks up the corresponding service, team and org (EPOD) from the service registry using API call to 'serviceregistry' microservice. Its outputs are the canonical team and org names for the given service, or null if it can't find them.
