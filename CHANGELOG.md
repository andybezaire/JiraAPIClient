# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added
### Changed
### Deprecated
### Removed
### Fixed
### Security

## [0.3.0] - 2021-04-17
### Added
- separate logger for auth
- user profile object
- log in flow
- user profile view model
### Changed
- using logging data task from newer version of combine extras
- got rid of generics and mocked with configure
- split login updating tasks to own publishers

## [0.2.0] - 2021-04-05
### Added
- added token refreshing
### Changed
- added refresh token to the oauth token request with a boolean flag to disable if desired
- updated to latest package versions
- improved logging

## [0.1.0] - 2021-03-29
### Added
- added changelog
- set up readme with initial version

[Unreleased]: https://github.com/andybezaire/JiraAPI/compare/0.2.0...HEAD
[0.2.0]: https://github.com/andybezaire/JiraAPI/compare/0.1.0...0.2.0
[0.1.0]: https://github.com/andybezaire/JiraAPI/releases/tag/0.1.0
