# PSModules

# Most functions in these modules will exit if certain requirements aren't met.
# E.g, You must use Get-ServiceExists to check whether the service exists before running Get-ServiceStatus, as to limit the functions to a single use, they have been build to exit if certain conditions aren't met. For instance, Get-ServiceStatus asserts that the service exists and will exit due to any failure.