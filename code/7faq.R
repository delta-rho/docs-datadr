
## Misc ##

### Debugging ###

More to come here, but for now, general guidelines:

- Get it right first on a subset.  When using the `divide()` and `recombine()` interface, pretty much the only place you can introduce errors is in your custom `addTransform()` functions or other transformation functions.
- With large datasets, read in a small collection of subsets and test those in-memory by calling the same methods on the in-memory object.  `browser()` is your friend - you can stick this in any user-defined function or inside your map and reduce expressions, which allows you to step into the environment in which your code is operating.

<!-- Will be adding capability to set `debug = TRUE` in your `control()` method, in which case whenever there is an error, the key is returned or something along those lines so you can pull out the troublesome key-value pair and see why it was causing problems. -->

### FAQ ###

#### I want to keep up on the latest developments - what do I do?

Please subscribe to our google [mailing list](https://groups.google.com/forum/#!forum/tessera-users)!

Simply send an email to 
[mailto:tessera-users+subscribe@googlegroups.com](tessera-users+subscribe@googlegroups.com) to join.

#### What should I do if I have an issue or feature request?

Please post an issue on [github](https://github.com/tesseradata/datadr/issues).

#### When should I consider using `datadr`?

Whenever you have large and/or complex data to analyze.  

Complexity is often more of an issue than size.  Complex data requires great flexibility.  We need to be able to do more than run numerical linear algebra routines against the data.  We need to interrogate it from many different angles, both visually and numerically.  `datadr` strives to provide a very flexible interface for this, while being able to scale.

#### What is the state of development of `datadr`?

`datadr` started out as proof of concept, and after applying it to several real-world large complex datasets and getting a feel for the requirements, we completely rewrote the package around a more cohesive design, with extensibility in mind.

At this point, we do not anticipate major changes to the interface, but do anticipate many changes under the hood, and perhaps some small changes in how various attributes for data structures are stored and handled.

#### What are the plans for future development of `datadr`?

Currently the plan is to continue to use the package in applied situations and refine, tweak, and tune performance.  We also plan to continue to add features, and particularly to investigate new backends, such as distributed memory architectures.

#### Can you support backend "x" please?

We are definitely interested in making `datadr` work with the latest technology.  We're particularly interested in efficient, scalable, fault-tolerant backends.

If the proposed backend meets these requirements, it is a candidate:

- data is stored in a key-value store
- MapReduce is a feasible computation approach
- data can be accessed by key

If it has these additional characteristics, it is all the more interesting:

- it is scalable
- work has already been done on generic R interfaces to this backend
- other people use it -- it is not an obscure technology

#### How is `datadr` similar to / different from `plyr` / `dplyr`?

Please note that we do not see `dplyr` and `datadr` two in competition.  The beauty of R is that there are many ways to do things.  The purpose of this discussion is both to point out when one might be more appropriate than the other.

Between `plyr` and `dplyr`, `datadr` is particularly similar to `dplyr`.  `dplyr` provides a backend-agnostic interface to performing split-apply-combine operations, which is basically the same thing that `datadr` does.  However, there are important distinctions, which we will discuss in terms of scalability, flexibility, performance, and other features.

1. **Scalability:** A backing technology for `datadr` must be a key-value store that is capable of running MapReduce operations.  For `dplyr`, it is tabular backends that can run group-by operations.  Backends that satisfy the requirements of `datadr` include Hadoop, Spark, etc., while backends that satisfy the requirements of `dplyr` include MySQL, SQLite, etc.  We are aware of users using `dplyr` on the low tens of gigabytes of data.  Backends like Hadoop are designed to scale to hundreds of terabytes, and we have used `datadr` with multi-terabyte data.  That said, we have heard of `dplyr` plugins to systems like Cloudera's Impala, which could bring greater scalability to `dplyr`.  However, our experience has indicated that typically when data is very very big, it is also very very complex, and becomes very difficult to treat as a large table.

2. **Flexibility:** Data structures in `dplyr` must be tabular, such as data frames, SQL tables, etc.  In datadr, data structures can be arbitrary.  While a great deal of the data we analyze is tabular, throughout the course of a data analysis it is often much more convenient to store data as arbitrary objects.  For example, we may want to store the result of a linear model fit to each subset of data.  We often have disparate sources of data that we can join together into a semi-structured format much more conveniently and compactly than a table join that flattens the results into a single large table.  Also, from an algorithmic point of view, the backing MapReduce framework of `datadr` provides a great deal more flexibility than simple group-gy operations.  But with the flexibility comes a bit more complexity.  Thinking of everything as a data frame in `dplyr` greatly simplifies things, but can come with a cost of what you are able to do.

3. **Performance:** A lot of effort has been spent on optimization for `dplyr`.  With `datadr`, we have been focusing on getting the design right and will move to tuning for performance soon.  Even with `datadr` fully-optimized, a lot of the difference in speed of operations is highly dependent on the backend being used, and also on the design philosophy (see below).  With `datadr`, we are concerned about speed, but we are more concerned with the tools accomodating the D&R analysis approach.

4. **Philosophy:** While `datadr`'s "divide and recombine" strategy is basically the same thing as "split-apply-combine", there are some important emphases to the D&R approach.  A very important one is that in D&R, when we split a dataset, we require the partioning to be persistent.  This means repartitioning the input data and saving a copy of the result.  This can be expensive, but it is very important.  Typically we divide once and then apply/recombine multiple times.  While we pay an up-front cost but reap the benefits during the meat of our analysis.  `dplyr`'s philosophy is to do things quickly and through very simple syntax with tabular data, and it does that very well.

5. Other Features: Another consideration is the features that come along with "ecosystem" of either package.  `dplyr` is being designed to work closesly with `ggvis`, for example.  `datadr` is designed to work closely with `trelliscope`.  Also, `datadr` is designed to support new advances in D&R theory and methods.

#### How is `datadr` similar to / different from Pig?

Pig is similar to `datadr` in that it has a high-level language that abstracts MapReduce computations from the user.  Although I'm sure it is possible to run R code somehow with Pig using UDFs, and that it is also probably possible to reproduce division and recombination functionality in pig, the power of `datadr` comes from the fact that you never leave the R analysis environment, and that you deal with native R data structures.

I see Pig as more of a data processing, transformation, and tabulation engine than a deep statistical analysis environment.  If you are mostly interested in scalable, high-level data manipulation tool and want a mature product (`datadr` is new and currently has one developer), then Pig is a good choice.  Another good thing about Pig is that it is tightly integrated into the Hadoop ecosystem.  If you are interested in deep analysis with a whole bunch of statistical tools available, then `datadr` is probably a better choice.

#### How does `datadr` compare to other R-based big data solutions?

There are many solutions for dealing with big data in R, so many that I won't even attempt to make direct comparisons out of fear of making an incorrect assessment of solutions I am not adequately familiar with.

A listing of many approaches can be found at the [HPC CRAN Task View](http://cran.r-project.org/web/views/HighPerformanceComputing.html).  Note that "high-performance computing" does not always mean "big data".

Instead of making direct comparisons, I will try to point out some things that I think make `datadr` unique:

- `datadr` leverages Hadoop, which is routinely used for extremely large data sets
- `datadr` as an interface is extensible to other backends
- `datadr` is not only a technology linking R to distributed computing backends, but an implementation of D&R, an *approach* to data analysis that has been used successfully for many analyses of large, complex data
- `datadr` provides a backend to scalable detailed visualization of data using [trelliscope](http://tesseradata.org/docs-trelliscope/)

### R Code ###

If you would like to run through all of the code examples in this documentation without having to pick out each line of code from the text, below are files with the R code for each section.

- [Dealing with Data in D&R](code/2data.R)
- [Division and Recombination](code/3dnr.R)
- [MapReduce](code/4mr.R)
- [Division-Independent Methods](code/5divag.R)
- [Store/Compute Backends](code/6backend.R)


