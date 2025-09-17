# zzz.R
.onLoad <- function(libname, pkgname) {
  # Set cache directory option and increase timeout
  op <- options()
  op.forestgrowthmatrixP2 <- list(
    forestgrowthmatrixP2.cache_dir = tools::R_user_dir("forestgrowthmatrixP2", "cache")
  )
  toset <- !(names(op.forestgrowthmatrixP2) %in% names(op))
  if (any(toset)) options(op.forestgrowthmatrixP2[toset])

  # Increase default timeout for large downloads
  options(timeout = 600)  # 10 minutes
}

# In zzz.R
.onAttach <- function(libname, pkgname) {
  packageStartupMessage("Welcome to the Forest Growth Matrix - Phase2 package!")

  # Try to load models with cache-first approach
  success <- tryCatch({
    .load_models_with_fallback()  # This now tries cache first
  }, error = function(e) {
    packageStartupMessage("Model loading error: ", e$message)
    FALSE
  })

  if (success) {
    if (all(sapply(names(MODEL_FILES), function(x) exists(x, envir = .forestgrowthmatrixP2_models)))) {
      packageStartupMessage("All models loaded successfully!")
    } else {
      packageStartupMessage("Some models loaded from cache, others downloaded.")
    }
  } else {
    packageStartupMessage(
      "Could not load models.\n",
      "Use load_all_models() to download from Zenodo,\n",
      "or model_install_instructions() for manual setup."
    )
  }
}
