

#' Create a new graphical device for an Xpose plot.
#' 
#' The function uses the code from dev.new(). This is a function to make
#' dev.new() back compatible with older versions of R (before 2.8.0).
#' 
#' 
#' @param \dots Additional arguments to a new graphical device.  see
#' \code{\link[grDevices]{dev.new}}.
#' @author Andrew Hooker
#' @seealso \code{\link[grDevices]{dev.new}}.
#' @keywords internal
# @export xpose.dev.new
xpose.dev.new <- function (...) 
{
  if(getRversion()>="2.8.0"){
    dev.new(...)
  } else {
    dev <- getOption("device")
    if (!is.character(dev) && !is.function(dev)) 
      stop("invalid setting for 'getOption(\"device\")'")
    if (is.character(dev)) {
      dev <- if (exists(dev, .GlobalEnv)) 
        get(dev, .GlobalEnv)
      else if (exists(dev, asNamespace("grDevices"))) 
        get(dev, asNamespace("grDevices"))
      else stop(gettextf("device '%s' not found", dev), domain = NA)
    }
    a <- list(...)
    a2 <- names(formals(dev))
    a <- a[names(a) %in% a2]
    if (identical(dev, pdf)) {
      if (is.null(a[["file"]]) && file.exists("Rplots.pdf")) {
        fe <- file.exists(tmp <- paste("Rplots", 1:999, ".pdf", 
                                       sep = ""))
        if (all(fe)) 
          stop("no suitable unused file name for pdf()")
        message(gettextf("dev.new(): using pdf(file=\"%s\")", 
                         tmp[!fe][1]), domain = NA)
        a$file <- tmp[!fe][1]
      }
    }
    else if (identical(dev, postscript)) {
      if (is.null(a[["file"]]) && file.exists("Rplots.ps")) {
        fe <- file.exists(tmp <- paste("Rplots", 1:999, ".ps", 
                                       sep = ""))
        if (all(fe)) 
          stop("no suitable unused file name for postscript()")
        message(gettextf("dev.new(): using postscript(file=\"%s\")", 
                         tmp[!fe][1]), domain = NA)
        a$file <- tmp[!fe][1]
      }
    }
    else if (!is.null(a[["width"]]) && !is.null(a[["height"]]) && 
             (identical(dev, png) || identical(dev, jpeg) || identical(dev, 
                                                                       bmp) || identical(dev, tiff))) {
      if (is.null(a[["units"]]) && is.null(a[["res"]])) {
        a$units <- "in"
        a$res <- 72
      }
    }
    do.call(dev, a)
  }
}
#<environment: namespace:grDevices>
