# in config/test.exs

import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :helpdesk, Helpdesk.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "helpdesk_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

"""
/home/helpdesk$ mix help test

      mix test

Runs the tests for a project.

This task starts the current application, loads up test/test_helper.exs and
then, requires all files matching the test/**/*_test.exs pattern in parallel.

A list of files and/or directories can be given after the task name in order to
select the files to run:

    $ mix test test/some/particular/file_test.exs
    $ mix test test/some/particular/dir

Tests in umbrella projects can be run from the root by specifying the full
suite path, including apps/my_app/test, in which case recursive tests for other
child apps will be skipped completely:

    # To run all tests for my_app from the umbrella root
    $ mix test apps/my_app/test

    # To run a given test file on my_app from the umbrella root
    $ mix test apps/my_app/test/some/particular/file_test.exs

## Understanding test results

When you run your test suite, it prints results as they run with a summary at
the end, as seen below:

    $ mix test
    ...

      1) test greets the world (FooTest)
         test/foo_test.exs:5
         Assertion with == failed
         code:  assert Foo.hello() == :world!
         left:  :world
         right: :world!
         stacktrace:
           test/foo_test.exs:6: (test)

    ........

    Finished in 0.05 seconds (0.00s async, 0.05s sync)
    1 doctest, 11 tests, 1 failure

    Randomized with seed 646219

For each test, the test suite will print a dot. Failed tests are printed
immediately in the format described in the next section.

After all tests run, we print the suite summary. The first line contains the
total time spent on the suite, followed by how much time was spent on async
tests (defined with use ExUnit.Case, async: true) vs sync ones:

    Finished in 0.05 seconds (0.00s async, 0.05s sync)

Developers want to minimize the time spent on sync tests whenever possible, as
sync tests run serially and async tests run concurrently.

Finally, how many tests we have run, how many of them failed, how many were
invalid, and so on.

### Understanding test failures

First, it contains the failure counter, followed by the test name and the
module the test was defined:

    1) test greets the world (FooTest)

The next line contains the exact location of the test in the FILE:LINE format:

    test/foo_test.exs:5

If you want to re-run only this test, all you need to do is to copy the line
above and paste it in front of mix test:

    $ mix test test/foo_test.exs:5

Then we show the error message, code snippet, and general information about the
failed test:

    Assertion with == failed
    code:  assert Foo.hello() == :world!
    left:  :world
    right: :world!

If your terminal supports coloring (see the  "Coloring" section below), a diff
is typically shown between left and right sides. Finally, we print the
stacktrace of the failure:

    stacktrace:
      test/foo_test.exs:6: (test)

## Command line options

  • --color - enables color in the output
  • --cover - runs coverage tool. See "Coverage" section below
  • --exclude - excludes tests that match the filter
  • --exit-status - use an alternate exit status to use when the test suite
    fails (default is 2).
  • --export-coverage - the name of the file to export coverage results to.
    Only has an effect when used with --cover
  • --failed - runs only tests that failed the last time they ran
  • --force - forces compilation regardless of modification times
  • --formatter - sets the formatter module that will print the results.
    Defaults to ExUnit's built-in CLI formatter
  • --include - includes tests that match the filter
  • --listen-on-stdin - runs tests, and then listens on stdin. It will
    re-run tests once a newline is received. See the "File system watchers"
    section below
  • --max-cases - sets the maximum number of tests running asynchronously.
    Only tests from different modules run in parallel. Defaults to twice the
    number of cores
  • --max-failures - the suite stops evaluating tests when this number of
    test failures is reached. It runs all tests if omitted
  • --no-all-warnings - prints only warnings from files currently compiled
    (instead of all)
  • --no-archives-check - does not check archives
  • --no-color - disables color in the output
  • --no-compile - does not compile, even if files require compilation
  • --no-deps-check - does not check dependencies
  • --no-elixir-version-check - does not check the Elixir version from
    mix.exs
  • --no-start - does not start applications after compilation
  • --only - runs only tests that match the filter
  • --partitions - sets the amount of partitions to split tests in. It must
    be a number greater than zero. If set to one, it acts a no-op. If more than
    one, then you must also set the MIX_TEST_PARTITION environment variable
    with the partition to use in the current test run. See the "Operating
    system process partitioning" section for more information
  • --preload-modules - preloads all modules defined in applications
  • --profile-require time - profiles the time spent to require test files.
    Used only for debugging. The test suite does not run.
  • --raise - raises if the test suite failed
  • --seed - seeds the random number generator used to randomize the order
    of tests; --seed 0 disables randomization so the tests in a single file
    will always be ran in the same order they were defined in
  • --slowest - prints timing information for the N slowest tests.
    Automatically sets --trace and --preload-modules
  • --stale - runs only tests which reference modules that changed since
    the last time tests were ran with --stale. You can read more about this
    option in the "The --stale option" section below
  • --timeout - sets the timeout for the tests
  • --trace - runs tests with detailed reporting. Automatically sets
    --max-cases to 1. Note that in trace mode test timeouts will be ignored as
    timeout is set to :infinity
  • --warnings-as-errors - (since v1.12.0) treats warnings as errors and
    returns a non-zero exit status. This option only applies to test files. To
    treat warnings as errors during compilation and during tests, run:
        MIX_ENV=test mix do compile --warnings-as-errors + test --warnings-as-errors


## Configuration

These configurations can be set in the def project section of your mix.exs:

  • :test_coverage - a set of options to be passed down to the coverage
    mechanism. See the "Coverage" section for more information
  • :test_elixirc_options - the compiler options to used when
    loading/compiling test files. By default it disables the debug chunk and
    docs chunk
  • :test_paths - list of paths containing test files. Defaults to ["test"]
    if the test directory exists; otherwise, it defaults to []. It is expected
    that all test paths contain a test_helper.exs file
  • :test_pattern - a pattern to load test files. Defaults to *_test.exs
  • :warn_test_pattern - a pattern to match potentially misnamed test files
    and display a warning. Defaults to *_test.ex

## Coloring

Coloring is enabled by default on most Unix terminals. They are also available
on Windows consoles from Windows 10, although it must be explicitly enabled for
the current user in the registry by running the following command:

    $ reg add HKCU\Console /v VirtualTerminalLevel /t REG_DWORD /d 1

After running the command above, you must restart your current console.

## Filters

ExUnit provides tags and filtering functionality that allow developers to
select which tests to run. The most common functionality is to exclude some
particular tests from running by default in your test helper file:

    # Exclude all external tests from running
    ExUnit.configure(exclude: [external: true])

Then, whenever desired, those tests could be included in the run via the
--include option:

    $ mix test --include external:true

The example above will run all tests that have the external option set to true.
It is also possible to include all examples that have a given tag, regardless
of its value:

    $ mix test --include external

Note that all tests are included by default, so unless they are excluded first
(either in the test helper or via the --exclude option) the --include option
has no effect.

For this reason, Mix also provides an --only option that excludes all tests and
includes only the given ones:

    $ mix test --only external

Which is similar to:

    $ mix test --include external --exclude test

It differs in that the test suite will fail if no tests are executed when the
--only option is used.

In case a single file is being tested, it is possible to pass one or more
specific line numbers to run only those given tests:

    $ mix test test/some/particular/file_test.exs:12

Which is equivalent to:

    $ mix test --exclude test --include line:12 test/some/particular/file_test.exs

Or:

    $ mix test test/some/particular/file_test.exs:12:24

Which is equivalent to:

    $ mix test --exclude test --include line:12 --include line:24 test/some/particular/file_test.exs

If a given line starts a describe block, that line filter runs all tests in it.
Otherwise, it runs the closest test on or before the given line number.

## Coverage

Elixir provides built-in line-based test coverage via the --cover flag. The
test coverages shows which lines of code and in which files were executed
during the test run.

### Limitations

Coverage in Elixir has the following limitations:

  • Literals, such as atoms, strings, and numbers, are not traced by
    coverage. For example, if a function simply returns :ok, the atom :ok
    itself is never taken into account by coverage;
  • Macros, such as the ones defined by defmacro/2 and defguard/2, and code
    invoked only by macros are never considered as covered, unless they are
    also invoked during the tests themselves. That's because macros are invoked
    at compilation time, before the test coverage instrumentation begins;

### Configuratiuon

The :test_coverage configures the coverage tool and accepts the following
options:

  • :output - the output directory for cover results. Defaults to "cover".
  • :tool - a module specifying the coverage tool to use.
  • :summary - at the end of each coverage run, a summary of each module is
    printed, with results in red or green depending on whether the percentage
    is below or above a given threshold. The task will exit with status of 1 if
    the total coverage is below the threshold. The :summary option allows you
    to customize the summary generation and defaults to [threshold: 90], but it
    may be set to false to disable such reports.
  • :export - a filename to export results to instead of generating the
    coverage result on the fly. The .coverdata extension is automatically added
    to the given file. This option is automatically set via the
    --export-coverage option or when using process partitioning. See mix
    test.coverage to compile a report from multiple exports.
  • :ignore_modules - modules to ignore from generating reports and in
    summaries. It is a list of module names as atoms and regular expressions
    that are matched against the module names.
  • :local_only - by default coverage only tracks local calls, set this
    option to false if you plan to run coverage across nodes.

By default, a wrapper around OTP's cover is used as the default coverage tool.
You can learn more about how it works in the docs for mix test.coverage. Your
tool of choice can be given as follows:

    def project() do
      [
        ...
        test_coverage: [tool: CoverModule]
        ...
      ]
    end

CoverModule can be any module that exports start/2, receiving the compilation
path and the test_coverage options as arguments. It must return either nil or
an anonymous function of zero arity that will run after the test suite is done.

## Operating system process partitioning

While ExUnit supports the ability to run tests concurrently within the same
Elixir instance, it is not always possible to run all tests concurrently. For
example, some tests may rely on global resources.

For this reason, mix test supports partitioning the test files across different
Elixir instances. This is done by setting the --partitions option to an
integer, with the number of partitions, and setting the MIX_TEST_PARTITION
environment variable to control which test partition that particular instance
is running. This can also be useful if you want to distribute testing across
multiple machines.

For example, to split a test suite into 4 partitions and run them, you would
use the following commands:

    $ MIX_TEST_PARTITION=1 mix test --partitions 4
    $ MIX_TEST_PARTITION=2 mix test --partitions 4
    $ MIX_TEST_PARTITION=3 mix test --partitions 4
    $ MIX_TEST_PARTITION=4 mix test --partitions 4

The test files are sorted upfront in a round-robin fashion. Note the partition
itself is given as an environment variable so it can be accessed in config
files and test scripts. For example, it can be used to setup a different
database instance per partition in config/test.exs.

If partitioning is enabled and --cover is used, no cover reports are generated,
as they only contain a subset of the coverage data. Instead, the coverage data
is exported to files such as cover/MIX_TEST_PARTITION.coverdata. Once you have
the results of all partitions inside cover/, you can run mix test.coverage to
get the unified report.

## The --stale option

The --stale command line option attempts to run only the test files which
reference modules that have changed since the last time you ran this task with
--stale.

The first time this task is run with --stale, all tests are run and a manifest
is generated. On subsequent runs, a test file is marked "stale" if any modules
it references (and any modules those modules reference, recursively) were
modified since the last run with --stale. A test file is also marked "stale" if
it has been changed since the last run with --stale.

The --stale option is extremely useful for software iteration, allowing you to
run only the relevant tests as you perform changes to the codebase.

## File-system watchers

You can integrate mix test with filesystem watchers through the command line
via the --listen-on-stdin option. For example, you can use fswatch
(https://github.com/emcrisostomo/fswatch) or similar to emit newlines whenever
there is a change, which will cause your test suite to re-run:

    $ fswatch lib test | mix test --listen-on-stdin

This can be combined with the --stale option to re-run only the test files that
have changed as well as the tests that have gone stale due to changes in lib.

## Aborting the suite

It is possible to abort the test suite with Ctrl+\ , which sends a SIGQUIT
signal to the Erlang VM. ExUnit will intercept this signal to show all tests
that have been aborted and print the results collected so far.

This can be useful in case the suite gets stuck and you don't want to wait
until the timeout times passes (which defaults to 30 seconds).

Location: /.../v1.15.7-otp-25/lib/mix/ebin
/home/helpdesk$
"""
