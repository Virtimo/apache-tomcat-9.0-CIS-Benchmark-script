# Apache Tomcat 9.0 CIS Benchmark script

Apache Tomcat 9.0 CIS Benchmark Automation Script

This would run mostly all the audit points specified in the Official CIS Benchmark PDF.

Simply run the bash script:

    $>./Apache-Tomcat-9.0.sh

# Features

- Usage of environment variables CATALINA_HOME & CATALINA_BASE
- Provide your Tomcat application context
- Support location containing whitespaces

NOTE: This will only give the output of the audit points. Manual check of the outputs needs to be done in order to check if it is compliant or not by following the Benchmarks PDF.

# TODOs

- Improve user/user group rights check (it's currently failing if hard-coded names not matching)
- Provide output in a parsable format (e.g. JSON)
- Give more context output on:
  - What is checked
  - What check passed
  - What check failed
