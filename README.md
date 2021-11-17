# Apache Tomcat 9.0 CIS Benchmark script

# Introduction

Apache Tomcat 9.0 CIS Benchmark Automation Script

This would run mostly all the audit points specified in the Official CIS Benchmark PDF.

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

Simply run the bash script:

    $>./Apache-Tomcat-9.0.sh

NOTE: This will only give the output of the audit points. Manual check of the outputs needs to be done in order to check if it is compliant or not by following the Benchmarks PDF.

# Contributing

Please open an issue or create a PR.

# TODOs

- Improve user/user group rights check (it's currently failing if hard-coded names not matching)
- Give more context output on:
  - What is checked
  - What check passed
  - What check failed
  - Provide information on manual tests
- Option to set output location

# [License](LICENSE.md)

Licensed under the MIT License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

https://mit-license.org/

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
