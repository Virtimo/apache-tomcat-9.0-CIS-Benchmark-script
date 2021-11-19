# Apache Tomcat 9.0 CIS Benchmark script

# Introduction

Apache Tomcat 9.0 CIS Benchmark Automation Script

This would run mostly all the audit points specified in the [Official CIS Benchmark PDF](CIS_Apache_Tomcat_9_Benchmark_v1.0.0.pdf).

# Features

- Use of environment variables CATALINA_HOME & CATALINA_BASE
- Provide your Tomcat application context
- Support locations containing whitespaces

# Requirements

- Bash shell available
- Tomcat 9 installed on the same machine
- Tomcat environment variables are set accordingly:
  - CATALINA_BASE
  - CATALINA_HOME

# Usage

**Run the bash script**

    $ ./Apache-Tomcat-9.0.sh

The output will be stored in the file `Apache_Tomcat_9.0.txt`.

**Run the bash script and report into your file**

    $ ./Apache-Tomcat-9.0.sh -f report.txt

The output will be stored in the file `report.txt`.

NOTE: This will only give the output of the audit points.
Manual check of the outputs needs to be done in order to check if it is compliant or not by following the [Benchmarks PDF](CIS_Apache_Tomcat_9_Benchmark_v1.0.0.pdf).

# Contributing

Please open an issue or create a PR.

# TODOs

- Give more context output on:
  - What is checked
  - What check passed
  - What check failed
  - Provide information on manual tests

# [License](LICENSE.md)

Licensed under the MIT License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.
You may obtain a copy of the License at

https://mit-license.org/

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.
