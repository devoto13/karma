Feature: Config
  In order to use Karma
  As a person who wants to write great tests
  I want to write Karma config in my favourite language.

  Scenario: Transpile TypeScript config
    Given a configuration file named "karma.conf.ts" containing:
      """
      import { resolve } from 'path';

      module.exports = (config: any) => {
        config.set({
          files: [resolve('basic/plus.js'), resolve('basic/test.js')],
          browsers: ['ChromeHeadlessNoSandbox'],
          plugins: ['karma-jasmine', 'karma-chrome-launcher'],
          singleRun: true,
          reporters: ['dots'],
          frameworks: ['jasmine'],
          colors: false,
          logLevel: 'warn',
          customLaunchers: {
            ChromeHeadlessNoSandbox: { base: 'ChromeHeadless', flags: ['--no-sandbox'] }
          }
        });
      };
      """
    When I start Karma with additional arguments: "--require ts-node/register"
    Then it passes with:
      """
      ..
      Chrome Headless
      """

  Scenario: Local transpiler is resolved relative to the CWD
    Given a configuration file named "karma.conf.ts" containing:
      """
      import { resolve } from 'path';

      module.exports = (config: any) => {
        config.set({
          files: [resolve('basic/plus.js'), resolve('basic/test.js')],
          browsers: ['ChromeHeadlessNoSandbox'],
          plugins: ['karma-jasmine', 'karma-chrome-launcher'],
          singleRun: true,
          reporters: ['dots'],
          frameworks: ['jasmine'],
          colors: false,
          logLevel: 'warn',
          customLaunchers: {
            ChromeHeadlessNoSandbox: { base: 'ChromeHeadless', flags: ['--no-sandbox'] }
          }
        });
      };
      """
    When I start Karma with additional arguments: "--require ./config/register"
    Then it passes with:
      """
      ..
      Chrome Headless
      """

  Scenario: Warning for deprecated behavior
    Given a configuration file named "karma.conf.ts" containing:
      """
      import { resolve } from 'path';

      module.exports = (config: any) => {
        config.set({
          files: [resolve('basic/plus.js'), resolve('basic/test.js')],
          browsers: ['ChromeHeadlessNoSandbox'],
          plugins: ['karma-jasmine', 'karma-chrome-launcher'],
          singleRun: true,
          reporters: ['dots'],
          frameworks: ['jasmine'],
          colors: false,
          logLevel: 'warn',
          customLaunchers: {
            ChromeHeadlessNoSandbox: { base: 'ChromeHeadless', flags: ['--no-sandbox'] }
          }
        });
      };
      """
    When I start Karma
    Then it passes with regexp:
      """
      WARN \[config\]:.+Starting with the next major version Karma will not load any transpilers for configuration file by default. You see this message because the configuration file \(.+karma.conf.ts\) has an extension other than .js and probably requires a transpiler. To suppress this warning, configure a transpiler explicitly with e.g. `karma start --require ts-node/register` or `karma start --require none` \(if no transpiler is needed\). See https://karma-runner.github.io/latest/intro/configuration.html for more information.
      ..
      Chrome Headless
      """
