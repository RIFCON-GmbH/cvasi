% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/batch.R
\name{batch}
\alias{batch}
\title{Batch simulation of multiple exposure levels}
\usage{
batch(
  scenario,
  exposure,
  id_col = "trial",
  format = c("long", "wide"),
  times_from = c("scenario", "exposure"),
  select = NULL
)
}
\arguments{
\item{scenario}{a \link{scenario} object}

\item{exposure}{a named \code{list()} or a \code{data.frame} with three columns}

\item{id_col}{\code{character}, name of column in resulting ´data.frame` which
contains a trial's name or ID}

\item{format}{\code{character}, set to \code{'long'} for long tabular format, or
\code{'wide'} for wide format}

\item{times_from}{\code{character}, set to \code{'scenario'} to use output times from
scenario, or \code{'exposure'} to take output times from each exposure series}

\item{select}{optional \code{character} vector to select columns from the
simulation output}
}
\value{
a simulation batch object
}
\description{
\ifelse{html}{\href{https://lifecycle.r-lib.org/articles/stages.html#experimental}{\figure{lifecycle-experimental.svg}{options: alt='[Experimental]'}}}{\strong{[Experimental]}}
}
\details{
A convenience function to simulate a single base scenario with one or more
exposure levels. The functions aims at reproducing the setup and result format
of common effect studies.

Simulating a \link{scenario} is generally limited to assessing a single exposure
series. However, laboratory experiments commonly examine the effects of
multiple exposure levels on a biological system.
A \emph{batch simulation} approach involves running multiple simulations with
varying exposure or \emph{treatment} conditions. To illustrate: if the objective is
to examine the impact of a chemical on cell growth, multiple scenarios need
to be simulated to reproduce the cell growth dynamics under varying
concentrations of the assessed chemical. Each simulation run will represent a
specific exposure level, ranging from low to high concentrations of the
chemical.

To simulate the conditions of such a laboratory experiment, the scenarios and
exposure levels can either be created and simulated individually, or the
\code{batch()} function can be used for ease of use.
\subsection{Exposure series}{

The set of exposure levels can be represented by one of the following types:
\itemize{
\item A (named) list: Each element represents an exposure level or exposure
series. An exposure level can be represented by a constant numeric, a
\code{data.frame} with two columns, or an ExposureSeries object. The names of
the list elements specify the study ID.
\item Or alternatively, a \code{data.frame} with three columns: One column for time,
one for the exposure level, and one character column to specify the
study IDs.
}

Each exposure level will be simulated using the base scenario. If the exposure
levels are provided as a named list, the names will also appear in the return
value of \code{simulate()}. This behavior can be used, for example, to define unique
study IDs for particular exposure levels.
}

\subsection{Exposure IDs}{

The list of exposure levels can be supplied as a named list. The names
will be used as unique (study) IDs, so that the simulation results belonging
to any exposure level can be identified in the output.
If no IDs are defined by the user, generic IDs of the form \code{'trial{n}'} will
be assigned, with \code{{n}} being replaced by consecutive integers starting at one.

If the batch is passed on to \code{\link[=simulate]{simulate()}}`, the IDs will be contained in its
return value, e.g. as a dedicated column (long format) or as part of the
column names (wide format).
}

\subsection{Output format}{

The return value of \code{\link[=simulate]{simulate()}} is by default in long format, i.e. it will
contain one row for each output time and exposure level. It is possible to
pivot the tabular data to wide format, by setting the argument
\code{format = 'wide'}.

In wide format, the output columns of each exposure level are pasted
next to each other. If more than one column is pivoted per exposure level,
then the exposure or study ID is added as a suffix to column names.
If the output per exposure level contains only a single column (besides time
and the exposure ID itself), then original column name is dropped and only
exposure IDs are used. See the examples section for reference.
}

\subsection{Select output columns}{

Often, only a single output column is of interest in batch simulations,
such as the number of surviving individuals. To ease the interpretation and
handling of the output of batch simulations, the columns contained in the
output of each simulated exposure level can be filtered. One or more columns
can be selected. By default, no filtering of output columns is conducted.

As an example, to create an overview of survival probabilities (\emph{S}) in the
GUTS-RED-IT example scenario \code{minnow_it}:

\if{html}{\out{<div class="sourceCode">}}\preformatted{minnow_it \%>\%
  batch(exposure=list(0, 5, 10), select="S", format="wide") \%>\%
  simulate()
}\if{html}{\out{</div>}}
}
}
\examples{
# Simulate a batch experiment with three constant exposure levels of
# 0.0, 2.0, and 5.0 µmol/L
simulate(batch(minnow_it, list(0, 2, 5)))

# Alternatively, in tidyr style syntax
trials_list1 <- list(0, 2, 5)
minnow_it \%>\%
  batch(trials_list1) \%>\%
  simulate()

# Assign unique IDs to each exposure level
trials_list2 <- list(Control=0, TrialA=2, TrialB=5)
minnow_it \%>\%
  batch(trials_list2) \%>\%
  simulate()

# Alternatively, define multiple exposure levels in a single data.frame
trials_table <- data.frame(time=c(0, 0, 0),
                           conc=c(0, 2, 5),
                           trial=c("Control", "TrialA", "TrialB"))
minnow_it \%>\%
  batch(trials_table) \%>\%
  simulate()

# Limit simulation output to column 'S' (survival probability)
minnow_it \%>\%
  batch(trials_list2, select="S") \%>\%
  simulate()

# Return data in wide-format, unique IDs will be used as column names
minnow_it \%>\%
  batch(trials_list2, select="S", format="wide") \%>\%
  simulate()
}
