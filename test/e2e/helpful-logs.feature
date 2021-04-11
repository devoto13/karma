Feature: Helpful warning and errors
  In order to use Karma
  As a person who wants to write great tests
  I want to get messages which help me to fix problems

  Scenario: Karma fails to determine a file type from the file extension
    Given a configuration with:
      """
      files = [ 'modules/**/*.mjs' ];
      browsers = ['ChromeHeadlessNoSandbox'];
      frameworks = ['mocha', 'chai'];
      plugins = [
        'karma-mocha',
        'karma-chai',
        'karma-chrome-launcher'
      ];
      """
    When I start Karma
    Then the stdout matches RegExp:
      """
      WARN \[middleware:karma\]: Unable to determine file type from the file extension, defaulting to js.
        To silence the warning specify a valid type for .+modules/minus.mjs in the configuration file.
        See https://karma-runner.github.io/latest/config/files.html
      """

  Scenario: Transpiler for the configuration file is not provided
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
    When I start Karma with additional arguments: "--require none"
    Then it fails with like:
      """
      WARN \[config\]:.+The configuration file \(.+karma.conf.ts\) has an extension other than .js, but no transpiler is configured. Configure a transpiler with e.g. `karma start --require ts-node/register`. See https://karma-runner.github.io/latest/intro/configuration.html for more information.
      """
