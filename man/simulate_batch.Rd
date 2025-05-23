% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/simulate.R
\name{simulate_batch}
\alias{simulate_batch}
\title{Batch simulation using multiple exposure series}
\usage{
simulate_batch(model_base, treatments, param_sample = deprecated(), ...)
}
\arguments{
\item{model_base}{effect scenario object with mean parameters}

\item{treatments}{treatments exposure levels as data frame (time, conc, trial)}

\item{param_sample}{\emph{deprecated} parameter, no longer in use}

\item{...}{additional parameters passed through to \code{\link[=simulate]{simulate()}}}
}
\value{
a \code{data.frame} with simulation results
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#deprecated}{\figure{lifecycle-deprecated.svg}{options: alt='[Deprecated]'}}}{\strong{[Deprecated]}}
}
\details{
A convenience function to simulate a single base scenario with one or more
exposure series. This aims at reproducing the setup and results of common
effect studies.

A scenario contains only one exposure series. However, laboratory experiments
commonly examine the effects of multiple exposure levels on a biological system.
A batch simulation approach would involve running multiple simulations with
varying exposure or treatment conditions. To illustrate, if the objective is
to examine the impact of a substance on cell growth, the simulation model
could be designed to replicate the cell growth dynamics under varying
concentrations of the substance. Each simulation run would represent a
specific exposure level, ranging from low to high concentrations of the
chemical. To simulate such a laboratory experiment, the simulate_batch
function can be used. All exposure series are saved in the treatment argument.
The first column contains the time, the second column the concentration, and
the third column the trial name (exposure level, e.g. 'T1', 'T2', 'T3').
}
\examples{
t1 <- data.frame(time=0:10, conc=0, trial="control")  # 1st treatment level
t2 <- data.frame(time=0:10, conc=1, trial="T1")       # 2nd treatment level
treatments <- rbind(t1, t2)

metsulfuron \%>\%
  simulate_batch(treatments)
}
