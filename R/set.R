#' @include class-EffectScenario.R
NULL

#' Set effect endpoints
#'
#' Effect endpoints calculated by functions such as [effect()] and [epx()]
#' can be enabled and disabled. If an endpoint is not required for an assessment,
#' it should be disabled for reasons of computational efficiency. Please refer
#' to the model description for a list of available endpoints.
#'
#' @param x vector of `EffectScenario` objects
#' @param endpoints `character` vector of endpoint names
#'
#' @return Modified `EffectScenario` objects
#' @export
#' @examples
#' # Only enable reproduction (R) endpoint for americamysis scenario
#' americamysis %>%
#'   set_endpoints("R") %>%
#'   effect()
#'
#' # Enable endpoints length (L) and reproduction (R)
#' americamysis %>%
#'   set_endpoints(c("L","R")) %>%
#'   effect()
set_endpoints <- function(x, endpoints) {
  if(is.vector(x)) {
    return(sapply(x, function(sc) set_endpoints(sc,endpoints)))
  }
  if(length(endpoints) == 0)
    return(x)

  x@endpoints <- unlist(endpoints)
  x
}

#' Set mode of action
#'
#' Updates the model parameter `MoA` to a certain value
#'
#' @param x vector of [scenarios]
#' @param code a code for a mode of action, refer to model description for
#'   details
#'
#' @return modified [scenarios]
#' @export
#'
#' @examples
#' # Set MoA=8, i.e. hazard during oogenesis
#' americamysis %>%
#'   set_mode_of_action(8) %>%
#'   effect(method="ode45")
#'
#' # alternative approach using the parameter directly
#' americamysis %>%
#'   set_param(c(MoA=8)) %>%
#'   effect(method="ode45")
set_mode_of_action <- function(x, code) {
  if(is.vector(x))
    return(sapply(x, set_mode_of_action, code))

  if(!("MoA" %in% x@param.req))
    stop("model does not support modes of action")
  set_param(x, c(MoA=code))
}

#' @describeIn set_mode_of_action Shorthand version
#' @export
set_moa <- function(x, code) {
  set_mode_of_action(x, code)
}


# Set/copy all slots to a new scenario
#
# Can be used to copy scenario properties to a new scenario object of another
# model, e.g. copy properties of a Lemna_Schmitt scenario to Lemna_SchmittThold.
#
# @param x an `EffectScenario` to modify
# @param tmpl an `EffectScenario` to copy properties from
# @return modified `EffectScenario` objects
# @examples
# # Apply scenario properties from one model to another
# Lemna_SchmittThold() %>%
#   set_all(metsulfuron)
#' @importFrom methods slot slotNames slot<-
set_all <- function(x, tmpl) {
  if(is.vector(x))
    return(sapply(x, set_all, tmpl))

  if(!is_scenario(x) | !is_scenario(tmpl))
    stop("argument is not an EffectScenario object")

  trgt_slots <- slotNames(x)
  tmpl_slots <- slotNames(tmpl)
  exclude <- c("name","param.req","forcings.req")

  for(nm in intersect(trgt_slots, tmpl_slots)) {
    if(nm %in% exclude) next

    slot(x, nm) <- slot(tmpl, nm)
  }

  x
}


#' Set a tag
#'
#' Sets the user-defined, custom tag of a scenario. Tags
#' can be helpful to quickly distinguish scenarios by e.g. a user-specified
#' string.
#'
#' The function supports vectorized inputs.
#' If arguments `x` and `tag` are vectors, then tags are assigned to scenarios
#' on a 1:1 basis. If the length of both vectors do not match, an error is raised.
#'
#' @param x (vector of) [scenario] objects
#' @param tag (vector of) `character` or any other object
#'
#' @return (vector of) modified [scenarios]
#' @seealso [get_tag()]
#' @export
#'
#' @examples
#' # set a custom tag
#' myscenario <- GUTS_RED_SD() %>% set_tag("My Custom Tag")
#'
#' # returns `My Custom Tag`
#' get_tag(myscenario)
#'
#' # the tag also appears in the scenario overview
#' myscenario
set_tag <- function(x, tag) {
  if(is.vector(x)) {
    if(length(tag) == 1)
      return(sapply(x, set_tag, tag=tag))
    else if(length(tag) == length(x))
      return(purrr::map2(x, tag, set_tag))
    else
      stop("Argument `x` and `tag` must have the same length", call.=FALSE)
  }

  if(!is_scenario(x))
    stop("Argument `x` is not a scenario", call.=FALSE)
  if(length(tag) > 1)
    stop("Argument `x` and `tag` must have the same length", call.=FALSE)

  x@tag <- tag
  x
}
